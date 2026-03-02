---
title: "Phase 2: Skill Reference Updates"
status: completed
version: "1.0"
phase: 2
---

# Phase 2: Skill Reference Updates

## Phase Context

**GATE**: Read all referenced files before starting this phase.

**Specification References**:
- `[ref: SDD/File Change Inventory/2-12]`
- `[ref: PRD/Feature 1: Migrate Knowledge Capture]`
- `[ref: PRD/Feature 2: Migrate Refactor Documentation]`
- `[ref: PRD/Feature 4: Update All Skill References]`
- `[ref: PRD/Feature 5: Update Skill Write Permissions]`

**Key Decisions**:
- ADR-3: Knowledge capture paths nest under `.start/docs/` (e.g., `.start/docs/domain/`)
- ADR-4: Clean break — no dual-path references, no "or legacy docs/" language

**Dependencies**:
- Phase 1 must be complete (spec.py is the foundation; skill files reference its behavior)

---

## Tasks

Updates all skill SKILL.md files, reference materials, and templates to replace `docs/` paths with `.start/docs/` paths. Removes legacy fallback language from descriptions.

- [ ] **T2.1 Update specify-meta skill and reference** `[activity: refactor]` `[component: specify-meta]`

  1. Prime: Read `skills/specify-meta/SKILL.md` and `skills/specify-meta/reference/spec-management.md` `[ref: SDD/File Change Inventory/2-3]`
  2. Test: Verify current content contains legacy references: grep for "docs/specs/" and "Falls back"
  3. Implement:
     - `SKILL.md` line 3: Remove "Falls back to docs/specs/ for legacy specs" from description
     - `SKILL.md` line 17: Remove "(legacy: docs/specs/)" from directory field comment
     - `spec-management.md` lines 29-36: Delete entire "Legacy Fallback" section (heading + 5 bullet points)
  4. Validate: `grep -n "docs/" skills/specify-meta/SKILL.md` returns empty; `grep -n "Legacy Fallback" skills/specify-meta/reference/spec-management.md` returns empty
  5. Success:
     - [ ] specify-meta description has no legacy fallback mention `[ref: PRD/Feature 4/AC-6]`
     - [ ] spec-management.md has no Legacy Fallback section `[ref: PRD/Feature 3/AC-4]`

- [ ] **T2.2 Update analyze skill and perspectives** `[activity: refactor]` `[parallel: true]` `[component: analyze]`

  1. Prime: Read `skills/analyze/SKILL.md` and `skills/analyze/reference/perspectives.md` `[ref: SDD/File Change Inventory/4-5]`
  2. Test: Verify both files contain `docs/domain/`, `docs/patterns/`, `docs/interfaces/`, `docs/research/` references
  3. Implement:
     - `SKILL.md` line 22: Replace `docs/domain/ | docs/patterns/ | docs/interfaces/ | docs/research/` with `.start/docs/domain/ | .start/docs/patterns/ | .start/docs/interfaces/ | .start/docs/research/`
     - `SKILL.md` line 41: Replace `docs/ directories` with `.start/docs/ directories`
     - `perspectives.md` lines 34-39: Replace all `docs/` prefixes with `.start/docs/` in the Output Location column
  4. Validate: `grep -n "docs/" skills/analyze/SKILL.md` returns empty; `grep -c "\.start/docs/" skills/analyze/reference/perspectives.md` returns 6
  5. Success:
     - [ ] analyze SKILL.md references `.start/docs/` paths `[ref: PRD/Feature 1/AC-1,2,3,4]` `[ref: PRD/Feature 4/AC-1,2]`
     - [ ] analyze perspectives.md maps all perspectives to `.start/docs/` locations `[ref: PRD/Feature 4/AC-2]`

- [ ] **T2.3 Update document skill references** `[activity: refactor]` `[parallel: true]` `[component: document]`

  1. Prime: Read `skills/document/reference/knowledge-capture.md` and `skills/document/reference/perspectives.md` `[ref: SDD/File Change Inventory/6-7]`
  2. Test: `grep -c "docs/" skills/document/reference/knowledge-capture.md` returns a count (expect ~50 matches)
  3. Implement:
     - `knowledge-capture.md`: Replace all occurrences of `docs/domain/` → `.start/docs/domain/`, `docs/patterns/` → `.start/docs/patterns/`, `docs/interfaces/` → `.start/docs/interfaces/`, `docs/research/` → `.start/docs/research/`, `docs/architecture/` → `.start/docs/architecture/`, `docs/decisions/` → `.start/docs/decisions/`
     - `knowledge-capture.md`: Update shell examples — `find docs` → `find .start/docs`, `grep -ri ... docs/` → `grep -ri ... .start/docs/`, `ls docs/patterns/` → `ls .start/docs/patterns/`, `find docs/patterns` → `find .start/docs/patterns`, `grep -l ... docs/**/*.md` → `grep -l ... .start/docs/**/*.md`
     - `perspectives.md` line 15: Replace `docs/domain/` → `.start/docs/domain/`, `docs/patterns/` → `.start/docs/patterns/`, `docs/interfaces/` → `.start/docs/interfaces/`
  4. Validate: `grep -c "docs/" skills/document/reference/knowledge-capture.md` returns 0 (or only in markdown cross-reference paths like `../docs/`); `grep "\.start/docs/" skills/document/reference/perspectives.md` shows updated Capture line
  5. Success:
     - [ ] knowledge-capture.md uses `.start/docs/` paths exclusively `[ref: PRD/Feature 1/AC-5]` `[ref: PRD/Feature 4/AC-3]`
     - [ ] document perspectives.md Capture row uses `.start/docs/` `[ref: PRD/Feature 4/AC-3]`

