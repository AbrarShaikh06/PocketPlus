**POCKETPLUS — ENGINEERING DOCUMENTS**

**Technical Architecture**

System Design, Data Flows & Sequence Diagrams

|  |  |
| --- | --- |
| **Document** | Technical Architecture Document (TAD) |
| **Version** | 1.0 — May 2026 |
| **Covers** | Data flows, sequence diagrams, dependency map, infrastructure |
| **Phase** | Phase 1 (Firebase) + Phase 2 (Django) both covered |

# **1. System Context Diagram**

PocketPlus sits at the centre of three external actor groups: Users (business owners), CAs (chartered accountants), and Google Services (Firebase, AdMob, Play, Gemini).

|  |  |  |
| --- | --- | --- |
| **Actor** | **Type** | **Interaction with PocketPlus** |
| Business Owner (Free) | Primary User | Logs transactions, views dashboard, watches ads to export PDF |
| Business Owner (Basic/Pro) | Primary User | All above + invoices, multiple profiles, CA Connect |
| Chartered Accountant | Secondary User | Reads client books via CA Connect, flags transactions, exports |
| Firebase Firestore | External Service | Primary database for all structured data in Phase 1 |
| Firebase Auth | External Service | OTP and Google OAuth authentication |
| Firebase Storage | External Service | Receipt photo storage |
| Firebase Cloud Functions | External Service | Scheduled tasks, Firestore triggers, FCM sends |
| Firebase Cloud Messaging | External Service | Push notifications to all users |
| Gemini API | External AI Service | Voice NLP, receipt OCR, transaction categorisation |
| Google AdMob | External Service | Rewarded video ads, native ad cards |
| Google Play Billing | External Service | Subscription management (₹100/mo Basic, ₹200/mo Pro) |
| Django + PostgreSQL (Phase 2) | Replaces Firebase | REST API, ML endpoints, CA web dashboard backend |
| React Web App (Phase 2) | CA Web Interface | Browser-based CA dashboard, marketing website |

# **2. Data Flow: SMS Auto-Capture**

The most critical data flow in PocketPlus. Must handle deduplication, offline queuing, and profile routing correctly.

## **2.1 Happy Path Flow**

|  |  |  |  |
| --- | --- | --- | --- |
| **Step** | **Component** | **Action** | **Data Passed** |
| 1 | Android OS | New SMS arrives from bank | Raw SMS text, sender ID |
| 2 | SmsReceiver (BroadcastReceiver) | Wakes PocketPlus process if killed. Receives SMS. | SmsMessage object |
| 3 | BankPatternMatcher | Checks sender ID against known bank list | sender: 'HDFCBK' → match |
| 4 | SmsParser | Runs regex. Extracts amount, type, merchant, date | { amount:85000, type:EXPENSE, merchant:'Aman Store' } |
| 5 | DedupChecker | Computes SHA256(rawSmsText). Checks sms\_dedup\_log | smsHash: 'a3f4...' |
| 6 | ProfileRouter | Checks bankAccountLast4 arrays across user profiles | profileId: 'uuid-biz' |
| 7 | GeminiCategoriser | Sends merchant name to Gemini. Gets category suggestion | { categoryId, confidence:0.89 } |
| 8 | CaptureNotificationService | Shows system notification: '₹850 detected — tap to confirm' | Notification with deep link |
| 9 | CaptureConfirmationScreen | User sees pre-filled entry. Selects category. Taps Confirm. | User action |
| 10 | TransactionRepository | Writes transaction to Firestore with syncStatus:PENDING | Transaction document |
| 11 | Firestore SDK | Syncs to Firebase. Updates syncStatus:SYNCED. | Network call |
| 12 | AuditLogger (Cloud Function) | Firestore trigger: writes to audit\_logs | Audit entry |
| 13 | AnalyticsService | Logs: sms\_capture\_confirmed, transaction\_created | Firebase Analytics |

## **2.2 Deduplication Flow**

Incoming SMS

│

├─ Compute SHA256(rawSmsText) → smsHash

│

├─ Query sms\_dedup\_log WHERE userId=X AND smsHash=Y

│ ├─ EXISTS → action: DUPLICATE\_SKIPPED

│ │ Log to analytics: sms\_duplicate\_skipped

│ │ STOP. Show nothing to user.

│ │

│ └─ NOT EXISTS → continue to parse

│

└─ After user confirms: write sms\_dedup\_log { smsHash, action:LOGGED, transactionId }

After user dismisses: write sms\_dedup\_log { smsHash, action:DISMISSED, transactionId:null }

## **2.3 Offline SMS Flow**

SMS arrives (no internet)

│

├─ Parse, dedup check (local Firestore cache)

├─ Show notification + confirmation UI (works offline)

├─ User confirms

├─ Write to Firestore local cache (syncStatus: PENDING)

├─ Firestore SDK queues write

└─ Internet returns → Firestore SDK syncs → syncStatus: SYNCED

→ Cloud Function triggers → audit\_log written

