---
title: "Phase 1: spec.py Cleanup"
status: completed
version: "1.0"
phase: 1
---

# Phase 1: spec.py Cleanup

## Phase Context

**GATE**: Read all referenced files before starting this phase.

**Specification References**:
- `[ref: SDD/File Change Inventory/1. spec.py]`
- `[ref: SDD/Implementation Examples/1-4]`
- `[ref: PRD/Feature 3: Remove Legacy docs/specs/ Fallback]`

**Key Decisions**:
- ADR-2: Remove template fallback (deprecated `templates/` directory) alongside legacy `docs/specs/` fallback
- ADR-4: Clean break — no backwards compatibility code

**Dependencies**:
- None. This is the first phase.

---

## Tasks

Simplifies spec.py by removing all legacy fallback code: `LEGACY_SPECS_DIR`, `resolve_doc_path()`, template directory fallback, and legacy filename mappings. Produces a cleaner script that operates exclusively on `.start/specs/`.

- [ ] **T1.1 Remove legacy constants and template fallback** `[activity: refactor]`

  1. Prime: Read `skills/specify-meta/spec.py` lines 24-53 `[ref: SDD/Implementation Examples/Example 4]`
  2. Test: Run `python3 skills/specify-meta/spec.py --help` to confirm script loads; run `python3 skills/specify-meta/spec.py "test-feature"` to confirm spec creation still works in `.start/specs/`
  3. Implement:
     - Delete `LEGACY_SPECS_DIR = Path("docs/specs")` (line 26)
     - Delete `TEMPLATES_DIR = plugin_root / "templates"` (line 30)
     - Simplify `get_template_path()`: remove legacy `templates/` fallback branch and stderr warning. Keep only `SKILLS_DIR / template_name / "template.md"` lookup.
  4. Validate: `python3 skills/specify-meta/spec.py --help` runs without error; `python3 skills/specify-meta/spec.py "verify-cleanup"` creates `.start/specs/NNN-verify-cleanup/`
  5. Success: `LEGACY_SPECS_DIR` and `TEMPLATES_DIR` constants are gone; `get_template_path()` has no fallback branch `[ref: PRD/Feature 3/AC-4]`

- [ ] **T1.2 Simplify directory resolution functions** `[activity: refactor]`

  1. Prime: Read `skills/specify-meta/spec.py` lines 56-122 `[ref: SDD/Implementation Examples/Example 1-2]`
  2. Test: Run `python3 skills/specify-meta/spec.py 002 --read` to confirm reading existing spec from `.start/specs/` works
  3. Implement:
     - Simplify `resolve_specs_dir()`: remove `LEGACY_SPECS_DIR` check, just return `SPECS_DIR`
     - Simplify `get_next_spec_id()`: remove loop over `[SPECS_DIR, LEGACY_SPECS_DIR]`, scan only `SPECS_DIR`
     - Simplify `find_spec_dir()`: remove loop over both directories, check only `SPECS_DIR`
     - Delete `resolve_doc_path()` function entirely
  4. Validate: `python3 skills/specify-meta/spec.py 002 --read` returns TOML for existing spec; `python3 skills/specify-meta/spec.py 999 --read` reports "not found" error
  5. Success:
     - [ ] `resolve_specs_dir()` only returns `SPECS_DIR` `[ref: PRD/Feature 3/AC-1]`
     - [ ] `get_next_spec_id()` only scans `.start/specs/` `[ref: PRD/Feature 3/AC-2]`
     - [ ] `find_spec_dir()` only checks `.start/specs/` `[ref: PRD/Feature 3/AC-1]`
     - [ ] `resolve_doc_path()` is deleted `[ref: PRD/Feature 3/AC-3]`

- [ ] **T1.3 Simplify read_spec and create_spec** `[activity: refactor]`

  1. Prime: Read `skills/specify-meta/spec.py` lines 125-287 `[ref: SDD/Implementation Examples/Example 3]`
  2. Test: Run `python3 skills/specify-meta/spec.py 002 --read` to verify TOML output format is correct after changes
  3. Implement:
     - In `read_spec()`: replace `resolve_doc_path()` calls with direct path checks (`spec_dir / "requirements.md"`, `spec_dir / "solution.md"`). Remove `implementation-plan.md` fallback (line 166). Only check for `plan/` directory structure.
     - In `create_spec()`: remove legacy filename mappings (`product-requirements` → `requirements`, `solution-design` → `solution`) from both the existing-spec branch (lines 231-236) and the new-spec branch (lines 271-276). Keep only current names.
  4. Validate: `python3 skills/specify-meta/spec.py 002 --read` shows `prd`, `sdd` paths correctly; `python3 skills/specify-meta/spec.py 002 --add specify-requirements` works
  5. Success:
     - [ ] `read_spec()` uses direct path checks, no legacy filename resolution `[ref: PRD/Feature 3/AC-3]`
     - [ ] `create_spec()` has no legacy filename mappings `[ref: PRD/Feature 3/AC-3]`
     - [ ] No reference to `LEGACY_SPECS_DIR` remains in the file `[ref: PRD/Feature 3/AC-4]`

- [ ] **T1.4 Phase Validation** `[activity: validate]`

  - Run `python3 skills/specify-meta/spec.py --help`, `python3 skills/specify-meta/spec.py "phase1-test"`, `python3 skills/specify-meta/spec.py NNN --read` (with the newly created spec ID). Verify no `docs/` or `LEGACY` references remain: `grep -n "docs/" skills/specify-meta/spec.py` and `grep -n "LEGACY" skills/specify-meta/spec.py` both return empty. Clean up any test spec directories created during validation.