- [ ] **T2.4 Update specify skill permissions** `[activity: refactor]` `[parallel: true]` `[component: specify]`

  1. Prime: Read `skills/specify/SKILL.md` line 6 `[ref: SDD/File Change Inventory/8]`
  2. Test: Verify line 6 contains `Write(.start/**, docs/**)` and `Edit(.start/**, docs/**)`
  3. Implement: Replace `Write(.start/**, docs/**)` with `Write(.start/**)` and `Edit(.start/**, docs/**)` with `Edit(.start/**)`
  4. Validate: `grep "docs/\*\*" skills/specify/SKILL.md` returns empty
  5. Success: specify skill no longer grants `docs/**` write access `[ref: PRD/Feature 5/AC-1,2]`

- [ ] **T2.5 Update solution and plan templates** `[activity: refactor]` `[parallel: true]` `[component: templates]`

  1. Prime: Read `skills/specify-solution/template.md` and `skills/specify-plan/template.md` `[ref: SDD/File Change Inventory/9-10]`
  2. Test: `grep -c "@docs/" skills/specify-solution/template.md` returns a count; `grep "docs/" skills/specify-plan/template.md` shows line 111
  3. Implement:
     - `specify-solution/template.md`: Replace all `@docs/interfaces/` → `@.start/docs/interfaces/`, `@docs/patterns/` → `@.start/docs/patterns/`, `@docs/domain/` → `@.start/docs/domain/`, `docs/patterns/` → `.start/docs/patterns/`
     - `specify-plan/template.md` line 111: Replace `docs/{patterns,interfaces,research}/[name].md` with `.start/docs/{patterns,interfaces,research}/[name].md`
  4. Validate: `grep -c "@docs/" skills/specify-solution/template.md` returns 0; `grep "docs/" skills/specify-plan/template.md` returns empty
  5. Success:
     - [ ] Solution template uses `@.start/docs/` references `[ref: PRD/Feature 4/AC-4]`
     - [ ] Plan template uses `.start/docs/` references `[ref: PRD/Feature 4/AC-5]`

- [ ] **T2.6 Update refactor output format** `[activity: refactor]` `[parallel: true]` `[component: refactor]`

  1. Prime: Read `skills/refactor/reference/output-format.md` line 19 `[ref: SDD/File Change Inventory/11]`
  2. Test: Verify line 19 contains `docs/refactor/[NNN]-[name].md`
  3. Implement: Replace `docs/refactor/[NNN]-[name].md` with `.start/docs/refactor/[NNN]-[name].md`
  4. Validate: `grep "docs/" skills/refactor/reference/output-format.md` returns empty
  5. Success: Refactor skill references `.start/docs/refactor/` path `[ref: PRD/Feature 2/AC-1]`

- [ ] **T2.7 Update framework README** `[activity: refactor]` `[component: readme]`

  1. Prime: Read `README.md` (framework root), search for all `docs/` references `[ref: SDD/File Change Inventory/12]`
  2. Test: `grep -n "docs/" README.md` to identify all lines
  3. Implement: Update directory structure diagrams and skill descriptions to replace `docs/` with `.start/docs/`. Replace `docs/patterns/` → `.start/docs/patterns/`, `docs/interfaces/` → `.start/docs/interfaces/`, `docs/domain/` → `.start/docs/domain/` throughout. Update any directory tree examples.
  4. Validate: `grep -c "docs/" README.md` — only matches should be in prose explaining the migration (if any), not in path references
  5. Success: Framework README shows `.start/` as the only location for all framework artifacts `[ref: PRD/Feature 4/AC-7]`

- [ ] **T2.8 Phase Validation** `[activity: validate]`

  - Run comprehensive grep audit: `grep -rn "docs/" skills/ --include="*.md" --include="*.py"` — verify zero path references to bare `docs/` (excluding this spec's own documents). Verify all `.start/docs/` references are syntactically correct. Check that no skill SKILL.md descriptions mention "legacy" or "fallback" in the context of `docs/`.
