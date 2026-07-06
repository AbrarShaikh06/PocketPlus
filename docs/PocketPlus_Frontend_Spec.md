**POCKETPLUS — ENGINEERING DOCUMENTS**

**Frontend Specification**

Screen Specs, Navigation, Forms, Animations & Accessibility

|  |  |
| --- | --- |
| **Document** | Frontend Specification Document (FSD) |
| **Version** | 1.0 — May 2026 |
| **Platform** | Flutter (Android primary, iOS Phase 2) |
| **Covers** | Navigation graph, every screen's component tree, form rules, animations, accessibility |

# **1. Navigation Architecture**

## **1.1 Router Setup — GoRouter**

PocketPlus uses GoRouter for all navigation. Deep links are required for CA invite flow. Every route is defined here and nowhere else.

final router = GoRouter(

initialLocation: '/splash',

redirect: (context, state) {

final isAuth = ref.read(authStateProvider).isAuthenticated;

final isOnboarded = ref.read(userProvider).tutorialCompleted;

if (!isAuth) return '/auth/login';

if (!isOnboarded) return '/onboarding/role';

return null; // proceed

},

routes: [

GoRoute(path: '/splash', builder: SplashScreen),

GoRoute(path: '/auth/login', builder: LoginScreen),

GoRoute(path: '/auth/otp', builder: OtpScreen),

GoRoute(path: '/onboarding/role', builder: RoleSelectionScreen),

GoRoute(path: '/onboarding/name', builder: BusinessNameScreen),

GoRoute(path: '/onboarding/sms', builder: SmsPermissionScreen),

GoRoute(path: '/onboarding/done', builder: OnboardingDoneScreen),

ShellRoute(builder: MainShell, routes: [ // Bottom nav shell

GoRoute(path: '/home', builder: HomeScreen),

GoRoute(path: '/analytics', builder: AnalyticsScreen),

GoRoute(path: '/reports', builder: ReportsScreen),

GoRoute(path: '/connect', builder: CAConnectScreen),

]),

GoRoute(path: '/add-transaction', builder: AddTransactionScreen),

GoRoute(path: '/transaction/:id', builder: TransactionDetailScreen),

GoRoute(path: '/history', builder: TransactionHistoryScreen),

GoRoute(path: '/capture/:smsId', builder: CaptureConfirmationScreen),

GoRoute(path: '/ml-insights', builder: MLInsightsScreen),

GoRoute(path: '/invoices', builder: InvoiceListScreen),

GoRoute(path: '/invoices/new', builder: CreateInvoiceScreen),

GoRoute(path: '/khata', builder: KhataListScreen),

GoRoute(path: '/settings', builder: SettingsScreen),

GoRoute(path: '/feedback', builder: FeedbackScreen),

GoRoute(path: '/upgrade', builder: UpgradeScreen),

// Deep link for CA invite

GoRoute(path: '/ca/accept', builder: CAAcceptScreen,

redirect: (ctx, state) {

final token = state.uri.queryParameters['token'];

if (token == null) return '/home';

return null;

}),

],

);

# **2. Screen Specifications**

## **2.1 Home Dashboard Screen**

|  |  |  |  |
| --- | --- | --- | --- |
| **Component** | **Widget** | **Data Source** | **Behaviour** |
| Status Bar | System (no customisation) | — | Green icons via SystemChrome.setSystemUIOverlayStyle |
| App Bar | Custom — HisaabAppBar | Profile name from profileProvider | Left: hamburger → Drawer. Right: notification bell with badge count. |
| Profile Switcher | DropdownButton in AppBar title | profilesProvider (List<Profile>) | Tap → BottomSheet with profile cards. Switch triggers full state refresh. |
| Net Profit Hero Card | NetProfitCard (custom) | reportSummaryProvider(currentMonth) | Large rupee amount. Green if positive, red if negative. Badge shows MoM%. |
| Today's Income/Expense | Row of 2 StatCards | transactionsTodayProvider | Income card (green icon), Expense card (red icon). Tap → History filtered to today. |
| AI Insight Pill | MLInsightPill (custom) | mlInsightProvider | Shows only if anomaly detected this month. Tap → ML Insights screen. |
| Performance Chart | fl\_chart BarChart | monthlyChartProvider (6 months) | 6 bars, current month highlighted. Tab switcher: Net Profit / Income / Expense. Tap bar → drill down. |
| Recent Entries Header | Row with 'View All' button | — | 'View All' → TransactionHistoryScreen |
| Recent Entries List | ListView (last 5) | recentTransactionsProvider | Each item: TransactionListTile. Swipe left → delete with undo. Tap → TransactionDetailScreen. |
| FAB | FloatingActionButton | — | Always visible. Taps → AddTransactionScreen. Color: colorPrimary. |
| Bottom Navigation | BottomNavigationBar | — | 4 tabs: Home, Analytics, Reports, Connect. Active tab uses filled icon + colorPrimary background chip. |
| Notification Badge | Badge on bell icon | unreadCACommentsProvider | Count of unresolved CA comments. Red dot if > 0. |

