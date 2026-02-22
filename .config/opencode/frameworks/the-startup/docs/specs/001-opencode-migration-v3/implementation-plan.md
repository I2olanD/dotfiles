---
title: "OpenCode Migration v3.2.1 - Full Rebuild"
status: approved
version: "1.0"
---

# Implementation Plan

## Validation Checklist

### CRITICAL GATES (Must Pass)

- [x] All `[NEEDS CLARIFICATION: ...]` markers have been addressed
- [x] All specification file paths are correct and exist
- [x] Each phase follows Prime -> Implement -> Validate
- [x] Every task has verifiable success criteria
- [x] A developer could follow this plan independently

### QUALITY CHECKS (Should Pass)

- [x] Context priming section is complete
- [x] All implementation phases are defined
- [x] Dependencies between phases are clear (no circular dependencies)
- [x] Parallel work is properly tagged with `[parallel: true]`
- [x] Activity hints provided for specialist selection `[activity: type]`
- [x] Every phase references relevant SDD sections
- [x] Project commands match actual project setup

---

## Metadata Reference

- `[parallel: true]` - Tasks that can run concurrently
- `[ref: document/section]` - Links to specifications
- `[activity: type]` - Activity hint for specialist agent selection

---

## Context Priming

*GATE: Read all files in this section before starting any implementation.*

**Specification**:

- `docs/specs/001-opencode-migration-v3/solution-design.md` - Solution Design (transformation rulesets)
- `docs/specs/001-opencode-migration-v3/README.md` - Decisions and progress

**Key Design Decisions**:

- **ADR-1**: Full rebuild with preserve-new strategy - Rebuild mapped files; preserve target-only expansions
- **ADR-2**: Model `github-copilot/claude-opus-4-5-20250918` for primary agents
- **ADR-3**: Remove all Team Mode content
- **ADR-4**: Output styles out of scope
- **ADR-5**: Expanded activities preserved from existing target

**Source and Target Paths**:

```
Source: ~/.claude/plugins/marketplaces/the-startup/
Target: ~/.config/opencode/frameworks/the-startup/
```

**Validation Commands**:

```bash
# Count files in each component
ls ~/.config/opencode/frameworks/the-startup/agent/**/*.md | wc -l
ls ~/.config/opencode/frameworks/the-startup/skill/*/SKILL.md | wc -l
ls ~/.config/opencode/frameworks/the-startup/command/*.md | wc -l

# Verify frontmatter compliance (spot check)
head -10 ~/.config/opencode/frameworks/the-startup/agent/the-chief.md
head -10 ~/.config/opencode/frameworks/the-startup/skill/coding-conventions/SKILL.md
head -10 ~/.config/opencode/frameworks/the-startup/command/implement.md
```

---

## Implementation Phases

Each task follows: **Prime** (read source + SDD rules), **Implement** (write converted file), **Validate** (verify format compliance).

> **Tracking Principle**: Track logical units that produce verifiable outcomes. Each task = one converted file or file group.

> **Execution Note**: This is a file format migration. "Test" in the TDD sense means defining the expected output format before writing. Validation confirms the output matches the specification.

---

### Phase 0: Backup

Create a safety net before overwriting target files.

- [ ] **T0.1 Backup existing target** `[activity: infrastructure]`

  1. Prime: Verify target directory exists at `~/.config/opencode/frameworks/the-startup/`
  2. Implement: `cp -r ~/.config/opencode/frameworks/the-startup/ ~/.config/opencode/frameworks/the-startup.bak.$(date +%Y%m%d)`
  3. Validate: Backup directory exists and has same file count as original

---

### Phase 1: Primary Agents

Convert the two top-level orchestrating agents. These establish the format pattern for all subsequent agents.

`[ref: SDD/Agent Frontmatter Format]` `[ref: SDD/Agent Body Format]`

- [ ] **T1.1 the-chief.md** `[activity: file-conversion]`

  1. Prime: Read source `plugins/team/agents/the-chief.md`; read SDD agent transformation rules
  2. Implement: Write to `agent/the-chief.md` with frontmatter: `description`, `mode: primary`, `model: github-copilot/claude-opus-4-5-20250918`, `skills`, `allowed-tools: [read, write, glob, grep]`. Body: identity line -> Focus Areas -> Approach -> Deliverables -> Quality Standards -> Usage Examples. Remove: Identity heading, Constraints DSL, Vision, Decision tables, Output schema, Entry Point.
  3. Validate: Frontmatter has all 5 required fields; no `name:` field; no `## Identity` heading; no `Constraints {` block; `<example>` blocks in Usage Examples section; "Claude Code" -> "Opencode"
  4. Success: Valid opencode primary agent file