# **3. Data Flow: CA Connect**

## **3.1 Invite → Accept → Live Access**

|  |  |  |  |
| --- | --- | --- | --- |
| **Step** | **Actor** | **Action** | **Technical Detail** |
| 1 | Owner | Taps 'Invite CA', enters CA phone | UI: CAConnectScreen |
| 2 | Flutter App | POST /api/v1/ca/invite (Phase 2) or write to Firestore (Phase 1) | Creates ca\_connections: { status:PENDING, inviteToken:random64hex } |
| 3 | Flutter App | Opens WhatsApp via url\_launcher: wa.me/91XXXXXXXXXX?text=... | Deep link with invite URL: pocketplus.app/ca/accept?token=ABC123 |
| 4 | CA | Receives WhatsApp. Taps invite link. Downloads PocketPlus. |  |
| 5 | CA | Opens app. Sees pending invite on CA Connect tab. | App reads ca\_connections WHERE caPhone=CA's phone AND status=PENDING |
| 6 | CA | Taps Accept | POST /api/v1/ca/accept { inviteToken } |
| 7 | Server | Validates token. Sets status=ACTIVE. Writes caId. | Atomic update |
| 8 | Firestore Rules | Now allow caId to read owner's transactions | Security rules evaluate isConnectedCA() → true |
| 9 | FCM | Notifies owner: 'Your CA has connected' | Cloud Function: onCAAccept trigger |
| 10 | CA | Opens owner's transactions in real-time | Firestore real-time listener on transactions where userId=ownerId |
| 11 | CA | Flags a transaction, adds comment | Creates ca\_comments document |
| 12 | FCM | Notifies owner: 'Your CA has a question' | Cloud Function: onCAComment trigger |
| 13 | Owner (any time) | Taps Revoke Access | Sets ca\_connections.status=REVOKED |
| 14 | Firestore Rules | isConnectedCA() → false. CA reads blocked immediately. | No migration, no cache flush needed — rules evaluated per request |

# **4. Data Flow: PDF Export with Rewarded Ad**

## **4.1 Free User Flow**

User taps 'Export PDF'

│

├─ Check user plan

│ ├─ FREE: check ad loaded?

│ │ ├─ YES → show RewardedAd

│ │ │ ├─ User watches ad (onUserEarnedReward fires)

│ │ │ │ → generatePDF() → download

│ │ │ └─ User skips ad (no reward)

│ │ │ → show SnackBar: 'Watch the full ad to export'

│ │ └─ NO (ad not loaded) → wait max 5s

│ │ ├─ Loads in 5s → show ad

│ │ └─ Still not loaded → generatePDF() anyway (offline fallback)

│ │ log: rewarded\_ad\_failed { fallback: 'exported\_anyway' }

│ │

│ ├─ BASIC: monthlyExportCount < 5?

│ │ ├─ YES → generatePDF() immediately

│ │ └─ NO → same rewarded ad flow as FREE

│ │

│ └─ PRO: generatePDF() immediately, no ad, no quota

│

└─ generatePDF()

├─ Fetch transactions from Firestore local cache (offline-safe)

├─ Render with pdf Flutter package

├─ Save to device Downloads folder

└─ Show share sheet (WhatsApp, email, etc.)

# **5. Data Flow: Invoice → Transaction**

When an invoice is marked PAID, an income transaction is created atomically. This is the most important atomic operation in PocketPlus.

User taps 'Mark as Paid' on an invoice

│

├─ Validate: grandTotal > 0, status != PAID already

│

├─ Start Firestore Batch (atomic — all succeed or all fail)

│ ├─ Write 1: Update invoices/{id}

│ │ { status: PAID, paidAt: now(), paidAmount: grandTotal }

│ │

│ └─ Write 2: Create transactions/{newId}

│ { userId, profileId, amount: grandTotal, type: INCOME,

│ source: INVOICE, categoryId: 'sales-category-id',

│ note: 'Invoice INV-042 — Rahul Sharma',

│ transactionDate: today, invoiceId: invoice.id }

│

├─ batch.commit()

│ ├─ SUCCESS: UI shows both updated invoice + new transaction

│ └─ FAILURE: NOTHING written. Show: 'Could not save. Retry?'

│

└─ Cloud Function trigger: writes audit\_log for both writes

# **6. Data Flow: Recurring Expense Auto-Log**

Firebase Cloud Function — scheduled: '0 6 \* \* \*' (6 AM IST daily)

│

├─ Query: recurring\_expenses WHERE active=true AND nextDueAt <= today

│

├─ For each due recurring expense:

│ ├─ Check: was it already logged today? (lastLoggedAt = today) → skip

│ │

│ ├─ Create transaction (same atomic batch as invoice flow)

│ │ { source: RECURRING, recurringId: expense.id, ... }

│ │

│ ├─ Update recurring\_expense:

│ │ { lastLoggedAt: now(), nextDueAt: calculateNext(frequency, dayOfMonth) }

│ │

│ └─ autoConfirm = false → send FCM notification to user

