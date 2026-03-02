# Specification: 002-migrate-to-start-directory

## Status

| Field | Value |
|-------|-------|
| **Created** | 2026-03-01 |
| **Current Phase** | PLAN |
| **Last Updated** | 2026-03-01 |

## Documents

| Document | Status | Notes |
|----------|--------|-------|
| requirements.md | completed | Full migration scope with clean break, .start/docs/ structure |
| solution.md | completed | 4 ADRs confirmed, 12 files identified, code examples for spec.py changes |
| plan/ | completed | 3 phases, 15 tasks, 5 parallel opportunities |

**Status values**: `pending` | `in_progress` | `completed` | `skipped`

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-01 | Created specification | User wants to migrate framework directory from docs/ to .start/ |
| 2026-03-01 | Scope: Complete cleanup | Full migration + remove legacy fallback code |
| 2026-03-01 | Structure: .start/docs/ | Knowledge capture nests under .start/docs/domain/, patterns/, interfaces/, research/ |
| 2026-03-01 | Fallback: Clean break | No backwards compatibility; users migrate manually |
| 2026-03-01 | PRD completed | 5 Must Have, 1 Should Have, 1 Could Have features defined |
| 2026-03-01 | ADR-1: Modify cache directly | Immediate effect; document for upstream |
| 2026-03-01 | ADR-2: Remove template fallback | Full cleanup of both legacy fallbacks |
| 2026-03-01 | SDD completed | 12 files to modify, spec.py simplification, complete change inventory |
| 2026-03-01 | PLAN completed | 3 phases: spec.py cleanup → skill updates → validation audit |

## Context

Migrate the framework's working directory from `docs/` to `.start/`. This affects where specifications, documentation, and framework artifacts are stored and discovered.

---
*This file is managed by the specify-meta skill.*
