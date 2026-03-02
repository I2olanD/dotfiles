---
title: "Phase 3: Final Validation & Audit"
status: completed
version: "1.0"
phase: 3
---

# Phase 3: Final Validation & Audit

## Phase Context

**GATE**: Read all referenced files before starting this phase.

**Specification References**:
- `[ref: PRD/Success Metrics]`
- `[ref: PRD/Feature 6: Migration Guide]`
- `[ref: SDD/Quality Requirements]`
- `[ref: SDD/Acceptance Criteria]`

**Key Decisions**:
- ADR-1: Changes are in plugin cache — document for upstream replication

**Dependencies**:
- Phase 1 and Phase 2 must both be complete

---

## Tasks

End-to-end validation of the migration. Runs the full spec creation workflow, audits for any remaining `docs/` references, and creates the migration guide.

- [ ] **T3.1 End-to-end spec workflow test** `[activity: validate]`

  1. Prime: Read spec.py and verify Phase 1 changes are in place `[ref: SDD/Acceptance Criteria/Main Flow]`
  2. Test: Execute the full spec lifecycle:
     - `python3 skills/specify-meta/spec.py "e2e-test"` — creates spec in `.start/specs/`
     - `python3 skills/specify-meta/spec.py NNN --read` — reads spec metadata
     - `python3 skills/specify-meta/spec.py NNN --add specify-requirements` — adds requirements template
     - `python3 skills/specify-meta/spec.py NNN --add specify-solution` — adds solution template
     - `python3 skills/specify-meta/spec.py NNN --add specify-plan` — adds plan directory
     - `python3 skills/specify-meta/spec.py NNN --read` — verify all documents listed
  3. Implement: Fix any issues discovered during the test run
  4. Validate: All commands succeed; TOML output shows correct `.start/specs/` paths; no `docs/` paths appear in output
  5. Success:
     - [ ] spec.py creates specs only in `.start/specs/` `[ref: PRD/Feature 3/AC-1]`
     - [ ] spec.py reads specs only from `.start/specs/` `[ref: PRD/Feature 3/AC-2]`
     - [ ] spec.py resolves only current file names `[ref: PRD/Feature 3/AC-3]`

- [ ] **T3.2 Full codebase audit** `[activity: validate]`

  1. Prime: Read `[ref: SDD/Quality Requirements]` — target is zero `docs/` path references in skill files
  2. Test: Run comprehensive audit commands:
     - `grep -rn "docs/" skills/ --include="*.md" --include="*.py"` — expect zero results
     - `grep -rn "LEGACY" skills/ --include="*.md" --include="*.py"` — expect zero results
     - `grep -rn "product-requirements" skills/ --include="*.md" --include="*.py"` — expect zero results
     - `grep -rn "solution-design" skills/ --include="*.md" --include="*.py"` — expect zero results
     - `grep -rn "implementation-plan" skills/ --include="*.md" --include="*.py"` — expect zero results (except in plan template where it describes TDD phases)
     - `grep -rn "docs/" README.md` — expect zero path references
  3. Implement: Fix any remaining references found by the audit
  4. Validate: All grep commands return zero matches (or only false positives in spec content that describes the migration itself)
  5. Success:
     - [ ] Zero `docs/` path references in skill files `[ref: PRD/Success Metrics/Quality]`
     - [ ] Zero legacy fallback code references `[ref: PRD/Success Metrics/Quality]`
     - [ ] Zero legacy file name references `[ref: PRD/Feature 3/AC-3]`

- [ ] **T3.3 Migration guide** `[activity: refactor]`

  1. Prime: Read `[ref: PRD/Feature 6: Migration Guide]` for requirements
  2. Test: Verify the guide covers all scenarios listed in PRD acceptance criteria
  3. Implement: Create a migration guide section in the framework README (or a separate `.start/MIGRATION.md`) that documents:
     - What changed: `docs/specs/` → `.start/specs/`, `docs/domain/` → `.start/docs/domain/`, etc.
     - How to migrate existing content: file moves + renames
     - Legacy file name mapping: `product-requirements.md` → `requirements.md`, `solution-design.md` → `solution.md`, `implementation-plan.md` → `plan/README.md`
  4. Validate: Guide is clear enough that a user with existing `docs/` content can migrate without confusion
  5. Success:
     - [ ] Migration guide explains directory moves `[ref: PRD/Feature 6/AC-1]`
     - [ ] Migration guide explains file renames `[ref: PRD/Feature 6/AC-2]`

- [ ] **T3.4 Clean up test artifacts** `[activity: validate]`

  - Remove any spec directories created during testing (e.g., `verify-cleanup`, `phase1-test`, `e2e-test`). Verify the `.start/specs/` directory contains only legitimate specs.

- [ ] **T3.5 Phase Validation** `[activity: validate]`

  - Final acceptance: Run all audit commands from T3.2 one more time. Verify spec workflow from T3.1. Confirm migration guide from T3.3 exists and is complete. All PRD acceptance criteria met. All SDD quality requirements satisfied.
