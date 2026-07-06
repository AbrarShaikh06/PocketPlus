# Roadmap: PocketPlus

This document outlines the sequential phases and ticket milestones for PocketPlus's development.

---

## Phase 1: Authentication & Core Architecture (Milestone 1)
*Goal: Initialize scaffolding, establish the design system, deploy the core router, and complete secure phone OTP auth.*

- [x] **IGR-001:** Flutter Project Scaffold & GoRouter Configuration
- [x] **IGR-002:** Custom Design System (Colors, Typography, Spacing, Shared Widgets)
- [x] **IGR-003:** Phone OTP Authentication (LoginScreen, OtpScreen, AuthViewModel)
- [x] **IGR-004:** Onboarding Flow (Role Selection, Business Name, SMS Permission screens)
- [x] **IGR-005:** Bottom Navigation Shell (GoRouter ShellRoute, preservers)

---

## Phase 2: Secure Database Layer & Net Profit Engine (Milestone 2)
*Goal: Secure database rules, build multi-profile and category repositories, and implement the net profit calculator.*

- [x] **IGR-006:** Firestore Security Rules Deployment & Unit Testing (Emulator)
- [x] **IGR-007:** Transaction Repository (Firestore CRUD, PENDING/SYNCED status, soft-delete)
- [x] **IGR-008:** Category Repository & 12 Default System Categories Seed
- [x] **IGR-009:** Profile Repository & Multi-Profile Switcher (UPI/Bank endings)
- [x] **IGR-010:** Report Repository (Net profit calculation engine, MoM percentage stats)
- [x] **IGR-011:** Home Dashboard Screen (Hero profit card, 6-month bar chart, recent items)
- [x] **IGR-012:** Add Transaction Screen (Specialized keypad entry form, scroll categories)

---

## Phase 3: Reporting, Search, & Assistants (Milestone 3)
*Goal: Implement reporting PDF downloads, full transaction history, background SMS capture, and voice/OCR helpers.*

- [x] **IGR-013:** Analytics Screen (Chart tabs, highlight current month, stat cards)
- [x] **IGR-014:** Reports Screen & Offline PDF Builder (AdMob rewarded ad gates)
- [x] **IGR-015:** History Screen (Debounced search, filter chips, sticky headers, swipe-to-delete)
- [x] **IGR-016:** SMS Listener & Android BroadcastReceiver permission flow
- [x] **IGR-017:** SMS Bank Pattern Matcher & SHA256 deduplication
- [x] **IGR-018:** SMS Pre-filled Capture Confirmation Screen & Gemini categoriser
- [x] **IGR-019:** Voice Entry Integration (Speech-to-text, Gemini NLP parsing)
- [x] **IGR-020:** Vision OCR Bill scanner (Image compression, Gemini vision parsing)

---

## Phase 4: Business Ledgers, CA Connect, & Production Polish (Milestone 4)
*Goal: Build invoices, Khata ledgers, CA sharing connections, push messaging, biometric safety, subscriptions, and CI/CD.*

- [x] **IGR-021:** Khata Ledger (Customer lists, atomic credit/repayments, WhatsApp ping)
- [x] **IGR-022:** Invoices Generator (GST, lines layout, auto invoice numbers, PAID transaction trigger)
- ~~**IGR-023:** CA Connect~~ — **REMOVED 2026-07-06** (product decision: keep the app simple; reconsider after production launch)
- ~~**IGR-024:** CA Accept Flow~~ — **REMOVED 2026-07-06** (same decision as IGR-023)
- [x] **IGR-025:** Firebase Cloud Messaging Push notification receivers
- [ ] **IGR-026:** Biometric App Lock & PIN fallback — *not present in the codebase (no `local_auth` dependency); decide whether to build or descope*
- ~~**IGR-027:** Play Billing API integration~~ — **REMOVED** (paywalls/IAP dropped; banner ads only, see pubspec.yaml)
- [x] **IGR-028:** Feedback NPS Survey & telemetry analytics events
- [x] **IGR-029:** Dynamic role-based coach marks
- [x] **IGR-030:** Languages translation (EN, HI, MR, GU, TA) and settings screen
- [x] **IGR-031:** GitHub Actions CI/CD workflows and secrets setup *(workflows exist but the project is not yet a git repository — CI is inactive)*
- [ ] **IGR-032:** Firebase Functions setup (Audit logger, daily recurring expense log) — *no `functions/` directory exists in the codebase; CA monthly email dropped with CA Connect*
- [x] **IGR-033:** Selective Transaction Calculator (Floating total bar, copy/share totals)
- [x] **IGR-054:** Dream Savings Planner (Goals, entries, keypad contribution sheet, confetti progress detail, list soft-delete with 5-second undo)

---

## Production Release Checklist
*Verify and update key configurations before compiling the final production release build.*

- [ ] **AdMob Production App ID:** In [AndroidManifest.xml](file:///a:/PocketPlus/android/app/src/main/AndroidManifest.xml), replace the AdMob test App ID (`ca-app-pub-3940256099942544~3347511713`) with your production AdMob App ID.
- [ ] **AdMob Production Unit IDs:** Replace the test ad unit IDs inside the ad services with your production AdMob unit IDs.
- [ ] **Firebase SHA-1 & SHA-256 Fingerprints:** Add your Google Play Console App Signing Certificate fingerprints to the Firebase console so phone login works on Play Store builds.
- [ ] **Firebase Production Config:** Verify that the project settings and `google-services.json` are linked to the correct production Firebase environment.
- [ ] **Version Code & Name:** Bump version codes in `pubspec.yaml` prior to compiling the final build bundle.
