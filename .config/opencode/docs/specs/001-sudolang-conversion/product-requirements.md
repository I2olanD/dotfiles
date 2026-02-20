---
title: "SudoLang Syntax Conversion for the-startup Framework"
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

Transform the-startup framework's procedural markdown patterns into idiomatic SudoLang syntax, enabling LLMs to better interpret, execute, and enforce agent instructions while maintaining human readability.

### Problem Statement

The current framework (131+ markdown files) uses a mix of:
- Natural language instructions scattered across prose sections
- Decision tables requiring mental parsing by LLMs
- Procedural templates (FOCUS/EXCLUDE/CONTEXT) without formal structure
- Validation checklists that are documentation rather than executable rules
- Workflow phases described narratively without state machine semantics

**Pain Points:**
1. **Inconsistent interpretation**: LLMs must infer structure from prose, leading to variable behavior
2. **No enforcement mechanism**: Rules and constraints are advisory, not programmatically enforceable
3. **Duplicate patterns**: The same template structures (FOCUS/EXCLUDE) are copy-pasted across files
4. **Hidden decision logic**: Decision matrices embedded in tables require interpretation

**Consequences of not solving:**
- Agent behavior remains non-deterministic across sessions
- Framework maintenance requires manual consistency checking
- New patterns cannot build on existing definitions

### Value Proposition

SudoLang provides:
1. **Constraint-based programming**: Rules declared once are continuously enforced
2. **Interface definitions**: Reusable, typed structures for templates and data
3. **Pattern matching**: Clear, executable decision logic replacing tables
4. **Native LLM support**: "SudoLang is designed to be understood by LLMs without any special prompting"

Converting to SudoLang transforms documentation into executable specifications.

## User Personas

### Primary Persona: LLM Agent Runtime

- **Demographics:** AI language models (Claude, GPT-4, etc.) executing framework instructions
- **Goals:** 
  - Parse instructions unambiguously
  - Execute workflows in correct sequence
  - Enforce constraints consistently
  - Produce predictable, repeatable outputs
- **Pain Points:**
  - Ambiguous prose requires interpretation decisions
  - Decision tables need mental conversion to if/then logic
  - No formal mechanism to enforce constraints
  - Template structures vary across files

### Secondary Persona: Framework Maintainer

- **Demographics:** Developers who create, modify, and extend agent instructions
- **Goals:**
  - Write clear, effective agent instructions
  - Maintain consistency across 100+ files
  - Update rules without breaking behavior
  - Extend patterns without duplication
- **Pain Points:**
  - No validation that instructions are complete
  - Patterns drift across files over time
  - Hard to verify semantic equivalence when editing
  - Copy-paste inheritance leads to inconsistencies

### Tertiary Persona: Orchestrating Agent (Meta-Agent)

- **Demographics:** AI agents that delegate tasks to other agents
- **Goals:**
  - Generate task prompts with clear boundaries
  - Validate task completion against criteria
  - Coordinate parallel and sequential execution
  - Handle failures with structured fallback logic
- **Pain Points:**
  - FOCUS/EXCLUDE pattern is prose, not structured data
  - Success criteria are human-readable, not machine-checkable
  - Validation produces formatted strings, not typed results

## User Journey Maps

### Primary User Journey: LLM Agent Executing a Command

1. **Awareness:** Agent receives `/implement 001` command from user
2. **Consideration:** Agent reads command file (`implement.md`), parses instructions
3. **Adoption:** Agent follows workflow phases, calls skills as directed
4. **Usage:** Agent executes tasks, applies constraints, produces outputs
5. **Retention:** Agent completes workflow successfully, results match expectations

**Current friction points:**
- Phase 3 (Adoption): Prose instructions require interpretation
- Phase 4 (Usage): Constraints are advisory, not enforced
- Phase 5 (Retention): Output formats vary, validation is manual

**SudoLang improvement:**
- Phase 3: Interfaces define exact structure to follow
- Phase 4: Constraints are programmatically enforced
- Phase 5: Type-safe outputs, automated validation

### Secondary User Journey: Maintainer Adding a New Skill

1. **Awareness:** Developer needs to create skill for new capability
2. **Consideration:** Reviews existing skills for patterns and structure
3. **Adoption:** Copies similar skill, modifies for new use case
4. **Usage:** Tests skill with example invocations
5. **Retention:** Skill works, documentation is clear

**Current friction points:**
- Phase 2-3: Pattern inheritance via copy-paste introduces drift
- Phase 4: No structural validation that skill is complete
- Phase 5: Manual testing only

**SudoLang improvement:**
- Phase 2-3: Shared interfaces ensure structural consistency
- Phase 4: Type checking validates completeness
- Phase 5: Constraint checking catches missing elements

## Feature Requirements

### Must Have Features

#### Feature 1: Decision Matrix Conversion

