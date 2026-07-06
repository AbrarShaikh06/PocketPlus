**POCKETPLUS — ENGINEERING DOCUMENTS**

**Security & Access**

Threat Model, Access Control, Compliance & Incident Response

|  |  |
| --- | --- |
| **Document** | Security & Access Control Document |
| **Version** | 1.0 — May 2026 |
| **Classification** | Internal — Engineering + Founders Only |
| **Covers** | Threat model, OWASP checklist, data classification, access control matrix, compliance, incident response |

# **1. Data Classification**

**🔴 Critical Rule**

* Every field in every database table must be classified. AI agents must never log, print, or transmit data above its classification level.

|  |  |  |  |
| --- | --- | --- | --- |
| **Classification** | **Definition** | **Examples** | **Rules** |
| CRITICAL | Data that directly identifies a person or their finances | Phone number, transaction amounts, merchant names, invoice details, bank account numbers | Never in logs, never in analytics events, never in error messages. Encrypted at rest. Transmitted only over TLS 1.3. |
| SENSITIVE | Data that could identify a person indirectly | Business name, profile name, email, CA connection details, khata customer names | Never in public logs. Only accessible to authenticated owner. Included in DPDP export. |
| INTERNAL | App operational data not tied to a specific person's identity | Category names, app version, platform, sessionId, event names | Can appear in aggregate analytics. Never tied to real user identity in logs. |
| PUBLIC | Data intentionally public | App store listing, marketing copy, feature names | No restrictions. |

# **2. Threat Model**

## **2.1 Attack Surface Map**

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| **Attack Surface** | **Threat** | **Likelihood** | **Impact** | **Mitigation** |
| SMS Read permission | Malicious app reads SMS to steal OTPs | Low (Android 12+ restricts SMS access) | Critical | SMS read limited to background processing only. Permission declared as 'financial transaction detection' in Play Console. |
| Firestore — unauthenticated reads | Attacker reads other users' financial data | Medium (if rules misconfigured) | Critical | Comprehensive security rules. Tested via Firebase Rules Unit Tests. CA access validated server-side. |
| JWT token theft (XSS) | Attacker steals JWT from local storage | Low (native app, no XSS) | High | JWT stored in Flutter SecureStorage (Android Keystore). Never in SharedPreferences. 15-min expiry limits blast radius. |
| OTP brute force | Attacker tries all 6-digit OTPs | Medium | High | Rate limit: 3 OTPs per phone per 10 min. OTP expires in 5 min. Firebase Auth handles lockout. |
| Invoice number manipulation | User forces invoice sequence to create confusion | Low | Medium | Invoice numbers generated server-side via atomic Firestore transaction. Client cannot control numbering. |
| CA reads owner data after revocation | Revoked CA still queries Firestore | Low | High | Security rules evaluated per-request. Revocation is immediate. No cached CA access. |
| Replay attack on SMS dedup | Attacker re-sends old SMS to create duplicate transactions | Low | Medium | SHA256 hash uniquely identifies each SMS text. Stored in sms\_dedup\_log with UNIQUE constraint. |
| Play Billing bypass | User claims subscription without paying | Low | Medium | Server-side purchase token verification with Google Play API. Never trust client-only receipt. |
| Gemini prompt injection | Malicious merchant name injects instructions | Low | Low | Structured output format enforced. Gemini response parsed as JSON only. Unexpected format → fallback category. |
| Mass account enumeration | Attacker probes /auth/request-otp to enumerate phone numbers | Medium | Low | Rate limit per IP + per phone. Firebase Auth hides whether phone exists. |

# **3. Access Control Matrix**

## **3.1 Firestore Document Access**

