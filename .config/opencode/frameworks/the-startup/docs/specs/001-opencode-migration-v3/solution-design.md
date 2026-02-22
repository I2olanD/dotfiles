---
title: "OpenCode Migration v3.2.1 - Full Rebuild"
status: approved
version: "1.0"
---

# Solution Design Document

## Validation Checklist

### CRITICAL GATES (Must Pass)

- [x] All required sections are complete
- [x] No [NEEDS CLARIFICATION] markers remain
- [x] Architecture pattern is clearly stated with rationale
- [x] **All architecture decisions confirmed by user (2026-02-21)**
- [x] Every interface has specification

### QUALITY CHECKS (Should Pass)

- [x] All context sources are listed with relevance ratings
- [x] Project commands are discovered from actual project files
- [x] Constraints -> Strategy -> Design -> Implementation path is logical
- [x] Every component in diagram has directory mapping
- [x] Error handling covers all error types
- [x] Quality requirements are specific and measurable
- [x] Component names consistent across diagrams
- [x] A developer could implement from this design

---

## Constraints

CON-1 **OpenCode compliance**: All output files must use opencode frontmatter format (description, mode, model, skills, allowed-tools, compatibility, metadata fields)
CON-2 **Flat namespace**: Skills must be in `skill/<name>/SKILL.md` (no category subdirectories); agents in `agent/<role>/<activity>.md`; commands in `command/<name>.md`
CON-3 **No team mode**: OpenCode does not support Claude Code's experimental agent teams. All team mode content (TeamCreate, TeamDelete, SendMessage, TaskCreate/TaskUpdate/TaskList/TaskGet) must be removed
CON-4 **Tool naming**: All tool references must use lowercase (`bash`, `read`, `write`, `edit`, `glob`, `grep`, `question`, `skill`, `todowrite`)
CON-5 **Full rebuild**: Every file in the target is regenerated from source v3.2.1 -- no incremental patching

## Implementation Context

### Required Context Sources

#### Documentation Context
```yaml
- doc: ~/.claude/plugins/marketplaces/the-startup/CLAUDE.md
  relevance: HIGH
  why: "Source repository structure and conventions"

- doc: ~/.config/opencode/frameworks/the-startup/README.md
  relevance: HIGH
  why: "Target framework structure and naming conventions"

- doc: ~/.claude/plugins/marketplaces/the-startup/CHANGELOG.md
  relevance: MEDIUM
  why: "Version history and migration patterns"
```

#### Code Context
```yaml
- file: ~/.claude/plugins/marketplaces/the-startup/plugins/start/.claude-plugin/plugin.json
  relevance: HIGH
  why: "Source version (3.2.1) and component manifest"

- file: ~/.claude/plugins/marketplaces/the-startup/plugins/team/.claude-plugin/plugin.json
  relevance: HIGH
  why: "Team plugin version and component manifest"

- file: ~/.config/opencode/opencode.json
  relevance: MEDIUM
  why: "OpenCode configuration with symlinks to framework"
```

### Implementation Boundaries

- **Must Preserve**: All agent capabilities, skill methodologies, command workflows, supporting files (templates, examples, checklists, references)
- **Can Modify**: File format, section structure, naming conventions, tool references, frontmatter fields
- **Must Not Touch**: `~/.config/opencode/opencode.json`, `~/.config/opencode/plugins/`, symlinks in `~/.config/opencode/`

### External Interfaces

Not applicable -- this is a file format migration with no external service integrations.

### Project Commands

```bash
# Verify results
ls -laR ~/.config/opencode/frameworks/the-startup/agent/
ls -laR ~/.config/opencode/frameworks/the-startup/skill/
ls -laR ~/.config/opencode/frameworks/the-startup/command/
```

## Solution Strategy

- **Architecture Pattern**: File-by-file transformation pipeline with three conversion rulesets (agents, skills, commands)
- **Integration Approach**: Read source -> apply transformation rules -> write to target directory, preserving co-located supporting files
- **Justification**: Each component type (agent, skill, command) has distinct transformation rules. Treating them as three parallel conversion streams enables independent validation.
- **Key Decisions**: See ADRs below

## Building Block View

### Components

