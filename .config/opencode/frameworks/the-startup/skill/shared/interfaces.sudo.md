# Shared SudoLang Interfaces

Reusable interface definitions for the-startup framework.

## Core Interfaces

### TaskPrompt

Used for task delegation with FOCUS/EXCLUDE pattern.

```sudolang
interface TaskPrompt {
  focus: String           // Required: What to accomplish
  deliverables: String[]  // Required: Specific outcomes
  exclude: String[]       // Required: Out of scope items
  context: String[]       // Required: Background and constraints
  output: String[]        // Required: Expected file paths
  success: String[]       // Required: Completion criteria
  termination: String[]   // Required: Stop conditions
}

TaskDelegation {
  constraints {
    FOCUS must be specific and measurable
    EXCLUDE should prevent scope creep
    OUTPUT must include exact paths when creating files
    SUCCESS criteria must be objectively verifiable
    All sections required unless explicitly optional
  }
  
  /delegate task:TaskPrompt => """
    FOCUS: $task.focus
      ${ task.deliverables |> map(d => "- $d") |> join("\n") }
    
    EXCLUDE:
      ${ task.exclude |> map(e => "- $e") |> join("\n") }
    
    CONTEXT:
      ${ task.context |> map(c => "- $c") |> join("\n") }
    
    OUTPUT:
      ${ task.output |> map(o => "- $o") |> join("\n") }
    
    SUCCESS:
      ${ task.success |> map(s => "- $s") |> join("\n") }
    
    TERMINATION:
      ${ task.termination |> map(t => "- $t") |> join("\n") }
  """
}
```

### ValidationResult

Standard result structure for validation operations.

```sudolang
interface ValidationResult {
  valid: Boolean
  findings: Finding[]
  summary: String
}

interface Finding {
  severity: "critical" | "high" | "medium" | "low" | "info"
  category: String
  message: String
  location: String?
  suggestion: String?
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
    behavior: "AI automatically fixes before proceeding"
    useCase: "Critical rules - security, correctness, architecture"
  }
  
  L2 {
    name: "Should"
    blocking: true
    autofix: false
    behavior: "Reports violation, requires human action"
    useCase: "Important rules requiring manual attention"
  }
  
  L3 {
    name: "May"
    blocking: false
    autofix: false
    behavior: "Optional improvement, can be ignored"
    useCase: "Advisory - style preferences, suggestions"
  }
  
  fn enforce(rule, violation) {
    match (rule.level) {
      case L1 => autofix(violation) |> continue
      case L2 => report(violation) |> block |> awaitHuman
      case L3 => log(violation) |> continue
    }
  }
}
```

### PhaseState

State machine for workflow phases.

```sudolang
interface PhaseState {
  current: String
  completed: String[]
  blockers: String[]
  awaiting: String?
}

PhaseWorkflow {
  State: PhaseState {
    current: "init"
    completed: []
    blockers: []
    awaiting: null
  }
  
  constraints {
    Cannot skip phases without explicit override
    User confirmation required at phase boundaries
    Blocked state requires explicit resolution
    Current phase must complete before advancing
  }
  
  /advance => {
    require current phase is complete
    completed.push(current)
    current = nextPhase(current)
  }
  
  /checkpoint message:String => {
    present phase summary to user
    awaiting = "user_confirmation"
  }
  
  /block reason:String => {
    blockers.push(reason)
    present options: [retry, skip, abort, assist]
  }
  
  /unblock => {
    require blockers is not empty
    resolution = await user decision
    blockers.pop()
  }
}
```

### ReviewVerdict

Decision logic for code review verdicts.

```sudolang
interface ReviewFindings {
  critical: Number
  high: Number
  medium: Number
  low: Number
}

fn determineVerdict(findings: ReviewFindings) {
  match (findings) {
    case { critical: c } if c > 0 => {
      verdict: "REQUEST_CHANGES",
      emoji: "RED_CIRCLE",
      action: "Address critical issues first"
    }
    case { critical: 0, high: h } if h > 3 => {
      verdict: "REQUEST_CHANGES",
      emoji: "RED_CIRCLE",
      action: "Too many high-severity issues"
    }
    case { critical: 0, high: 1..3 } => {
      verdict: "APPROVE_WITH_COMMENTS",
      emoji: "YELLOW_CIRCLE",
      action: "Address high issues before merge"
    }
    default => {
      verdict: "APPROVE",
      emoji: "GREEN_CHECK",
      action: "Ready to merge"
    }
  }
}
```

### ExecutionMode

Decision logic for parallel vs sequential task execution.

```sudolang
fn determineExecutionMode(tasks: Task[]) {
  match (tasks) {
    case tasks if hasFileDependencies(tasks) => "sequential"
    case tasks if hasDataDependencies(tasks) => "sequential"
    case tasks if allIndependent(tasks) => "parallel"
    case tasks if tasks.length == 1 => "sequential"
    default => "sequential"  // Safe default
  }
}

fn hasFileDependencies(tasks) {
  outputPaths = tasks |> flatMap(t => t.output)
  inputPaths = tasks |> flatMap(t => t.context |> extractPaths)
  outputPaths |> any(p => inputPaths.includes(p))
}

fn hasDataDependencies(tasks) {
  tasks |> any(t => t.dependsOn |> any(d => tasks.includes(d)))
}

fn allIndependent(tasks) {
  !hasFileDependencies(tasks) && !hasDataDependencies(tasks)
}
```

## Usage

Import these interfaces in skill/command files by referencing:

```
See: skill/shared/interfaces.sudo.md
```

Interfaces are interpreted by LLMs directly - no explicit import syntax required.