- [ ] **T1.2 the-meta-agent.md** `[parallel: true]` `[activity: file-conversion]`

  1. Prime: Read source `plugins/team/agents/the-meta-agent.md`; read SDD agent transformation rules
  2. Implement: Same transformation as T1.1. Additional: replace all "Claude Code sub-agent" with "Opencode sub-agent"; update path references `.claude/agents/` -> `agent/`
  3. Validate: Same as T1.1; verify no "Claude Code" references remain
  4. Success: Valid opencode primary agent file

- [ ] **T1.3 Phase Validation** `[activity: validate]`

  Verify both primary agents have correct frontmatter (5 fields), correct body structure (Focus Areas, Approach, Deliverables, Quality Standards, Usage Examples), no source-format artifacts.

---

### Phase 2: Subagents by Role

Convert all activity-level agents within each role directory. Each role can be converted in parallel.

`[ref: SDD/Agent Frontmatter Format (subagent)]` `[ref: SDD/Filename Mapping]` `[ref: SDD/Role Directories]`

**Subagent frontmatter**: `description`, `mode: subagent`, `skills`. No `model`, no `allowed-tools`.

**Subagent body**: Identity line -> Mission -> Domain sections (preserve checklists) -> Deliverables -> Quality Standards -> Usage Examples.

#### the-analyst/ `[parallel: true]`

- [ ] **T2.1 the-analyst: market-research.md** `[activity: file-conversion]`

  1. Prime: Read source `the-analyst/research-market.md`
  2. Implement: Rename `research-market.md` -> `market-research.md`. Convert frontmatter (subagent). Transform body structure.
  3. Validate: Filename is `market-research.md`; `mode: subagent`; no `model` field
  4. Success: Valid subagent file

- [ ] **T2.2 the-analyst: requirements-analysis.md** `[activity: file-conversion]`

  1. Prime: Read source `the-analyst/research-requirements.md`
  2. Implement: Rename `research-requirements.md` -> `requirements-analysis.md`. Convert.
  3. Validate: Same checks
  4. Success: Valid subagent file

- [ ] **T2.3 the-analyst: PRESERVE feature-prioritization.md + project-coordination.md** `[activity: preserve]`

  These are target-only expansions (ADR-5). Verify they exist; do not overwrite.

#### the-architect/ `[parallel: true]`

- [ ] **T2.4 the-architect: system-architecture.md** `[activity: file-conversion]`

  Source: `design-system.md` -> Target: `system-architecture.md`

- [ ] **T2.5 the-architect: security-review.md** `[activity: file-conversion]`

  Source: `review-security.md` -> Target: `security-review.md`. Add `vibe-security` to skills list.

- [ ] **T2.6 the-architect: complexity-review.md** `[activity: file-conversion]`

  Source: `review-complexity.md` -> Target: `complexity-review.md`

- [ ] **T2.7 the-architect: compatibility-review.md** `[activity: file-conversion]`

  Source: `review-compatibility.md` -> Target: `compatibility-review.md`

- [ ] **T2.8 the-architect: PRESERVE quality-review.md + system-documentation.md + technology-research.md** `[activity: preserve]`

  Target-only expansions (ADR-5). Verify existence.

#### the-designer/ `[parallel: true]`

- [ ] **T2.9 the-designer: accessibility-implementation.md** `[activity: file-conversion]`

  Source: `build-accessibility.md` -> Target: `accessibility-implementation.md`

- [ ] **T2.10 the-designer: design-foundation.md** `[activity: file-conversion]`

  Source: `design-visual.md` -> Target: `design-foundation.md`

- [ ] **T2.11 the-designer: interaction-architecture.md** `[activity: file-conversion]`

  Source: `design-interaction.md` -> Target: `interaction-architecture.md`

- [ ] **T2.12 the-designer: user-research.md** `[activity: file-conversion]`

  Source: `research-user.md` -> Target: `user-research.md`

#### the-software-engineer/ (from the-developer/) `[parallel: true]`

- [ ] **T2.13 the-software-engineer: concurrency-review.md** `[activity: file-conversion]`

  Source: `the-developer/review-concurrency.md` -> Target: `the-software-engineer/concurrency-review.md`

