---
title: "Migrate Framework from docs/ to .start/"
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

All framework artifacts live under `.start/` — a single, predictable directory that cleanly separates the framework's working data from the user's project source code.

### Problem Statement

The "start" framework (v3.2.1) currently splits its artifacts across two directories: `.start/specs/` for new specifications and `docs/` for knowledge capture (domain rules, patterns, interfaces, research, refactor plans). This split creates three concrete problems:

1. **Discoverability**: New users must learn that specs go in `.start/` but knowledge documents go in `docs/`. The framework's own README documents both locations, creating cognitive overhead.
2. **Namespace collision**: `docs/` is a conventional project directory. Many projects use `docs/` for user-facing documentation (API docs, guides, wikis). The framework claiming this directory conflicts with its conventional purpose.
3. **Dead code**: `spec.py` contains 40+ lines of legacy fallback logic (reading from `docs/specs/`, mapping old file names like `product-requirements.md` to `requirements.md`, supporting monolithic `implementation-plan.md`). This code exists solely for backwards compatibility with a convention the framework has already moved away from.

### Value Proposition

A unified `.start/` directory makes the framework self-contained and invisible by convention (dotfiles are hidden by default). Users get a clean project root, no namespace conflicts with their own `docs/` directory, and reduced framework complexity.

## User Personas

### Primary Persona: Framework User (Developer)

- **Demographics:** Software developer using Claude Code with the "start" plugin installed. Moderate-to-high technical expertise. Works on projects that may have their own `docs/` directory.
- **Goals:** Use the framework's specify, implement, analyze, and document workflows without the framework polluting their project structure. Find framework artifacts in one predictable location.
- **Pain Points:** Confused about which directory to look in for framework output. `docs/` conflicts with project documentation. Legacy file names and structures add noise when reading framework source.

### Secondary Persona: Framework Maintainer

- **Demographics:** Contributor to the "start" framework plugin. Deep understanding of skill architecture and spec.py internals.
- **Goals:** Maintain a clean, simple codebase without legacy compatibility branches. Add new features without worrying about old directory conventions.
- **Pain Points:** Legacy fallback code in spec.py adds complexity. Dual-path logic in multiple skills increases surface area for bugs. Two naming conventions (old and new file names) create confusion in templates.

## User Journey Maps

### Primary User Journey: Developer Using Framework Workflows

1. **Awareness:** Developer runs `/specify` or `/analyze` and notices output appearing in both `.start/` and `docs/` directories. They wonder why the framework uses two locations.
2. **Consideration:** Developer checks their project's `docs/` directory and sees framework artifacts mixed with (or blocking) their own documentation.
3. **Adoption:** After migration, running `/specify`, `/analyze`, `/document`, or `/refactor` all write exclusively to `.start/`. Developer's `docs/` directory is free for project use.
4. **Usage:** All framework artifacts are found under `.start/`. Specs in `.start/specs/`, knowledge capture in `.start/docs/domain/`, `.start/docs/patterns/`, `.start/docs/interfaces/`, `.start/docs/research/`.
5. **Retention:** The single-directory convention is easy to remember and teach. No ambiguity about where to look.

### Secondary User Journey: Framework Maintainer Updating Skills

1. **Awareness:** Maintainer opens a skill's SKILL.md or template and sees references to `docs/domain/`, `docs/patterns/` etc.
2. **Consideration:** Maintainer traces the path through spec.py fallback logic, legacy file name mappings, and dual-directory scanning. Complexity adds friction to changes.
3. **Adoption:** After migration, all directory references point to `.start/`. No fallback code. One naming convention.
4. **Usage:** Adding a new skill or modifying an existing one requires understanding only `.start/` paths. Templates reference `.start/docs/` consistently.
5. **Retention:** Reduced codebase complexity means fewer bugs and faster development.

## Feature Requirements

### Must Have Features

#### Feature 1: Migrate Knowledge Capture to .start/docs/

- **User Story:** As a framework user, I want all knowledge capture documents (domain rules, patterns, interfaces, research) written to `.start/docs/` so that my project's `docs/` directory is not claimed by the framework.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the analyze skill is invoked, When it writes domain documentation, Then the output goes to `.start/docs/domain/` instead of `docs/domain/`
  - [x] Given the analyze skill is invoked, When it writes pattern documentation, Then the output goes to `.start/docs/patterns/` instead of `docs/patterns/`
  - [x] Given the analyze skill is invoked, When it writes interface documentation, Then the output goes to `.start/docs/interfaces/` instead of `docs/interfaces/`
  - [x] Given the analyze skill is invoked, When it writes research documentation, Then the output goes to `.start/docs/research/` instead of `docs/research/`
  - [x] Given the document skill is invoked, When it captures knowledge, Then output goes to the corresponding `.start/docs/` subdirectory

