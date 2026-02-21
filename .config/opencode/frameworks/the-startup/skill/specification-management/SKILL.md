---
name: specification-management
description: Initialize and manage specification directories with auto-incrementing IDs. Use when creating new specs, checking spec status, tracking user decisions, or managing the docs/specs/ directory structure. Maintains README.md in each spec to record decisions (e.g., PRD skipped), context, and progress. Orchestrates the specification workflow across PRD, SDD, and PLAN phases.
license: MIT
compatibility: opencode
metadata:
  category: documentation
  version: "1.0"
---

# Specification Management Skill

You are a specification workflow orchestrator that manages specification directories and tracks user decisions throughout the PRD → SDD → PLAN workflow.

## When to Activate

Activate this skill when you need to:

- **Create a new specification** directory with auto-incrementing ID
- **Check specification status** (what documents exist)
- **Track user decisions** (e.g., "PRD skipped because requirements in JIRA")
- **Manage phase transitions** (PRD → SDD → PLAN)
- **Initialize or update README.md** in spec directories
- **Read existing spec metadata** via spec.py

## Core Interfaces

See: `skill/shared/interfaces.sudo.md` for PhaseState, PhaseWorkflow

```sudolang
SpecMetadata {
  id               e.g., "004"
  name             e.g., "feature-name"
  dir              e.g., "docs/specs/004-feature-name"
  prd              Path to PRD if exists
  sdd              Path to SDD if exists
  plan             Path to PLAN if exists
  files            List of existing files
}

SpecDocument {
  name
  status: "pending" | "in_progress" | "completed" | "skipped"
  notes
}

Decision {
  date
  decision
  rationale
}

SpecState {
  id
  name
  phase: "initialization" | "prd" | "sdd" | "plan" | "implementation" | "complete"
  documents
  decisions
  context
}
```

## Spec Workflow State Machine

```sudolang
SpecWorkflow {
  State {
    phase: "initialization"
    documents: [
      { name: "product-requirements.md", status: "pending" },
      { name: "solution-design.md", status: "pending" },
      { name: "implementation-plan.md", status: "pending" }
    ]
    decisions: []
    context: ""
  }

  Constraints {
    Phase transitions require user confirmation.
    Skipped phases must have documented rationale.
    README.md must be updated on every state change.
    Cannot advance to implementation without at least SDD or PLAN.
  }

  nextPhase(current) {
    match current {
      "initialization" => "prd"
      "prd" => "sdd"
      "sdd" => "plan"
      "plan" => "implementation"
      "implementation" => "complete"
      _ => current
    }
  }

  suggestContinuation(metadata) {
    match metadata {
      { plan: p } if p exists => {
        message: "PLAN found. Proceed to implementation?",
        suggestedPhase: "implementation"
      }
      { sdd: s, plan: null } if s exists => {
        message: "SDD found. Continue to PLAN?",
        suggestedPhase: "plan"
      }
      { prd: p, sdd: null } if p exists => {
        message: "PRD found. Continue to SDD?",
        suggestedPhase: "sdd"
      }
      _ => {
        message: "Start from PRD?",
        suggestedPhase: "prd"
      }
    }
  }

  /create name => {
    execute: "~/.config/opencode/skill/specification-management/spec.py '$name'"
    parse TOML output into SpecMetadata
    initialize README.md with template
    State.phase = "initialization"
    present spec directory and next steps
  }

  /read id => {
    execute: "~/.config/opencode/skill/specification-management/spec.py $id --read"
    parse TOML output into SpecMetadata
    present current state and suggestContinuation
  }

  /addTemplate id, template => {
    execute: "~/.config/opencode/skill/specification-management/spec.py $id --add $template"
    update State.documents status
    update README.md
  }

  /skip document, rationale => {
    require rationale is not empty
    find document in State.documents |> set status to "skipped"
    State.decisions add {
      date: today(),
      decision: "$document skipped",
      rationale: rationale
    }
    update README.md
  }

  /advance => {
    require current phase work is complete OR skipped with rationale
    State.phase = nextPhase(State.phase)
    update README.md
    present new phase and handoff to appropriate skill
  }
}
```

## Validation Requirements

```sudolang
SpecValidation {
  require {
    spec.py command executed successfully.
    README.md exists in spec directory.
    Current phase is correctly recorded in README.md.
    All decisions have been logged with date and rationale.
  }

  warn {
    More than 3 days since last README.md update.
    Phase marked complete without document validation.
    Skipping multiple consecutive phases.
  }

  Constraints {
    Never proceed without user confirmation on phase transitions.
    Always update README.md before reporting completion.
    Decision log must include rationale, not just action.
  }
}
```

## Directory Management

Use `spec.py` to create and read specification directories:

```bash
# Create new spec (auto-incrementing ID)
~/.config/opencode/skill/specification-management/spec.py "feature-name"

# Read existing spec metadata (TOML output)
~/.config/opencode/skill/specification-management/spec.py 004 --read

# Add template to existing spec
~/.config/opencode/skill/specification-management/spec.py 004 --add product-requirements
```

**TOML Output Format:**

```toml
id = "004"
name = "feature-name"
dir = "docs/specs/004-feature-name"

[spec]
prd = "docs/specs/004-feature-name/product-requirements.md"
sdd = "docs/specs/004-feature-name/solution-design.md"

files = [
  "product-requirements.md",
  "solution-design.md"
]
```

## README.md Template

Every spec directory should have a `README.md` tracking decisions and progress.

```markdown
# Specification: [NNN]-[name]

## Status

| Field             | Value          |
| ----------------- | -------------- |
| **Created**       | [date]         |
| **Current Phase** | Initialization |
| **Last Updated**  | [date]         |

## Documents

| Document                | Status  | Notes |
| ----------------------- | ------- | ----- |
| product-requirements.md | pending |       |
| solution-design.md      | pending |       |
| implementation-plan.md  | pending |       |

**Status values**: `pending` | `in_progress` | `completed` | `skipped`

## Decisions Log

| Date | Decision | Rationale |
| ---- | -------- | --------- |

## Context

[Initial context from user request]

---

_This file is managed by the specification-management skill._
```

## Workflow Integration

```sudolang
WorkflowHandoff {
  skills: [
    { phase: "prd", skill: "requirements-analysis" },
    { phase: "sdd", skill: "architecture-design" },
    { phase: "plan", skill: "implementation-planning" }
  ]

  handoff(phase) {
    match phase {
      "prd" => {
        activate: "requirements-analysis",
        context: "Continue PRD creation for spec",
        returnTo: "specification-management on completion"
      }
      "sdd" => {
        activate: "architecture-design",
        context: "Continue SDD creation for spec",
        returnTo: "specification-management on completion"
      }
      "plan" => {
        activate: "implementation-planning",
        context: "Continue PLAN creation for spec",
        returnTo: "specification-management on completion"
      }
      "implementation" => {
        activate: "agent-coordination",
        context: "Execute implementation from PLAN",
        returnTo: "specification-management on completion"
      }
    }
  }

  Constraints {
    Specification-management creates directory and README first.
    User confirms phase before handoff.
    Document skill activates for detailed guidance.
    On completion, context returns here for phase transition.
  }
}
```

## Output Format

After spec operations, report:

```
Specification: [NNN]-[name]
Directory: docs/specs/[NNN]-[name]/
Current Phase: [Phase]

Documents:
- product-requirements.md: [status]
- solution-design.md: [status]
- implementation-plan.md: [status]

Recent Decisions:
- [Decision 1]
- [Decision 2]

Next: [Suggested next step]
```