```
Source (Claude Code Plugin v3.2.1)          Target (OpenCode Framework)
====================================        ============================

plugins/team/agents/                   -->  agent/
  the-chief.md                              the-chief.md
  the-meta-agent.md                         the-meta-agent.md
  the-analyst/                              the-analyst/
  the-architect/                            the-architect/
  the-designer/                             the-designer/
  the-developer/                       -->  the-software-engineer/
  the-devops/                          -->  the-platform-engineer/
  the-tester/                          -->  the-qa-engineer/

plugins/start/skills/ (user-invocable) --> command/
plugins/start/skills/ (methodology)    --> skill/ (merged with team skills)
plugins/team/skills/ (all categories)  --> skill/ (flattened)
```

### Directory Map

**Component**: agent/
```
agent/
├── the-chief.md                         # REBUILD: Primary agent
├── the-meta-agent.md                    # REBUILD: Primary agent
├── the-analyst/
│   ├── market-research.md               # REBUILD from research-market.md
│   ├── requirements-analysis.md         # REBUILD from research-requirements.md
│   ├── feature-prioritization.md        # NEW: expanded from source
│   └── project-coordination.md          # NEW: expanded from source
├── the-architect/
│   ├── system-architecture.md           # REBUILD from design-system.md
│   ├── security-review.md              # REBUILD from review-security.md
│   ├── complexity-review.md            # REBUILD from review-complexity.md
│   ├── compatibility-review.md         # REBUILD from review-compatibility.md
│   ├── quality-review.md              # NEW: expanded
│   ├── system-documentation.md        # NEW: expanded
│   └── technology-research.md         # NEW: expanded
├── the-designer/
│   ├── accessibility-implementation.md  # REBUILD from build-accessibility.md
│   ├── design-foundation.md            # REBUILD from design-visual.md
│   ├── interaction-architecture.md     # REBUILD from design-interaction.md
│   └── user-research.md               # REBUILD from research-user.md
├── the-software-engineer/              # REBUILD from the-developer/
│   ├── api-development.md             # NEW: expanded from build-feature.md
│   ├── component-development.md       # NEW: expanded from build-feature.md
│   ├── concurrency-review.md          # REBUILD from review-concurrency.md
│   ├── domain-modeling.md             # NEW: expanded
│   └── performance-optimization.md    # REBUILD from optimize-performance.md
├── the-platform-engineer/              # REBUILD from the-devops/
│   ├── ci-cd-pipelines.md            # REBUILD from build-pipelines.md
│   ├── containerization.md           # REBUILD from build-containers.md
│   ├── data-architecture.md          # NEW: expanded
│   ├── dependency-review.md          # REBUILD from review-dependency.md
│   ├── deployment-automation.md      # NEW: expanded
│   ├── infrastructure-as-code.md     # REBUILD from build-infrastructure.md
│   ├── performance-tuning.md         # NEW: expanded
│   ├── pipeline-engineering.md       # NEW: expanded
│   └── production-monitoring.md      # REBUILD from monitor-production.md
└── the-qa-engineer/                    # REBUILD from the-tester/
    ├── exploratory-testing.md         # NEW: expanded
    ├── performance-testing.md         # REBUILD from test-performance.md
    ├── quality-assurance.md           # REBUILD from test-quality.md
    └── test-execution.md             # NEW: expanded
```

**Component**: command/
```
command/
├── analyze.md          # REBUILD from start/skills/analyze/SKILL.md
├── constitution.md     # REBUILD from start/skills/constitution/SKILL.md
├── debug.md            # REBUILD from start/skills/debug/SKILL.md
├── document.md         # REBUILD from start/skills/document/SKILL.md
├── implement.md        # REBUILD from start/skills/implement/SKILL.md
├── refactor.md         # REBUILD from start/skills/refactor/SKILL.md
├── review.md           # REBUILD from start/skills/review/SKILL.md
├── simplify.md         # PRESERVE (no source equivalent)
├── specify.md          # REBUILD from start/skills/specify/SKILL.md
└── validate.md         # REBUILD from start/skills/validate/SKILL.md
```