## **2.2 Add Transaction Screen**

|  |  |  |  |
| --- | --- | --- | --- |
| **Component** | **Widget** | **Validation Rule** | **Behaviour** |
| Close button | IconButton (X) | — | Pops screen. If form dirty: show 'Discard changes?' dialog. |
| Income/Expense Toggle | CustomSegmentedControl | — | Switches amountLabel and amount color (green/red). Resets category selection. |
| Amount Display | Text + underline | Required. > 0. < ₹10,00,000 | Shows '0.00' placeholder. Cursor blinks. Keypad updates this. |
| Number Keypad | Custom GridView (3x4) | — | Digits 0-9, decimal, backspace. Max 2 decimal places. Max 8 digits. |
| Category Scroll | Horizontal ListView | Required | Shows 8 categories + 'More' chip. 'More' opens CategoryPickerBottomSheet with full list. |
| Voice Input Button | ElevatedButton with mic icon | — | Holds to record. Releases to process. Shows waveform animation while recording. |
| Scan Bill Button | ElevatedButton with scan icon | — | Opens camera via image\_picker. Shows loading while Gemini processes. |
| Date Picker | ListTile with calendar icon | Cannot be future (> today + 1 day) | Taps → showDatePicker(). Defaults to today. |
| Note Field | TextField | Optional. Max 500 chars | Shows char count when > 400 chars typed. |
| Save Button | ElevatedButton (full width) | Enabled only when amount > 0 + category selected | Shows CircularProgressIndicator while saving. Disabled while in progress. |

## **2.3 Auto-Capture Confirmation Screen**

|  |  |  |
| --- | --- | --- |
| **Component** | **Behaviour** | **Edge Cases** |
| SMS origin label | 'DETECTED FROM SMS' — always shown. Non-removable. Communicates source to user. | — |
| SMS card | Shows raw bank notification in chat-bubble style. Never editable. | If SMS is very long (> 200 chars): truncate with 'Show more' toggle. |
| Merchant + amount card | Pre-filled from SMS parse. Amount shown in red (expense). | If merchant name null: show 'Unknown Merchant'. Allow manual edit. |
| ML suggestion badge | Shows 'AI suggests: Grocery (92%)' if confidence > 0.6. | If confidence < 0.6: do not show suggestion. Show all categories equally. |
| Category chips | Horizontal scroll. First chip = ML suggestion (pre-selected if confidence > 0.6). | If no categories loaded: show 3 skeleton chips while loading. |
| Confirm Entry button | Enabled only if a category is selected. Full-width, colorPrimary. | Shows spinner while writing to Firestore. |
| Dismiss link | Text link below Confirm: 'Dismiss — not a business expense' | Tap → dialog: 'Are you sure? This will not be logged.' Confirm → write DISMISSED to dedup log. |

## **2.4 Transaction History Screen**

|  |  |
| --- | --- |
| **Component** | **Behaviour** |
| Search bar | Sticky at top. Debounced 300ms. Searches merchantName + note fields locally. |
| Filter chips | Horizontal scroll: All, Income, Expense, SMS, Manual, Voice, This Month, This Week. Multiple selectable. |
| Anomaly alert banner | Shown above list if any anomalies detected. Orange background. Tap → jumps to flagged transaction. |
| Date group headers | Sticky headers: 'TODAY', 'YESTERDAY', 'MON 13 MAY'. Built with SliverPersistentHeader. |
| Transaction list tiles | Leading: category icon in circle. Title: merchantName. Subtitle: time + source badge. Trailing: amount (green/red) + status badge. |
| Swipe to delete | Swipe left reveals red delete background. Release: soft delete + undo SnackBar (5 seconds). |
| Tap | Opens TransactionDetailScreen via GoRouter.push('/transaction/:id'). |
| Infinite scroll | Cursor-based pagination. Load 50 at a time. Loading indicator at bottom while fetching next page. |
| Empty state | If no results: EmptyState widget with illustration + message based on active filters. |
| FAB | Same add button as Home. Consistent across all screens with list content. |

## **2.5 Selective Transaction Calculator (Selection Mode)**

