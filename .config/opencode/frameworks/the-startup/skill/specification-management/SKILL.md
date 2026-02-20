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
interface SpecMetadata {
  id: String               // e.g., "004"
  name: String             // e.g., "feature-name"
  dir: String              // e.g., "docs/specs/004-feature-name"
  prd: String?             // Path to PRD if exists
  sdd: String?             // Path to SDD if exists
  plan: String?            // Path to PLAN if exists
  files: String[]          // List of existing files
}

interface SpecDocument {
  name: String
  status: "pending" | "in_progress" | "completed" | "skipped"
  notes: String?
}

interface Decision {
  date: String
  decision: String
  rationale: String
}

interface SpecState {
  id: String
  name: String
  phase: "initialization" | "prd" | "sdd" | "plan" | "implementation" | "complete"
  documents: SpecDocument[]
  decisions: Decision[]
  context: String
}
```

## Spec Workflow State Machine

```sudolang
SpecWorkflow {
  State: SpecState {
    phase: "initialization"
    documents: [
      { name: "product-requirements.md", status: "pending" },
      { name: "solution-design.md", status: "pending" },
      { name: "implementation-plan.md", status: "pending" }
    ]
    decisions: []
    context: ""
  }
  
  constraints {
    Phase transitions require user confirmation
    Skipped phases must have documented rationale
    README.md must be updated on every state change
    Cannot advance to implementation without at least SDD or PLAN
  }
  
  fn nextPhase(current: String) {
    match (current) {
      case "initialization" => "prd"
      case "prd" => "sdd"
      case "sdd" => "plan"
      case "plan" => "implementation"
      case "implementation" => "complete"
      default => current
    }
  }
  
  fn suggestContinuation(metadata: SpecMetadata) {
    match (metadata) {
      case { plan: p } if p != null => {
        message: "PLAN found. Proceed to implementation?",
        suggestedPhase: "implementation"
      }
      case { sdd: s, plan: null } if s != null => {
        message: "SDD found. Continue to PLAN?",
        suggestedPhase: "plan"
      }
      case { prd: p, sdd: null } if p != null => {
        message: "PRD found. Continue to SDD?",
        suggestedPhase: "sdd"
      }
      default => {
        message: "Start from PRD?",
        suggestedPhase: "prd"
      }
    }
  }
  
  /create name:String => {
    execute: "~/.config/opencode/skill/specification-management/spec.py '$name'"
    parse TOML output into SpecMetadata
    initialize README.md with template
    State.phase = "initialization"
    present spec directory and next steps
  }
  
  /read id:String => {
    execute: "~/.config/opencode/skill/specification-management/spec.py $id --read"
    parse TOML output into SpecMetadata
    present current state and suggestContinuation
  }
  
  /addTemplate id:String, template:String => {
    execute: "~/.config/opencode/skill/specification-management/spec.py $id --add $template"
    update State.documents status
    update README.md
  }
  
  /skip document:String, rationale:String => {
    require rationale is not empty
    State.documents.find(d => d.name == document).status = "skipped"
    State.decisions.push({
      date: today(),
      decision: "$document skipped",
      rationale: rationale
    })
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
    spec.py command executed successfully
    README.md exists in spec directory
    Current phase is correctly recorded in README.md
    All decisions have been logged with date and rationale
  }
  
  warn {
    More than 3 days since last README.md update
    Phase marked complete without document validation
    Skipping multiple consecutive phases
  }
  
  constraints {
    Never proceed without user confirmation on phase transitions
    Always update README.md before reporting completion
    Decision log must include rationale, not just action
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
  
  fn handoff(phase: String) {
    match (phase) {
      case "prd" => {
        activate: "requirements-analysis",
        context: "Continue PRD creation for spec",
        returnTo: "specification-management on completion"
      }
      case "sdd" => {
        activate: "architecture-design",
        context: "Continue SDD creation for spec",
        returnTo: "specification-management on completion"
      }
      case "plan" => {
        activate: "implementation-planning",
        context: "Continue PLAN creation for spec",
        returnTo: "specification-management on completion"
      }
      case "implementation" => {
        activate: "agent-coordination",
        context: "Execute implementation from PLAN",
        returnTo: "specification-management on completion"
      }
    }
  }
  
  constraints {
    Specification-management creates directory and README first
    User confirms phase before handoff
    Document skill activates for detailed guidance
    On completion, context returns here for phase transition
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