**Component**: skill/ (flat, ~44 skills)
```
skill/
├── accessibility-design/          # From team/skills/design/ (via user-research context)
├── agent-coordination/            # From start/skills/implement/ (methodology extract)
├── api-contract-design/           # From team/skills/development/
├── architecture-design/           # From start/skills/specify-solution/ (methodology)
├── architecture-selection/        # From team/skills/development/
├── bug-diagnosis/                 # From start/skills/debug/ (methodology)
├── code-quality-review/           # From team/skills/quality/
├── code-review/                   # From start/skills/review/ (methodology)
├── codebase-analysis/             # From start/skills/analyze/ (methodology)
├── codebase-navigation/           # From team/skills/cross-cutting/
├── coding-conventions/            # From team/skills/cross-cutting/
├── constitution-validation/       # From start/skills/constitution/ (methodology)
├── context-preservation/          # PRESERVE (target-only)
├── data-modeling/                 # From team/skills/development/
├── deployment-pipeline-design/    # From team/skills/infrastructure/
├── documentation-extraction/      # From team/skills/cross-cutting/
├── documentation-sync/            # PRESERVE (target-only)
├── domain-driven-design/          # From team/skills/development/
├── drift-detection/               # From start/skills/validate/reference/
├── error-recovery/                # PRESERVE (target-only)
├── feature-prioritization/        # From team/skills/cross-cutting/
├── git-workflow/                  # PRESERVE (target-only)
├── implementation-planning/       # From start/skills/specify-plan/ (methodology)
├── implementation-verification/   # From start/skills/validate/reference/
├── knowledge-capture/             # From start/skills/document/ (methodology)
├── observability-design/          # From team/skills/infrastructure/
├── pattern-detection/             # From team/skills/cross-cutting/
├── performance-analysis/          # From team/skills/quality/
├── requirements-analysis/         # From start/skills/specify-requirements/ (methodology)
├── requirements-elicitation/      # From team/skills/cross-cutting/
├── safe-refactoring/              # From start/skills/refactor/ (methodology)
├── security-assessment/           # From team/skills/quality/
├── specification-management/      # From start/skills/specify-meta/ (methodology)
├── specification-validation/      # From start/skills/validate/ (methodology)
├── task-delegation/               # PRESERVE (target-only)
├── tech-stack-detection/          # From team/skills/cross-cutting/
├── technical-writing/             # From team/skills/development/
├── test-design/                   # PRESERVE (target-only)
├── testing/                       # From team/skills/development/
├── user-insight-synthesis/        # From team/skills/design/
├── user-research/                 # From team/skills/design/
└── vibe-security/                 # PRESERVE (target-only)
```

### Interface Specifications

#### Agent Frontmatter Format

```yaml
# PRIMARY agent
---
description: "<1-2 sentence functional summary>"
mode: primary
model: github-copilot/claude-opus-4-5-20250918
skills: <comma-separated skill names>
allowed-tools: [read, write, glob, grep]
---

# SUBAGENT
---
description: "<1-2 sentence functional summary>"
mode: subagent
skills: <comma-separated skill names>
---
```

**Field transformation from source:**

| Source | Target | Rule |
|--------|--------|------|
| `name: X` | *(removed)* | Filename is identifier |
| `description: PROACTIVELY...` | `description: "<concise>"` | Strip trigger language, examples; rewrite as functional summary |
| `model: sonnet` | `model: github-copilot/claude-opus-4-5-20250918` | Primary agents only; remove for subagents |
| `tools: Read, Write` | `allowed-tools: [read, write]` | Primary agents only; lowercase; remove for subagents |
| *(absent)* | `mode: primary\|subagent` | Add based on file location |
| `skills: X, Y` | `skills: X, Y, Z` | Retain; optionally add new skills (error-recovery, vibe-security) |

#### Agent Body Format

```markdown
# PRIMARY agents:                      # SUBAGENTS:
<identity sentence>                    <identity sentence>

## Focus Areas                         ## Mission
- <bullets>                            <purpose>

## Approach                            ## <Domain sections>
1. <numbered steps>                    <checklists, activities>

## Deliverables                        ## Deliverables
1. <list>                              <output format>

## Quality Standards                   ## Quality Standards
- <bullets>                            - <bullets>

## Usage Examples                      ## Usage Examples
<example>...</example>                 <example>...</example>
```

