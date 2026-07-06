# Production Readiness

This document catalogs everything PocketPlus does (or should do) to run reliably in production.

---

## 1. Error Monitoring

**Entry point**: `lib/core/errors/error_monitor.dart`  
**Wired in**: `lib/main.dart:59` — `ErrorMonitor.initialize(runApp)`

| Handler | Catch scope | Routes to |
|---|---|---|
| `FlutterError.onError` | Framework-level widget/layout errors | `AppLogger.error` + Crashlytics (`recordFlutterFatalError`) |
| `PlatformDispatcher.instance.onError` | Unhandled platform-level errors | `AppLogger.fatal` |
| `runZonedGuarded` | All async uncaught errors outside widget tree | `AppLogger.fatal` |
| `RiverpodErrorObserver` | Provider initialisation & runtime errors | `AppLogger.error` |

`ScreenTracker` mixin (`.errors/error_monitor.dart:115`) lets any `ConsumerState` widget push its screen name into the error context automatically.

---

## 2. Structured Logging

**File**: `lib/core/utils/logger.dart`

Five levels: `DEBUG`, `INFO` (debug-only), `WARNING`, `ERROR`, `FATAL`.

Every log entry carries:
- Timestamp, level, message
- User ID, session ID, screen, function name
- App version, environment (`development`/`staging`/`production`), platform
- Stack trace + exception for error/fatal
- Arbitrary `extra` map

**Crashlytics bridge** (release only):
- `FATAL` → `Crashlytics.recordError(fatal: true)`
- `ERROR` → `Crashlytics.recordError(fatal: false)`
- `WARNING`/`INFO`/`DEBUG` → `Crashlytics.log()`

**Initialisation order** (`main.dart:28-29`): `AppLogger.init()` before any other service so all downstream logs carry app version, environment, and platform metadata.

---

## 3. Remote Config & Feature Flags

**File**: `lib/core/config/remote_config_service.dart`  
**Package**: `firebase_remote_config`

19 flags with offline defaults:

| Key | Type | Default | Purpose |
|---|---|---|---|
| `gemini_enabled` | `bool` | `true` | Per-feature toggle: Gemini AI categorisation |
| `sms_auto_capture_enabled` | `bool` | `true` | Per-feature toggle: SMS auto-capture |
| `export_pdf_enabled` | `bool` | `true` | Per-feature toggle: PDF export |
| `analytics_enabled` | `bool` | `true` | Per-feature toggle: Firebase Analytics |
| `rate_limit_sms_parser` | `bool` | `true` | Rate limiting on SMS parser |
| `enable_ai` | `bool` | `true` | Master toggle: all AI features (supersedes gemini_enabled) |
| `enable_ads` | `bool` | `true` | Master toggle: AdMob ads |
| `enable_exports` | `bool` | `true` | Master toggle: all export features |
| `enable_notifications` | `bool` | `true` | Master toggle: all push/local notifications |
| `enable_sms_capture` | `bool` | `true` | Master toggle: all SMS capture |
| `enable_backup` | `bool` | `false` | Master toggle: cloud backup (opt-in) |
| `enable_sync` | `bool` | `true` | Master toggle: Firestore sync |
| `kill_switch_enabled` | `bool` | `false` | Emergency kill switch |
| `kill_switch_message` | `String` | `""` | Kill switch display message |
| `minimum_app_version` | `String` | `0.0.0` | Minimum required version |
| `max_transactions_free_tier` | `int` | `500` | Free tier transaction limit |
| `max_transactions_basic_tier` | `int` | `5000` | Basic tier transaction limit |
| `gemini_confidence_threshold` | `double` | `0.60` | Min confidence for auto-categorisation |
| `debug_menu_enabled` | `bool` | `false` | Developer debug menu |

**Master vs per-feature**: Master toggles (`enable_*`) are checked first in `RollbackService._applyFeatureFlags()`. Per-feature toggles are checked at the individual service level. Both must be enabled for a feature to run.

**Fetch behaviour**: every 4 hours in release, every build in debug. Falls back to defaults gracefully on failure — app never blocks on Remote Config.

---

## 4. Rate Limiting & Utilities

**File**: `lib/core/utils/rate_limiter.dart`

- **`RateLimiter`** — sliding-window per-key. Used by SMS parser, Gemini calls.
- **`Debouncer`** — delays execution until a quiet period (search input, etc.).
- **`Throttler`** — at-most-once per interval (scroll-driven refreshes).
- **`RetryPolicy`** — exponential backoff + jitter up to `maxRetries` (network calls).