- [ ] **T2.14 the-software-engineer: performance-optimization.md** `[activity: file-conversion]`

  Source: `the-developer/optimize-performance.md` -> Target: `the-software-engineer/performance-optimization.md`

- [ ] **T2.15 the-software-engineer: PRESERVE api-development.md + component-development.md + domain-modeling.md** `[activity: preserve]`

  Target-only expansions (ADR-5). `build-feature.md` content was split across these in prior migration.

#### the-platform-engineer/ (from the-devops/) `[parallel: true]`

- [ ] **T2.16 the-platform-engineer: ci-cd-pipelines.md** `[activity: file-conversion]`

  Source: `the-devops/build-pipelines.md`

- [ ] **T2.17 the-platform-engineer: containerization.md** `[activity: file-conversion]`

  Source: `the-devops/build-containers.md`

- [ ] **T2.18 the-platform-engineer: dependency-review.md** `[activity: file-conversion]`

  Source: `the-devops/review-dependency.md`

- [ ] **T2.19 the-platform-engineer: infrastructure-as-code.md** `[activity: file-conversion]`

  Source: `the-devops/build-infrastructure.md`

- [ ] **T2.20 the-platform-engineer: production-monitoring.md** `[activity: file-conversion]`

  Source: `the-devops/monitor-production.md`

- [ ] **T2.21 the-platform-engineer: PRESERVE data-architecture.md + deployment-automation.md + performance-tuning.md + pipeline-engineering.md** `[activity: preserve]`

  Target-only expansions (ADR-5).

#### the-qa-engineer/ (from the-tester/) `[parallel: true]`

- [ ] **T2.22 the-qa-engineer: performance-testing.md** `[activity: file-conversion]`

  Source: `the-tester/test-performance.md`

- [ ] **T2.23 the-qa-engineer: quality-assurance.md** `[activity: file-conversion]`

  Source: `the-tester/test-quality.md`

- [ ] **T2.24 the-qa-engineer: PRESERVE exploratory-testing.md + test-execution.md** `[activity: preserve]`

  Target-only expansions (ADR-5).

- [ ] **T2.25 Phase Validation** `[activity: validate]`

  Verify: all 20 source agents converted; all target-only files preserved; all filenames match SDD mapping table; all subagents have `mode: subagent` and no `model` field; no "Claude Code" references.

---

### Phase 3: Skills (Team Plugin)

Convert skills from `plugins/team/skills/<category>/<name>/` to flat `skill/<name>/`. Copy supporting files alongside.

`[ref: SDD/Skill Frontmatter Format]` `[ref: SDD/Supporting Files Strategy]`

**Skill frontmatter**: `name`, `description`, `license: MIT`, `compatibility: opencode`, `metadata: { category, version: "1.0" }`.

**Body**: Remove Identity/Constraints/Vision/Entry Point. Add H1 title. Preserve domain content.

#### Cross-cutting skills `[parallel: true]`

- [ ] **T3.1 codebase-navigation** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/codebase-navigation/` -> Target: `skill/codebase-navigation/`
  Copy: SKILL.md (converted) + examples/

- [ ] **T3.2 coding-conventions** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/coding-conventions/` -> Target: `skill/coding-conventions/`
  Copy: SKILL.md (converted) + checklists/

- [ ] **T3.3 documentation-extraction** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/documentation-extraction/` -> Target: `skill/documentation-extraction/`

- [ ] **T3.4 feature-prioritization** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/feature-prioritization/` -> Target: `skill/feature-prioritization/`
  Copy: SKILL.md + reference.md + examples/

- [ ] **T3.5 pattern-detection** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/pattern-detection/` -> Target: `skill/pattern-detection/`
  Copy: SKILL.md + examples/

- [ ] **T3.6 requirements-elicitation** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/requirements-elicitation/` -> Target: `skill/requirements-elicitation/`
  Copy: SKILL.md + examples/

- [ ] **T3.7 tech-stack-detection** `[activity: file-conversion]`

  Source: `team/skills/cross-cutting/tech-stack-detection/` -> Target: `skill/tech-stack-detection/`
  Copy: SKILL.md + references/

#### Design skills `[parallel: true]`