Activated by long-pressing any transaction in TransactionHistoryScreen. Overlays the existing list UI with checkboxes and a floating calculator bar. This is not a separate screen — it is a mode of TransactionHistoryScreen.

|  |  |  |  |
| --- | --- | --- | --- |
| **Component** | **Widget** | **State Source** | **Behaviour** |
| Selection mode trigger | GestureDetector (onLongPress) on TransactionListTile | selectionModeProvider | Long-press: sets isActive=true, adds tapped transaction to selectedIds. Haptic: HapticFeedback.lightImpact(). |
| Transaction checkbox | AnimatedContainer wrapping leading icon | selectionModeProvider.selectedIds | Slides in from left when isActive=true (150ms). Circular checkbox: outlined when unselected, filled colorPrimary when selected. |
| Selected tile highlight | ColoredBox tint behind tile | selectionModeProvider.selectedIds.contains(id) | colorPrimaryLight background when selected. Animated with AnimatedContainer (100ms). |
| Toolbar (top) | AnimatedSwitcher in AppBar actions | selectionModeProvider.isActive | When active: shows '[N] selected' counter + 'Select All' TextButton. When inactive: shows normal search/filter icons. |
| Calculator bar | Animated bottom panel | selectionModeProvider | AnimatedSlide + AnimatedContainer. Slides up from bottom (250ms easeOut) when isActive=true. Sits above BottomNavigationBar. |
| Bar — single type total | Large rupee amount text | selectedTotalProvider | displayLarge style. Green for income, red for expense. AnimatedSwitcher for number transitions. |
| Bar — mixed type breakdown | 3-row column | selectedTotalIncomeProvider, selectedTotalExpenseProvider, selectedNetProvider | Row 1: 'Income: +₹X' (green). Row 2: 'Expenses: -₹Y' (red). Row 3: 'Net: ₹Z' (green/red). bodyMedium style. |
| Bar — share button | IconButton (share icon) | — | Opens share\_plus sheet with pre-formatted summary text. See ticket IGR-033 for exact text format. |
| Bar — close button | IconButton (X icon) | — | Sets selectionModeProvider.isActive=false. Bar slides down (200ms easeIn). All selectedIds cleared. |
| Back button override | WillPopScope / PopScope | selectionModeProvider.isActive | If selection mode active: back button exits selection mode (not the screen). If not active: normal back navigation. |

**Selection Mode State (Riverpod):**

@riverpod

class SelectionMode extends \_$SelectionMode {

@override

SelectionState build() => SelectionState.initial();

void enterMode(String firstId, Transaction firstTxn) {

state = state.copyWith(isActive: true, selectedIds: {firstId},

selectedTransactions: [firstTxn]);

}

void toggleSelection(String id, Transaction txn) {

final ids = Set<String>.from(state.selectedIds);

final txns = List<Transaction>.from(state.selectedTransactions);

if (ids.contains(id)) { ids.remove(id); txns.removeWhere((t)=>t.id==id); }

else { ids.add(id); txns.add(txn); }

if (ids.isEmpty) { exitMode(); return; }

state = state.copyWith(selectedIds: ids, selectedTransactions: txns);

}

void exitMode() => state = SelectionState.initial();

void selectAll(List<Transaction> all) {

state = state.copyWith(selectedIds: all.map((t)=>t.id).toSet(),

selectedTransactions: all);

}

}

// Derived providers — all in paise integers

final selectedIncomeProvider = Provider<int>((ref) {

final txns = ref.watch(selectionModeProvider).selectedTransactions;

return txns.where((t)=>t.type==TransactionType.income)

.fold(0, (sum, t) => sum + t.amount);

});

final selectedExpenseProvider = Provider<int>((ref) {

final txns = ref.watch(selectionModeProvider).selectedTransactions;

return txns.where((t)=>t.type==TransactionType.expense)

.fold(0, (sum, t) => sum + t.amount);

});

final selectedNetProvider = Provider<int>((ref) {

return ref.watch(selectedIncomeProvider) - ref.watch(selectedExpenseProvider);

});

**📝 Validation Rule**

* All validation is done in the ViewModel, not in the Widget. UI reads validation state from the provider. This keeps validation logic testable.