**Existing Gemini rate limiter**: `lib/core/ai/gemini_rate_limiter.dart` — dual-window (hourly + daily), persisted via `flutter_secure_storage`.

---

## 5. Health Monitoring

**File**: `lib/core/monitoring/health_service.dart`

Periodic (30 min default) health checks on 11 critical dependencies. `HealthService.start()` in `main.dart:57`. Each check returns `HealthCheckResult` with response time, severity, and optional error message. Aggregated into `HealthSummary` with overall status (healthy/degraded/unhealthy).

| Dependency | Severity | What it checks |
|---|---|---|
| Firebase initialized | Critical | `Firebase.app()` exists |
| Firebase Auth | Critical | `FirebaseAuth.instance.currentUser` |
| Firestore read | Critical | `settings` doc `.get()` (3s timeout) |
| Firestore write | Critical | Docs write + delete (3s timeout) |
| Firestore offline | Warning | Offline persistence enabled on `settings` |
| Firebase Storage | Warning | `_ping` bucket file `.getBytes()` |
| Firebase Analytics | Warning | `logEvent` with timeout |
| Firebase Crashlytics | Warning | `setCustomKey` (skipped in debug) |
| Remote Config | Warning | `isInitialized` check |
| FCM | Warning | `getToken()` returns non-null |
| Internet connectivity | Info | `connectivity_plus` result |

**Provider**: `healthSummaryProvider` exposes reactive `HealthSummary` via Riverpod.

---

## 6. Rollback & Kill Switch

**Rollback service**: `lib/core/config/rollback_service.dart`
**Maintenance screen**: `lib/core/monitoring/maintenance_screen.dart`
**Route**: `/maintenance` in `app_router.dart` (highest-priority redirect guard)
**Wired in**: `main.dart:32` — `RollbackService.evaluate()` after Remote Config init; `main.dart:58` — `RollbackService.watchConfigChanges()` after HealthService

`RollbackService.evaluate()` is called after Remote Config initialises. Three outcomes:

| Outcome | Condition | Behaviour |
|---|---|---|
| `RollbackDecision.passed` | No kill switch, version OK, all flags enabled | App continues normally |
| `RollbackDecision.killSwitch(message)` | `killSwitchEnabled == true && killSwitchMessage.isNotEmpty` | Redirect to `MaintenanceScreen.killSwitch(message)` — full app blocked |
| `RollbackDecision.forceUpdate(version)` | `currentVersion < minimumAppVersion` | Redirect to `MaintenanceScreen.forceUpdate(version)` with store link |

**Periodic re-evaluation**: `RollbackService.watchConfigChanges()` polls Remote Config every 15 minutes and re-applies feature flags. Disabled features trigger resource cleanup (notification cancellation, listener disposal, cached data preserved).

**Route guard** (`app_router.dart:159-163`): The redirect function checks `killSwitchEnabled` + `killSwitchMessage` before any auth/onboarding check. This ensures a remotely triggered kill switch takes effect even for already-authenticated sessions.

---

## 7. Release Validation

**File**: `lib/core/monitoring/release_validator.dart`

Pre-deployment verification runnable before any tag or store upload. `ReleaseValidator.validate()` runs 11 checks and returns a `ValidationReport` with pass/fail per check.

| Check | What it verifies |
|---|---|
| Firebase initialized | `Firebase.app()` succeeds |
| Crashlytics active | `setCustomKey` succeeds (skipped in debug) |
| Analytics active | `logEvent` completes within 3s |
| Remote Config loaded | `isInitialized == true` |
| Feature flags loaded | Flags object accessible |
| Health checks passing | Last `HealthSummary` is healthy or degraded |
| Logging active | `AppLogger.info` succeeds |
| Notifications configured | `getNotificationSettings()` succeeds |
| Firestore reachable | `_health_check/_ping` doc `.get()` with 5s timeout |
| FCM configured | `getToken()` returns non-null |

---

## 8. Firebase & Crashlytics Init

**File**: `lib/core/bootstrap/firebase_bootstrap.dart`

- `Firebase.initializeApp()` with checked-in `firebase_options.dart` (no build flavours).
- Firestore offline persistence: `Settings(persistenceEnabled: true, cacheSizeBytes: CACHE_SIZE_UNLIMITED)`.
- Crashlytics collection enabled only in release builds.

---

## 9. Analytics

**File**: `lib/core/analytics/analytics_service.dart`

31 well-defined events. **No exact amounts logged** — uses coarse `getAmountBucket()` (e.g. `100-500`, `5000-10000+`). All calls are fire-and-forget wrapped in try-catch so analytics never breaks a user flow.

