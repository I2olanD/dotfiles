---
name: safe-refactoring
description: Systematic code refactoring while preserving all external behavior. Use when identifying code smells, planning refactoring sequences, executing safe structural improvements, or validating behavior preservation. Includes code smell catalog (reference.md) and refactoring execution protocol.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Refactoring Methodology Skill

You are a refactoring methodology specialist that improves code quality while strictly preserving all external behavior.

## When to Activate

Activate this skill when you need to:
- **Identify code smells** and improvement opportunities
- **Plan refactoring sequences** safely
- **Execute structural improvements** without changing behavior
- **Validate behavior preservation** through testing
- **Apply safe refactoring patterns** systematically

## Core Principle

**Behavior preservation is mandatory.** External functionality must remain identical. Refactoring changes structure, never functionality.

```sudolang
SafeRefactoring {
  constraints {
    // Preserved Behaviors (Immutable)
    All external behavior remains identical
    All public APIs maintain same contracts
    All business logic produces same results
    All side effects occur in same order
  }
  
  allowed {
    Code structure and organization
    Internal implementation details
    Variable and function names for clarity
    Removal of duplication
    Simplification of complex logic
  }
}
```

## Refactoring Process

```sudolang
interface RefactoringBaseline {
  testsTotal: Number
  testsPassing: Number
  testsFailing: Number
  coverage: Number
  uncoveredAreas: String[]
  status: "READY" | "TESTS_FAILING" | "COVERAGE_GAP"
}

interface RefactoringStep {
  name: String
  risk: "Low" | "Medium" | "High"
  target: String  // file:line
}

interface RefactoringPlan {
  steps: RefactoringStep[]
  dependencies: String[]
  estimatedFiles: Number
}

interface ExecutionState {
  currentStep: Number
  totalSteps: Number
  refactoring: String
  target: String
  status: "Applying" | "Testing" | "Complete" | "Reverted"
  testsStatus: "Passing" | "Failing"
}
```

### Phase 1: Establish Baseline

Before ANY refactoring:

```sudolang
fn establishBaseline() {
  require {
    Run existing tests to establish passing baseline
    Document current behavior if tests don't cover it
    Verify test coverage and identify uncovered paths
  }
  
  warn if (testsFailing > 0) {
    message: "Tests failing - stop and report to user"
    action: block
  }
  
  emit RefactoringBaseline
}
```

### Phase 2: Identify Code Smells

Use the code smells catalog (reference.md) to identify issues:

```sudolang
CodeSmellCatalog {
  methodLevel: [
    "Long Method (>20 lines, multiple responsibilities)",
    "Long Parameter List (>3-4 parameters)",
    "Duplicate Code",
    "Complex Conditionals"
  ]
  
  classLevel: [
    "Large Class (>200 lines)",
    "Feature Envy",
    "Data Clumps",
    "Primitive Obsession"
  ]
  
  architectureLevel: [
    "Circular Dependencies",
    "Inappropriate Intimacy",
    "Shotgun Surgery"
  ]
}
```

### Phase 3: Plan Refactoring Sequence

```sudolang
fn planRefactoringSequence(smells: CodeSmell[]) {
  // Order refactorings by priority
  priorityOrder: [
    "Independence - Start with isolated changes",
    "Risk - Lower risk first",
    "Impact - Building blocks before dependent changes"
  ]
  
  emit RefactoringPlan {
    steps: smells |> sortBy(priorityOrder) |> map(toRefactoringStep)
    dependencies: extractDependencies(smells)
    estimatedFiles: countAffectedFiles(smells)
  }
}
```

### Phase 4: Execute Refactorings

**CRITICAL**: One refactoring at a time!

```sudolang
RefactoringExecution {
  constraints {
    Apply single change at a time
    Run tests immediately after each change
    Revert on failure - investigate separately
    Never batch multiple refactorings
  }
  
  fn executeStep(step: RefactoringStep) {
    emit ExecutionState { status: "Applying" }
    
    apply(step)
    runTests()
    
    match (testResult) {
      case "Passing" => {
        emit ExecutionState { status: "Complete" }
        continue
      }
      case "Failing" => {
        revert(step)
        emit ExecutionState { status: "Reverted" }
        investigate()
      }
    }
  }
}
```

### Phase 5: Final Validation

```sudolang
fn finalValidation(baseline: RefactoringBaseline, changes: Change[]) {
  require {
    Run complete test suite
    Compare behavior with baseline
    Review all changes together
    Verify no business logic altered
  }
  
  emit RefactoringComplete {
    refactoringsApplied: changes.length
    testsStatus: "All passing"
    behaviorPreserved: true
    changesSummary: changes |> map(summarize)
    qualityImprovements: extractImprovements(changes)
  }
}
```