**Sections removed from source:** `## Identity` heading, `## Constraints` DSL, `## Vision`, `## Decision: *` tables, `## Output` typed schemas, `## Entry Point`

#### Skill Frontmatter Format

```yaml
---
name: <skill-name>
description: "<what this skill enables>"
license: MIT
compatibility: opencode
metadata:
  category: <analysis|design|development|testing|documentation|infrastructure>
  version: "1.0"
---
```

**Fields removed:** `user-invocable`, `argument-hint`, `allowed-tools` (move to command/)
**Fields added:** `license`, `compatibility`, `metadata`

#### Command Frontmatter Format

```yaml
---
description: "<what this command does>"
argument-hint: "<expected arguments>"
allowed-tools:
  [
    "todowrite",
    "bash",
    "write",
    "edit",
    "read",
    "glob",
    "grep",
    "question",
    "skill",
  ]
---
```

**Tool name mapping:**

| Source | Target |
|--------|--------|
| Task, TaskOutput | *(removed)* |
| TodoWrite | todowrite |
| Bash | bash |
| Write | write |
| Edit | edit |
| Read | read |
| LS | *(removed)* |
| Glob | glob |
| Grep | grep |
| MultiEdit | *(removed)* |
| AskUserQuestion | question |
| Skill | skill |
| TeamCreate, TeamDelete, SendMessage | *(removed)* |
| TaskCreate, TaskUpdate, TaskList, TaskGet | *(removed)* |

#### Skill Invocation Syntax

| Source | Target |
|--------|--------|
| `Skill(start:specify-meta)` | `skill({ name: "specification-management" })` |
| `Skill(start:validate)` | `skill({ name: "specification-validation" })` |
| `Skill(start:validate) drift` | `skill({ name: "drift-detection" })` |
| `Skill(start:validate) constitution` | `skill({ name: "constitution-validation" })` |
| `Skill(start:specify-requirements)` | `skill({ name: "requirements-analysis" })` |
| `Skill(start:specify-solution)` | `skill({ name: "architecture-design" })` |
| `Skill(start:specify-plan)` | `skill({ name: "implementation-planning" })` |

#### Filename Mapping

**Agent activities (verb-noun -> noun-verb):**

| Source | Target |
|--------|--------|
| review-security.md | security-review.md |
| review-complexity.md | complexity-review.md |
| review-compatibility.md | compatibility-review.md |
| review-concurrency.md | concurrency-review.md |
| review-dependency.md | dependency-review.md |
| design-system.md | system-architecture.md |
| build-feature.md | component-development.md + api-development.md |
| build-containers.md | containerization.md |
| build-pipelines.md | ci-cd-pipelines.md |
| build-infrastructure.md | infrastructure-as-code.md |
| build-accessibility.md | accessibility-implementation.md |
| design-interaction.md | interaction-architecture.md |
| design-visual.md | design-foundation.md |
| optimize-performance.md | performance-optimization.md |
| research-market.md | market-research.md |
| research-requirements.md | requirements-analysis.md |
| research-user.md | user-research.md |
| test-quality.md | quality-assurance.md |
| test-performance.md | performance-testing.md |
| monitor-production.md | production-monitoring.md |

**Role directories:**

| Source | Target |
|--------|--------|
| the-developer/ | the-software-engineer/ |
| the-devops/ | the-platform-engineer/ |
| the-tester/ | the-qa-engineer/ |

### Supporting Files Strategy

Supporting files are **copied as-is** with these exceptions:
1. If a supporting file references `Skill(start:name)`, update to `skill({ name: "mapped-name" })`
2. If a supporting file references PascalCase tool names, update to lowercase
3. If a supporting file references "Claude Code", update to "Opencode"

## Runtime View

### Conversion Flow

```
For each component type (agents, skills, commands):
  1. List source files
  2. For each source file:
     a. Read source content
     b. Determine file type (primary/subagent, user-invocable/autonomous)
     c. Apply frontmatter transformation
     d. Apply body transformation
     e. Apply filename/directory mapping
     f. Write to target location
     g. Copy supporting files if present
  3. For target-only files (no source):
     a. Preserve existing target file unchanged
```

### Error Handling

- **Missing source file**: Skip; preserve existing target file (for NEW/expanded files)
- **Ambiguous mapping**: Use filename mapping tables; flag unmapped files
- **Supporting file with Claude Code references**: Scan and update

