---
title: "SudoLang Migration Implementation Plan"
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
- [x] All implementation phases are defined
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

1. **Before Each Phase**: Read SDD transformation rules and before/after examples
2. **During Implementation**: Apply the 8 transformation rules consistently
3. **After Each Task**: Verify YAML frontmatter preserved, SudoLang body correct
4. **Phase Completion**: Spot-check migrated files against SDD examples

### Deviation Protocol

When implementation requires changes from the specification:
1. Document the deviation with clear rationale
2. Obtain approval before proceeding
3. Update SDD when the deviation improves the design
4. Record all deviations in this plan for traceability

## Metadata Reference

- `[parallel: true]` - Tasks that can run concurrently
- `[component: agent|skill|command]` - File type being migrated
- `[ref: document/section; lines: 1, 2-3]` - Links to specifications
- `[activity: content-transformation]` - Activity hint for specialist agent selection

---

## Context Priming

*GATE: Read all files in this section before starting any implementation.*

**Specification**:

- `docs/specs/001-sudolang-migration/product-requirements.md` - Product Requirements
- `docs/specs/001-sudolang-migration/solution-design.md` - Solution Design (lines 186-420 for transformation examples)

**Key Design Decisions**:

- **ADR-1**: Hybrid YAML + SudoLang Format - Retain YAML frontmatter, use SudoLang for body content only
- **ADR-2**: Interface Naming Convention - Use PascalCase interface names derived from file names
- **ADR-3**: Preserve Structural Tables as Markdown - Keep tables as markdown, not SudoLang
- **ADR-4**: Manual Migration Over Automated Tooling - AI-assisted transformation, no build scripts

**Implementation Context**:

```bash
# No build/test commands - this is a content transformation project
# Validation approach:
diff original-file.md migrated-file.md   # Compare structure
wc -w original-file.md migrated-file.md  # Word count comparison

# Quality verification:
# 1. YAML frontmatter parses correctly
# 2. SudoLang interface structure is valid
# 3. All original instructions are preserved as constraints
```

**SudoLang Reference**:

Read the SudoLang specification before starting: https://github.com/paralleldrive/sudolang

**Transformation Rules** (from SDD):

| Rule | Source → Target |
|------|-----------------|
| R1 | YAML frontmatter → Preserve unchanged |
| R2 | `## Section` headings → Interface property blocks |
| R3 | Bullet instructions → `Constraints { }` block |
| R4 | Numbered steps → Numbered constraints or functions |
| R5 | Decision tables → Pattern matching or constraint tables |
| R6 | Code examples → Preserve in code blocks |
| R7 | `$ARGUMENTS` → Template string (unchanged) |
| R8 | `skill({ name: "..." })` → Preserve function call |

---

## File Inventory

### Agents (35 files)

**Primary Agents** (2 files):
- `agent/the-chief.md`
- `agent/the-meta-agent.md`

**Team: the-architect** (6 files):
- `agent/the-architect/compatibility-review.md`
- `agent/the-architect/complexity-review.md`
- `agent/the-architect/quality-review.md`
- `agent/the-architect/security-review.md`
- `agent/the-architect/system-architecture.md`
- `agent/the-architect/system-documentation.md`
- `agent/the-architect/technology-research.md`

**Team: the-analyst** (4 files):
- `agent/the-analyst/feature-prioritization.md`
- `agent/the-analyst/market-research.md`
- `agent/the-analyst/project-coordination.md`
- `agent/the-analyst/requirements-analysis.md`

**Team: the-designer** (4 files):
- `agent/the-designer/accessibility-implementation.md`
- `agent/the-designer/design-foundation.md`
- `agent/the-designer/interaction-architecture.md`
- `agent/the-designer/user-research.md`

**Team: the-software-engineer** (5 files):
- `agent/the-software-engineer/api-development.md`
- `agent/the-software-engineer/component-development.md`
- `agent/the-software-engineer/concurrency-review.md`
- `agent/the-software-engineer/domain-modeling.md`
- `agent/the-software-engineer/performance-optimization.md`

**Team: the-qa-engineer** (4 files):
- `agent/the-qa-engineer/exploratory-testing.md`
- `agent/the-qa-engineer/performance-testing.md`
- `agent/the-qa-engineer/quality-assurance.md`
- `agent/the-qa-engineer/test-execution.md`

