**POCKETPLUS — ENGINEERING DOCUMENTS**

**Feature Ticket List**

Atomic Build Tickets with Acceptance Criteria & Dependencies

|  |  |
| --- | --- |
| **Document** | Feature Ticket List — Phase 1 (Android MVP) |
| **Version** | 1.0 — May 2026 |
| **Total Tickets** | 52 tickets across 8 weeks |
| **Effort Scale** | S = 0.5 day | M = 1 day | L = 2 days | XL = 3 days |
| **Format** | Each ticket: ID, title, description, acceptance criteria, dependencies, effort |

**📋 How to Use This Document**

* Paste the ticket for your current task into the AI agent chat along with the Engineering Spec and Frontend Spec. The AI has everything it needs to build that one feature correctly. Never give the AI more than one ticket at a time.

# **WEEK 1 — Project Setup & Core UI**

**TICKET IGR-001 — Flutter Project Scaffold**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-001 |
| Title | Flutter project scaffold with Clean Architecture |
| Description | Create the Flutter project with the feature-first folder structure defined in Engineering Spec A-1. Set up Riverpod, GoRouter, and Firebase CLI integration. Single environment — no build flavors. |
| Acceptance Criteria | 1. Folder structure matches Engineering Spec A-1 exactly. 2. App runs against the Firebase emulator with no flavor (`flutter run`). 3. flutter analyze returns zero errors. 4. flutter test passes. 5. GoRouter configured with all routes from Frontend Spec section 1.1. |
| Dependencies | None — first ticket |
| Effort | L (2 days) |
| Assignee | — |

**TICKET IGR-002 — Design System Implementation**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-002 |
| Title | Implement design system: colors, typography, spacing, components |
| Description | Create AppColors, AppTextStyles, AppSpacing constants. Build shared widgets: AppButton (primary/outline/text variants), AppCard, AppTextField, EmptyState, LoadingSkeleton. All values from Frontend Spec B1.1–B1.4. |
| Acceptance Criteria | 1. All color tokens defined in AppColors. 2. All 9 text styles defined. 3. All 9 spacing tokens defined. 4. AppButton has all 3 variants with all 5 states (default, pressed, loading, disabled, error). 5. EmptyState accepts illustration, message, and optional CTA. 6. Widget tests pass for all shared components. |
| Dependencies | IGR-001 |
| Effort | L (2 days) |

**TICKET IGR-003 — Authentication Screen (Login + OTP)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-003 |
| Title | Phone OTP authentication screens |
| Description | Build LoginScreen (phone number entry) and OtpScreen (6-digit entry). Implement AuthRepository using Firebase Auth phone sign-in. All form validation from Frontend Spec section 3. |
| Acceptance Criteria | 1. LoginScreen: validates Indian phone format (starts 6–9, 10 digits). 2. OTP screen: 6 input fields that auto-advance. Paste supported. 3. Rate limit error shown correctly: 'Too many attempts. Try again in 10 minutes.' 4. On success: navigates to /onboarding/role if new user, /home if returning. 5. Error handling: VALIDATION\_ERROR, RATE\_LIMITED, UNAUTHENTICATED all show user-friendly messages. 6. Widget tests pass. |
| Dependencies | IGR-001, IGR-002 |
| Effort | M (1 day) |

**TICKET IGR-004 — Onboarding Flow (3 screens)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-004 |
| Title | Role selection, business name, and SMS permission onboarding |
| Description | Three onboarding screens: RoleSelectionScreen (Personal/Business/CA cards), BusinessNameScreen (text input), SmsPermissionScreen (demo card + allow/skip). Store role + tutorialCompleted in Firestore users/{uid} on completion. |
| Acceptance Criteria | 1. Role selection: 3 cards, one selectable at a time. 2. Business name: validation per Frontend Spec (2–200 chars). 3. SMS permission screen shows mock bank SMS card as demo. 4. 'Maybe Later' skips SMS permission but continues flow. 5. On completion: tutorialCompleted=false, tutorialRole=selected written to Firestore. 6. Progress dots show correct state on each screen. 7. Back navigation works without data loss. |
| Dependencies | IGR-003 |
| Effort | M (1 day) |

**TICKET IGR-005 — Bottom Navigation Shell**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-005 |
| Title | Main navigation shell with bottom nav bar |
| Description | Build MainShell with GoRouter ShellRoute. 4 tabs: Home, Analytics, Reports, Connect. Active tab shows filled icon + primary background pill. Notification badge on Connect tab. |
| Acceptance Criteria | 1. All 4 tabs render their screens. 2. Active tab highlighted correctly. 3. Tab state preserved when switching (no reload). 4. Badge count on Connect tab reads from unreadCACommentsProvider. 5. Correct icons per Frontend Spec 2.1. |
| Dependencies | IGR-001, IGR-002 |
| Effort | S (0.5 day) |

# **WEEK 2 — Firestore Data Layer**

**TICKET IGR-006 — Firestore Security Rules**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-006 |
| Title | Deploy complete Firestore security rules |
| Description | Deploy the security rules from Engineering Spec A-4 section 4.9 to the single Firebase project. Run Firebase Rules Unit Tests against the emulator. Rules must pass ALL tests before any data layer work begins. |
| Acceptance Criteria | 1. All rules from Engineering Spec 4.9 deployed to the Firebase project (validated first on the `demo-pocketplus` emulator). 2. Unit test suite: owner can read/write own transactions. 3. Unit test: other user cannot read owner transactions. 4. Unit test: active CA can read owner transactions. 5. Unit test: revoked CA cannot read. 6. Unit test: CA cannot write transactions. 7. All 7+ unit tests pass. 8. firebase deploy --only firestore:rules succeeds with zero warnings. |
| Dependencies | IGR-001 |
| Effort | M (1 day) |