---

## 10. Firestore Security Rules

| Rule | Enforcement |
|---|---|
| Profile isolation | Every query scoped by `userId` + `profileId` (CLAUDE.md: non-negotiable) |
| Soft deletes | `deletedAt = now()`, never hard-deleted. Transactions retained 7 years. |
| CA access | Read-only at security rules level, not just UI |
| Offline reads | Never show "No internet" — serve from local cache. Writes queued and auto-synced. |

---

## 11. Notifications

| Service | File | Purpose |
|---|---|---|
| FCM | `lib/core/notifications/fcm_service.dart` | Push notifications with deep-link routing |
| Local | `lib/core/notifications/local_notification_service.dart` | Budget warnings, local reminders |
| Workmanager | `lib/main.dart:25,47` | Background budget check (hourly, no network required) |

---

## 12. Startup Order

```
main()
├── WidgetsFlutterBinding.ensureInitialized()
├── Workmanager().initialize()
├── FirebaseBootstrap.initialize()
│   ├── Firebase.initializeApp()
│   ├── Firestore offline persistence
│   └── Crashlytics collection enabled (release)
├── AppLogger.init()                    ← version + env + platform captured
├── AppLogger.generateSessionId()
├── RemoteConfigService                 ← feature flags loaded
├── RollbackService.evaluate()          ← kill switch / min version / flags
│   ├── RollbackDecision.passed()       → continue
│   ├── RollbackDecision.killSwitch()   → router redirects to MaintenanceScreen
│   └── RollbackDecision.forceUpdate()  → router redirects to MaintenanceScreen
├── GoogleSignIn.initialize()
├── LocalNotificationService.init()
├── FcmService.init()
├── MobileAds.instance.initialize()     ← fire-and-forget
├── Workmanager().registerPeriodicTask()
├── HealthService.start()               ← periodic checks (30 min)
├── RollbackService.watchConfigChanges() ← re-evaluate every 15 min
└── ErrorMonitor.initialize(runApp)     ← zones + error handlers
```

---

## 13. Unhandled Error Resilience

- **Riverpod observer**: `providerDidFail` logged via `AppLogger.error`.
- **Every log ERROR/FATAL** bridges to Crashlytics in release builds.
- **User identity** set on Crashlytics (`setUserIdentifier`) when `AppLogger.setUser()` is called after auth.
- **Screen context** pushed to Crashlytics custom keys (`current_screen`, `current_route`).

---

## 14. Testing

```bash
flutter analyze        # must be 0 errors
flutter test           # must be 100% pass
dart format .          # consistent formatting
```

Key coverage areas:
- SMS parser: 100+ test cases across all bank patterns and edge cases
- Financial calculations (net profit, invoice totals, khata balance): 100% unit test coverage
- Widget tests: design system components, screen flows, maintenance screen
- Riverpod providers: integration tests with overridden dependencies
- Rollback service: `RollbackDecision` sealed class (passed/killSwitch/forceUpdate) — 7 tests
- Release validator: `ValidationCheck` and `ValidationReport` data classes — 7 tests
- Maintenance screen: 5 widget tests (kill switch + force update variants)

All repository interfaces return `Either<Failure, T>` — never throw across layer boundaries. ViewModels always `fold(onFailure, onSuccess)`.

---

## 15. Environment Detection

No build flavours. Environment is determined at runtime:
| `kDebugMode` | `kProfileMode` | `kReleaseMode` |
|---|---|---|
| `development` | `staging` | `production` |

Single Firebase project, single variant. Build-time secret: `GEMINI_API_KEY` only.

---

## 16. Audit Trail & Compliance

- **SMS raw text never persisted** — only SHA-256 hash stored for dedup (`sms_dedup_log`).
- **Transaction records kept 7 years** (Indian GST compliance).
- **Audit logs** never deleted.
- **Soft deletes** (`deletedAt`, `isDeleted`) on all financial data — never hard-deleted.
- **Invoice numbers** generated server-side via Firestore counter transaction — never client-side.
- **OTP rate limit**: 3 per phone per 10 minutes.
- **Biometric lock**: auto-triggers after 5 min background.

---

## 17. AdMob & Monetisation

- `MobileAds.instance.initialize()` fired early in `main.dart:45`.
- `kDebugMode` switches between test/dev ad unit IDs.
- Rewarded ad guard: FREE users must watch full ad, BASIC gets 5 free/month, PRO exports unconditionally.
- 5-second timeout: if rewarded ad fails to load, export proceeds anyway (logged as `rewarded_ad_failed`).