**Team: the-platform-engineer** (10 files):
- `agent/the-platform-engineer/ci-cd-pipelines.md`
- `agent/the-platform-engineer/containerization.md`
- `agent/the-platform-engineer/data-architecture.md`
- `agent/the-platform-engineer/dependency-review.md`
- `agent/the-platform-engineer/deployment-automation.md`
- `agent/the-platform-engineer/infrastructure-as-code.md`
- `agent/the-platform-engineer/performance-tuning.md`
- `agent/the-platform-engineer/pipeline-engineering.md`
- `agent/the-platform-engineer/production-monitoring.md`

### Commands (10 files)

- `command/analyze.md`
- `command/constitution.md`
- `command/debug.md`
- `command/document.md`
- `command/implement.md`
- `command/refactor.md`
- `command/review.md`
- `command/simplify.md`
- `command/specify.md`
- `command/validate.md`

### Skills (42 SKILL.md files)

- `skill/accessibility-design/SKILL.md`
- `skill/agent-coordination/SKILL.md`
- `skill/api-contract-design/SKILL.md`
- `skill/architecture-design/SKILL.md`
- `skill/architecture-selection/SKILL.md`
- `skill/bug-diagnosis/SKILL.md`
- `skill/code-quality-review/SKILL.md`
- `skill/code-review/SKILL.md`
- `skill/codebase-analysis/SKILL.md`
- `skill/codebase-navigation/SKILL.md`
- `skill/coding-conventions/SKILL.md`
- `skill/constitution-validation/SKILL.md`
- `skill/context-preservation/SKILL.md`
- `skill/data-modeling/SKILL.md`
- `skill/deployment-pipeline-design/SKILL.md`
- `skill/documentation-extraction/SKILL.md`
- `skill/documentation-sync/SKILL.md`
- `skill/domain-driven-design/SKILL.md`
- `skill/drift-detection/SKILL.md`
- `skill/error-recovery/SKILL.md`
- `skill/feature-prioritization/SKILL.md`
- `skill/git-workflow/SKILL.md`
- `skill/implementation-planning/SKILL.md`
- `skill/implementation-verification/SKILL.md`
- `skill/knowledge-capture/SKILL.md`
- `skill/observability-design/SKILL.md`
- `skill/pattern-detection/SKILL.md`
- `skill/performance-analysis/SKILL.md`
- `skill/requirements-analysis/SKILL.md`
- `skill/requirements-elicitation/SKILL.md`
- `skill/safe-refactoring/SKILL.md`
- `skill/security-assessment/SKILL.md`
- `skill/specification-management/SKILL.md`
- `skill/specification-validation/SKILL.md`
- `skill/task-delegation/SKILL.md`
- `skill/tech-stack-detection/SKILL.md`
- `skill/technical-writing/SKILL.md`
- `skill/test-design/SKILL.md`
- `skill/testing/SKILL.md`
- `skill/user-insight-synthesis/SKILL.md`
- `skill/user-research/SKILL.md`
- `skill/vibe-security/SKILL.md`

---

## Implementation Phases

Each task follows: **Prime** (read context), **Transform** (apply rules), **Validate** (verify correctness).

> **Tracking Principle**: Track logical units (batches of similar files) that produce verifiable outcomes.

---

### Phase 1: Pilot Migration (2 files)

Establishes the pattern by migrating primary agents. These serve as reference examples for all subsequent migrations.

- [ ] **T1.1 Migrate the-chief.md** `[activity: content-transformation]` `[component: agent]`

  1. Prime: Read SDD agent format example `[ref: SDD/Section Interface Specifications; lines: 186-273]`
  2. Transform: Apply transformation rules R1-R8; create `TheChief` interface
  3. Validate: YAML parses; interface structure valid; all original instructions preserved as constraints
  4. Success: File serves as reference pattern for other agent migrations `[ref: PRD/AC-1]`

- [ ] **T1.2 Migrate the-meta-agent.md** `[activity: content-transformation]` `[component: agent]`

  1. Prime: Use T1.1 output as reference pattern
  2. Transform: Apply transformation rules; create `TheMetaAgent` interface
  3. Validate: Structure matches T1.1 pattern; YAML preserved
  4. Success: Second reference pattern confirms transformation approach

- [ ] **T1.3 Phase Validation** `[activity: validate]`

  - Review both migrated files side-by-side with originals
  - Confirm all YAML frontmatter fields preserved
  - Verify SudoLang interface structure follows spec
  - Document any pattern refinements for subsequent phases

---

### Phase 2: Command Migration (10 files)

Migrates all command definitions. Commands are good second targets because they have consistent structure and `/command` syntax maps directly to SudoLang.