- **User Story:** As an LLM agent, I want decision tables converted to pattern matching so that I can execute decision logic directly without mental parsing
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given a Markdown decision table with conditions and outcomes, When converted to SudoLang, Then it uses `match` expressions with guards
  - [x] Given a decision matrix input, When the SudoLang match is evaluated, Then it produces the same outcome as the original table
  - [x] Given multiple conditions in a row, When expressed in SudoLang, Then they are combined with logical operators (`&&`, `||`)
  - [x] Given a default/fallback row, When converted, Then it maps to the `default =>` case

**Target patterns:**
- Verdict decision matrix (`command/review.md:159-167`)
- Parallel vs Sequential matrix (`skill/task-delegation/SKILL.md:216-224`)
- Constitution level behaviors (`skill/constitution-validation/SKILL.md:39-52`)

#### Feature 2: Validation Checklist Conversion

- **User Story:** As an LLM agent, I want validation checklists converted to SudoLang requirements/constraints so that I can programmatically verify completeness
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given a markdown checklist with `- [ ]` items, When converted to SudoLang, Then critical items become `require` statements that throw on violation
  - [x] Given checklist items marked as "should" pass, When converted, Then they become `warn` statements that report but don't block
  - [x] Given a checklist with nested items, When converted, Then the hierarchy is preserved in constraint structure
  - [x] Given a validation checklist, When all constraints are checked, Then the system reports pass/fail for each

**Target patterns:**
- Success criteria checklists (`skill/implementation-planning/SKILL.md:18-23`)
- Validation checklists (`skill/task-delegation/SKILL.md:226-236`)
- Quality checks (`skill/architecture-design/template.md:9-28`)

#### Feature 3: Task Delegation Template Conversion

- **User Story:** As an orchestrating agent, I want the FOCUS/EXCLUDE/CONTEXT template converted to a SudoLang interface so that task delegation has enforced structure
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the 6-section FOCUS/EXCLUDE template pattern, When converted to SudoLang, Then each section becomes a typed interface property
  - [x] Given a task delegation call, When validated against the interface, Then missing required sections are flagged as errors
  - [x] Given a task prompt interface, When a `/generate` command is invoked, Then it outputs the traditional text format for backwards compatibility
  - [x] Given template instantiation, When all required fields are provided, Then validation passes

**Target patterns:**
- Base template structure (`skill/task-delegation/SKILL.md:276-302`)
- Implementation task delegation (`command/implement.md:57-92`)
- Review task delegation (`command/review.md`)

#### Feature 4: YAML Frontmatter Preservation

- **User Story:** As the system runtime, I want YAML frontmatter contracts preserved exactly so that existing tooling continues to work
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given a command file with `allowed-tools`, When converted, Then the exact key name and array format is preserved
  - [x] Given an agent file with `mode: primary`, When converted, Then the mode distinction is maintained
  - [x] Given a skill file with `metadata` section, When converted, Then all nested keys are preserved
  - [x] Given any converted file, When parsed by existing tools, Then it produces identical frontmatter output

**Target scope:**
- All 10 command files
- All 35 agent files  
- All 42 skill SKILL.md files

### Should Have Features

#### Feature 5: Workflow Phase State Machine

- **User Story:** As an LLM agent, I want workflow phases converted to state machine constraints so that phase transitions are formally defined
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given a numbered phase workflow, When converted to SudoLang, Then phases become state machine states
  - [x] Given phase transition rules, When expressed as constraints, Then invalid transitions are prevented
  - [x] Given user confirmation checkpoints, When modeled in SudoLang, Then they are explicit state boundaries

**Target patterns:**
- Implementation phases (`command/implement.md:128-182`)
- Debug phases (`command/debug.md:79-166`)
- Cycle patterns (`skill/constitution-validation/SKILL.md:66-99`)

#### Feature 6: ASCII Diagram to Mermaid Conversion

- **User Story:** As a framework reader, I want ASCII architecture diagrams converted to Mermaid so that they are interactive and consistently styled
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given an ASCII box diagram, When converted to Mermaid, Then it produces equivalent visual representation
  - [x] Given a flow diagram with arrows, When converted, Then directional relationships are preserved
  - [x] Given a complex multi-layer diagram, When converted, Then subgraph groupings match original sections

**Target patterns:**
- Architecture diagrams (`skill/architecture-selection/SKILL.md:30-56`, `78-103`)
- Scaling diagrams (`skill/architecture-selection/SKILL.md:343-358`)

#### Feature 7: Shared Interface Library

- **User Story:** As a framework maintainer, I want common patterns extracted to shared interfaces so that consistency is enforced across files
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the FOCUS/EXCLUDE template used in 27+ places, When extracted to a shared interface, Then all usages reference the same definition
  - [x] Given a shared interface update, When propagated, Then all consuming files benefit automatically
  - [x] Given skill frontmatter patterns, When standardized to an interface, Then validation catches non-compliant files

### Could Have Features

#### Feature 8: Bidirectional Conversion Tooling

- **User Story:** As a maintainer, I want tools to convert between prose and SudoLang so that I can work in my preferred format
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given a SudoLang interface definition, When export is requested, Then readable prose documentation is generated
  - [x] Given prose constraints, When import is requested, Then equivalent SudoLang is suggested

#### Feature 9: Incremental Migration Mode

