# Specification: 001-sudolang-conversion

## Status

| Field             | Value          |
| ----------------- | -------------- |
| **Created**       | 2026-02-19     |
| **Current Phase** | PLAN           |
| **Last Updated**  | 2026-02-19     |

## Documents

| Document                | Status      | Notes |
| ----------------------- | ----------- | ----- |
| product-requirements.md | completed   | 9 features defined (4 must, 3 should, 2 could) |
| solution-design.md      | completed   | 7 pattern conversions, 5 ADRs approved |
| implementation-plan.md  | completed   | 5 phases, 88 files, approved |

**Status values**: `pending` | `in_progress` | `completed` | `skipped`

## Decisions Log

| Date       | Decision          | Rationale                                                   |
| ---------- | ----------------- | ----------------------------------------------------------- |
| 2026-02-19 | Start with PRD    | User chose recommended path for full conversion             |
| 2026-02-19 | Full conversion   | Convert all code-like patterns to SudoLang syntax           |
| 2026-02-19 | Hybrid approach   | ADR-1: Keep prose alongside SudoLang code blocks            |
| 2026-02-19 | Fenced blocks     | ADR-2: Wrap SudoLang in ```sudolang fences                  |
| 2026-02-19 | Preserve YAML     | ADR-3: Do not convert frontmatter to SudoLang               |
| 2026-02-19 | Pattern-selective | ADR-4: Only convert identified 7 pattern types              |
| 2026-02-19 | Backwards compat  | ADR-5: Include /generate commands for compatibility         |

## Context

**User Request:** Adjust code examples and code parts of `frameworks/the-startup/` with SudoLang syntax as defined in https://github.com/paralleldrive/sudolang/blob/main/sudolang.sudo.md

**Scope:**
- Target directory: `/Users/rolandwallner/.config/opencode/frameworks/the-startup/`
- File types: agents (8+ files), commands (10 files), skills (42+ directories)
- Conversion type: Full conversion of all code-like patterns to SudoLang

**SudoLang Key Features:**
- Interface-oriented programming with typed structures
- Natural language constraint-based programming
- Functions and function composition with `|>` operator
- `/commands` for defining chat/programmatic interfaces
- Semantic pattern matching
- Referential omnipotence (inferred functions)

---

_This file is managed by the specification-management skill._