- [ ] **T2.1 Migrate specify.md** `[activity: content-transformation]` `[component: command]`

  1. Prime: Read SDD command format example `[ref: SDD/Section Interface Specifications; lines: 380-450]`
  2. Transform: Apply rules; preserve `$ARGUMENTS` and `skill()` invocations; create command interface
  3. Validate: YAML preserved; workflow phases converted to constraints/functions
  4. Success: Complex command with multiple phases migrated correctly

- [ ] **T2.2 Migrate remaining commands** `[parallel: true]` `[component: command]`

  Files: `analyze.md`, `constitution.md`, `debug.md`, `document.md`, `implement.md`, `refactor.md`, `review.md`, `simplify.md`, `validate.md`

  1. Prime: Use T2.1 as reference pattern
  2. Transform: Apply transformation rules to all 9 files
  3. Validate: Each file follows established command pattern
  4. Success: All 10 commands migrated consistently `[ref: PRD/AC-2]`

- [ ] **T2.3 Phase Validation** `[activity: validate]`

  - Verify all 10 command files migrated
  - Check `$ARGUMENTS` preserved in all files
  - Confirm `skill()` invocations unchanged
  - Document command-specific patterns

---

### Phase 3: Skill Migration (42 files)

Migrates all SKILL.md files. Skills have the most complex structure with activation conditions, protocols, and embedded documentation.

- [ ] **T3.1 Migrate testing/SKILL.md (reference)** `[activity: content-transformation]` `[component: skill]`

  1. Prime: Read SDD skill format example `[ref: SDD/Section Interface Specifications; lines: 275-378]`
  2. Transform: Apply rules; "When to Activate" → `Activation {}` or constraints; protocols → functions
  3. Validate: Skill structure complete; activation conditions preserved
  4. Success: Complex skill with multiple sections serves as reference

- [ ] **T3.2 Migrate specification-related skills** `[parallel: true]` `[component: skill]`

  Files (8): `specification-management`, `specification-validation`, `implementation-planning`, `implementation-verification`, `requirements-analysis`, `requirements-elicitation`, `architecture-design`, `drift-detection`

  1. Prime: Use T3.1 as reference pattern
  2. Transform: Apply transformation rules; preserve templates and validation checklists
  3. Validate: Each skill follows established pattern
  4. Success: Specification workflow skills migrated

- [ ] **T3.3 Migrate codebase skills** `[parallel: true]` `[component: skill]`

  Files (8): `codebase-analysis`, `codebase-navigation`, `pattern-detection`, `tech-stack-detection`, `documentation-extraction`, `documentation-sync`, `coding-conventions`, `knowledge-capture`

  1. Prime: Use T3.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each skill follows established pattern
  4. Success: Codebase-focused skills migrated

- [ ] **T3.4 Migrate development skills** `[parallel: true]` `[component: skill]`

  Files (8): `domain-driven-design`, `data-modeling`, `api-contract-design`, `error-recovery`, `test-design`, `bug-diagnosis`, `safe-refactoring`, `context-preservation`

  1. Prime: Use T3.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each skill follows established pattern
  4. Success: Development practice skills migrated

- [ ] **T3.5 Migrate review skills** `[parallel: true]` `[component: skill]`

  Files (6): `code-review`, `code-quality-review`, `security-assessment`, `constitution-validation`, `performance-analysis`, `vibe-security`

  1. Prime: Use T3.1 as reference pattern
  2. Transform: Apply transformation rules; preserve severity/scoring tables
  3. Validate: Review checklists and scoring preserved
  4. Success: Review and assessment skills migrated

- [ ] **T3.6 Migrate architecture/design skills** `[parallel: true]` `[component: skill]`

  Files (6): `architecture-selection`, `observability-design`, `deployment-pipeline-design`, `accessibility-design`, `user-research`, `user-insight-synthesis`

  1. Prime: Use T3.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each skill follows established pattern
  4. Success: Architecture and design skills migrated

- [ ] **T3.7 Migrate coordination skills** `[parallel: true]` `[component: skill]`

  Files (6): `agent-coordination`, `task-delegation`, `feature-prioritization`, `git-workflow`, `technical-writing`, `testing`

  1. Prime: Use T3.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each skill follows established pattern
  4. Success: All 42 skills migrated `[ref: PRD/AC-3]`

- [ ] **T3.8 Phase Validation** `[activity: validate]`

  - Verify all 42 SKILL.md files migrated
  - Spot-check 5 random skills for consistency
  - Confirm supporting files (templates, examples) NOT modified
  - Document skill-specific patterns

