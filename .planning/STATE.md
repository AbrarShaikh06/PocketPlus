---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: milestone
status: unknown
last_updated: "2026-06-21T04:28:50.089Z"
---

# Current State: PocketPlus

This document tracks the active development status, latest decisions, and blockers for PocketPlus.

---

## 1. Project Phase

- **Active Phase:** Phase 4 (Business Ledgers, CA Connect, & Production Polish)
- **Active Milestone:** Dream Savings Planner (IGR-054)

---

## 2. Completed Milestones

- [x] Feature-First Clean Architecture structure and workspace cleanup.
- [x] Typography, sizes, spacing, and custom layouts defined in the Custom Design System.
- [x] Customized design system widgets: `AppButton`, `AppCard`, `AppTextField`, `EmptyState`, `LoadingShimmer`, `MinTouchTarget`, `PressableScale`.
- [x] Firebase-Native Phone OTP signup flow (`LoginScreen`, `OtpScreen`, `AuthViewModel`, `AuthRepositoryImpl`, `FirebaseAuthDataSource`).
- [x] Test suite expanded & resolved: All 232 unit and widget tests pass.
- [x] Biometric lock with dynamic auto-lock trigger and 4-6 digit PIN fallback (IGR-026).
- [x] Dream Savings Planner (IGR-054): Created domain schemas, Firestore rules, repositories, state providers, keypad inputs, list & detail screens with custom confetti and soft-delete/undo functionality.

---

## 3. Current Task

- **Localization sweep (in progress, 2026-07-07):** wiring hardcoded English into `.arb` for all 5 locales (en/hi/mr/ar/sw).
  - ✅ Wave 1: nav labels, exit dialog, biometric/PIN app-lock screens.
  - ✅ Wave 2: entire settings screen (31 keys).
  - ✅ Wave 3: reports + all three budget screens + all three invoice screens (~140 keys total; interpolations use ARB placeholders).
  - ⏳ Wave 4 (remaining): savings, sms_diagnostics, feedback, home, auth remnants + a CI grep guard against new hardcoded strings.
  - **Decision:** the generated invoice/report **PDF stays English** (GST/accounting convention) — only on-screen UI is localized.

### Earlier this session

- **Production-readiness hardening (2026-07-06):**
  - **CA Connect fully removed** (product decision — reconsider post-launch). Feature code, routes, rules, and all dead `isCa` branches deleted; `ca_*` Firestore collections are now default-deny.
  - **Security fixes:** closed the `ca_members` self-grant rules exploit (by removal), removed the PII `debugPrint` from the router, moved the Gemini API key from URL query params to the `x-goog-api-key` header. *Manual step pending: add application restrictions to the Gemini key in Google Cloud console.*
  - **Firestore rules test suite** added under `firebase/` — `npm run test:emulator` (60 tests, all passing). firebase-tools pinned to v13 (machine has Java 17).
  - **Gemini model migrated** from retired `gemini-1.5-flash` to `gemini-2.5-flash`, overridable via Remote Config key `gemini_model`.
  - **`RECORD_AUDIO` permission added** — voice entry was silently broken without it.
  - **ML Insights placeholder route removed** along with stale `connect`/`upgrade`/`caAccept` route names.

---

## 4. Active Decisions & Architectures

- **Modern Notifier Pattern:** Using the modern Riverpod `Notifier<State>` API (via `riverpod_annotation` / `riverpod_generator`) for state management instead of deprecated `StateNotifier`.
- **Paise-Based Ledgers:** Storing cash flow amounts as integers representing paise.
- **GoRouter Declarative Routes:** Relying strictly on path-based location pushes to maintain state preservation.

---

## 5. Potential Blockers & Concerns

- **Firebase Initialization Call:** The bootstrap setup inside `lib/core/bootstrap/firebase_bootstrap.dart` must be called in `lib/main.dart` once testing requires real Firebase instances (or emulator endpoints).
- **Missing Auth Test Coverage:** While core utilities and layouts are tested, there are no tests verifying `AuthViewModel` state mutations or Auth repository exceptions.
- **Placeholder Redirection:** The `AppRouter` has routes registered, but we should make sure all routing transitions smoothly in the mobile flow.