- [ ] **T3.8 user-insight-synthesis** `[activity: file-conversion]`

  Source: `team/skills/design/user-insight-synthesis/` -> Target: `skill/user-insight-synthesis/`
  Copy: SKILL.md + templates/

- [ ] **T3.9 user-research** `[activity: file-conversion]`

  Source: `team/skills/design/user-research/` -> Target: `skill/user-research/`
  Copy: SKILL.md + examples/

#### Development skills `[parallel: true]`

- [ ] **T3.10 api-contract-design** `[activity: file-conversion]`

  Source: `team/skills/development/api-contract-design/` -> Target: `skill/api-contract-design/`
  Copy: SKILL.md + templates/

- [ ] **T3.11 architecture-selection** `[activity: file-conversion]`

  Source: `team/skills/development/architecture-selection/` -> Target: `skill/architecture-selection/`
  Copy: SKILL.md + examples/ (includes adrs/)

- [ ] **T3.12 data-modeling** `[activity: file-conversion]`

  Source: `team/skills/development/data-modeling/` -> Target: `skill/data-modeling/`
  Copy: SKILL.md + templates/

- [ ] **T3.13 domain-driven-design** `[activity: file-conversion]`

  Source: `team/skills/development/domain-driven-design/` -> Target: `skill/domain-driven-design/`
  Copy: SKILL.md + reference.md + examples/

- [ ] **T3.14 technical-writing** `[activity: file-conversion]`

  Source: `team/skills/development/technical-writing/` -> Target: `skill/technical-writing/`
  Copy: SKILL.md + templates/

- [ ] **T3.15 testing** `[activity: file-conversion]`

  Source: `team/skills/development/testing/` -> Target: `skill/testing/`
  Copy: SKILL.md + examples/

#### Infrastructure skills `[parallel: true]`

- [ ] **T3.16 deployment-pipeline-design** `[activity: file-conversion]`

  Source: `team/skills/infrastructure/deployment-pipeline-design/` -> Target: `skill/deployment-pipeline-design/`
  Copy: SKILL.md + templates/

- [ ] **T3.17 observability-design** `[activity: file-conversion]`

  Source: `team/skills/infrastructure/observability-design/` -> Target: `skill/observability-design/`
  Copy: SKILL.md + references/

#### Quality skills `[parallel: true]`

- [ ] **T3.18 code-quality-review** `[activity: file-conversion]`

  Source: `team/skills/quality/code-quality-review/` -> Target: `skill/code-quality-review/`
  Copy: SKILL.md + reference.md + examples/

- [ ] **T3.19 performance-analysis** `[activity: file-conversion]`

  Source: `team/skills/quality/performance-analysis/` -> Target: `skill/performance-analysis/`
  Copy: SKILL.md + references/

- [ ] **T3.20 security-assessment** `[activity: file-conversion]`

  Source: `team/skills/quality/security-assessment/` -> Target: `skill/security-assessment/`
  Copy: SKILL.md + checklists/

- [ ] **T3.21 Phase Validation** `[activity: validate]`

  Verify: all 20 team skills converted; supporting files copied; all SKILL.md have `license: MIT`, `compatibility: opencode`, `metadata` fields; no `user-invocable` or `allowed-tools` in skill frontmatter.

---

### Phase 4: Skills (Start Plugin - Methodology)

Convert methodology content from user-invocable start skills into pure skill files. The orchestration parts move to commands in Phase 5.

`[ref: SDD/Skill Name Mapping]` `[ref: SDD/Skill Frontmatter Format]`

- [ ] **T4.1 specification-management** `[activity: file-conversion]`

  Source: `start/skills/specify-meta/` -> Target: `skill/specification-management/`
  Copy: SKILL.md (methodology only, strip orchestration) + readme-template.md + reference.md + spec.py

- [ ] **T4.2 requirements-analysis** `[activity: file-conversion]`

  Source: `start/skills/specify-requirements/` -> Target: `skill/requirements-analysis/`
  Copy: SKILL.md + template.md + validation.md + examples/

- [ ] **T4.3 architecture-design** `[activity: file-conversion]`

  Source: `start/skills/specify-solution/` -> Target: `skill/architecture-design/`
  Copy: SKILL.md + template.md + validation.md + examples/

- [ ] **T4.4 implementation-planning** `[activity: file-conversion]`

  Source: `start/skills/specify-plan/` -> Target: `skill/implementation-planning/`
  Copy: SKILL.md + template.md + validation.md + examples/

