---
name: implementation-planning
description: Create and validate implementation plans (PLAN). Use when planning implementation phases, defining tasks, sequencing work, analyzing dependencies, or working on implementation-plan.md files in docs/specs/. Includes TDD phase structure and specification compliance gates.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Implementation Plan Skill

Creates actionable implementation plans that break features into executable tasks following TDD principles. Plans enable developers to work independently without requiring clarification.

## Success Criteria

A plan is complete when:

- [ ] A developer can follow it independently without additional context
- [ ] Every task produces a verifiable deliverable (not just an activity)
- [ ] All PRD acceptance criteria map to specific tasks
- [ ] All SDD components have corresponding implementation tasks
- [ ] Dependencies are explicit and no circular dependencies exist

## When to Activate

Activate when:

- **Create a new PLAN** from the template
- **Complete phases** in an existing implementation-plan.md
- **Define task sequences** and dependencies
- **Plan TDD cycles** (Prime → Test → Implement → Validate)
- **Work on any `implementation-plan.md`** file in docs/specs/

## Template

The PLAN template is at [template.md](template.md). Use this structure exactly.

**To write template to spec directory:**

1. Read the template: `~/.config/opencode/skill/implementation-plan/template.md`
2. Write to spec directory: `docs/specs/[NNN]-[name]/implementation-plan.md`

## PLAN Focus Areas

Your plan MUST answer these questions:

- **WHAT** produces value? (deliverables, not activities)
- **IN WHAT ORDER** do tasks execute? (dependencies and sequencing)
- **HOW TO VALIDATE** correctness? (test-first approach)
- **WHERE** is each task specified? (links to PRD/SDD sections)

Keep plans **actionable and focused**:

- Use task descriptions, sequence, and validation criteria
- Omit time estimates—focus on what, not when
- Omit resource assignments—focus on work, not who
- Omit implementation code—the plan guides, implementation follows

## Task Granularity

```sudolang
TaskGranularity {
  Constraints {
    Track logical units that produce verifiable outcomes.
    TDD cycle is the execution method, not separate tracked items.
    Each task must produce a testable deliverable.
  }

  isValidTask(description) {
    match description {
      Good: produces an artifact => true
      Good: has a verifiable result => true
      Bad: is preparation only => false
      Bad: is a single test case => false
      Bad: is a validation step only => false
      _ => false
    }
  }

  examples {
    good: [
      "Payment Entity"         Produces: working entity with tests
      "Stripe Adapter"         Produces: working integration with tests
      "Payment Form Component" Produces: working UI with tests
    ]
    bad: [
      "Read payment interface contracts"        Preparation, not deliverable
      "Test Payment.validate() rejects amounts" Part of larger outcome
      "Run linting"                             Validation step only
    ]
  }
}
```

### Task Structure Pattern

```markdown
- [ ] **T1.1 Payment Entity** `[activity: domain-modeling]`

  **Prime**: Read payment interface contracts `[ref: SDD/Section 4.2; lines: 145-200]`

  **Test**: Entity validation rejects negative amounts; supports currency conversion; handles refunds

  **Implement**: Create `src/domain/Payment.ts` with validation logic

  **Validate**: Run unit tests, lint, typecheck
```

The checkbox tracks "Payment Entity" as a unit. Prime/Test/Implement/Validate are embedded guidance.

## TDD Phase State Machine

```sudolang
TDDPhase {
  name: "prime" | "test" | "implement" | "validate"
  description
  artifacts
}

TDDStateMachine {
  State {
    current
    taskId
    completed
  }

  Constraints {
    Must follow sequence: prime, then test, then implement, then validate.
    Cannot skip phases without explicit deviation approval.
    Each phase must produce artifacts before advancing.
    Validate phase must pass before task completion.
  }

  phases {
    prime {
      name: "Prime Context"
      artifacts: ["specification understanding", "interface contracts", "patterns loaded"]
      actions: [
        "Read relevant specification sections"
        "Understand interfaces and contracts"
        "Load patterns and examples"
      ]
    }

    test {
      name: "Write Tests (Red)"
      artifacts: ["failing tests", "test coverage plan"]
      actions: [
        "Test behavior before implementation"
        "Reference PRD acceptance criteria"
        "Cover happy path and edge cases"
      ]
    }

    implement {
      name: "Implement (Green)"
      artifacts: ["passing code", "SDD-compliant structure"]
      actions: [
        "Build to pass tests"
        "Follow SDD architecture"
        "Use discovered patterns"
      ]
    }

    validate {
      name: "Validate (Refactor)"
      artifacts: ["test results", "quality checks", "compliance verification"]
      actions: [
        "Run automated tests"
        "Check code quality (lint, format)"
        "Verify specification compliance"
      ]
    }
  }

  /advance => {
    require current phase artifacts exist
    current |> nextPhase
  }

  /completeTask => {
    require current == "validate"
    require all validation checks pass
    emit "task_complete"
  }
}
```

