# Skill: PocketPlus Security Auditor

## File Name
`.ai/skills/pocketplus-security-auditor.md`

## Purpose
Reviews all PocketPlus code for security vulnerabilities, data classification violations, Firestore rules gaps, and compliance issues (DPDP Act, GST, RBI, Play Store). Blocks any code that exposes CRITICAL or SENSITIVE data.

## When To Use
- Before every Firebase rules deployment
- Before any feature touching transactions, auth, or CA connect
- When reviewing CA access patterns
- Before Play Store submission
- After any incident or P0 alert

## Inputs
- Code to review (Dart, Firebase rules, Cloud Functions)
- Security & Access document
- Data classification table

## Outputs
- Security violations list (CRITICAL / HIGH / MEDIUM / LOW)
- Fixed code or rules
- Compliance checklist result

## Dependencies
None — runs independently.

## Rules

### Data Classification (must never be violated)
```
CRITICAL (never log, never transmit unencrypted):
  - Phone numbers
  - Transaction amounts
  - Merchant names
  - Invoice details
  - Bank account numbers

SENSITIVE (never in public logs):
  - Business name
  - Profile name
  - CA connection details
  - Khata customer names

INTERNAL (aggregate analytics only):
  - Category names, app version, sessionId

PUBLIC:
  - Feature names, marketing copy
```

### Automatic BLOCK conditions
Agent must refuse to generate code that:
1. Logs phone numbers or amounts to console/Crashlytics
2. Stores raw SMS text anywhere (only SHA256 hash allowed)
3. Allows CA to write transactions (read-only enforced at DB level)
4. Hard-deletes financial records (soft-delete only)
5. Stores JWT in SharedPreferences (must use flutter_secure_storage)
6. Makes HTTP calls without TLS (all must be HTTPS)
7. Exposes Firebase credentials in source code (use --dart-define)
8. Allows unauthenticated Firestore reads on user data
9. Generates invoice numbers client-side (must be server-side atomic)
10. Stores biometric data (BiometricPrompt API only — never touch biometric data)

### Firestore Rules Audit Checklist
```
[ ] Owner can read/write own documents
[ ] CA (active) can READ but NOT WRITE transactions
[ ] CA (revoked) has NO ACCESS
[ ] Other users have NO ACCESS
[ ] Cloud Functions use admin SDK (bypass rules intentionally)
[ ] audit_logs: WRITE ONLY by Cloud Functions, READ ONLY by owner
[ ] CA revocation is immediate (no cache window)
[ ] Profile isolation: every query filters by profileId
```

### OTP Security Checklist
```
[ ] Max 3 OTP requests per phone per 10 minutes
[ ] Max 10 OTP requests per phone per 24 hours
[ ] OTP expires in 5 minutes
[ ] OTP is 6 digits (single use)
[ ] After 10 failed verifications: 24-hour lockout
[ ] Rate limit per IP: max 20 per hour
```

### DPDP Act Compliance
```
[ ] GET /api/v1/users/data-export returns ALL user data as JSON
[ ] DELETE /api/v1/users/me triggers 30-day grace period then hard delete
[ ] Privacy policy URL live at pocketplus.in/privacy before Play Store submission
[ ] Privacy policy explicitly mentions SMS processing
```

### GST Compliance
```
[ ] All transactions use soft delete only (deletedAt timestamp)
[ ] Financial records retained minimum 7 years
[ ] No hard deletes on any financial collection
[ ] category.gstHead maps to valid GST rate slabs
```

## Example Usage
```
[User]: Review this Firestore rule
[Agent]:
VIOLATION FOUND — CRITICAL:
Rule allows CA to write to transactions/{id}
CA access must be READ ONLY per Security & Access doc section 3.1
Fix:
  allow read: if isActiveCA(...);  // ✓
  allow write: if request.auth.uid == resource.data.userId;  // owner only ✓
```

## Recommended AI Models
- **Primary**: Claude Opus (best security reasoning)
- **Secondary**: Claude Sonnet
- **Avoid**: Models that tend to be overly permissive or skip security checks