- [ ] **T4.5 codebase-analysis** `[activity: file-conversion]`

  Source: `start/skills/analyze/` -> Target: `skill/codebase-analysis/`

- [ ] **T4.6 bug-diagnosis** `[activity: file-conversion]`

  Source: `start/skills/debug/` -> Target: `skill/bug-diagnosis/`

- [ ] **T4.7 agent-coordination** `[activity: file-conversion]`

  Source: `start/skills/implement/` (methodology extract) -> Target: `skill/agent-coordination/`

- [ ] **T4.8 code-review** `[activity: file-conversion]`

  Source: `start/skills/review/` -> Target: `skill/code-review/`
  Copy: SKILL.md + reference.md

- [ ] **T4.9 safe-refactoring** `[activity: file-conversion]`

  Source: `start/skills/refactor/` -> Target: `skill/safe-refactoring/`
  Copy: SKILL.md + reference/

- [ ] **T4.10 constitution-validation** `[activity: file-conversion]`

  Source: `start/skills/constitution/` -> Target: `skill/constitution-validation/`
  Copy: SKILL.md + template.md + reference/ + examples/

- [ ] **T4.11 specification-validation** `[activity: file-conversion]`

  Source: `start/skills/validate/` -> Target: `skill/specification-validation/`
  Copy: SKILL.md + reference/ (3cs-framework.md, ambiguity-detection.md, constitution-validation.md, drift-detection.md)

- [ ] **T4.12 drift-detection** `[activity: file-conversion]`

  Source: `start/skills/validate/reference/drift-detection.md` -> Target: `skill/drift-detection/`
  Extract into standalone skill with SKILL.md + reference.md

- [ ] **T4.13 implementation-verification** `[activity: file-conversion]`

  Source: extracted from validate skill -> Target: `skill/implementation-verification/`

- [ ] **T4.14 knowledge-capture** `[activity: file-conversion]`

  Source: `start/skills/document/` -> Target: `skill/knowledge-capture/`
  Copy: SKILL.md + reference/ + templates/

- [ ] **T4.15 PRESERVE target-only skills** `[activity: preserve]`

  Verify these exist and do not overwrite: `context-preservation`, `documentation-sync`, `error-recovery`, `git-workflow`, `task-delegation`, `test-design`, `vibe-security`, `accessibility-design`

- [ ] **T4.16 Phase Validation** `[activity: validate]`

  Verify: all 14 start skills converted to methodology-only skill files; no `$ARGUMENTS` references in skills; no `user-invocable` fields; supporting files copied; target-only skills preserved.

---

### Phase 5: Commands

Convert user-invocable skills to command files. Depends on Phase 4 (skill names must be finalized).

`[ref: SDD/Command Frontmatter Format]` `[ref: SDD/Tool Name Mapping]` `[ref: SDD/Skill Invocation Syntax]`

**Command frontmatter**: `description` (quoted), `argument-hint`, `allowed-tools` (JSON array, lowercase).

**Command body**: Identity line (no heading) -> `$ARGUMENTS` context -> Core Rules (from Constraints) -> Workflow (nested phases) -> Important Notes. Remove: Team Mode, formal schemas, Vision, Entry Point.

- [ ] **T5.1 specify.md** `[activity: file-conversion]`

  Source: `start/skills/specify/SKILL.md` -> Target: `command/specify.md`
  Tool mapping: `Skill(start:specify-meta)` -> `skill({ name: "specification-management" })`

- [ ] **T5.2 implement.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/implement/SKILL.md` -> Target: `command/implement.md`
  Remove entire Team Mode workflow. Convert Constraints -> Core Rules.

- [ ] **T5.3 review.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/review/SKILL.md` -> Target: `command/review.md`
  Remove Team Mode. Remove formal `interface Finding` definitions. allowed-tools: no `write`, no `edit`.

- [ ] **T5.4 debug.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/debug/SKILL.md` -> Target: `command/debug.md`
  Remove Team Mode. Split investigation into multiple phases.

- [ ] **T5.5 analyze.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/analyze/SKILL.md` -> Target: `command/analyze.md`

- [ ] **T5.6 refactor.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/refactor/SKILL.md` -> Target: `command/refactor.md`

- [ ] **T5.7 document.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/document/SKILL.md` -> Target: `command/document.md`