---

### Phase 4: Agent Team Migration (33 files)

Migrates all team agents. These follow the pattern established in Phase 1.

- [ ] **T4.1 Migrate the-architect team** `[parallel: true]` `[component: agent]`

  Files (7): `compatibility-review`, `complexity-review`, `quality-review`, `security-review`, `system-architecture`, `system-documentation`, `technology-research`

  1. Prime: Use T1.1 (TheChief) as reference pattern
  2. Transform: Apply transformation rules to all architect agents
  3. Validate: Each agent follows established interface pattern
  4. Success: Architect team migrated

- [ ] **T4.2 Migrate the-analyst team** `[parallel: true]` `[component: agent]`

  Files (4): `feature-prioritization`, `market-research`, `project-coordination`, `requirements-analysis`

  1. Prime: Use T1.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each agent follows established pattern
  4. Success: Analyst team migrated

- [ ] **T4.3 Migrate the-designer team** `[parallel: true]` `[component: agent]`

  Files (4): `accessibility-implementation`, `design-foundation`, `interaction-architecture`, `user-research`

  1. Prime: Use T1.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each agent follows established pattern
  4. Success: Designer team migrated

- [ ] **T4.4 Migrate the-software-engineer team** `[parallel: true]` `[component: agent]`

  Files (5): `api-development`, `component-development`, `concurrency-review`, `domain-modeling`, `performance-optimization`

  1. Prime: Use T1.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each agent follows established pattern
  4. Success: Software engineer team migrated

- [ ] **T4.5 Migrate the-qa-engineer team** `[parallel: true]` `[component: agent]`

  Files (4): `exploratory-testing`, `performance-testing`, `quality-assurance`, `test-execution`

  1. Prime: Use T1.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each agent follows established pattern
  4. Success: QA engineer team migrated

- [ ] **T4.6 Migrate the-platform-engineer team** `[parallel: true]` `[component: agent]`

  Files (9): `ci-cd-pipelines`, `containerization`, `data-architecture`, `dependency-review`, `deployment-automation`, `infrastructure-as-code`, `performance-tuning`, `pipeline-engineering`, `production-monitoring`

  1. Prime: Use T1.1 as reference pattern
  2. Transform: Apply transformation rules
  3. Validate: Each agent follows established pattern
  4. Success: Platform engineer team migrated; all 35 agents complete `[ref: PRD/AC-4]`

- [ ] **T4.7 Phase Validation** `[activity: validate]`

  - Verify all 33 team agent files migrated
  - Spot-check 5 random agents for consistency
  - Compare interface naming (PascalCase from file name)
  - Document any team-specific patterns

---

### Phase 5: Final Integration & Validation

Full framework validation ensuring all 87 migrated files work together correctly.

- [ ] **T5.1 Cross-File Consistency Check** `[activity: validate]`

  - All agents use consistent interface structure
  - All skills use consistent activation/constraint patterns
  - All commands use consistent workflow patterns

- [ ] **T5.2 Token Efficiency Measurement** `[activity: validate]`

  Sample 10 files (mix of agents, skills, commands) and measure token reduction:
  - Target: 15-30% token reduction `[ref: SDD/Quality Requirements]`
  - Compare original vs migrated using tiktoken or word count

- [ ] **T5.3 Behavioral Equivalence Testing** `[activity: validate]`

  Test representative files with actual LLM interactions:
  - Load migrated agent, verify behavior matches original
  - Load migrated skill, verify guidance is equivalent
  - Load migrated command, verify workflow executes correctly

- [ ] **T5.4 Documentation Update** `[activity: documentation]`

  - Update framework README if needed
  - Note any syntax changes for users
  - Archive original files (optional - user decision)

- [ ] **T5.5 Specification Compliance** `[activity: validate]`

  - All PRD acceptance criteria verified
  - Implementation follows SDD transformation rules
  - All 87 files migrated successfully

---

## Summary

| Phase | Files | Parallel Opportunities |
|-------|-------|------------------------|
| Phase 1: Pilot | 2 agents | Sequential (establishing pattern) |
| Phase 2: Commands | 10 commands | 9 in parallel after reference |
| Phase 3: Skills | 42 skills | 6 batches in parallel after reference |
| Phase 4: Agents | 33 team agents | 6 teams in parallel |
| Phase 5: Validation | - | Sequential validation |
| **Total** | **87 files** | - |

---

## Plan Verification

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