**TICKET IGR-007 — Transaction Repository (Firestore)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-007 |
| Title | Transaction data layer: Firestore CRUD + real-time stream |
| Description | Implement TransactionRepository interface and FirestoreTransactionDataSource. Methods: watchTransactions (Stream), createTransaction, updateTransaction, softDeleteTransaction, restoreTransaction. Money stored as paise integers per Engineering Spec A-4.4. |
| Acceptance Criteria | 1. watchTransactions returns Stream<List<Transaction>> filtered by userId + profileId. 2. createTransaction writes all required fields from schema (Eng Spec A-2.3). 3. Soft delete sets isDeleted=true, deletedAt=now(). 4. restore sets isDeleted=false, deletedAt=null. 5. All monetary values stored as integers (paise). 6. syncStatus field set correctly: PENDING on write, SYNCED after Firestore acknowledges. 7. Unit tests with Firestore emulator: all CRUD operations tested. 8. Repository returns Either<Failure, T> — never throws. |
| Dependencies | IGR-006 |
| Effort | L (2 days) |

**TICKET IGR-008 — Category Repository + Default Seed**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-008 |
| Title | Category data layer with system defaults seed |
| Description | Implement CategoryRepository. On first user login: seed 12 system categories (Fuel, Food, Salary, Rent, Inventory, Electricity, Transport, Medical, Staff-Salary, Sales, Other-Income, Other-Expense). isSystem=true, userId=null for defaults. |
| Acceptance Criteria | 1. System categories seeded exactly once on first login (check if collection empty first). 2. System categories cannot be deleted (isSystem=true enforced in UI and Firestore rules). 3. User can add custom categories (isSystem=false, userId=user.uid). 4. Category has: id, name, icon (material symbol name), colorHex, gstHead, type, isSystem. 5. Unit tests: seed runs once, categories returned in sortOrder order. |
| Dependencies | IGR-006, IGR-007 |
| Effort | M (1 day) |

**TICKET IGR-009 — Profile Repository + Multi-Profile**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-009 |
| Title | Profile data layer with SMS routing |
| Description | Implement ProfileRepository. Create default profile on signup. Store upiIds[] and bankAccountLast4[] for SMS routing. Profile switching updates active profileId in local state. |
| Acceptance Criteria | 1. Default profile auto-created on first login with isDefault=true. 2. Profile switches update activeProfileId in Riverpod state. 3. All subsequent queries use new profileId immediately. 4. SMS routing: given a bank account last 4 digits, returns correct profileId. 5. Free tier: block profile creation if profileCount >= 1 (return PLAN\_LIMIT\_EXCEEDED). 6. Basic tier: block if >= 3. Pro: unlimited. 7. Unit tests for routing and limit enforcement. |
| Dependencies | IGR-007 |
| Effort | M (1 day) |

# **WEEK 3 — Dashboard & Net Profit Engine**

**TICKET IGR-010 — Net Profit Calculation Engine**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-010 |
| Title | Real-time net profit calculation with Firestore streams |
| Description | Implement ReportRepository.watchMonthlyReport(). Sums income and expense transactions for given profileId and month using Firestore stream. Returns ReportSummary with totalIncome, totalExpense, netProfit, changePercent vs previous month. All in paise. |
| Acceptance Criteria | 1. Net profit updates within 1 second of a new transaction being saved. 2. Correctly filters by profileId and date range. 3. Compares to previous month and returns changePercent. 4. Returns 0 (not null) when no transactions exist. 5. Unit tests: positive profit, negative profit (loss), zero, profile isolation (no cross-profile leakage). 6. All amounts in paise integers. |
| Dependencies | IGR-007 |
| Effort | M (1 day) |

**TICKET IGR-011 — Home Dashboard Screen**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-011 |
| Title | Home dashboard with all components |
| Description | Build HomeScreen with all components from Frontend Spec 2.1. Net profit hero card, today's cards, performance chart (6-month bar chart), recent entries (last 5). Real-time data via Riverpod StreamProvider. |
| Acceptance Criteria | 1. Net profit displays in green (positive) or red (negative). 2. MoM% badge shows correctly. 3. Performance chart shows 6 months with current month highlighted. 4. Recent entries list shows last 5 transactions with source badge. 5. FAB visible always, navigates to AddTransactionScreen. 6. Skeleton loading shown while data loads (never blank screen). 7. Pull-to-refresh works. 8. Profile switcher updates all data instantly. 9. Widget tests: positive profit, negative profit, empty state. |
| Dependencies | IGR-010, IGR-005, IGR-002 |
| Effort | L (2 days) |

**TICKET IGR-012 — Add Transaction Screen**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-012 |
| Title | Add transaction form with keypad |
| Description | Build AddTransactionScreen per Frontend Spec 2.2. Custom number keypad, income/expense toggle, category horizontal scroll, date picker, note field. All validation from Frontend Spec section 3. |
| Acceptance Criteria | 1. Custom keypad: max 2 decimal places, max 8 digits, backspace works. 2. Income/Expense toggle changes amount color and label. 3. Category scroll shows 8 categories + 'More' chip. 4. 'More' opens bottom sheet with all categories. 5. Date picker defaults to today. Future dates rejected with error. 6. Save button disabled until amount > 0 AND category selected. 7. Save shows spinner, then navigates back on success. 8. Dirty form shows 'Discard changes?' dialog on back. 9. All form validation per Engineering Spec A-3.2 (POST /transactions validation). 10. Widget tests for all validation states. |
| Dependencies | IGR-008, IGR-009 |
| Effort | L (2 days) |