## Task Metadata

```sudolang
TaskMetadata {
  parallel     Can run concurrently with other tasks
  component    For multi-component features
  ref          Links to specifications
  activity     Hint for specialist selection
}

SpecReference {
  document: "PRD" | "SDD"
  section
  lines
}

ActivityType = "domain-modeling" | "backend-api" | "frontend-ui" |
               "integration" | "e2e-testing" | "validate" | "infrastructure"

formatTaskLine(id, description, meta) {
  base = "- [ ] $id $description"
  annotations = []

  if meta.ref => annotations add "[ref: $meta.ref.document/$meta.ref.section; lines: $meta.ref.lines]"
  if meta.activity => annotations add "[activity: $meta.activity]"
  if meta.parallel => annotations add "[parallel: true]"
  if meta.component => annotations add "[component: $meta.component]"

  "$base `${annotations |> join(' ')}`"
}
```

## Planning Cycle Workflow

```sudolang
PlanningCycle {
  State {
    current: "discovery"
    completed
    blockers
    awaiting
  }

  Constraints {
    User confirmation required at phase boundaries.
    Cannot skip phases without explicit override.
    Each cycle must trace tasks to specifications.
  }

  phases {
    discovery {
      actions: [
        "Read PRD and SDD to understand requirements and design"
        "Identify activities needed for each implementation area"
        "Launch parallel specialist agents to investigate"
      ]
      specialists: [
        "Task sequencing and dependencies"
        "Testing strategies"
        "Risk assessment"
        "Validation approaches"
      ]
    }

    documentation {
      actions: [
        "Update the PLAN with task definitions"
        "Add specification references [ref: ...]"
        "Focus only on current phase being defined"
        "Follow template structure exactly"
      ]
    }

    review {
      actions: [
        "Present task breakdown to user"
        "Show dependencies and sequencing"
        "Highlight parallel opportunities"
        "Wait for user confirmation before next phase"
      ]
    }
  }

  /selfCheck => {
    require "Have I read the relevant PRD and SDD sections?"
    require "Do all tasks trace back to specification requirements?"
    require "Are dependencies between tasks clear?"
    require "Can parallel tasks actually run in parallel?"
    require "Are validation steps included in each phase?"
    require "Have I received user confirmation?"
  }
}
```

## Specification Compliance

```sudolang
SpecificationCompliance {
  Constraints {
    Every phase must include a validation task.
    All tasks must trace to PRD or SDD.
    Deviations require explicit approval.
  }

  validationTask(phaseId) => """
    - [ ] **T$phaseId.N Phase Validation** `[activity: validate]`

      Run all phase tests, linting, type checking.
      Verify against SDD patterns and PRD acceptance criteria.
  """

  DeviationProtocol {
    steps: [
      "Document the deviation with clear rationale"
      "Obtain approval before proceeding"
      "Update SDD when the deviation improves the design"
      "Record all deviations in the plan for traceability"
    ]

    /handleDeviation reason => {
      document(reason)
      approval = await user confirmation
      if approved => updateSDD()
      recordInPlan(reason, approval)
    }
  }
}
```

## Validation Checklist

See [validation.md](validation.md) for the complete checklist.

```sudolang
PLANValidation {
  require {
    All specification file paths are correct and exist.
    Context priming section is complete.

    All implementation phases are defined.
    Each phase follows TDD: Prime, Test, Implement, Validate.
    Dependencies between phases are clear with no circular dependencies.

    Parallel work is properly tagged with [parallel: true].
    Activity hints provided for specialist selection [activity: type].
    Every phase references relevant SDD sections.
    Every test references PRD acceptance criteria.

    Integration and E2E tests defined in final phase.
    Project commands match actual project setup.
  }

  warn {
    Phases without parallel task opportunities.
    Missing edge case coverage in test definitions.
    Large phases that could be decomposed further.
  }

  require "A developer could follow this plan independently."
}
```

## Output Format

After PLAN work, report:

```
PLAN Status: [spec-id]-[name]

Phases Defined:
- Phase 1 [Name]: Complete (X tasks)
- Phase 2 [Name]: In progress
- Phase 3 [Name]: Pending

Task Summary:
- Total tasks: [N]
- Parallel groups: [N]
- Dependencies: [List key dependencies]

Specification Coverage:
- PRD requirements mapped: [X/Y]
- SDD components covered: [X/Y]

Next Steps:
- [What needs to happen next]
```

## Examples

See [examples/phase-examples.md](examples/phase-examples.md) for reference.
