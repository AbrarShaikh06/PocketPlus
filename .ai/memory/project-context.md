# Codebase Map: PocketPlus (Income Grow)

This document maps the technical context, architecture, file structure, conventions, and concerns of the **PocketPlus** codebase. It acts as the primary reference for AI developers to understand the project's current status and structural boundaries.

---

## 1. Technology Stack (`STACK.md`)

PocketPlus is a mobile-first financial tracking application for small Indian businesses.
The project is currently in **Phase 1 (Firebase-Native)**, running on a Flutter frontend and integrating directly with Firebase services.

### Core Technologies
- **Framework:** Flutter (target SDK: `>=3.4.0 <4.0.0`)
- **Language:** Dart
- **State Management:** Riverpod (`^3.3.2-dev.2`, with modern `Notifier` and annotation-based providers)
- **Routing & Navigation:** GoRouter (`^17.3.0` for declarative routing and deep-linking)
- **Database:** Firebase Cloud Firestore (`^6.5.0` with local cache persistence enabled)
- **Authentication:** Firebase Authentication (`^6.5.2` for phone OTP and Google sign-in)
- **Storage:** Firebase Storage (`^13.4.2` for receipt uploads and temporary PDF caching)
- **Notifications:** Firebase Cloud Messaging (`^16.3.0` for push notifications)
- **AI Integrations:** Gemini API via Node.js Cloud Functions (dev/prod) for voice parsing and receipt OCR
- **Monetisation:** Google Mobile Ads (`^8.0.0` for rewarded and native ads) & Google Play Billing (`^3.2.0` for subscriptions)
- **Design System:** Google Fonts (`^8.1.0` Outfit/Inter), Custom Glassmorphic/Modern UI tokens

---

## 2. External Integrations (`INTEGRATIONS.md`)

PocketPlus interacts with several third-party services and APIs:
1. **Firebase Auth SDK:** Authenticates users via Phone OTP (Indian numbers only, `+91`) and Google Sign-in.
2. **Firestore Database:** Holds users, profiles, transactions, categories, CA connections, comments, invoices, and khata customers/entries.
3. **Gemini API:** Performs NLP on raw voice inputs and OCR/Vision parsing on receipt images to extract transaction parameters (amount, category, merchant, date) in JSON formats.
4. **Android Telephony API:** Listens to incoming bank SMS notifications to trigger auto-capture.
5. **Google AdMob:** Delivers rewarded videos required for free users to export reports/PDFs.
6. **Google Play Billing API:** Manages Monthly Subscriptions:
   - **Basic Plan (₹100/mo):** Multi-profile (up to 3), basic invoices.
   - **Pro Plan (₹200/mo):** Unlimited profiles, CA Connect access, automated AI insights.

---

## 3. Architecture & File Structure (`ARCHITECTURE.md` & `STRUCTURE.md`)

PocketPlus uses a **Feature-First Clean Architecture** pattern. Features are isolated from each other. Communication between features must pass through either the `core/` or `shared/` layer.

### Directory Structure
```
lib/
├── firebase_options.dart               # Firebase CLI auto-generated configuration
├── main.dart                           # App entry point, registers ProviderScope
├── core/                               # Central infrastructure and configurations
│   ├── bootstrap/                      # App startup logic (e.g. FirebaseBootstrap)
│   ├── constants/                      # Spacing, colors, typography, strings
│   ├── errors/                         # Standard failures, app exceptions, and errors mapping
│   ├── network/                        # Connectivity & online/offline checker
│   ├── router/                         # GoRouter router configurations and route names
│   └── theme/                          # Material Design custom theme configuration
│   └── utils/                          # Common utilities (currency/date formatters, logger)
├── shared/                             # App-wide reusable components and models
│   ├── models/                         # Shared enums (plan type, transaction type, sync status)
│   ├── providers/                      # Shared riverpod providers (auth state, firebase client)
│   └── widgets/                        # Common widgets (AppButton, AppCard, AppTextField, etc.)
└── features/                           # Feature modules (Clean Architecture layers inside each)
    ├── auth/                           # Fully Implemented: Login screen, OTP verification & VM
    ├── analytics/                      # SKELETON ONLY (.gitkeep)
    ├── ca_connect/                     # SKELETON ONLY (.gitkeep)
    ├── dashboard/                      # SKELETON ONLY (.gitkeep)
    ├── feedback/                       # SKELETON ONLY (.gitkeep)
    ├── invoices/                       # SKELETON ONLY (.gitkeep)
    ├── khata/                          # SKELETON ONLY (.gitkeep)
    ├── ml_insights/                    # SKELETON ONLY (.gitkeep)
    ├── onboarding/                     # SKELETON ONLY (.gitkeep)
    ├── reports/                        # SKELETON ONLY (.gitkeep)
    ├── settings/                       # SKELETON ONLY (.gitkeep)
    ├── sms_capture/                    # SKELETON ONLY (.gitkeep)
    └── transactions/                   # SKELETON ONLY (.gitkeep)
```