# **WEEK 4 — Analytics, Reports & Charts**

**TICKET IGR-013 — Analytics Screen with Charts**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-013 |
| Title | Analytics screen: charts, stat cards, tab switcher |
| Description | Build AnalyticsScreen with tab switcher (Net Profit / Income / Expense), monthly bar chart, and stat cards (Best Month, Worst Month, Avg Monthly, MoM Growth). All data from reportSummaryProvider. |
| Acceptance Criteria | 1. Tab switcher switches chart data correctly. 2. Bar chart shows current month highlighted (full opacity), others at 0.5 opacity. 3. Chart animates on load (600ms, easeOut). 4. Stat cards show correct values. 5. 'View AI Insights' button visible for Pro users only. 6. Skeleton loading shown during data fetch. 7. Empty state if < 1 month of data. |
| Dependencies | IGR-010, IGR-011 |
| Effort | M (1 day) |

**TICKET IGR-014 — Reports Screen + PDF Export**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-014 |
| Title | Reports screen with period selector, breakdown, and PDF export |
| Description | Build ReportsScreen with Week/Month/Custom selector, net profit hero, income/expense split, category breakdown bars. PDF export with AdMob rewarded ad for free users. WhatsApp share. 'Send to CA' button (Pro only). |
| Acceptance Criteria | 1. Period selector: Week, Month, Custom (date range picker). 2. Category breakdown shows percentage bars. 3. PDF generates correctly from local Firestore cache (works offline). 4. FREE user: rewarded ad loads on screen open. Tapping export shows ad. PDF downloads after reward. 5. Ad failed to load (5s timeout): PDF exports anyway. Logs rewarded\_ad\_failed. 6. BASIC user: tracks monthly export count. 5 free, then ad required. 7. PRO user: no ad, no quota. 8. 'Send to CA' visible for Pro users with active CA connection. 9. WhatsApp share works via share\_plus. |
| Dependencies | IGR-010, IGR-013 |
| Effort | L (2 days) |

**TICKET IGR-015 — Transaction History Screen**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-015 |
| Title | Full transaction history with search, filters, infinite scroll |
| Description | Build TransactionHistoryScreen per Frontend Spec 2.4. Search (debounced 300ms), filter chips, date-grouped list with sticky headers, swipe-to-delete with undo, cursor-based pagination (50 per page). |
| Acceptance Criteria | 1. Search filters results within 300ms (debounced). 2. Filter chips are multi-selectable. Combine correctly (AND logic). 3. Date group headers are sticky (SliverPersistentHeader). 4. Swipe left reveals red background. Release: soft delete + SnackBar with Undo (5 seconds). 5. Tap Undo: transaction restored, SnackBar dismissed. 6. Pagination: loads next 50 on scroll to bottom. Loading indicator shown. 7. Empty state: shows when no results match filters. 8. Anomaly banner shown if any flagged transactions exist. |
| Dependencies | IGR-007, IGR-011 |
| Effort | L (2 days) |

# **WEEK 5 — SMS Auto-Capture**

**TICKET IGR-016 — SMS Permission & Listener**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-016 |
| Title | SMS background listener with Android BroadcastReceiver |
| Description | Set up SMS Read permission request flow. Register BroadcastReceiver to receive incoming SMSes even when app is killed. Route to BankPatternMatcher. |
| Acceptance Criteria | 1. AndroidManifest: RECEIVE\_SMS + READ\_SMS permissions declared with correct use-case justification. 2. permission\_handler: runtime permission request with rationale shown per SmsPermissionScreen design. 3. BroadcastReceiver fires when new SMS arrives (test with emulated SMS). 4. Works when app is: foreground, background, killed. 5. Permission denied gracefully: app works without SMS, feature disabled, settings prompt shown. |
| Dependencies | IGR-001 |
| Effort | M (1 day) |

**TICKET IGR-017 — SMS Parser with Bank Patterns**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-017 |
| Title | SMS parser: regex patterns for all major Indian banks |
| Description | Implement SmsParser with regex patterns for HDFC, SBI, ICICI, Axis, Kotak, and generic UPI. Returns ParsedSms { amount (paise), type, merchantName, date, smsHash }. Includes deduplication check against sms\_dedup\_log. |
| Acceptance Criteria | 1. ALL 12 test cases from Engineering Spec B4.1 pass. 2. Duplicate SMS (same hash in dedup log): returns null, no UI shown, logs sms\_duplicate\_skipped. 3. Malformed SMS: returns null, logs sms\_parse\_failed. 4. Amount extracted in paise (integer). 5. smsHash = SHA256(rawSmsText) computed correctly. 6. Raw SMS never written to Firestore. 7. 100% unit test coverage on SmsParser. |
| Dependencies | IGR-016 |
| Effort | M (1 day) |

**TICKET IGR-018 — Capture Confirmation Screen + Gemini Category**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-018 |
| Title | Auto-capture confirmation UI with Gemini ML suggestion |
| Description | Build CaptureConfirmationScreen per Frontend Spec 2.3. Send merchant name to Gemini for category suggestion. Show confidence badge. On Confirm: write transaction + update dedup log. On Dismiss: write DISMISSED to dedup log. |
| Acceptance Criteria | 1. Screen shows parsed SMS in chat bubble. 2. Merchant name and amount pre-filled and NOT editable (amount is shown as-is). 3. If Gemini confidence > 0.6: pre-select that category chip with 'AI suggests X (92%)' badge. 4. If confidence ≤ 0.6: no pre-selection, no badge. 5. Confirm disabled until category selected. 6. Confirm: writes transaction (source=SMS) + writes sms\_dedup\_log (action=LOGGED). 7. Dismiss: writes sms\_dedup\_log (action=DISMISSED), no transaction created. 8. If Gemini API fails (timeout/error): show all categories equally, no badge. 9. Widget tests for all states. |
| Dependencies | IGR-012, IGR-017 |
| Effort | L (2 days) |