- [ ] **T5.8 constitution.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/constitution/SKILL.md` -> Target: `command/constitution.md`

- [ ] **T5.9 validate.md** `[parallel: true]` `[activity: file-conversion]`

  Source: `start/skills/validate/SKILL.md` -> Target: `command/validate.md`
  Map three validation modes: `skill({ name: "specification-validation" })`, `skill({ name: "drift-detection" })`, `skill({ name: "constitution-validation" })`

- [ ] **T5.10 PRESERVE simplify.md** `[activity: preserve]`

  Target-only command (no source equivalent). Verify exists.

- [ ] **T5.11 Phase Validation** `[activity: validate]`

  Verify: all 9 source commands converted; simplify.md preserved; all tool names lowercase; all `Skill()` calls converted to `skill({ name: })` syntax; no Team Mode content; no `name:` in frontmatter; descriptions are quoted strings.

---

### Phase 6: Cross-Cutting Updates

Scan all converted files for remaining source-format artifacts.

- [ ] **T6.1 Brand name substitution** `[activity: search-replace]`

  Scan all files under `agent/`, `skill/`, `command/` for:
  - "Claude Code" -> "Opencode"
  - ".claude/agents/" -> "agent/"
  - "Claude Code plugin" -> "Opencode framework"
  Validate: `grep -r "Claude Code" agent/ skill/ command/` returns no results.

- [ ] **T6.2 Tool name audit** `[activity: search-replace]`

  Scan for PascalCase tool names: `AskUserQuestion`, `TodoWrite`, `TaskCreate`, `TaskOutput`, `MultiEdit`
  Replace with lowercase equivalents or remove.
  Validate: `grep -rE "(AskUserQuestion|TodoWrite|TaskCreate|TaskOutput|MultiEdit)" agent/ skill/ command/` returns no results.

- [ ] **T6.3 Skill invocation audit** `[activity: search-replace]`

  Scan for old-format skill calls: `Skill(start:`, `Skill(team:`
  Replace with `skill({ name: "mapped-name" })` per SDD mapping table.
  Validate: `grep -r "Skill(" agent/ skill/ command/` returns no results.

- [ ] **T6.4 Supporting file reference audit** `[activity: search-replace]`

  Scan supporting files (templates, examples, checklists, references) for Claude Code artifacts.
  Update any tool/skill references found.

- [ ] **T6.5 Update README.md** `[activity: documentation]`

  Update `~/.config/opencode/frameworks/the-startup/README.md` to reflect:
  - New agent names and activities
  - New skill inventory
  - Command list
  - Version: migrated from v3.2.1

- [ ] **T6.6 Phase Validation** `[activity: validate]`

  Final comprehensive scan. No source-format artifacts remain anywhere in the target framework.

---

## Dependency Graph

```
Phase 0 (Backup)
  |
  v
Phase 1 (Primary Agents) ─────────────────────────┐
  |                                                 |
  v                                                 |
Phase 2 (Subagents) ── all roles run in parallel    |
  |                                                 |
  v                                                 |
Phase 3 (Team Skills) ── all categories in parallel |
  |                                                 |
  v                                                 |
Phase 4 (Start Skills) ── depends on skill names    |
  |                                                 |
  v                                                 |
Phase 5 (Commands) ── depends on Phase 4 skill names|
  |                                                 |
  v                                                 |
Phase 6 (Cross-Cutting) ── depends on all above ────┘
```

**Parallel opportunities**: Within Phase 2 (roles), Phase 3 (categories), Phase 5 (commands).
**Sequential dependencies**: Phase 4 before Phase 5 (skill name mapping). Phase 6 after all others.

---

## Plan Verification

| Criterion | Status |
|-----------|--------|
| A developer can follow this plan without additional clarification | Yes |
| Every task produces a verifiable deliverable | Yes |
| All SDD components have implementation tasks | Yes |
| Dependencies are explicit with no circular references | Yes |
| Parallel opportunities are marked with `[parallel: true]` | Yes |
| Each task has specification references `[ref: ...]` | Yes |
| Project commands in Context Priming are accurate | Yes |

---

## Summary

| Metric | Value |
|--------|-------|
| Total phases | 7 (0-6) |
| Total tasks | ~56 |
| Parallel groups | 8 (role groups + skill categories + commands) |
| Files to rebuild | ~43 (agents + skills + commands) |
| Files to preserve | ~23 (target-only expansions) |
| Key dependencies | Phase 4 -> Phase 5 (skill names); Phase 6 after all |