## Deployment View

No change to deployment. Local filesystem migration only.

## Architecture Decisions

- [x] ADR-1 **Full rebuild with preserve-new strategy**: Rebuild all files with source equivalents; preserve target-only files unchanged.
  - Rationale: Clean conversion from latest source while keeping target's independent expansions
  - Trade-offs: Target-only files may diverge from source conventions
  - User confirmed: 2026-02-21

- [x] ADR-2 **Model: github-copilot/claude-opus-4-5-20250918 for primary agents**: All primary agents use this model value
  - Rationale: User preference; stable model version
  - Trade-offs: Tied to GitHub Copilot routing
  - User confirmed: 2026-02-21

- [x] ADR-3 **Remove all Team Mode content**: Strip all team tools and workflow sections
  - Rationale: OpenCode does not support Claude Code agent teams
  - Trade-offs: Loses collaborative research (re-add if OpenCode adds support)
  - User confirmed: 2026-02-21

- [x] ADR-4 **Output styles out of scope**: Do not migrate the-startup.md and the-scaleup.md
  - Rationale: No equivalent mechanism in OpenCode
  - Trade-offs: Users lose personality/voice customization
  - User confirmed: 2026-02-21

- [x] ADR-5 **Expanded activities preserved**: Keep target's expanded agent activities not present in source
  - Rationale: These add value; were deliberately expanded
  - Trade-offs: May not reflect latest source formatting conventions
  - User confirmed: 2026-02-21

## Quality Requirements

- **Completeness**: Every source file with a mapping produces a valid target file
- **Format compliance**: All target files have correct opencode frontmatter
- **Content fidelity**: Core capabilities, methodologies, and workflows preserved through transformation
- **Naming consistency**: All references use target conventions throughout

## Acceptance Criteria

**Agent Conversion:**
- [ ] WHEN a source agent exists, THE SYSTEM SHALL produce a target file with correct opencode frontmatter
- [ ] THE SYSTEM SHALL map all role directories (developer->software-engineer, devops->platform-engineer, tester->qa-engineer)
- [ ] THE SYSTEM SHALL map all activity filenames per the mapping table
- [ ] WHEN an agent is primary, THE SYSTEM SHALL include mode, model, and allowed-tools
- [ ] WHEN an agent is a subagent, THE SYSTEM SHALL include only mode (no model, no allowed-tools)

**Skill Conversion:**
- [ ] THE SYSTEM SHALL flatten all skills into `skill/<name>/SKILL.md`
- [ ] THE SYSTEM SHALL add license, compatibility, and metadata fields
- [ ] THE SYSTEM SHALL copy all supporting files

**Command Conversion:**
- [ ] THE SYSTEM SHALL produce a `command/<name>.md` for each user-invocable skill
- [ ] THE SYSTEM SHALL map all tool names to lowercase
- [ ] THE SYSTEM SHALL replace Skill() syntax with skill() syntax
- [ ] THE SYSTEM SHALL remove all Team Mode content

**Cross-Cutting:**
- [ ] THE SYSTEM SHALL replace "Claude Code" with "Opencode"
- [ ] THE SYSTEM SHALL preserve all target-only files

## Risks and Technical Debt

### Implementation Gotchas

- Source `build-feature.md` maps to TWO target files (`api-development.md` + `component-development.md`) -- content needs splitting
- The `validate` source skill maps to THREE target skills (`specification-validation`, `drift-detection`, `constitution-validation`)
- The `document` source skill maps to multiple target skills (`knowledge-capture`, `documentation-extraction`, `documentation-sync`, `technical-writing`)
- Supporting files may contain Claude Code tool references needing update

## Glossary

| Term | Definition |
|------|------------|
| Claude Code Plugin | Source format using `.claude-plugin/plugin.json` manifest |
| OpenCode Framework | Target format with flat `agent/`, `skill/`, `command/` directories |
| Primary agent | Top-level orchestrator with `mode: primary` (the-chief, the-meta-agent) |
| Subagent | Activity-level specialist with `mode: subagent` |
| User-invocable | Source skill that maps to both a command/ file and a skill/ file in target |
| Activity | Specialized capability within an agent role directory |