# **WEEK 6 — Voice, OCR, Khata & Invoices**

**TICKET IGR-019 — Voice Entry (Gemini NLP)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-019 |
| Title | Voice-to-transaction using speech\_to\_text + Gemini |
| Description | Add voice input button to AddTransactionScreen. Record audio using speech\_to\_text. Send transcript to Gemini for structured extraction. Pre-fill form. |
| Acceptance Criteria | 1. Microphone icon in AddTransactionScreen. Hold to record, release to process. 2. Waveform animation during recording. 3. Transcript sent to Gemini with structured prompt (Engineering Spec A-4.7). 4. Response parsed as JSON: { amount, type, categoryId, note }. 5. Amount converted to paise. 6. Form pre-filled. User can edit before saving. 7. If Gemini returns null amount: show error 'Could not understand. Try again or enter manually.' 8. If Gemini API fails: show error, keep form empty for manual entry. 9. Hindi and English both tested with real voice input. |
| Dependencies | IGR-012, IGR-018 |
| Effort | M (1 day) |

**TICKET IGR-020 — Receipt OCR (Gemini Vision)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-020 |
| Title | Receipt photo scan with Gemini Vision OCR |
| Description | Add 'Scan Bill' button to AddTransactionScreen. Capture photo with image\_picker. Send base64 to Gemini Vision. Pre-fill form. Handle all OCR edge cases from Engineering Spec A-5.2. |
| Acceptance Criteria | 1. Camera opens on button tap. 2. Photo compressed to max 1MB before Gemini (use flutter\_image\_compress). 3. Gemini prompt per Engineering Spec A-4.7. 4. JSON response parsed: amount, merchantName, date, items. 5. Blurry/unreadable: show 'Could not read bill — enter manually'. 6. No receipt in photo: show 'No receipt found'. 7. Foreign currency detected: prompt user 'This appears to be in USD. Convert?'. 8. 10-second timeout: cancel + show manual entry. 9. All amounts in paise. 10. OCR values pre-fill form, user always reviews before save. NEVER auto-save OCR result. |
| Dependencies | IGR-012, IGR-019 |
| Effort | M (1 day) |

**TICKET IGR-021 — Khata / Udhaar Tracker**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-021 |
| Title | Khata customer list, credit/repayment logging, WhatsApp reminder |
| Description | Build KhataListScreen, AddKhataCustomerScreen, KhataCustomerDetailScreen. Log credit and repayment atomically (batch write: khata\_entry + balance update). WhatsApp reminder via url\_launcher. |
| Acceptance Criteria | 1. Customer list sorted by balance descending (most owed first). 2. Balance shown in rupees (colorPrimary if positive = owed to owner, colorError if negative). 3. Add credit: atomic batch write (new khata\_entry + FieldValue.increment on balance). 4. Add repayment: same batch write with decrement. 5. If batch fails: neither write completes. Show retry. 6. WhatsApp reminder: opens wa.me with pre-filled message 'Namaste [Name], your outstanding balance is ₹X. — [Business Name]'. 7. Empty state shown when no customers. 8. All amounts in paise. |
| Dependencies | IGR-007, IGR-009 |
| Effort | L (2 days) |

**TICKET IGR-022 — Invoice Generator**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-022 |
| Title | Invoice creation, PDF generation, and mark-as-paid flow |
| Description | Build CreateInvoiceScreen and InvoiceDetailScreen. Line items with GST, auto-invoice numbering (server-side), PDF export, WhatsApp share, mark-as-paid atomic batch (invoice update + income transaction create). Gated to Basic/Pro plan. |
| Acceptance Criteria | 1. Free user sees invoice feature locked with upgrade prompt. 2. Invoice number generated server-side via Firestore atomic transaction (never client-generated). Format: INV-001. 3. Line items: add/remove/reorder. GST options: 0, 5, 12, 18, 28%. 4. Totals auto-calculated: subtotal, GST, discount, grandTotal. All in paise. 5. grandTotal validated server-side (sum check per Eng Spec A-5.5). 6. Mark as PAID: atomic batch write (invoice + transaction). If batch fails: nothing written, show retry. 7. PDF exports correctly with business name, logo placeholder, line items. 8. WhatsApp share opens correctly. 9. BASIC user: 5 free invoices/month then watch ad. |
| Dependencies | IGR-007, IGR-012 |
| Effort | XL (3 days) |

# **WEEK 7 — CA Connect & Notifications**

**TICKET IGR-023 — CA Connect — Owner Side**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-023 |
| Title | CA Connect owner UI: invite, connected state, revoke |
| Description | Build CAConnectScreen with two states: empty (invite CA) and connected (show CA card, data sharing toggles, CA comments). Invite flow creates ca\_connections document with inviteToken. WhatsApp invite send. |
| Acceptance Criteria | 1. Empty state: shows benefit list + phone input. Pro plan only (Free/Basic see upgrade prompt). 2. Phone validation: Indian format, cannot be own number. 3. Invite creates ca\_connections doc: { ownerId, ownerProfileId, caPhone, status:PENDING, inviteToken:random64hex }. 4. WhatsApp opens with pre-filled message including invite link. 5. Connected state: CA name, last viewed timestamp, data sharing toggles. 6. Revoke: dialog 'Are you sure?' → sets status=REVOKED → CA access blocked immediately. 7. Recent CA comments shown as chat bubbles. 8. FCM notification shown as badge on Connect tab. |
| Dependencies | IGR-006, IGR-005 |
| Effort | L (2 days) |

