# Specification: 001-sudolang-migration

## Status

| Field | Value |
|-------|-------|
| **Created** | 2026-02-21 |
| **Current Phase** | COMPLETED |
| **Last Updated** | 2026-02-22 |

## Documents

| Document | Status | Notes |
|----------|--------|-------|
| product-requirements.md | completed | Migration requirements for the-startup framework |
| solution-design.md | completed | SudoLang syntax mapping and conversion strategy |
| implementation-plan.md | completed | File-by-file migration sequence |

## Implementation Summary

| Phase | Component | Files | Status |
|-------|-----------|-------|--------|
| Phase 1 | Primary Agents | 2 | Completed |
| Phase 2 | Commands | 10 | Completed |
| Phase 3 | Skills | 42 | Completed |
| Phase 4 | Team Agents | 33 | Completed |
| Phase 5 | Validation | - | Completed |
| **Total** | **All** | **87** | **Completed** |

**Status values**: `pending` | `in_progress` | `completed` | `skipped`

## Overview

Migrate the `@frameworks/the-startup/` framework from Markdown-based agent/skill/command definitions to **SudoLang** format.

**Source**: `/Users/rolandolah/.config/opencode/frameworks/the-startup/`

**Target Format**: [SudoLang](https://github.com/paralleldrive/sudolang) - a pseudolanguage designed for LLM interactions

## Scope

### In Scope
- 35 agent definitions (markdown -> SudoLang interfaces)
- 42 skill definitions (SKILL.md -> .sudo format)
- 10 command definitions (markdown -> SudoLang commands)
- Templates and examples conversion
- Documentation updates

### Framework Assets
| Type | Count | Current Format | Target Format |
|------|-------|----------------|---------------|
| Agents | 35 | Markdown with YAML frontmatter | SudoLang interface |
| Skills | 42 | SKILL.md with YAML frontmatter | SudoLang interface |
| Commands | 10 | Markdown with YAML frontmatter | SudoLang /commands |
| Templates | ~10 | Markdown | SudoLang |

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-21 | Specification created | User requested migration of the-startup to SudoLang |
| 2026-02-21 | Keep .md extension | OpenCode requires .md file extension for parsing |
| 2026-02-21 | Complete cutover | No parallel format period; migrate all files at once |
| 2026-02-21 | Keep supporting files as-is | Templates, scripts, examples remain in current format |
| 2026-02-22 | ADR-1 approved: Hybrid YAML + SudoLang | Retain YAML frontmatter, SudoLang for body only |
| 2026-02-22 | ADR-2 approved: PascalCase interface names | e.g., the-chief.md → TheChief |
| 2026-02-22 | ADR-3 approved: Keep tables as Markdown | Tables readable by LLMs, no conversion needed |
| 2026-02-22 | ADR-4 approved: Manual migration | AI-assisted, no automated tooling |
| 2026-02-22 | Migration complete | All 87 files migrated to SudoLang format |

## Context

### SudoLang Key Features
- Interface-oriented programming with constraints
- Natural language constraint-based programming
- `/commands` for chat/programmatic interfaces
- Semantic pattern matching
- Referential omnipotence (LLM infers undefined functions)
- Pipe operator `|>` for function composition

### Current Framework Structure
```
the-startup/
  agent/           (35 agents in markdown)
  command/         (10 commands in markdown)
  skill/           (42 skills with SKILL.md)
  docs/
```

---
*This file is managed by the specification-management skill.*
