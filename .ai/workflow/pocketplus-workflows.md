# PocketPlus — Agent Workflows
> Reference this file to know which skills to load and in what order for any task.

---

## Workflow: Build a New Feature

**Trigger**: New IGR-XXX ticket to implement

**Skills to load** (in order):
1. `memory/project-context.md` ← always first
2. `.ai/skills/pocketplus-flutter-conventions.md`
3. `.ai/skills/pocketplus-architect.md`
4. `.ai/skills/pocketplus-firebase-architect.md` (if Firestore needed)
5. `.ai/skills/pocketplus-security-auditor.md` (if user data involved)
6. `.ai/skills/pocketplus-feature-builder.md`
7. `.ai/skills/pocketplus-qa-engineer.md`

**Steps**:
```
1. Read full ticket acceptance criteria
2. Plan folder structure (data/domain/presentation)
3. Design Firestore schema if needed
4. Security audit data classification
5. Build domain layer (entity + repository interface)
6. Build data layer (datasource + repository impl)
7. Build presentation layer (viewmodel + screen)
8. Write widget tests
9. flutter analyze → must be zero errors
10. flutter test → must pass
```

---

## Workflow: Fix a Bug

**Trigger**: Error, crash, or wrong behaviour reported

**Skills to load**:
1. `memory/project-context.md`
2. `.ai/skills/pocketplus-bug-hunter.md`
3. `.ai/skills/pocketplus-flutter-conventions.md`

**Steps**:
```
1. Reproduce the bug
2. Identify root cause (not just symptom)
3. Fix the root cause
4. Add regression test
5. flutter analyze → zero errors
6. flutter test → all pass
```

---

## Workflow: Firebase / Firestore Change

**Trigger**: New collection, rule update, or Cloud Function

**Skills to load**:
1. `memory/project-context.md`
2. `.ai/skills/pocketplus-firebase-architect.md`
3. `.ai/skills/pocketplus-security-auditor.md`

**Steps**:
```
1. Design schema with all required fields
2. Write security rules
3. Audit rules against access control matrix
4. Run Firebase Rules Unit Tests against the emulator (demo-pocketplus)
5. Only after passing → deploy to the single Firebase project
```

**Never skip**: Security audit before any rules deployment.

---

## Workflow: SMS Parser Update

**Trigger**: New bank to support or SMS parsing bug

**Skills to load**:
1. `memory/project-context.md`
2. `.ai/skills/pocketplus-sms-specialist.md`
3. `.ai/skills/pocketplus-security-auditor.md`
4. `.ai/skills/pocketplus-qa-engineer.md`

**Steps**:
```
1. Collect 5+ real SMS examples from the bank
2. Write regex pattern
3. Test against all examples
4. Add sender ID to known banks list
5. Write 10+ test cases
6. Run full SMS test suite (100+ cases must pass)
7. Verify raw SMS still never stored (hash only)
```

---

## Workflow: Transaction Feature

**Trigger**: Any IGR-007 to IGR-014 ticket

**Skills to load**:
1. `memory/project-context.md`
2. `.ai/skills/pocketplus-transaction-specialist.md`
3. `.ai/skills/pocketplus-firebase-architect.md`
4. `.ai/skills/pocketplus-security-auditor.md`

**Key reminders**:
```
- All amounts in paise (int) — never double
- Soft delete only — never hard delete
- Atomic batch for invoice→transaction
- Gemini categorisation: confidence < 0.6 → don't pre-select
- Voice entry: parse text → paise conversion → Gemini category
```

---

## Workflow: Security Review

**Trigger**: Before any release or after a P0 incident

**Skills to load**:
1. `memory/project-context.md`
2. `.ai/skills/pocketplus-security-auditor.md`

**Checklist**:
```
[ ] No CRITICAL data (phone, amounts) in logs
[ ] Raw SMS never stored
[ ] JWT in flutter_secure_storage only
[ ] All Firestore rules tested
[ ] CA cannot write transactions
[ ] Soft delete enforced on financial data
[ ] OTP rate limits active
[ ] TLS enforced on all network calls
[ ] Privacy policy live at pocketplus.in/privacy
[ ] DPDP data export endpoint working
```

---

## Workflow: Release Preparation

**Trigger**: Ready for Play Store submission

**Skills to load**:
1. `memory/project-context.md`
2. `.ai/skills/pocketplus-security-auditor.md`
3. `.ai/skills/pocketplus-qa-engineer.md`

**Steps**:
```
1. flutter analyze → zero errors
2. flutter test → 100% pass
3. Full security review checklist
4. flutter build apk --release
5. Verify privacy policy live
6. Fill Play Console Data Safety form
7. Declare SMS permission with justification
8. Phased rollout: 10% → 50% → 100%
```

---

## Skill Dependency Graph
```
project-context.md (always load first)
│
├── pocketplus-flutter-conventions.md (load before any code generation)
│       │
│       └── pocketplus-architect.md
│               │
│               └── pocketplus-feature-builder.md
│                       ├── pocketplus-firebase-architect.md
│                       │       └── pocketplus-security-auditor.md
│                       ├── pocketplus-transaction-specialist.md
│                       └── pocketplus-sms-specialist.md
│
├── pocketplus-qa-engineer.md (after any feature is built)
└── pocketplus-bug-hunter.md (any time, independent)
```

---

## Model Recommendations by Task
| Task | Best Model |
|------|-----------|
| Architecture & planning | Claude Opus/Sonnet |
| Flutter UI screens | Gemini 3.5 / Kimi K2 |
| Dart logic & algorithms | DeepSeek (OpenCode Zen) |
| Security review | Claude Opus |
| Test generation | DeepSeek / Claude Sonnet |
| SMS regex | Claude Sonnet |
| Firebase rules | Claude Sonnet |
| Node.js Cloud Functions | DeepSeek |
| Quick UI components | Kimi K2.6 / BlackboxAI |
| Receipt OCR prompts | Gemini 3.5 (multimodal) |