#### Feature 2: Migrate Refactor Documentation to .start/docs/

- **User Story:** As a framework user, I want refactoring plans saved under `.start/docs/refactor/` so that they follow the same convention as all other framework artifacts.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the refactor skill produces a documentation plan, When it saves the output, Then the file is written to `.start/docs/refactor/[NNN]-[name].md` instead of `docs/refactor/[NNN]-[name].md`

#### Feature 3: Remove Legacy docs/specs/ Fallback

- **User Story:** As a framework maintainer, I want the legacy `docs/specs/` fallback code removed from spec.py so that the codebase is simpler and has one canonical path for specs.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given spec.py is invoked, When it resolves a spec directory, Then it only checks `.start/specs/` and never falls back to `docs/specs/`
  - [x] Given spec.py scans for the next spec ID, When it counts existing specs, Then it only scans `.start/specs/`
  - [x] Given spec.py resolves a document path, When it looks up requirements or solution files, Then it only checks new naming conventions (`requirements.md`, `solution.md`, `plan/`) without legacy name fallbacks (`product-requirements.md`, `solution-design.md`, `implementation-plan.md`)
  - [x] Given the `LEGACY_SPECS_DIR` constant, When the migration is complete, Then the constant and all code referencing it are removed

#### Feature 4: Update All Skill References

- **User Story:** As a framework user, I want every skill to reference `.start/` paths consistently so that documentation and behavior match.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the analyze skill's SKILL.md, When it describes output locations, Then it references `.start/docs/` paths
  - [x] Given the analyze skill's perspectives.md, When it maps perspectives to locations, Then all paths use `.start/docs/`
  - [x] Given the document skill's knowledge-capture.md, When it provides examples, Then all example paths use `.start/docs/`
  - [x] Given the specify-solution template, When it references discovered patterns or interfaces, Then `@docs/` references become `@.start/docs/`
  - [x] Given the specify-plan template, When it references documentation, Then paths use `.start/docs/`
  - [x] Given the specify-meta SKILL.md, When it describes directory structure, Then it no longer mentions `docs/specs/` as a fallback
  - [x] Given the framework README.md, When it describes the directory structure, Then it shows `.start/` as the only location for all framework artifacts

#### Feature 5: Update Skill Write Permissions

- **User Story:** As a framework maintainer, I want skill tool permissions updated to reflect the new paths so that skills can write to `.start/docs/` and no longer need `docs/` access.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the specify skill's allowed-tools, When it lists Write and Edit permissions, Then `docs/**` is replaced with `.start/**` (or `.start/**` covers all needed paths)
  - [x] Given any skill that writes to `docs/`, When its permissions are checked, Then the permissions reference `.start/` paths

### Should Have Features

#### Feature 6: Migration Guide in Changelog

- **User Story:** As an existing framework user, I want clear migration instructions so that I can move my existing `docs/` artifacts to `.start/docs/` without losing data.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given the migration guide exists, When a user reads it, Then they understand which directories to move and where
  - [x] Given an existing project with `docs/specs/`, When the user follows the guide, Then they know to move contents to `.start/specs/` and rename legacy files

### Could Have Features

#### Feature 7: Automated Migration Script

- **User Story:** As a framework user with existing docs/ content, I want a script that moves my files from `docs/` to `.start/docs/` automatically, renaming legacy files as needed.
- **Acceptance Criteria (Gherkin Format):**
  - [x] Given a project with `docs/domain/`, `docs/patterns/`, `docs/interfaces/`, When the migration script runs, Then files are copied to `.start/docs/domain/`, `.start/docs/patterns/`, `.start/docs/interfaces/`
  - [x] Given a project with `docs/specs/[NNN]-*/`, When the migration script runs, Then specs are moved to `.start/specs/[NNN]-*/` with files renamed (`product-requirements.md` → `requirements.md`, etc.)

### Won't Have (This Phase)

- **Configurable base directory**: The `.start/` path will not be user-configurable. It is a convention, not a setting.
- **Gradual migration mode**: No dual-directory fallback during transition. This is a clean break.
- **Backwards-compatible imports**: No `@docs/` aliases or symlinks to maintain old paths.

## Detailed Feature Specifications

### Feature: Remove Legacy docs/specs/ Fallback (Most Complex)

