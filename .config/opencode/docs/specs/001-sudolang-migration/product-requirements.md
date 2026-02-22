---
title: "SudoLang Migration for The Startup Framework"
status: draft
version: "1.0"
---

# Product Requirements Document

## Validation Checklist

### CRITICAL GATES (Must Pass)

- [x] All required sections are complete
- [x] No [NEEDS CLARIFICATION] markers remain
- [x] Problem statement is specific and measurable
- [x] Every feature has testable acceptance criteria (Gherkin format)
- [x] No contradictions between sections

### QUALITY CHECKS (Should Pass)

- [x] Problem is validated by evidence (not assumptions)
- [x] Context → Problem → Solution flow makes sense
- [x] Every persona has at least one user journey
- [x] All MoSCoW categories addressed (Must/Should/Could/Won't)
- [x] Every metric has corresponding tracking events
- [x] No feature redundancy (check for duplicates)
- [x] No technical implementation details included
- [x] A new team member could understand this PRD

---

## Product Overview

### Vision

Transform the-startup framework from Markdown+YAML format to SudoLang syntax, enabling more expressive agent/skill/command definitions with native LLM constraint support while maintaining `.md` file extension for OpenCode compatibility.

### Problem Statement

**Current State**: The-startup framework uses 143 files (35 agents, 42 skills, 10 commands, 51 supporting files) with Markdown content and YAML frontmatter. This format:
- Separates metadata (YAML) from behavior (Markdown), creating cognitive split
- Uses prose-based instructions that lack explicit constraint semantics
- Does not leverage LLM-native pseudocode that models understand more efficiently
- Requires verbose natural language for logic that could be more concise

**Pain Points**:
1. Maintaining consistency across 87 primary definition files is error-prone
2. Decision tables and routing logic lack formal pattern matching syntax
3. No standardized way to express constraints vs. suggestions vs. requirements
4. Token usage for framework instructions is higher than necessary

**Consequences of Not Solving**:
- Higher LLM API costs due to verbose prompts
- Potential for inconsistent constraint following
- Steeper learning curve for framework contributors
- Missed opportunity for improved LLM comprehension

### Value Proposition

SudoLang provides a pseudolanguage specifically designed for LLM interaction that:
- **Reduces tokens by 20-30%** compared to verbose natural language
- **Formalizes constraints** that LLMs continuously respect
- **Native /commands** syntax aligning with framework command patterns
- **Pattern matching** for decision tables (first-match-wins logic)
- **Interface composition** for modular, reusable definitions
- **No special prompting required** - LLMs understand SudoLang natively

---

## User Personas

### Primary Persona: Framework Maintainer

- **Demographics**: Developer or tech lead maintaining the-startup framework; comfortable with AI tooling; intermediate+ programming experience
- **Goals**: 
  - Keep framework definitions consistent and maintainable
  - Reduce duplication and improve modularity
  - Ensure agents follow instructions reliably
- **Pain Points**: 
  - YAML frontmatter feels disconnected from behavior instructions
  - No formal syntax for constraints leads to inconsistent phrasing
  - Difficult to spot redundancy across 87 definition files

### Secondary Persona: Agent Developer

- **Demographics**: Developer creating new agents or skills for the framework; may be new to the codebase
- **Goals**:
  - Quickly understand existing patterns to follow
  - Create new definitions without extensive documentation reading
  - Compose existing skills into new capabilities
- **Pain Points**:
  - Current format requires reading full markdown to understand structure
  - No clear distinction between required vs. optional behaviors
  - Skill composition requires understanding implicit conventions

### Secondary Persona: OpenCode User

- **Demographics**: End user running commands and workflows; may not modify framework
- **Goals**:
  - Commands work reliably and consistently
  - Workflows complete successfully
  - Clear error messages when things go wrong
- **Pain Points**:
  - Inconsistent agent behavior due to ambiguous instructions
  - Some workflows feel slower than expected

---

## User Journey Maps

### Primary User Journey: Framework Migration

1. **Awareness**: Framework maintainer learns about SudoLang and its benefits for LLM instructions
2. **Consideration**: Evaluates migration effort vs. benefits; reviews SudoLang syntax
3. **Adoption**: Follows migration specification to convert files systematically
4. **Usage**: Maintains framework using SudoLang syntax; creates new definitions
5. **Retention**: Benefits from clearer syntax, better LLM behavior, reduced token costs

### Secondary User Journey: New Agent Creation

1. **Awareness**: Developer needs to create new agent for specific task
2. **Consideration**: Reviews existing agent examples in SudoLang format
3. **Adoption**: Copies template structure and adapts for new agent
4. **Usage**: Defines interface, constraints, and commands using SudoLang
5. **Retention**: Agent works reliably; pattern is repeatable for future agents

---

## Feature Requirements

### Must Have Features

#### Feature 1: Agent Definition Migration

- **User Story**: As a framework maintainer, I want all 35 agent definitions converted to SudoLang interface format, so that agent behavior is explicitly defined with constraints.

- **Acceptance Criteria (Gherkin Format)**:
  - Given an existing agent markdown file with YAML frontmatter
  - When I run the migration process
  - Then the agent is converted to SudoLang format with Metadata block
  - And all instruction sections become Constraints or functions
  - And the file retains `.md` extension
  
  - Given a migrated agent file
  - When an LLM processes it
  - Then the LLM follows all defined constraints
  - And produces output matching current agent behavior

#### Feature 2: Skill Definition Migration

- **User Story**: As a framework maintainer, I want all 42 skill SKILL.md files converted to SudoLang interface format, so that skill protocols are formally defined.

- **Acceptance Criteria (Gherkin Format)**:
  - Given an existing skill SKILL.md file with YAML frontmatter
  - When I run the migration process
  - Then the skill is converted to SudoLang format with Metadata block
  - And procedural knowledge becomes Constraints and functions
  - And decision tables become pattern matching constructs
  - And the file retains `.md` extension
  
  - Given a migrated skill file
  - When referenced by an agent via skill tool
  - Then the skill loads correctly
  - And provides equivalent guidance to current format

#### Feature 3: Command Definition Migration

- **User Story**: As a framework maintainer, I want all 10 command definitions converted to SudoLang format with native /command syntax, so that command interfaces are formally defined.

- **Acceptance Criteria (Gherkin Format)**:
  - Given an existing command markdown file with YAML frontmatter
  - When I run the migration process
  - Then the command is converted to SudoLang interface with /commands
  - And workflow phases become functions or constraint blocks
  - And `$ARGUMENTS` interpolation is preserved
  - And the file retains `.md` extension
  
  - Given a migrated command file
  - When invoked via OpenCode
  - Then the command executes identically to current behavior
  - And skill tool calls work correctly

#### Feature 4: Metadata Preservation

- **User Story**: As a framework maintainer, I want all YAML frontmatter metadata preserved in migrated files, so that OpenCode can still parse required configuration.

- **Acceptance Criteria (Gherkin Format)**:
  - Given a file with YAML frontmatter containing `description`, `mode`, `model`, `skills`, `allowed-tools`
  - When migrated to SudoLang format
  - Then all metadata fields are represented in a Metadata block
  - And the structure is parseable by OpenCode framework
  
  - Given a migrated agent with model specification
  - When loaded by OpenCode
  - Then the correct model is selected for that agent

### Should Have Features

#### Feature 5: Token Efficiency Measurement

- **User Story**: As a framework maintainer, I want to measure token reduction achieved by migration, so that I can quantify cost savings.

- **Acceptance Criteria**:
  - Given original and migrated files
  - When token counts are compared
  - Then migrated files use fewer tokens (target: 15-30% reduction)
  - And a comparison report is generated

#### Feature 6: Behavioral Equivalence Validation

- **User Story**: As a framework maintainer, I want to validate that migrated definitions produce equivalent behavior, so that I can ensure no regression.

- **Acceptance Criteria**:
  - Given a sample of migrated agents/skills/commands
  - When tested with representative prompts
  - Then outputs match expected behavior from original definitions
  - And any deviations are documented

### Could Have Features

#### Feature 7: Migration Tooling

- **User Story**: As a framework maintainer, I want automated tooling to assist with migration, so that I can convert files more quickly.

- **Acceptance Criteria**:
  - Given a markdown file with YAML frontmatter
  - When processed by migration tool
  - Then a SudoLang formatted version is generated
  - And manual review/refinement is still required

### Won't Have (This Phase)

- **SudoLang linting automation**: Custom lint rules for framework conventions (future enhancement)
- **Supporting file conversion**: Templates, scripts, examples remain in current format
- **File extension change**: All files keep `.md` extension per OpenCode requirement
- **Runtime parser changes**: OpenCode framework itself is not modified
- **New agents/skills/commands**: This migration focuses on existing definitions only

---

## Detailed Feature Specifications

### Feature: Command Definition Migration

**Description**: Commands orchestrate workflows by invoking skills, delegating to agents, and interacting with users. Migration must preserve workflow phases, tool permissions, and argument handling.

**User Flow**:
1. User invokes command (e.g., `/specify feature description`)
2. OpenCode loads command definition
3. LLM interprets SudoLang interface and constraints
4. Command executes workflow phases
5. Skills are invoked via skill tool calls
6. User receives output per command specification

**Business Rules**:
- Rule 1: All `$ARGUMENTS` placeholders must be preserved as SudoLang template strings
- Rule 2: `skill({ name: "..." })` invocations must remain as natural language instructions (not SudoLang function calls)
- Rule 3: `allowed-tools` must be represented in a way OpenCode can parse
- Rule 4: Workflow phases must maintain sequential ordering

**Edge Cases**:
- Scenario 1: Command with no `argument-hint` → Expected: Still functional with empty arguments
- Scenario 2: Command invoking multiple skills sequentially → Expected: Each skill call preserved in order
- Scenario 3: Command with complex decision tables → Expected: Pattern matching or constraint preserves first-match-wins

---

## Success Metrics

### Key Performance Indicators

- **Adoption**: 100% of 87 primary definition files migrated
- **Engagement**: Framework maintainers use SudoLang syntax for new definitions
- **Quality**: Zero behavioral regressions reported post-migration
- **Business Impact**: 15-30% token reduction across framework definitions

### Tracking Requirements

| Event | Properties | Purpose |
|-------|------------|---------|
| File migrated | file_type (agent/skill/command), original_tokens, migrated_tokens | Track migration progress and token efficiency |
| Behavioral test | file_name, test_type, pass/fail | Validate equivalence |
| Post-migration issue | file_name, issue_type, severity | Track regression quality |

---

## Constraints and Assumptions

### Constraints

- **File Extension**: All migrated files must retain `.md` extension for OpenCode compatibility
- **Migration Strategy**: Complete cutover - no parallel format support period
- **Supporting Files**: Templates, scripts, and reference docs remain unchanged (51 files)
- **Framework Code**: OpenCode framework itself is not modified

### Assumptions

- LLMs (Claude, GPT-4) understand SudoLang natively without specification preamble
- SudoLang syntax within `.md` files is parsed as expected by LLMs
- Current skill tool invocation pattern (`skill({ name: "..." })`) continues to work
- Token efficiency claims (20-30% reduction) are achievable for this content type

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| LLM misinterprets SudoLang syntax | High | Low | Start with pilot files, validate behavior before full migration |
| OpenCode fails to parse new format | High | Low | Retain YAML frontmatter structure if needed; test early |
| Token reduction not achieved | Medium | Medium | Measure baseline first; accept that some files may not reduce |
| Behavioral regression in agents | High | Medium | Create test cases before migration; validate sample after |
| Supporting files need SudoLang too | Low | Low | Defer to future phase if needed |

---

## Open Questions

- [x] File extension requirement → **Confirmed: Keep `.md` extension**
- [x] Migration strategy → **Confirmed: Complete cutover**
- [x] Supporting files → **Confirmed: Keep as-is**
- [ ] How should YAML frontmatter coexist with SudoLang? Keep YAML block + SudoLang body, or convert YAML to SudoLang Metadata block?
- [ ] Should we create a migration guide document for future maintainers?

---

## Supporting Research

### Competitive Analysis

- **SudoLang**: The target format; designed specifically for LLM interaction; 1.3k GitHub stars; active maintenance
- **YAML+Markdown**: Current format; widely understood; verbose for LLM instructions
- **Structured prompting**: Research shows pseudocode can improve LLM reasoning (https://arxiv.org/abs/2305.11790)

### Evidence

- SudoLang claim: "SudoLang prompts can often be written with 20%-30% fewer tokens than natural language"
- Framework scale: 87 primary definition files = significant token savings potential
- SudoLang native LLM support: "An AI model does not need the SudoLang specification to correctly interpret SudoLang programs"

### Framework Inventory

| Category | Count |
|----------|-------|
| Agents | 35 |
| Commands | 10 |
| Skills (SKILL.md) | 42 |
| Supporting Files | 51 |
| Documentation | 5 |
| **Total** | **143** |
