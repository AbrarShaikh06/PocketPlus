# Skill: PocketPlus Architect

## File Name
`.ai/skills/pocketplus-architect.md`

## Purpose
Acts as the lead systems architect for PocketPlus. Enforces architectural decisions, reviews structural changes, and ensures all new code aligns with the feature-first Clean Architecture defined in Engineering Spec A-1.

## When To Use
- Before starting any new feature
- When reviewing PRs that touch core/ or shared/
- When adding new packages to pubspec.yaml
- When creating new features or modules
- When planning Phase 2 Django migration steps

## Inputs
- Feature description or ticket ID
- Affected files or folders
- Engineering Spec A-1 (architecture rules)
- Technical Architecture Document (TAD)

## Outputs
- Folder structure plan for the feature
- List of files to create (data/domain/presentation split)
- Package recommendations
- Warnings for any architectural violations

## Dependencies
None — this is a root skill.

## Rules
1. Every feature MUST follow: `features/{name}/data/`, `features/{name}/domain/`, `features/{name}/presentation/`
2. No feature may import directly from another feature — only through `shared/` or `core/`
3. All repositories return `Either<Failure, T>` — never throw exceptions to the UI
4. State management is Riverpod ONLY — no Provider, no Bloc, no GetX
5. Navigation is GoRouter ONLY — no Navigator.push anywhere
6. All monetary values are stored as INTEGER (paise) — never double or float
7. No package may be added without updating the dependency map in TAD section 9
8. Phase 1 = Firebase only. No custom HTTP calls except Gemini API
9. Soft deletes only — never hard delete financial data (GST compliance)
10. All IDs are UUID v4 — never Firestore auto-IDs in domain layer

## Detailed Instructions

### Analyzing a new feature request:
1. Identify which existing feature it belongs to OR if a new feature folder is needed
2. Define the domain entity (pure Dart, no Firebase imports)
3. Define the repository interface in domain/
4. Define the data source in data/
5. Define the ViewModel (Notifier) in presentation/
6. List all Riverpod providers needed
7. Check if any shared/ widgets need to be created or reused
8. Verify no cross-feature imports are introduced

### Checking for violations:
- Scan for `Navigator.push` → replace with `context.go()` or `context.push()`
- Scan for `double` in amount fields → replace with `int` (paise)
- Scan for direct Firestore calls in presentation/ → move to data/
- Scan for `throw` in repository → replace with `Left(Failure(...))`
- Scan for feature-to-feature imports → route through shared/

## Example Usage
```
[User]: I want to add a recurring expense feature
[Agent using this skill]:
1. Feature folder: features/recurring_expenses/
2. Domain entity: RecurringExpense { id, profileId, amount(paise), categoryId, frequency, dayOfMonth, nextDueAt, active }
3. Repository interface: RecurringExpenseRepository with CRUD + getActiveDue(DateTime)
4. Data source: FirestoreRecurringExpenseDataSource
5. ViewModel: RecurringExpenseViewModel (Notifier)
6. Providers: recurringExpensesProvider, dueRecurringExpensesProvider
7. No new shared widgets needed — reuse AppCard, AppButton
8. Cloud Function needed for auto-log scheduler (TAD section 6)
```

## Recommended AI Models
- **Primary**: Claude Sonnet / Opus (best for architectural reasoning)
- **Secondary**: Gemini 2.5 Pro (good for Flutter-specific patterns)
- **Avoid**: Models without strong Dart knowledge for this skill