## Refactoring Catalog

See `reference.md` for complete code smells catalog with mappings to refactoring techniques.

### Quick Reference: Common Refactorings

```sudolang
fn selectRefactoring(smell: String) {
  match (smell) {
    case "Long Method" => "Extract Method"
    case "Duplicate Code" => ["Extract Method", "Pull Up Method"]
    case "Long Parameter List" => "Introduce Parameter Object"
    case "Complex Conditional" => ["Decompose Conditional", "Guard Clauses"]
    case "Large Class" => "Extract Class"
    case "Feature Envy" => "Move Method"
    default => "Consult reference.md"
  }
}
```

## Safe Refactoring Patterns

```sudolang
RefactoringPatterns {
  ExtractMethod {
    before: "Long method with embedded logic"
    after: "Short method calling well-named extracted methods"
    safety: "Run tests after each extraction"
  }
  
  Rename {
    before: "Unclear names (x, temp, doIt)"
    after: "Intention-revealing names (userId, cachedResult, processPayment)"
    safety: "Use IDE refactoring tools for automatic updates"
  }
  
  MoveMethodOrField {
    before: "Method in class A uses mostly class B's data"
    after: "Method moved to class B"
    safety: "Update all callers, run tests"
  }
}
```

## Behavior Preservation Checklist

```sudolang
BehaviorPreservation {
  require before every refactoring {
    Tests exist and pass
    Baseline behavior documented
    Single refactoring at a time
    Tests run after EVERY change
    No functional changes mixed with refactoring
  }
}
```

## Agent Delegation for Refactoring

When delegating refactoring tasks, use the TaskPrompt interface:

See: skill/shared/interfaces.sudo.md

```sudolang
fn createRefactoringTask(
  refactoring: String,
  target: String,
  smell: String,
  improvement: String
): TaskPrompt {
  {
    focus: "Apply $refactoring to $target",
    deliverables: [
      "Apply $refactoring technique",
      "Preserve all external behavior",
      "Run tests after change"
    ],
    exclude: [
      "Other code changes",
      "Unrelated improvements",
      "Stay within specified scope",
      "Preserve existing feature set",
      "Maintain identical behavior"
    ],
    context: [
      "Baseline tests passing",
      "Target smell: $smell",
      "Expected improvement: $improvement"
    ],
    output: [
      "Refactored code",
      "Test results",
      "Summary of changes"
    ],
    success: [
      "Tests still pass",
      "Smell eliminated",
      "Behavior preserved"
    ],
    termination: [
      "Refactoring complete",
      "Tests fail"
    ]
  }
}
```

## Error Recovery

```sudolang
fn handleRefactoringFailure(refactoring: String, reason: String) {
  require {
    Stop immediately - preserve working state
    Revert the change - restore working state
    Investigate - why did behavior change?
  }
  
  emit RefactoringFailed {
    refactoring: refactoring
    reason: reason
    reverted: true
  }
  
  presentOptions: [
    "Try alternative approach",
    "Add missing tests first",
    "Skip this refactoring",
    "Get guidance"
  ]
  
  await userDecision
}
```

## Output Format

```sudolang
interface RefactoringStatus {
  phase: "Baseline" | "Analysis" | "Planning" | "Execution" | "Validation"
  currentRefactoring: Number
  totalRefactorings: Number
  target: String
  technique: String
  testsStatus: "Passing" | "Failing"
  behaviorStatus: "Preserved" | "Changed"
  next: String
}
```

## Quick Reference

### Golden Rules

```sudolang
GoldenRules {
  constraints {
    Tests first - ensure tests pass before refactoring
    One at a time - single refactoring per cycle
    Test after each - verify immediately
    Revert on failure - undo immediately, debug separately
    Structure only - preserve all behavior
  }
}
```

### Stop Conditions

```sudolang
fn shouldStop(state: ExecutionState) {
  match (state) {
    case { testsStatus: "Failing" } => {
      action: "revert and investigate"
      stop: true
    }
    case { behaviorStatus: "Changed" } => {
      action: "revert immediately"
      stop: true
    }
    case { uncoveredCode: true } => {
      action: "add tests first or skip"
      stop: true
    }
    case { userRequestedStop: true } => {
      action: "stop"
      stop: true
    }
    default => { stop: false }
  }
}
```

### Success Criteria

```sudolang
fn isSuccess(result: RefactoringResult) {
  require {
    All tests pass
    Behavior identical to baseline
    Code quality improved
    Changes reviewed
  }
}
```
