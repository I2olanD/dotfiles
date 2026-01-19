# Specification: 001-centralized-keymaps

## Status

| Field | Value |
|-------|-------|
| **Created** | 2026-01-06 |
| **Current Phase** | Implementation Complete |
| **Last Updated** | 2026-01-06 |

## Documents

| Document | Status | Notes |
|----------|--------|-------|
| product-requirements.md | skipped | Straightforward refactoring task |
| solution-design.md | skipped | Design embedded in implementation plan |
| implementation-plan.md | completed | Ready for implementation |

**Status values**: `pending` | `in_progress` | `completed` | `skipped`

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-01-06 | PRD skipped | Straightforward refactoring - goal is clear |
| 2026-01-06 | SDD skipped | Design decisions embedded in implementation plan |
| 2026-01-06 | Keep cmp keymaps local | Insert-mode keymaps tightly coupled to cmp API |
| 2026-01-06 | Keep oil buffer keymaps local | q/Esc only apply within Oil buffers |
| 2026-01-06 | Fix LSP gd bug | Duplicate mapping will be split to gd/gD |

## Context

Move all keymaps from scattered plugin files to a single centralized file for easier management and discovery.

**Current state identified:**
- Core keymaps in `lua/mappings.lua`
- Plugin keymaps scattered across 10+ files in `lua/plugins/`
- Leader key: Space
- Plugins with keymaps: LSP, FZF, Oil, Trouble, Formatter, Bufferline, Windows, Visual-multi, Which-key, CMP

---
*This file is managed by the specification-management skill.*