**TICKET IGR-024 — CA Connect — CA Side + Deep Link**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-024 |
| Title | CA accept flow, CA view of owner books, comment system |
| Description | Handle /ca/accept?token=X deep link. CA sees pending invite, accepts, gets read-only view of owner transactions. CA can add comments (ca\_comments documents). Flag transactions for review. |
| Acceptance Criteria | 1. Deep link /ca/accept?token=X handled by GoRouter. 2. Invalid/expired token: show 'Invite expired or invalid. Ask your client to resend.' 3. Correct CA phone (matches ca\_connections.caPhone): show Accept button. 4. Wrong CA phone: show 'This invite was not sent to your number.' 5. Accept: updates ca\_connections { status:ACTIVE, caId, acceptedAt }. 6. CA sees owner's transactions in real-time (read-only). 7. CA cannot see add/edit/delete UI elements. 8. CA adds comment: creates ca\_comments doc. Owner gets FCM notification. 9. CA flag button on transactions opens comment input. |
| Dependencies | IGR-023, IGR-015 |
| Effort | L (2 days) |

**TICKET IGR-025 — Push Notifications (FCM)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-025 |
| Title | FCM notification handling for all notification types |
| Description | Set up firebase\_messaging plugin. Handle all notifications from Engineering Spec B2 table (CA comment, weekly summary, auto-capture, recurring logged). Handle foreground, background, and app-killed states. |
| Acceptance Criteria | 1. FCM token stored in users/{uid}.deviceTokens array on login. 2. Foreground: show local notification using flutter\_local\_notifications. 3. Background: system notification shown, tap navigates to correct screen. 4. App killed: system notification shown, tap opens app to correct screen. 5. Notification taps use GoRouter deep links: CA comment → /transaction/:id, auto-capture → /capture/:id. 6. Cloud Function IGR-CF-001 triggers on ca\_comments onCreate and sends FCM to owner. |
| Dependencies | IGR-023, IGR-024 |
| Effort | M (1 day) |

# **WEEK 8 — Polish, Monetisation & Launch**

**TICKET IGR-026 — Biometric Lock**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-026 |
| Title | Biometric lock with auto-trigger and PIN fallback |
| Description | Implement biometric authentication using local\_auth. Auto-triggers when app comes to foreground after 5 minutes in background. On by default. PIN fallback. |
| Acceptance Criteria | 1. Biometric prompt auto-shows when app foregrounds after > 5 min background. 2. Successful auth: proceeds to app. 3. Failed auth: retry up to 3 times, then show PIN entry. 4. Biometric not available: auto-skip, no error. 5. Can be turned off in Settings (requires current PIN to disable). 6. Biometric lock overlay fade animation: 150ms easeIn on dismiss. |
| Dependencies | IGR-004 |
| Effort | M (1 day) |

**TICKET IGR-027 — In-App Purchases (Play Billing)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-027 |
| Title | Google Play Billing subscriptions: Basic ₹100/mo, Pro ₹200/mo |
| Description | Implement in\_app\_purchase plugin. Products: pocketplus\_basic\_monthly (₹100), pocketplus\_pro\_monthly (₹200). Verify purchase server-side via Cloud Function. Update user.plan in Firestore on verified purchase. |
| Acceptance Criteria | 1. UpgradeScreen shows both plans with feature comparison. 2. Tapping Subscribe launches Google Play billing flow. 3. Purchase stream handled correctly: purchased, pending, error states. 4. Server-side verification via Firebase Cloud Function calling Google Play Developer API. 5. On verified: user.plan updated in Firestore. Features unlock immediately. 6. 7-day grace period for unverifiable plan (cached locally). 7. Cancellation detection: plan downgraded at period end. 8. Tested with Google Play test accounts. 9. Production ad unit IDs used in release build only. |
| Dependencies | IGR-001, IGR-003 |
| Effort | L (2 days) |

**TICKET IGR-028 — Feedback Screen + Analytics**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-028 |
| Title | Feedback screen, NPS survey, Firebase Analytics events |
| Description | Build FeedbackScreen per Engineering Spec design. 4 feedback types. NPS slider. WhatsApp support link. Implement all 35 analytics events from Engineering Spec B2. |
| Acceptance Criteria | 1. All 4 feedback types save to Firestore feedback collection with correct schema (Eng Spec A-2.11). 2. NPS score: slider 0-10, Submit saves to feedback. 3. WhatsApp button: opens wa.me with team number. 4. ALL 35 analytics events from Engineering Spec B2 implemented and firing correctly (verified in Firebase DebugView). 5. No PII (amounts, phone numbers, names) in any analytics event properties. |
| Dependencies | IGR-003 |
| Effort | M (1 day) |

**TICKET IGR-029 — Tutorial Coach Mark System**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-029 |
| Title | Role-based onboarding tutorial: Personal, Business, CA |
| Description | Implement tutorial\_coach\_mark. Three tutorial paths per Engineering Spec section 26. Store completion in Firestore. Role selection after onboarding. Replay option in Settings. |
| Acceptance Criteria | 1. Role selection screen shown after onboarding if tutorialCompleted=false. 2. Personal (5 steps): all steps match Eng Spec 26.2. 3. Business (7 steps): all steps match Eng Spec 26.3. 4. CA (6 steps): all steps match Eng Spec 26.4. 5. Skip button on every step. Tapping Skip: sets tutorialCompleted=true immediately. 6. On completion: tutorialCompleted=true, tutorialRole=role written to Firestore. 7. Never shown again on same account. 8. Settings: Replay Tutorial option resets tutorialCompleted=false. |
| Dependencies | IGR-004, IGR-011 |
| Effort | M (1 day) |