│ '3 recurring expenses auto-logged for June — tap to review'

│

└─ Error handling: if any expense fails, log to Sentry. Continue others.

Never let one failure block the rest.

# **7. Infrastructure Diagram — Phase 1**

|  |  |  |  |
| --- | --- | --- | --- |
| **Component** | **Provider** | **Region** | **Cost** |
| Flutter App | User's Android device | Local | Free |
| Firebase Firestore | Google Cloud | asia-south1 (Mumbai) | Free tier → pay-as-you-go |
| Firebase Auth | Google Cloud | Global | Free up to 10k/month |
| Firebase Storage | Google Cloud | asia-south1 | Free tier: 5GB storage, 1GB/day download |
| Firebase Cloud Functions | Google Cloud | asia-south1 | Free: 2M invocations/month |
| Firebase Cloud Messaging | Google Cloud | Global | Free, unlimited |
| Firebase Analytics + Crashlytics | Google Cloud | Global | Free |
| Gemini API | Google AI | Global | Free tier: 15 RPM, 1M tokens/day |
| Google AdMob | Google | Global | Free — you earn revenue |
| Google Play Billing | Google Play | Global | 15–30% rev share on subscriptions |

# **8. Infrastructure Diagram — Phase 2 (Migration)**

|  |  |  |  |
| --- | --- | --- | --- |
| **Component** | **Provider** | **Cost / month** | **Notes** |
| Django API Server | Railway Starter → Pro | ₹0 → ₹800 | Scale up when needed |
| PostgreSQL Database | Railway | Included in plan | Up to 100GB on Pro |
| Redis (Celery broker) | Railway | ₹400 | Required for Celery task queue |
| React CA Dashboard | Vercel Free | ₹0 | Auto-deploys from GitHub main branch |
| PocketPlus.in Marketing Site | Vercel Free | ₹0 | Static site, CDN-served |
| Email (CA reports) | Resend Free → Scale | ₹0 → ₹600 | 3,000 free emails/month |
| Error Monitoring | Sentry Developer Free | ₹0 | 5k errors/month free |
| Django → Firebase migration | One-time Python script | ₹0 | Run once, then deprecated |

# **9. Dependency Map — Flutter Packages**

Every package has a purpose. No package should be added without updating this list.

|  |  |  |  |
| --- | --- | --- | --- |
| **Package** | **Version** | **Purpose** | **Replaceable With** |
| firebase\_core | 3.x | Firebase initialisation — required base | — |
| cloud\_firestore | 5.x | Realtime database, offline cache | ApiDataSource in Phase 2 |
| firebase\_auth | 5.x | Auth — Google + OTP | JWT auth in Phase 2 |
| firebase\_storage | 12.x | Receipt photo upload | S3 / Django file upload in Phase 2 |
| firebase\_messaging | 15.x | Push notifications | FCM stays even in Phase 2 |
| firebase\_analytics | 11.x | Event tracking | Kept in Phase 2 (alongside Django analytics) |
| firebase\_crashlytics | 4.x | Crash reporting | Sentry added in Phase 2 alongside |
| riverpod | 2.5.x | State management | NOT replaceable — architectural choice |
| flutter\_riverpod | 2.5.x | Riverpod Flutter integration | — |
| go\_router | 14.x | Navigation / deep linking | NOT replaceable — handles invite deep links |
| google\_mobile\_ads | 5.x | AdMob rewarded + native | — |
| in\_app\_purchase | 3.1.x | Play Billing subscriptions | — |
| fl\_chart | 0.68.x | Charts — bar, line, pie | — |
| pdf | 3.10.x | PDF generation (offline) | — |
| printing | 5.x | PDF preview + share sheet | — |
| image\_picker | 1.x | Camera + gallery for receipts | — |
| speech\_to\_text | 6.x | Voice → text for voice entry | — |
| local\_auth | 2.x | Biometric fingerprint/face lock | — |
| tutorial\_coach\_mark | 3.x | Onboarding coach marks | — |
| permission\_handler | 11.x | SMS, camera, microphone permissions | — |
| telephony | 2.x | Incoming SMS listener | — |
| share\_plus | 9.x | WhatsApp share for PDFs/invoices | — |
| url\_launcher | 6.x | WhatsApp deep links, CA invite | — |
| intl | 0.19.x | Indian locale formatting ₹1,00,000 | — |
| path\_provider | 2.x | Device file paths for PDF save | — |
| crypto | 3.x | SHA256 for SMS deduplication | — |
| uuid | 4.x | UUID v4 generation for all IDs | — |
| dartz | 0.10.x | Either<Failure,T> error handling | — |
| freezed | 2.x | Immutable data classes (entities) | — |
| json\_serializable | 6.x | JSON serialisation for API models | — |
| flutter\_secure\_storage | 9.x | JWT storage (uses Android Keystore) | — |
| connectivity\_plus | 6.x | Network status for offline detection | — |

Version 1.0 — Technical Architecture Document — May 2026 — PocketPlus Engineering