|  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| **Resource** | **Owner (self)** | **CA (active connection)** | **CA (revoked)** | **Other Users** | **Cloud Functions** |
| users/{uid} | READ WRITE | NO ACCESS | NO ACCESS | NO ACCESS | READ (for notifications) |
| profiles/{id} | READ WRITE | NO ACCESS | NO ACCESS | NO ACCESS | READ |
| transactions/{id} | READ WRITE | READ ONLY | NO ACCESS | NO ACCESS | READ WRITE (audit) |
| categories/{id} | READ WRITE | READ ONLY | NO ACCESS | NO ACCESS | READ |
| ca\_connections/{id} | READ WRITE | READ WRITE | READ ONLY | NO ACCESS | READ WRITE |
| ca\_comments/{id} | READ (own), WRITE (resolved) | READ WRITE | NO ACCESS | NO ACCESS | READ WRITE |
| invoices/{id} | READ WRITE | READ ONLY | NO ACCESS | NO ACCESS | READ WRITE |
| khata\_customers/{id} | READ WRITE | NO ACCESS | NO ACCESS | NO ACCESS | READ |
| audit\_logs/{id} | READ ONLY | NO ACCESS | NO ACCESS | NO ACCESS | WRITE ONLY |
| feedback/{id} | WRITE ONLY (own) | NO ACCESS | NO ACCESS | NO ACCESS | READ WRITE |
| analytics\_events/{id} | WRITE ONLY | NO ACCESS | NO ACCESS | NO ACCESS | READ |

## **3.2 API Endpoint Access (Phase 2)**

|  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| **Endpoint** | **Free User** | **Basic User** | **Pro User** | **CA** | **Unauthenticated** |
| POST /auth/request-otp | ✓ | ✓ | ✓ | ✓ | ✓ (public) |
| POST /auth/verify-otp | ✓ | ✓ | ✓ | ✓ | ✓ (public) |
| GET /transactions | Own only | Own only | Own only | Connected clients only | ✗ |
| POST /transactions | ✓ | ✓ | ✓ | ✗ (read-only) | ✗ |
| GET /reports/summary | ✓ | ✓ | ✓ | Connected clients | ✗ |
| GET /reports/export-pdf | Ad required | 5 free then ad | ✓ unlimited | ✗ | ✗ |
| POST /ca/invite | ✗ (Pro only) | ✗ (Pro only) | ✓ | ✗ | ✗ |
| POST /ca/accept | ✗ | ✗ | ✗ | ✓ | ✗ |
| GET /invoices | ✗ (view only) | ✓ | ✓ | Connected clients | ✗ |
| POST /invoices | ✗ | ✓ | ✓ | ✗ | ✗ |
| GET /ml/forecast | ✗ | ✗ | ✓ | ✗ | ✗ |
| GET /ml/health-score | ✗ | ✗ | ✓ | Connected clients | ✗ |
| DELETE /users/me | ✓ | ✓ | ✓ | ✓ | ✗ |

# **4. Encryption Standards**

|  |  |  |  |
| --- | --- | --- | --- |
| **Data State** | **Standard** | **Implementation** | **Who Controls** |
| Data in transit (app ↔ Firebase) | TLS 1.3 | Firebase SDK enforces. Cannot be disabled. | Google |
| Data in transit (app ↔ Gemini) | TLS 1.3 | HTTPS enforced by Dart http package. | Google + App |
| Data in transit (Phase 2 app ↔ Django) | TLS 1.3 | Railway provides TLS termination. HTTP disabled. | Railway + App |
| Data at rest (Firestore) | AES-256 | Google-managed encryption. Automatic. | Google |
| Data at rest (Firebase Storage) | AES-256 | Google-managed encryption. Automatic. | Google |
| Data at rest (Phase 2 PostgreSQL) | AES-256 | Railway disk encryption. Enabled by default. | Railway |
| JWT tokens (on device) | Android Keystore | flutter\_secure\_storage uses Keystore API. | Android OS |
| Biometric data | Android BiometricPrompt API | Never touches PocketPlus code. OS handles entirely. | Android OS |
| SMS raw content | Never stored | SHA256 hash only. Raw text discarded after parsing. | N/A |
| Backups (Phase 2) | AES-256 | Railway automated backups with encryption. | Railway |

# **5. OTP & Authentication Security Detail**

## **5.1 OTP Flow Security**

Rate limits (per phone number):

- Max 3 OTP requests per 10-minute window

- Max 10 OTP requests per 24-hour window

- After 10 failed verifications: 24-hour lockout

- OTP expires: 5 minutes after issue

- OTP length: 6 digits (1,000,000 possibilities)

- OTP is single-use: invalidated immediately after verification

Rate limits (per IP address):

- Max 20 OTP requests per hour per IP

- Exceeding → RATE\_LIMITED error, 1-hour cooldown