**TICKET IGR-030 — Settings Screen**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-030 |
| Title | Settings screen: language, dark mode, security, data export, account deletion |
| Description | Build SettingsScreen with all settings from Engineering Spec section 17. Language selector, dark mode, auto-lock, SMS capture toggle, fiscal year, data export (all data as JSON), account deletion with 30-day grace period. |
| Acceptance Criteria | 1. Language switch: EN, HI, MR, GU, TA. App text updates immediately (use intl). 2. Dark mode: system/light/dark. Persists across app restarts. 3. Auto-lock duration: Never/1min/5min/15min. 4. SMS capture toggle: disabling removes the BroadcastReceiver. 5. Data export: generates JSON with all user data, saves to Downloads. 6. Account deletion: two-step confirmation dialog. On confirm: sets deletedAt on user doc. 30-day grace period. Firebase Auth account disabled. 7. Replay Tutorial: resets tutorialCompleted=false. |
| Dependencies | IGR-026, IGR-003 |
| Effort | M (1 day) |

**TICKET IGR-031 — CI/CD Pipeline Setup**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-031 |
| Title | GitHub Actions CI/CD with Firebase App Distribution and Play Store |
| Description | Set up CI/CD pipeline per Engineering Spec B4.5. On every PR: lint, tests, build check. On merge to main: Firebase App Distribution (internal testers). Manual trigger: Play Store internal track. |
| Acceptance Criteria | 1. GitHub Actions: flutter analyze → zero errors or PR fails. 2. flutter test: all unit + widget tests must pass or PR fails. 3. flutter build apk --release: must compile or PR fails. 4. Firebase App Distribution: auto-deploy to internal testers on main merge. 5. Crashlytics: enabled in staging and production builds. 6. Production ADMOB\_APP\_ID injected via --dart-define from GitHub Secrets. 7. All secrets in GitHub Actions Secrets. Zero secrets in source code. |
| Dependencies | IGR-001 |
| Effort | M (1 day) |

**TICKET IGR-032 — Firebase Cloud Functions (5 functions)**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-032 |
| Title | All Firebase Cloud Functions |
| Description | Implement all 5 Cloud Functions: onTransactionCreate (audit log), onCACommentCreate (FCM to owner), dailyRecurringExpenseLogger (scheduled), monthlyCAReportEmail (scheduled), onUserDelete (data cleanup). |
| Acceptance Criteria | 1. onTransactionCreate: writes audit\_log on every new transaction. Fields: entityType=transaction, entityId, action=CREATE, userId. 2. onCACommentCreate: sends FCM notification to owner's deviceTokens array within 5 seconds of comment creation. 3. dailyRecurringExpenseLogger: runs 6 AM IST daily. Processes all due recurring expenses. Handles Feb 28/29 for dayOfMonth=31. Failures logged to Sentry, do not stop other expenses. 4. monthlyCAReportEmail: runs 1st of month 8 AM IST. Sends summary email to all active CA connections. 5. onUserDelete: anonymises all user data when account deleted (replace PII with 'DELETED\_USER'). All 5 tested with Firebase Functions emulator. |
| Dependencies | IGR-006, IGR-025 |
| Effort | XL (3 days) |

**TICKET IGR-033 — Selective Transaction Calculator**

