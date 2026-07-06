# Skill: PocketPlus Firebase Architect

## File Name
`.ai/skills/pocketplus-firebase-architect.md`

## Purpose
Manages all Firebase-related decisions for PocketPlus — Firestore schema, security rules, Cloud Functions, Storage rules, and FCM. Ensures every Firebase change is secure, cost-optimised, and offline-capable.

## When To Use
- When creating a new Firestore collection
- When writing or modifying security rules
- When creating a Cloud Function
- When debugging Firestore permission errors
- When optimising Firestore reads for cost

## Inputs
- Feature description or ticket ID
- Engineering Spec A-2 (schema) and A-4 (security rules)
- Security & Access document

## Outputs
- Firestore schema definition
- Security rules for the new collection
- Cloud Function code (if needed)
- Index definitions for composite queries

## Dependencies
- `pocketplus-security-auditor.md`

## Rules

### Schema Rules
1. All IDs are UUID v4 — set client-side using the `uuid` package
2. Every document has: `createdAt`, `updatedAt`, `deletedAt` (nullable)
3. All monetary amounts stored as INTEGER (paise)
4. `syncStatus` field on all user-generated documents: `PENDING` | `SYNCED` | `FAILED`
5. Never store raw SMS text — store SHA256 hash only
6. Receipt photo URLs must be signed with expiry — never permanent public URLs

### Firestore Paths (from Engineering Spec A-2)
```
users/{userId}
profiles/{profileId}                    # userId index
transactions/{transactionId}            # userId + profileId index
categories/{categoryId}                 # userId index
sms_dedup_log/{logId}                   # userId + smsHash index
ca_connections/{connectionId}           # ownerId + caPhone index
ca_comments/{commentId}                 # transactionId index
invoices/{invoiceId}                    # userId + profileId index
invoice_items/{itemId}                  # invoiceId index
khata_customers/{customerId}            # userId index
khata_entries/{entryId}                 # customerId index
recurring_expenses/{expenseId}          # userId + profileId index
audit_logs/{logId}                      # WRITE ONLY by Cloud Functions
feedback/{feedbackId}                   # WRITE ONLY by users
analytics_events/{eventId}             # WRITE ONLY
```

### Security Rules Template
```javascript
// Always use this pattern for user-owned resources
match /transactions/{transactionId} {
  allow read, write: if request.auth != null
    && request.auth.uid == resource.data.userId
    && !request.resource.data.keys().hasAny(['userId']); // prevent userId spoofing

  // CA read access
  allow read: if request.auth != null
    && isActiveCA(request.auth.uid, resource.data.userId);
}

function isActiveCA(caUid, ownerUid) {
  return exists(/databases/$(database)/documents/ca_connections/$(caUid + '_' + ownerUid))
    && get(/databases/$(database)/documents/ca_connections/$(caUid + '_' + ownerUid)).data.status == 'ACTIVE';
}
```

### Offline Support
- Enable persistence in FirebaseBootstrap (already done)
- All queries must work with Firestore local cache
- Use `Source.cache` for non-critical reads when offline
- Never block UI waiting for network — show cached data first

### Cost Optimisation
- Paginate all list queries — max 50 documents per page
- Use `streamRecent(limit: 5)` for dashboard — not `streamAll()`
- Composite indexes declared in `firestore.indexes.json` — never auto-created
- Avoid `collectionGroup` queries in Phase 1 — expensive
- Batch writes for atomic operations (invoice → transaction)

### Cloud Functions Checklist
- Runtime: Node.js 20
- Region: `asia-south1` (Mumbai) — always
- Idempotent — safe to run multiple times
- Error → log to Sentry (Phase 2) / console.error (Phase 1)
- Never access production Firebase from dev Functions

## Example Usage
```
[User]: Add support for recurring expenses
[Agent using this skill]:
Collection: recurring_expenses/{expenseId}
Schema:
  id: UUID
  userId: string
  profileId: string
  amount: int (paise)
  categoryId: UUID
  merchantName: string (optional)
  frequency: enum DAILY|WEEKLY|MONTHLY|YEARLY
  dayOfMonth: int (1-31, null if not monthly)
  active: bool
  lastLoggedAt: timestamp (nullable)
  nextDueAt: timestamp
  createdAt: timestamp
  updatedAt: timestamp
  deletedAt: timestamp (nullable)
  syncStatus: PENDING|SYNCED|FAILED

Security rules: owner read/write, CA read-only, no public access
Cloud Function: scheduled 6AM IST daily, queries active where nextDueAt <= today
```

## Recommended AI Models
- **Primary**: Claude Sonnet (best security rules reasoning)
- **Secondary**: Gemini 2.5 Pro (good Firebase knowledge)
- **For Functions**: DeepSeek V3 (strong Node.js)