|  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- |
| **Field** | **Type** | **Required** | **Min** | **Max** | **Special Rules** | **Error Message** |
| Transaction amount | Integer (paise) | Yes | 1 (= ₹0.01) | 1,00,00,000 (= ₹10L) | Max 2 decimal places in input | Amount must be greater than ₹0 |
| Transaction date | Date | Yes | 2000-01-01 | Today + 1 day | Future dates rejected | Date cannot be in the future |
| Transaction note | String | No | — | 500 chars | — | Note too long (max 500 characters) |
| Merchant name | String | No | — | 300 chars | Auto-trimmed on save | — |
| Category | UUID | Yes | — | — | Must be from user's category list | Please select a category |
| Phone number (OTP) | String | Yes | 10 digits | 10 digits | Must start with 6-9 (Indian mobile) | Enter a valid 10-digit mobile number |
| Phone number (CA invite) | String | Yes | 10 digits | 10 digits | Same as above. Cannot be own number. | Enter a valid mobile number |
| Business name | String | Yes | 2 chars | 200 chars | Auto-trimmed. No special chars except space, &, -, . | Business name must be 2-200 characters |
| Invoice customer name | String | Yes | 2 chars | 200 chars | — | Customer name is required |
| Invoice line item qty | Float | Yes | 0.01 | 9999 | Max 2 decimal places | Quantity must be greater than 0 |
| Invoice line item price | Integer (paise) | Yes | 1 | 1,00,00,000 | — | Price must be greater than ₹0 |
| Invoice GST % | Float | No | 0 | 28 | Allowed: 0, 5, 12, 18, 28 only | Select a valid GST rate |
| Khata customer name | String | Yes | 2 chars | 200 chars | — | Customer name is required |
| Khata amount | Integer (paise) | Yes | 1 | 1,00,00,000 | — | Amount must be greater than ₹0 |
| NPS score | Integer | No | 0 | 10 | — | — |
| Feedback message | String | Yes for GENERAL/BUG | 10 chars | 2000 chars | — | Please describe your feedback (min 10 characters) |

# **4. Animation Specifications**

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| **Animation** | **Trigger** | **Duration** | **Curve** | **Implementation** |
| Screen transitions | GoRouter push/pop | 300ms | easeInOut | Default GoRouter transition. Slide from right on push, reverse on pop. |
| Bottom sheet open | Modal bottom sheet | 250ms | easeOut | showModalBottomSheet with animation. |
| FAB press | User taps FAB | 100ms | easeInOut | AnimatedScale: 1.0 → 0.92 → 1.0 |
| Card press | Any tappable card | 80ms | easeInOut | InkWell splash + scale 1.0 → 0.97 |
| Net profit number change | New transaction saved | 400ms | easeOut | AnimatedSwitcher with fade + slide up |
| Chart bar reveal | Analytics screen loads | 600ms | easeOut | fl\_chart built-in animation. Bars grow from bottom. |
| Profile switch | User changes active profile | 200ms | easeInOut | Fade out → data reload → fade in |
| Coach mark spotlight | Tutorial step shown | 300ms | easeOut | tutorial\_coach\_mark built-in |
| Delete swipe | Swipe left on list tile | 200ms | easeOut | Dismissible widget with custom background |
| Undo toast appear/dismiss | After delete | Appear: 200ms, Dismiss: 150ms | easeOut | ScaffoldMessenger.showSnackBar with custom animation |
| Skeleton loading shimmer | While data loads | 1200ms repeating | linear | shimmer package: light passes over grey rectangles |
| Biometric lock overlay | App comes to foreground | 150ms | easeIn | Opacity fade from 1.0 → 0.0 after successful auth |

# **5. Accessibility Requirements**

|  |  |  |
| --- | --- | --- |
| **Requirement** | **Standard** | **Implementation** |
| Minimum touch target | 48×48dp | All interactive elements wrapped in SizedBox(min 48×48). Use Semantics widget if visual size smaller. |
| Text scaling | Support up to 200% system font scale | Never use fixed pixel text sizes. Always use textScaleFactor from MediaQuery. |
| Screen reader support | TalkBack (Android) | All custom widgets have Semantics label. Charts have textual description alternative. |
| Color contrast | WCAG AA: 4.5:1 for text | colorPrimary (#0D631B) on white: 7.2:1 ✓. colorError (#B71C1C) on white: 8.1:1 ✓. |
| Hindi/Marathi text | Noto Sans supports all scripts | Noto Sans chosen specifically for Indic script support. Test with actual Hindi input. |
| Motion reduction | Respect system reduce motion setting | Check MediaQuery.disableAnimations. If true: disable all chart animations and transitions. |
| Error announcement | TalkBack reads error messages | Form errors use Semantics(liveRegion: true) so TalkBack announces them. |
| Focus management | Logical focus order | FocusTraversalGroup used in forms. Focus moves logically: amount → category → date → note → save. |

Version 1.0 — Frontend Specification Document — May 2026 — PocketPlus Engineering