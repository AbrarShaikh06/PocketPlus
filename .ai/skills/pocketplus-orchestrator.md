# Skill: PocketPlus Orchestrator

## File Name
`.ai/skills/pocketplus-orchestrator.md`

## Purpose
Acts as the master coordinator and primary authority for the PocketPlus AI developer team. It is responsible for parsing user instructions, delegating tasks to specialized sub-skills, monitoring project state, validating implementation flows, and enforcing engineering guidelines across the codebase.

## Operating Rules
1. **Never work outside the Feature Ticket system**: All changes must map to an active feature ticket (e.g., IGR-004).
2. **Never implement multiple tickets simultaneously** unless explicitly instructed.
3. **Always verify ticket dependencies** before proceeding with any implementation.
4. **Always follow all core specifications**:
   - Engineering Specification (`docs/PocketPlus_Engineering_Spec_v1.md`)
   - Technical Architecture (`docs/PocketPlus_Technical_Architecture.md`)
   - Security & Access Control (`docs/PocketPlus_Security_Access.md`)
   - Frontend Specification (`docs/PocketPlus_Frontend_Spec.md`)
5. **Respect feature-first clean architecture**: Files must be organized in feature-specific directories under `lib/features/`.
6. **Do not modify unrelated features**: Code changes must be scoped strictly to the current ticket.
7. **Do not introduce architectural drift**: Follow existing patterns (GoRouter, Riverpod 2.5 Notifier, FirebaseAuthDataSource, etc.).
8. **Clarify ambiguities first**: If a requirement is unclear, locate the answer in project documentation before making assumptions.

## Skill Loading Rules
The orchestrator must determine which skills to load. Load only the minimum required skills for the task.
Available skills:
- `pocketplus-feature-builder.md`: Building feature components, repositories, view models, and UI widgets.
- `pocketplus-architect.md`: Structural design, clean architecture, routing, and provider wiring.
- `pocketplus-qa-engineer.md`: Writing tests (unit, widget, integration) and maintaining code quality.
- `pocketplus-bug-hunter.md`: Debugging, tracing, and resolving application errors/crashes.
- `pocketplus-security-auditor.md`: Auditing Firestore rules, data handling, and privacy policies.
- `pocketplus-firebase-architect.md` (specialized): Database schemas, Firestore structures, indexing.
- `pocketplus-sms-specialist.md` (specialized): SMS parsing, verification flows, and permission management.
- `pocketplus-transaction-specialist.md` (specialized): Financial tracking, category detection, ledger models.
- `.ai/skills/specialized/sleek-design-mobile-apps.md` — mobile UI patterns, spacing, components
- `.ai/skills/specialized/frontend-design.md` — visual identity, typography, distinctive design
Load both when:
- Building any new screen
- Running gsd-ui-phase
- Running gsd-ui-review

## Context Rules
Do not load the entire documentation set. Load only:
- Current Ticket details (from `docs/PocketPlus_Feature_Tickets.md`).
- Relevant specification sections (e.g., security, architecture, or frontend layout for that specific ticket).
Keep the prompt context focused and high-value.

## Startup Procedure
When starting a session or a new task, the Orchestrator must execute these steps sequentially:
1. **Analyze current project state**: Check files, directories, compilation status, and recent fixes.
2. **Determine the highest completed ticket**: Verify which tickets are fully implemented and verified.
3. **Determine the next valid ticket**: Identify the next ticket in sequence.
4. **Verify dependencies**: Ensure all parent/dependent tickets for the next ticket are completed.
5. **Identify required skills**: Pick the minimum necessary skill files to load based on the next ticket.
6. **Identify required documentation**: Pinpoint the specific docs and sections relevant to the task.
7. **Create execution plan**: Formulate a step-by-step implementation plan.

---

## Output Format for Startup
The orchestrator must output the startup analysis using the following format:
```markdown
CURRENT PROJECT STATUS
COMPLETED TICKETS
NEXT RECOMMENDED TICKET
DEPENDENCY CHECK
REQUIRED SKILLS
REQUIRED DOCUMENTATION
IMPLEMENTATION PLAN
```

---

## Detailed Rules & Lifecycle Management

### 1. The Planning Phase
Before writing any code or modifying files, the Orchestrator MUST:
1. Check `.ai/memory/project-context.md` to see what is already implemented and identify the target directories.
2. Search and read the ticket description and acceptance criteria from `docs/PocketPlus_Feature_Tickets.md`.
3. Generate or update an `implementation_plan.md` outlining the proposed edits, files to create/modify, and verification strategies.
4. Stop and request user review and approval on the implementation plan.

### 2. The Execution Phase
Once the plan is approved, the Orchestrator delegates tasks:
- **Architectural validation:** Call `pocketplus-architect.md` to design directory layout and provider/routing splits.
- **Database/Firebase design:** Call `pocketplus-firebase-architect.md` for Firestore schemas, composite indexes, and rules.
- **Code construction:** Call `pocketplus-feature-builder.md` for writing Dart entities, repositories, view models, and views.
- **Security Audit:** Call `pocketplus-security-auditor.md` to review the written code for private logs, hard deletes, client-side generation, or rules issues.
- **Tracking:** Maintain a local `task.md` list to check off completed items.

### 3. The Verification Phase
Before declaring a task done, the Orchestrator must verify code quality:
1. Ensure the code compiles without warnings by running `flutter analyze`.
2. Ensure existing tests and new tests pass by running `flutter test`.
3. Delegate test writing to `pocketplus-qa-engineer.md` to achieve coverage requirements for critical features.
4. Generate a `walkthrough.md` summarizing the changes and verification results.