|  |  |
| --- | --- |
| **Field** | **Detail** |
| ID | IGR-033 |
| Title | Selective transaction calculator with floating total bar |
| Description | Add a multi-select calculator mode to TransactionHistoryScreen. Long-pressing any transaction enters selection mode — checkboxes appear on all items and a floating calculator bar rises from the bottom showing the running total of selected transactions. Mixed income+expense selections show a net breakdown. Selection total can be copied or shared via WhatsApp. |
| User Story | As a business owner, I want to tap specific transactions and instantly see their combined total, so I can do quick custom calculations without leaving the app or opening a separate calculator. |
| Acceptance Criteria | 1. TRIGGER: Long-press any transaction tile → enters selection mode. The long-pressed transaction is auto-selected as the first item. 2. SELECTION MODE UI: Circular checkbox appears on the left of every transaction tile. Selected tiles have a colorPrimaryLight background tint. All other tiles remain visible and tappable. 3. CALCULATOR BAR: Animated bar slides up from bottom (250ms, easeOut) above the bottom navigation bar. Shows: [X selected] [total amount] [share icon] [X close button]. 4. MIXED SELECTION (income + expense both selected): Bar expands to show three rows — Selected Income: +₹X (green), Selected Expense: -₹Y (red), Net: ₹Z (green if positive, red if negative). 5. PURE INCOME SELECTION: Bar shows single total in green. Label: 'Total Income Selected'. 6. PURE EXPENSE SELECTION: Bar shows single total in red. Label: 'Total Expenses Selected'. 7. RUNNING UPDATE: Total updates instantly on every tap. No lag, no loading state. 8. SELECT ALL: Toolbar shows 'Select All' option when in selection mode. Selecting all shows grand total (same as the normal dashboard total for that filtered view). 9. DESELECT: Tapping a selected transaction deselects it. Total updates immediately. 10. EXIT MODE: Tap X on calculator bar OR press Android back button → exits selection mode, all checkboxes disappear, bar slides down. 11. SHARE: Tapping share icon on bar opens share sheet with pre-formatted text: 'PocketPlus Summary\n4 transactions selected\nIncome: ₹8,000\nExpenses: ₹3,200\nNet: ₹4,800\n— Sharma General Store' 12. COPY: Long-press the total amount in the bar → copies formatted total to clipboard. SnackBar: 'Total copied to clipboard'. 13. SCROLL WHILE SELECTING: User can scroll the transaction list while in selection mode. Selected items retain their selected state while scrolled out of view. 14. FILTER COMPATIBILITY: Applies on top of any active filter chips. If user has filtered to 'Expenses only' and enters selection mode, only expense transactions are visible and selectable. 15. NO PERSISTENCE: Selection state is purely in-memory (Riverpod local state). Exiting screen clears selection entirely. 16. ANIMATION: Calculator bar slide-up 250ms easeOut. Slide-down 200ms easeIn. Total number uses AnimatedSwitcher for smooth number transitions when total changes. 17. HAPTIC FEEDBACK: Light haptic on long-press to enter selection mode (HapticFeedback.lightImpact). Selection tap: no haptic (too frequent). 18. MINIMUM SELECTION: Bar visible only when >= 1 item selected. Selecting 0 items (impossible via UI) would auto-exit selection mode. |
| UI Spec — Calculator Bar Layout | Height: 72dp (single total) or 110dp (mixed income+expense breakdown) Background: colorCard with top shadow (elevation 8) Left: '[N] selected' label in labelSmall Centre: Total amount in displayLarge, color based on type Right: Share icon (IconButton) + Close icon (IconButton) Mixed breakdown: 3 rows of bodyMedium text, left-aligned, with color coding |
| State Management | New Riverpod provider: selectionModeProvider (StateNotifier) State: { isActive: bool, selectedIds: Set<String>, selectedTransactions: List<Transaction> } Derived providers: selectedTotalIncomeProvider, selectedTotalExpenseProvider, selectedNetProvider All derived values computed as integers (paise). Never floats. |
| Edge Cases | Empty list: long-press on empty state shows nothing (no selection mode on empty lists) Single transaction selected: bar shows single amount, share text says '1 transaction selected' 100+ transactions selected: still instant — calculation is a simple fold() over a List in memory Very large total (> ₹10L): formatted correctly as ₹10,00,000 using intl Indian locale |
| Dependencies | IGR-015 (Transaction History Screen must exist) |
| Effort | M (1 day) |
| Priority | Medium — ship after core features. Can be added in a post-launch update if needed. |

Implement IGR-054 — Dream Savings Planner**

# IGR-054 — Dream Savings Planner

## Feature Name
Dream Savings Planner

## Epic
Financial Planning

## Priority
Medium

## Effort
5 days

## Dependencies
- IGR-007 (Transaction Repository) ✅ — for paise storage pattern
- IGR-003 (Auth) ✅ — userId required
- IGR-002 (Design System) ✅ — AppCard, AppButton, AppTextField

---

## Overview
A dedicated savings goal planner that lets PocketPlus users set financial dreams (car, house, education, shop expansion, etc.) and track how much they've saved toward each goal over time.

Targeted at small business owners who want to plan big purchases alongside their daily expense tracking.

---

## User Story
> As a kirana store owner, I want to set a savings goal for a new delivery vehicle worth ₹3,00,000 and track how much I've added each month, so I can see how close I am to my dream.

---

## Screens

### 1. Dream Savings List Screen (`/savings`)
- Shows all active saving goals as cards
- Each card shows:
  - Dream name + emoji/icon
  - Progress bar (saved / target)
  - Amount: `₹1,00,000 / ₹3,00,000`
  - Percentage: `33%`
  - "Add Money Today" button
- Empty state: "What are you saving for?" illustration + CTA
- FAB → Create New Dream screen

### 2. Create Dream Screen (`/savings/new`)
- Fields:
  - Dream name (e.g. "My Car", "New Shop") — required, 2-100 chars
  - Category picker (Car, House, Education, Business, Travel, Other)
  - Target amount in ₹ (rupees input, stored as paise) — required, min ₹1
  - Target date (optional) — "By when?" date picker
  - Notes (optional) — max 200 chars
- On Save → creates SavingsGoal document in Firestore → navigates to list

### 3. Dream Detail Screen (`/savings/:id`)
- Hero section:
  - Dream name + icon
  - Large progress bar (animated, fills on load)
  - `₹X,XX,XXX saved of ₹X,XX,XXX`
  - Percentage complete
  - Days remaining (if target date set)
- "Add Money Today" button → opens AddSavingsEntryBottomSheet
- Contribution history list (date + amount added)
- "Edit Goal" and "Mark as Achieved" options

### 4. Add Savings Entry Bottom Sheet
- Prompt: `"How much have you added to your dream today?"`
- Amount input (custom keypad — same as AddTransactionScreen)
- Date picker (defaults to today)
- Note field (optional)
- "Add to Dream" button
- On save → updates savedAmount + creates SavingsEntry document

---

## Firestore Schema

### `savings_goals/{goalId}`
```
id:            UUID v4
userId:        string
profileId:     string
name:          string (2-100 chars)
category:      enum (CAR, HOUSE, EDUCATION, BUSINESS, TRAVEL, OTHER)
targetAmount:  int (paise)
savedAmount:   int (paise) — running total, updated on each entry
targetDate:    timestamp (nullable)
notes:         string (nullable, max 200 chars)
isAchieved:    bool (default false)
achievedAt:    timestamp (nullable)
createdAt:     timestamp
updatedAt:     timestamp
deletedAt:     timestamp (nullable) — soft delete only
syncStatus:    PENDING | SYNCED | FAILED
```

