# Shared SudoLang Interfaces

Reusable interface definitions for the-startup framework.

## Core Interfaces

### TaskPrompt

Used for task delegation with FOCUS/EXCLUDE pattern.

```sudolang
TaskPrompt {
  focus         // What to accomplish
  deliverables  // Specific outcomes
  exclude       // Out of scope items
  context       // Background and constraints
  output        // Expected file paths
  success       // Completion criteria
  termination   // Stop conditions

  Constraints {
    focus must be specific and measurable.
    exclude should prevent scope creep.
    output must include exact paths when creating files.
    success criteria must be objectively verifiable.
    All sections required unless explicitly optional.
  }

  /delegate task => """
    FOCUS: $task.focus
      ${ task.deliverables |> formatList }

    EXCLUDE:
      ${ task.exclude |> formatList }

    CONTEXT:
      ${ task.context |> formatList }

    OUTPUT:
      ${ task.output |> formatList }

    SUCCESS:
      ${ task.success |> formatList }

    TERMINATION:
      ${ task.termination |> formatList }
  """
}
```

### ValidationResult

Standard result structure for validation operations.

```sudolang
ValidationResult {
  valid
  findings
  summary
}

Finding {
  severity: "critical" | "high" | "medium" | "low" | "info"
  category
  message
  location   // file:line format, optional
  suggestion // optional
}
```

### ConstitutionLevel

Enforcement levels for constitution rules (L1/L2/L3).

```sudolang
ConstitutionLevel {
  L1 {
    name: "Must"
    blocking: true
    autofix: true
    // AI automatically fixes before proceeding
    // Use for: security, correctness, architecture
  }

  L2 {
    name: "Should"
    blocking: true
    autofix: false
    // Reports violation, requires human action
    // Use for: important rules requiring manual attention
  }

  L3 {
    name: "May"
    blocking: false
    autofix: false
    // Optional improvement, can be ignored
    // Use for: style preferences, suggestions
  }

  enforce(rule, violation) {
    match rule.level {
      L1 => autofix(violation) |> continue
      L2 => report(violation) |> block |> awaitHuman
      L3 => log(violation) |> continue
    }
  }
}
```

### PhaseState

State machine for workflow phases.

```sudolang
PhaseState {
  current: "init"
  completed: []
  blockers: []
  awaiting   // null until waiting on user

  Constraints {
    Cannot skip phases without explicit override.
    User confirmation required at phase boundaries.
    Blocked state requires explicit resolution.
    Current phase must complete before advancing.
  }

  /advance => {
    require current phase is complete
    completed += current
    current = nextPhase(current)
  }

  /checkpoint message => {
    present phase summary to user
    awaiting = "user_confirmation"
  }

  /block reason => {
    blockers += reason
    present options: [retry, skip, abort, assist]
  }

  /unblock => {
    require blockers is not empty
    resolution = await user decision
    remove resolved blocker
  }
}
```

### ReviewVerdict

Decision logic for code review verdicts.

```sudolang
ReviewFindings {
  critical: 0
  high: 0
  medium: 0
  low: 0
}

determineVerdict(findings) {
  match findings {
    critical > 0 =>
      verdict: "REQUEST_CHANGES"
      action: "Address critical issues first"

    critical == 0, high > 3 =>
      verdict: "REQUEST_CHANGES"
      action: "Too many high-severity issues"

    critical == 0, high 1..3 =>
      verdict: "APPROVE_WITH_COMMENTS"
      action: "Address high issues before merge"

    default =>
      verdict: "APPROVE"
      action: "Ready to merge"
  }
}
```

### ExecutionMode

Decision logic for parallel vs sequential task execution.

```sudolang
determineExecutionMode(tasks) {
  match tasks {
    (tasks have file dependencies) => "sequential"
    (tasks have data dependencies) => "sequential"
    (all tasks are independent) => "parallel"
    (single task) => "sequential"
    default => "sequential"  // Safe default
  }
}

Constraints {
  File dependencies exist when one task's output overlaps another's input paths.
  Data dependencies exist when any task depends on another task's result.
  Tasks are independent when neither file nor data dependencies exist.
}
```

## Usage

Import these interfaces in skill/command files by referencing:

```
See: skill/shared/interfaces.sudo.md
```

Interfaces are interpreted by LLMs directly - no explicit import syntax required.
