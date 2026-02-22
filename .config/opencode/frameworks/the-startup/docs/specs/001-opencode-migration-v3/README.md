# Specification: 001-opencode-migration-v3

## Status

| Field | Value |
|-------|-------|
| **Created** | 2026-02-21 |
| **Current Phase** | COMPLETE |
| **Last Updated** | 2026-02-21 |

## Documents

| Document | Status | Notes |
|----------|--------|-------|
| product-requirements.md | skipped | Requirements clear from initial research |
| solution-design.md | completed | All ADRs approved (opus-4.5 model) |
| implementation-plan.md | completed | 7 phases, ~56 tasks |

**Status values**: `pending` | `in_progress` | `completed` | `skipped`

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-21 | Full rebuild from source | User chose to regenerate all target files from the v3.2.1 source plugin rather than incremental sync |
| 2026-02-21 | Spec location: opencode framework dir | User chose ~/.config/opencode/frameworks/the-startup/docs/specs/ as spec home |
| 2026-02-21 | PRD skipped | Requirements clear from research - migration scope well-defined |
| 2026-02-21 | Start with SDD | Solution design defines format transformation rules and conversion approach |
| 2026-02-21 | Standard research mode | Parallel fire-and-forget agents sufficient for format migration |
| 2026-02-21 | All 5 ADRs approved | Model changed to claude-opus-4-5-20250918 per user preference |
| 2026-02-21 | SDD completed | Moving to PLAN phase |
| 2026-02-21 | PLAN completed | 7 phases (0-6), ~56 tasks, 8 parallel groups |
| 2026-02-21 | Specification complete | Ready for implementation via `/start:implement 001` |

## Context

Migrate The Agentic Startup marketplace plugin (v3.2.1) from Claude Code plugin format to OpenCode framework format. Full rebuild: regenerate all agents, skills, and commands from the source plugin, converting to opencode-compliant format.

Source: `~/.claude/plugins/marketplaces/the-startup/` (Claude Code plugin, v3.2.1)
Target: `~/.config/opencode/frameworks/the-startup/` (OpenCode framework)

Key transformations:
- Agent format: name/description/model:sonnet -> description/mode/model:github-copilot/claude-opus-4.6
- Tool names: Capitalized -> lowercase
- Skill invocation: Skill(start:name) -> skill({ name: "name" })
- Structure: Identity/Constraints/Vision -> Focus Areas/Approach/Deliverables/Quality Standards
- Organization: Plugin-based (start/team) -> Flat (agent/skill/command)

---
*This file is managed by the specify-meta skill.*