### `savings_entries/{entryId}`
```
id:            UUID v4
goalId:        string (ref to savings_goals)
userId:        string
profileId:     string
amount:        int (paise)
note:          string (nullable)
entryDate:     timestamp
createdAt:     timestamp
syncStatus:    PENDING | SYNCED | FAILED
```

---

## Validation Rules
| Field | Rule | Error Message |
|-------|------|--------------|
| Dream name | Required, 2-100 chars | "Name must be 2-100 characters" |
| Target amount | Required, > 0, max ₹10Cr | "Enter a valid target amount" |
| Entry amount | Required, > 0, max = remaining amount | "Amount cannot exceed your remaining goal" |
| Target date | Optional, must be future date | "Target date must be in the future" |

---

## UI Behaviour
- Progress bar animates from 0 to current % on screen load (600ms easeOut)
- When savedAmount >= targetAmount → confetti animation → "You did it! 🎉" screen
- Progress bar color: AppColors.primary (green) — matching income color
- If > 90% complete → progress bar shows orange accent to show "almost there"
- Card press → Dream Detail Screen (300ms slide transition)
- Swipe to delete on list → soft delete with undo SnackBar (5 seconds)

---

## Folder Structure
```
features/savings/
  domain/
    savings_goal.dart          # freezed entity
    savings_entry.dart         # freezed entity
    savings_repository.dart    # abstract interface
  data/
    savings_data_source.dart   # Firestore impl
    savings_repository_impl.dart
  presentation/
    savings_list_screen.dart
    create_dream_screen.dart
    dream_detail_screen.dart
    savings_view_model.dart    # Notifier<SavingsState>
    savings_providers.dart
    widgets/
      dream_card.dart          # individual saving goal card
      savings_progress_bar.dart # animated progress bar
      add_entry_bottom_sheet.dart
```

---

## Routes to Add (route_names.dart)
```dart
static const String savings = '/savings';
static const String savingsNew = '/savings/new';
static String savingsDetail(String id) => '/savings/$id';
```

---

## Navigation Entry Point
Add "Savings" tab to bottom navigation OR add as a card on Home Dashboard.
Recommended: Add as a dedicated card on Home Dashboard in Phase 1,
promote to bottom nav tab in Phase 2 when usage is confirmed.

---

## Atomic Operation (important)
When adding a savings entry:
```dart
// ALWAYS use Firestore batch — never two separate writes
final batch = _firestore.batch();

// Write 1: Create savings entry
batch.set(entryRef, entry.toJson());

// Write 2: Update savedAmount on goal (increment)
batch.update(goalRef, {
  'savedAmount': FieldValue.increment(entry.amount),
  'updatedAt': FieldValue.serverTimestamp(),
});

await batch.commit();
```

---

## Security Rules
```javascript
match /savings_goals/{goalId} {
  allow read, write: if request.auth != null
    && request.auth.uid == resource.data.userId;
}

match /savings_entries/{entryId} {
  allow read, write: if request.auth != null
    && request.auth.uid == resource.data.userId;
}
// CA does NOT have access to savings — personal financial goals
```

---

## Acceptance Criteria
- [x] User can create a savings goal with name, category, target amount
- [x] Goal appears as a card on the savings list screen
- [x] Card shows `₹X saved / ₹Y target` and animated progress bar
- [x] User can tap "Add Money Today" and enter an amount
- [x] savedAmount updates atomically with new entry creation
- [x] Progress bar updates immediately after adding money
- [x] When goal is 100% complete → celebration screen shown
- [x] Goals persist offline (Firestore local cache)
- [x] Soft delete works with undo SnackBar
- [x] All amounts stored as paise (int) — never double
- [x] flutter analyze → zero errors
- [x] Widget tests for DreamCard, SavingsProgressBar, CreateDreamScreen

---

## Dream Category Icons
```dart
enum SavingsCategory {
  CAR,        // 🚗 Icons.directions_car
  HOUSE,      // 🏠 Icons.home
  EDUCATION,  // 📚 Icons.school
  BUSINESS,   // 🏪 Icons.store
  TRAVEL,     // ✈️ Icons.flight
  OTHER,      // ⭐ Icons.star
}
```

---

## Future Enhancements (Phase 2)
- Monthly savings target: "Save ₹10,000/month toward this goal"
- Auto-deduct from income transactions toward savings
- ML prediction: "At this rate, you'll reach your goal in 8 months"
- Share goal progress card on WhatsApp

---

## Ticket Status
- [x] Planning
- [x] In Progress
- [x] Review
- [x] Done

**Total Phase 1 Effort Estimate:**

|  |  |  |
| --- | --- | --- |
| **Week** | **Tickets** | **Total Effort** |
| Week 1 (Setup) | IGR-001 to IGR-005 | 6.5 days |
| Week 2 (Data Layer) | IGR-006 to IGR-009 | 5 days |
| Week 3 (Dashboard) | IGR-010 to IGR-012 | 5 days |
| Week 4 (Analytics) | IGR-013 to IGR-015 | 5 days |
| Week 5 (SMS Capture) | IGR-016 to IGR-018 | 4 days |
| Week 6 (Voice/OCR/Khata/Invoice) | IGR-019 to IGR-022 | 7 days |
| Week 7 (CA Connect + FCM) | IGR-023 to IGR-025 | 5 days |
| Week 8 (Polish + Launch) | IGR-026 to IGR-032 | 10 days |
| Post-launch / Week 9 | IGR-033 (Selective Calculator) | 1 day |
| TOTAL | 33 tickets | ~49 days (working part-time: 2-3 hrs/day = ~13 weeks) |

Version 1.0 — Feature Ticket List — May 2026 — PocketPlus Engineering