- **User Story:** As a team, I want to convert files incrementally so that we don't have to do a big-bang migration
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given one converted file and one original file, When both are used together, Then the system operates correctly
  - [x] Given a partially converted skill, When invoked, Then both SudoLang and prose sections are interpreted

### Won't Have (This Phase)

- **Full test automation**: Semantic equivalence testing is out of scope for this specification
- **Editor tooling**: Syntax highlighting, linting plugins are deferred
- **Runtime interpreter**: No execution engine for SudoLang; LLMs interpret directly
- **Backwards compatibility layer**: Files will be converted in-place, not maintaining dual formats
- **Training materials**: SudoLang documentation/tutorials for maintainers is separate work

## Detailed Feature Specifications

### Feature: Task Delegation Template (FOCUS/EXCLUDE)

**Description:** Convert the prose-based task delegation template to a SudoLang interface with validation constraints.

**User Flow:**
1. Orchestrator identifies task to delegate
2. Orchestrator instantiates TaskPrompt interface with required fields
3. System validates all required fields are present
4. `/generate` command outputs traditional text format
5. Subagent receives and executes task

**Business Rules:**
- Rule 1: FOCUS field is required and must be specific/actionable
- Rule 2: EXCLUDE field is required to prevent scope creep
- Rule 3: OUTPUT field must include exact file paths when creating files
- Rule 4: SUCCESS criteria must be objectively verifiable
- Rule 5: All six sections (FOCUS, EXCLUDE, CONTEXT, OUTPUT, SUCCESS, TERMINATION) must be present

**Edge Cases:**
- Scenario 1: Optional sections are empty → Expected: Validation passes with warning
- Scenario 2: File paths in OUTPUT don't exist → Expected: Flag as advisory, not error
- Scenario 3: Nested templates (template defining templates) → Expected: Use SudoLang template syntax with escaping

## Success Metrics

### Key Performance Indicators

- **Adoption:** 100% of decision matrices converted to pattern matching within framework
- **Engagement:** All 131 framework files reviewed, 80%+ converted to SudoLang patterns
- **Quality:** Zero semantic drift in converted decision logic (same inputs produce same outputs)
- **Business Impact:** Reduced LLM interpretation variance (measurable via A/B testing agent behavior)

### Tracking Requirements

| Event | Properties | Purpose |
|-------|------------|---------|
| File converted | file_path, patterns_converted, line_count | Track conversion progress |
| Decision matrix tested | original_output, sudolang_output, match | Verify semantic equivalence |
| Constraint violation | file_path, constraint_id, severity | Monitor enforcement effectiveness |
| Validation check | checklist_id, pass_count, fail_count | Track completeness adoption |

---

## Constraints and Assumptions

### Constraints

- **Markdown compatibility required**: Converted files must remain valid Markdown (SudoLang in fenced code blocks)
- **YAML frontmatter contracts**: Exact key names must be preserved for system compatibility
- **File organization**: Directory structure (`agent/`, `command/`, `skill/`) must be maintained
- **Naming conventions**: Kebab-case for skill/agent references must be preserved

### Assumptions

- LLMs can interpret SudoLang without explicit specification (per SudoLang design goals)
- Existing tooling (spec.py) will continue to work with converted files
- Maintainers will accept a learning curve for SudoLang syntax
- Hybrid files (SudoLang + prose) are acceptable during transition

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Semantic drift in conversion | High | Medium | Create test harness comparing original vs converted outputs |
| Maintainer resistance to new syntax | Medium | Medium | Provide examples, document patterns, support hybrid approach |
| Tooling breaks with SudoLang | High | Low | Preserve exact frontmatter format, test with existing tools |
| Over-formalization reduces flexibility | Medium | Medium | Keep prose for narrative sections, formalize only decision logic |
| Edge cases not handled | Medium | Medium | Create explicit edge case catalog with conversion rules |

## Open Questions

- [x] Which files should be converted first? (Recommended: orchestration layer - commands, then skills, then agents)
- [x] Should prose descriptions remain alongside SudoLang for human readers? (Recommended: Yes, hybrid approach)
- [ ] What is acceptable semantic drift tolerance? (Need to define threshold)
- [ ] Who validates semantic equivalence for each file? (Need to assign ownership)

---

## Supporting Research

### Competitive Analysis

SudoLang is the only pseudolanguage specifically designed for LLM interaction. Alternatives:
- **Plain prose**: Current approach, works but inconsistent
- **YAML/JSON configs**: Too rigid, lose natural language expressiveness
- **Domain-specific languages**: Require parsers, not LLM-native

### User Research

Based on framework analysis:
- 27 `skill()` calls across commands indicate heavy skill reuse
- 35 agents all reference common skills (pattern indicates opportunity for shared interfaces)
- FOCUS/EXCLUDE pattern appears 27+ times (prime candidate for interface extraction)

### Market Data

SudoLang adoption is nascent but growing. Key advantages for this use case:
- Native Markdown compatibility
- No runtime required (LLM interprets directly)
- Constraint-based programming aligns with agent instruction patterns