**Description:** The spec.py script currently contains dual-directory logic that checks both `.start/specs/` and `docs/specs/` for reading, scanning, and resolving specs. All of this fallback code must be removed, leaving only `.start/specs/` as the single canonical location.

**User Flow:**
1. User invokes `/specify new-feature`
2. Framework calls spec.py to scaffold a new spec
3. spec.py creates `.start/specs/003-new-feature/` (only location)
4. User invokes `/implement 003`
5. Framework calls spec.py to resolve the spec
6. spec.py looks only in `.start/specs/003-*/` (no fallback)

**Business Rules:**
- Rule 1: All new specs are created under `.start/specs/` exclusively
- Rule 2: Spec ID scanning only considers `.start/specs/` directories
- Rule 3: Document name resolution only supports current naming (`requirements.md`, `solution.md`, `plan/`)
- Rule 4: If a spec exists only in `docs/specs/`, it will not be found — users must migrate manually

**Edge Cases:**
- Scenario 1: User has specs in `docs/specs/` but not in `.start/specs/` → Expected: Framework does not find them; user must move them. Migration guide explains this.
- Scenario 2: User has specs in both locations with overlapping IDs → Expected: Only `.start/specs/` is recognized. `docs/specs/` is invisible to the framework.
- Scenario 3: User has legacy file names in `.start/specs/` (e.g., `product-requirements.md`) → Expected: Not recognized. Only `requirements.md` is supported.

## Success Metrics

### Key Performance Indicators

- **Adoption:** 100% of framework skills reference `.start/` paths exclusively after migration
- **Engagement:** Zero user confusion reports about dual-directory behavior
- **Quality:** Zero lines of legacy fallback code remaining in spec.py; zero `docs/` path references in skill files (except possibly in migration guide)
- **Business Impact:** Reduced maintenance burden — fewer code paths to test and debug

### Tracking Requirements

| Event | Properties | Purpose |
|-------|------------|---------|
| Skill file references audited | skill_name, path_type (start vs docs) | Verify all references updated |
| spec.py lines of code | total_loc, fallback_loc | Measure code simplification |
| Legacy file name references | file, reference_type | Confirm all legacy names removed |
| User-reported directory confusion | count, description | Validate problem resolution |

---

## Constraints and Assumptions

### Constraints

- **Plugin architecture**: Changes are to framework source files in the plugin cache. The plugin version (3.2.1) determines the file locations.
- **No runtime configuration**: `.start/` is a convention, not configurable. This simplifies the implementation.
- **Breaking change**: Removing legacy fallback means existing `docs/specs/` content becomes invisible to the framework. This is intentional per user decision.

### Assumptions

- Users with existing `docs/specs/` content can manually move files to `.start/specs/` before upgrading.
- The `.start/` directory convention (dotfile prefix = hidden) is acceptable for all target platforms (macOS, Linux, Windows).
- No other plugins or tools depend on the framework writing to `docs/`.

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Existing projects lose access to docs/specs/ specs | High | Medium | Migration guide with clear instructions; "Could Have" migration script |
| Plugin cache overwrites changes on update | High | High | Changes must be made in the plugin source repo, not just the cache |
| Missed docs/ reference in a skill file | Low | Medium | Grep audit as final validation step |
| Windows path issues with .start/ | Low | Low | .start/ is a valid directory name on all major OSes |

## Open Questions

- [x] ~~Should knowledge capture nest under .start/docs/ or flatten to .start/domain/?~~ **Decision: .start/docs/**
- [x] ~~Should legacy fallback be maintained?~~ **Decision: No, clean break**
- [x] ~~What scope? Specs only or full migration?~~ **Decision: Complete cleanup**

---

## Supporting Research

### Competitive Analysis

No direct competitors for this specific migration. However, the convention of using dotfile directories (`.github/`, `.vscode/`, `.husky/`) for tool-specific artifacts is well-established across the development ecosystem. Moving to `.start/` aligns with this industry norm.

### User Research

Based on framework analysis: the current `docs/` convention conflicts with common project documentation practices. GitHub Pages, MkDocs, Docusaurus, and other documentation tools conventionally use `docs/` as their root directory. Framework users who also use these tools face a namespace conflict.

### Market Data

Dotfile directory convention is near-universal in modern development tooling. Examples: `.github/` (GitHub Actions, templates), `.vscode/` (VS Code settings), `.idea/` (JetBrains), `.husky/` (Git hooks), `.claude/` (Claude Code itself). This validates the `.start/` approach.
