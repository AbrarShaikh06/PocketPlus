# Skill: PocketPlus Feature Builder

## File Name
`.ai/skills/pocketplus-feature-builder.md`

## Purpose
Builds complete, production-ready Flutter features for PocketPlus from a single ticket ID. Reads the ticket, cross-references the Engineering Spec and Frontend Spec, and generates all files needed for data/domain/presentation layers.

## When To Use
- When implementing any IGR-XXX ticket
- When building a new screen from scratch
- When adding a new Firestore collection + UI flow

## Inputs
- Ticket ID (e.g. IGR-007)
- Relevant section of Engineering Spec
- Relevant section of Frontend Spec
- Current folder structure

## Outputs
- Complete Dart files for data/, domain/, presentation/
- Riverpod providers
- Widget tests
- Updated barrel exports

## Dependencies
- `pocketplus-architect.md` (must validate structure first)
- `pocketplus-flutter-conventions.md` (must follow coding style)

## Rules
1. Read the FULL ticket acceptance criteria before writing any code
2. Every screen is a ConsumerStatefulWidget or ConsumerWidget — never StatefulWidget alone
3. All validation logic in ViewModel, never in Widget
4. All error states shown using AppTextField errorText or SnackBar — never AlertDialog for form errors
5. All amounts displayed using CurrencyFormatter.format(paise) from core/utils/
6. All dates displayed using DateFormatter from core/utils/
7. Loading states use AppButton(isLoading: true) or LoadingShimmer — never raw CircularProgressIndicator
8. Empty states use EmptyState widget from shared/widgets/
9. Every new provider must be added to the feature's provider file
10. Widget tests required for every new screen

## Detailed Instructions

### Step 1 — Parse the ticket
Extract: feature name, acceptance criteria list, dependencies, effort size

### Step 2 — Plan files
```
features/{name}/
  domain/
    {name}_entity.dart        # Pure Dart, freezed
    {name}_repository.dart    # Abstract interface
  data/
    {name}_data_source.dart   # Firebase impl
    {name}_repository_impl.dart
  presentation/
    {name}_screen.dart        # ConsumerWidget/StatefulWidget
    {name}_view_model.dart    # Notifier<State>
    {name}_providers.dart     # All providers for this feature
```

### Step 3 — Build domain layer first
- Entity uses freezed for immutability
- All money fields are `int` (paise)
- Repository interface returns `Either<Failure, T>`

### Step 4 — Build data layer
- DataSource calls Firebase directly
- RepositoryImpl wraps DataSource with try/catch → Either
- Firestore paths follow schema in Engineering Spec A-2

### Step 5 — Build presentation layer
- ViewModel extends Notifier<FeatureState>
- State is immutable with copyWith
- Screen reads state via ref.watch, calls methods via ref.read

### Step 6 — Wire providers
- Feature providers in {name}_providers.dart
- Register in shared/providers/ only if needed app-wide

### Step 7 — Write widget tests
- Test loading state
- Test error state
- Test success state
- Test validation rules from Frontend Spec section 3

## Example Usage
```
[User]: Build IGR-007 — Transaction Repository
[Agent]:
- Creates Transaction entity (freezed) with all fields from schema A-2
- Creates TransactionRepository interface with: create, update, softDelete, getByProfile, streamRecent
- Creates FirestoreTransactionDataSource with Firestore paths: transactions/{id}
- Creates TransactionRepositoryImpl with Either error handling
- Creates transactionRepositoryProvider
- All amounts stored as int (paise) — never double
- syncStatus field: PENDING → SYNCED lifecycle handled
```

## Recommended AI Models
- **Primary**: Gemini 2.5 Pro (fast Flutter code gen)
- **Secondary**: Claude Sonnet (better for complex logic)
- **Also good**: DeepSeek V3 (strong Dart codegen)
- **For UI only**: Kimi K2 (good at component generation)
