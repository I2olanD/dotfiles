---
title: "Migrate Framework from docs/ to .start/"
status: draft
version: "1.0"
---

# Implementation Plan

## Validation Checklist

### CRITICAL GATES (Must Pass)

- [x] All `[NEEDS CLARIFICATION: ...]` markers have been addressed
- [x] All specification file paths are correct and exist
- [x] Each phase follows TDD: Prime → Test → Implement → Validate
- [x] Every task has verifiable success criteria
- [x] A developer could follow this plan independently

### QUALITY CHECKS (Should Pass)

- [x] Context priming section is complete
- [x] All implementation phases are defined with linked phase files
- [x] Dependencies between phases are clear (no circular dependencies)
- [x] Parallel work is properly tagged with `[parallel: true]`
- [x] Activity hints provided for specialist selection `[activity: type]`
- [x] Every phase references relevant SDD sections
- [x] Every test references PRD acceptance criteria
- [x] Integration & E2E tests defined in final phase
- [x] Project commands match actual project setup

---

## Specification Compliance Guidelines

### How to Ensure Specification Adherence

1. **Before Each Phase**: Complete the Pre-Implementation Specification Gate
2. **During Implementation**: Reference specific SDD sections in each task
3. **After Each Task**: Run Specification Compliance checks
4. **Phase Completion**: Verify all specification requirements are met

### Deviation Protocol

When implementation requires changes from the specification:
1. Document the deviation with clear rationale
2. Obtain approval before proceeding
3. Update SDD when the deviation improves the design
4. Record all deviations in this plan for traceability

## Metadata Reference

- `[parallel: true]` - Tasks that can run concurrently
- `[component: component-name]` - For multi-component features
- `[ref: document/section; lines: 1, 2-3]` - Links to specifications, patterns, or interfaces and (if applicable) line(s)
- `[activity: type]` - Activity hint for specialist agent selection

### Success Criteria

**Validate** = Process verification ("did we follow TDD?")
**Success** = Outcome verification ("does it work correctly?")

```markdown
# Single-line format
- Success: [Criterion] `[ref: PRD/AC-X.Y]`

# Multi-line format
- Success:
  - [ ] [Criterion 1] `[ref: PRD/AC-X.Y]`
  - [ ] [Criterion 2] `[ref: SDD/Section]`
```

---

## Context Priming

*GATE: Read all files in this section before starting any implementation.*

**Specification**:

- `.start/specs/002-migrate-to-start-directory/requirements.md` - Product Requirements
- `.start/specs/002-migrate-to-start-directory/solution.md` - Solution Design

**Key Design Decisions**:

- **ADR-1**: Modify cache directly — make changes in plugin cache for immediate effect, document for upstream
- **ADR-2**: Remove template fallback — remove deprecated templates/ directory fallback alongside docs/specs/ fallback
- **ADR-3**: Knowledge capture under .start/docs/ — nest knowledge capture directories under .start/docs/
- **ADR-4**: Clean break — no backwards compatibility, no fallback code

**Implementation Context**:

```bash
# All files are in the plugin cache directory
cd ~/.claude/plugins/cache/the-startup/start/3.2.1/

# Verify spec.py works after changes
python3 skills/specify-meta/spec.py --help
python3 skills/specify-meta/spec.py "test-feature"
python3 skills/specify-meta/spec.py 001 --read

# Post-migration audit: verify no docs/ references remain
grep -r "docs/" skills/ --include="*.md" --include="*.py" -l
```

---

## Implementation Phases

Each phase is defined in a separate file. Tasks follow red-green-refactor: **Prime** (understand context), **Test** (red), **Implement** (green), **Validate** (refactor + verify).

> **Tracking Principle**: Track logical units that produce verifiable outcomes. The TDD cycle is the method, not separate tracked items.

- [x] [Phase 1: spec.py Cleanup](phase-1.md)
- [x] [Phase 2: Skill Reference Updates](phase-2.md)
- [x] [Phase 3: Final Validation & Audit](phase-3.md)

---

## Plan Verification

Before this plan is ready for implementation, verify:

| Criterion | Status |
|-----------|--------|
| A developer can follow this plan without additional clarification | ✅ |
| Every task produces a verifiable deliverable | ✅ |
| All PRD acceptance criteria map to specific tasks | ✅ |
| All SDD components have implementation tasks | ✅ |
| Dependencies are explicit with no circular references | ✅ |
| Parallel opportunities are marked with `[parallel: true]` | ✅ |
| Each task has specification references `[ref: ...]` | ✅ |
| Project commands in Context Priming are accurate | ✅ |
| All phase files exist and are linked from this manifest as `[Phase N: Title](phase-N.md)` | ✅ |