### Complete Codebase Inventory
- [lib/main.dart](file:///a:/PocketPlus/lib/main.dart): App entry point; instantiates the main MaterialApp.router.
- [lib/core/bootstrap/firebase_bootstrap.dart](file:///a:/PocketPlus/lib/core/bootstrap/firebase_bootstrap.dart): Handles Firebase initializeApp and enables Firestore local cache persistence.
- [lib/core/constants/app_colors.dart](file:///a:/PocketPlus/lib/core/constants/app_colors.dart): Main color palette tokens (brand green, error red, surfaces).
- [lib/core/constants/app_text_styles.dart](file:///a:/PocketPlus/lib/core/constants/app_text_styles.dart): Typography definitions using the `Outfit` google font.
- [lib/core/router/app_router.dart](file:///a:/PocketPlus/lib/core/router/app_router.dart): GoRouter navigation configuration. Uses placeholder widgets for unimplemented features.
- [lib/core/utils/currency_formatter.dart](file:///a:/PocketPlus/lib/core/utils/currency_formatter.dart): Currency parsing and display utilities (formats integer paise to Rupees symbol output).
- [lib/features/auth/](file:///a:/PocketPlus/lib/features/auth): Authenticates user using Firebase Auth phone flow.
  - [auth_repository.dart](file:///a:/PocketPlus/lib/features/auth/domain/auth_repository.dart): Domain interface.
  - [firebase_auth_data_source.dart](file:///a:/PocketPlus/lib/features/auth/data/firebase_auth_data_source.dart): Data source interacting with Firebase.
  - [auth_repository_impl.dart](file:///a:/PocketPlus/lib/features/auth/data/auth_repository_impl.dart): Implementation of repository returning `Either<Failure, User?>`.
  - [auth_view_model.dart](file:///a:/PocketPlus/lib/features/auth/presentation/auth_view_model.dart): Presentation layer VM implementing custom `Notifier`.
  - [login_screen.dart](file:///a:/PocketPlus/lib/features/auth/presentation/login_screen.dart) & [otp_screen.dart](file:///a:/PocketPlus/lib/features/auth/presentation/otp_screen.dart): Modern UI views.

---

## 4. Coding Conventions & Quality (`CONVENTIONS.md` & `TESTING.md`)

### Coding Style & Design Rules
1. **No Floats/Doubles for Money:** Amounts must always be treated as `int` representing paise (e.g. `10000` paise = `₹100.00`). Dividing by 100 is done strictly at the UI display formatting boundary.
2. **Error Handling via Either:** Repositories must never leak exceptions directly to UI code. Return `Either<Failure, T>` using the `dartz` package.
3. **Declarative Navigation:** GoRouter is mandatory. Never call `Navigator.push`. Use `context.go()` or `context.push()`.
4. **Modern Riverpod Providers:** ViewModels must extend the modern `Notifier` or `AsyncNotifier` from Riverpod and be instantiated via `NotifierProvider` (not `StateNotifier`).
5. **Widget Construction:** Widgets must inherit from `ConsumerWidget` or `ConsumerStatefulWidget` to access providers. No raw stateful widgets when accessing data providers.

### Testing Status
- The test suite is located in the [test/](file:///a:/PocketPlus/test) directory.
- Current tests cover:
  - [test/core/utils/currency_formatter_test.dart](file:///a:/PocketPlus/test/core/utils/currency_formatter_test.dart): Validates conversion and negative amount display logic.
  - [test/shared/widgets/design_system_test.dart](file:///a:/PocketPlus/test/shared/widgets/design_system_test.dart): Verifies all custom layout widgets, buttons, input fields, and layouts.

---

## 5. Current Concerns & Technical Debt (`CONCERNS.md`)

1. **Unintegrated Firebase Bootstrap:** Firebase initialisation in [lib/core/bootstrap/firebase_bootstrap.dart](file:///a:/PocketPlus/lib/core/bootstrap/firebase_bootstrap.dart) is implemented but not yet called in [lib/main.dart](file:///a:/PocketPlus/lib/main.dart).
2. **Prevalence of Screen Placeholders:** Currently, 15 out of 18 screens configured in [lib/core/router/app_router.dart](file:///a:/PocketPlus/lib/core/router/app_router.dart) render a generic `_PlaceholderScreen`.
3. **Empty Feature Skeletons:** All feature directories outside of `auth/` contain only a `.gitkeep` placeholder and have no implementation.
4. **Lack of Coverage on Auth Layer:** While the custom design system and formatting utilities have unit/widget tests, there are currently no tests verifying the `AuthViewModel` state changes or OTP authentication flow.
5. **No Local Firestore Emulators Setup for Auth:** The `FirebaseBootstrap.useEmulators()` function configures the Firestore emulator but lacks setup for the FirebaseAuth emulator.