Implementation: Firebase Auth built-in rate limiting + Cloud Function

secondary check for the 10/24h limit stored in Firestore.

## **5.2 JWT Token Security**

|  |  |  |
| --- | --- | --- |
| **Property** | **Value** | **Rationale** |
| Access token lifetime | 15 minutes | Limits exposure window if token is leaked |
| Refresh token lifetime | 7 days | Balances security with user experience (not re-logging daily) |
| Refresh token storage | Android Keystore via flutter\_secure\_storage | Encrypted by OS. Inaccessible to other apps even on rooted devices. |
| Refresh token rotation | New token issued on every refresh. Old invalidated. | Prevents refresh token reuse if intercepted |
| Token invalidation | DELETE /auth/logout invalidates server-side | User can hard-logout on lost/stolen device |
| JWT claims | { userId, plan, deviceId, iat, exp } | deviceId enables device binding in Phase 2 |
| Token algorithm | RS256 (asymmetric) | Private key on server only. Public key for verification. |

# **6. Compliance Checklist**

## **6.1 Play Store Compliance**

|  |  |  |
| --- | --- | --- |
| **Requirement** | **Status** | **Implementation** |
| SMS permission declaration | Required | Play Console: Declare 'READ\_SMS' for financial transaction auto-detection. Justification text documented in Eng Spec A-4. |
| Privacy policy URL | Required | Must be live at pocketplus.in/privacy before Play Store submission. Must explicitly mention SMS processing. |
| Data safety form | Required | Declare: financial info collected, SMS read on-device, no data sold, data encrypted. |
| Play Billing for subscriptions | Required | All ₹100/₹200 subscriptions go through Google Play Billing exclusively. No external payment links in app. |
| Target API level | Required | Target SDK 34 (Android 14). Minimum SDK 26 (Android 8). |

## **6.2 Indian Regulatory Compliance**

|  |  |  |
| --- | --- | --- |
| **Regulation** | **Requirement** | **PocketPlus Implementation** |
| DPDP Act 2023 | Users must be able to access and delete their personal data | GET /api/v1/users/data-export returns all user data as JSON. DELETE /api/v1/users/me triggers 30-day grace period then hard delete. |
| GST (Goods & Services Tax) | Financial records must be retained for audit | All transactions retain deletedAt as soft delete only. Records kept minimum 7 years. Hard deletes forbidden on financial data. |
| IT Act 2000 (Section 43A) | Reasonable security practices for sensitive personal data | AES-256 at rest, TLS 1.3 in transit, biometric lock, JWT rotation all implemented. |
| RBI Digital Payments | Apps reading payment SMSes must follow RBI guidelines | SMS read on-device only, never transmitted. Compliant with RBI's data localisation requirements. |

# **7. Incident Response Playbook**

## **7.1 Severity Levels**

|  |  |  |  |
| --- | --- | --- | --- |
| **Level** | **Definition** | **Response Time** | **Examples** |
| P0 — Critical | Data breach or financial data exposure | Immediately (24/7) | Firestore rules misconfigured, JWT leak, SMS data transmitted to server |
| P1 — High | Core feature broken for all users | < 2 hours | Transaction save failing, auth broken, CA connect down |
| P2 — Medium | Feature degraded for subset of users | < 8 hours | SMS parser failing for one bank, Gemini API errors, ad loading failure |
| P3 — Low | Minor bug, UI issue | Next business day | Wrong chart color, typo, minor layout issue |

## **7.2 P0 Response Steps**

1. DETECT: Crashlytics alert or user report. Acknowledge within 15 minutes.
2. CONTAIN: If Firestore rules compromised → immediately publish restrictive rules (deny all reads/writes). This takes effect in < 1 minute globally.
3. ASSESS: Determine scope. How many users affected? What data was exposed?
4. NOTIFY: If > 100 users affected: notify via in-app message + email within 72 hours (DPDP Act requirement).
5. FIX: Deploy corrected rules or code. Validate on the emulator first. Phased rollout.
6. POST-MORTEM: Write incident report within 72 hours. Root cause, timeline, fix, prevention.

Version 1.0 — Security & Access Document — May 2026 — CONFIDENTIAL — PocketPlus Engineering