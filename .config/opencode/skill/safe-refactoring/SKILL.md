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
  Constraints {
    All external behavior remains identical.
    All public APIs maintain same contracts.
    All business logic produces same results.
    All side effects occur in same order.
  }

  allowed {
    Code structure and organization.
    Internal implementation details.
    Variable and function names for clarity.
    Removal of duplication.
    Simplification of complex logic.
  }
}
```

## Refactoring Process

```sudolang
RefactoringBaseline {
  testsTotal
  testsPassing
  testsFailing
  coverage
  uncoveredAreas
  status
}

RefactoringStep {
  name
  risk
  target
}

RefactoringPlan {
  steps
  dependencies
  estimatedFiles
}

ExecutionState {
  currentStep
  totalSteps
  refactoring
  target
  status
  testsStatus
}
```

### Phase 1: Establish Baseline

Before ANY refactoring:

```sudolang
establishBaseline() {
  require {
    Run existing tests to establish passing baseline.
    Document current behavior if tests don't cover it.
    Verify test coverage and identify uncovered paths.
  }

  warn if tests are failing: "Tests failing - stop and report to user"

  emit RefactoringBaseline
}
```

### Phase 2: Identify Code Smells

Use the code smells catalog (reference.md) to identify issues:

```sudolang
CodeSmellCatalog {
  methodLevel [
    "Long Method (>20 lines, multiple responsibilities)",
    "Long Parameter List (>3-4 parameters)",
    "Duplicate Code",
    "Complex Conditionals"
  ]

  classLevel [
    "Large Class (>200 lines)",
    "Feature Envy",
    "Data Clumps",
    "Primitive Obsession"
  ]

  architectureLevel [
    "Circular Dependencies",
    "Inappropriate Intimacy",
    "Shotgun Surgery"
  ]
}
```

### Phase 3: Plan Refactoring Sequence

```sudolang
planRefactoringSequence(smells) {
  Priority order:
    "Independence - Start with isolated changes."
    "Risk - Lower risk first."
    "Impact - Building blocks before dependent changes."

  emit RefactoringPlan {
    steps: smells |> sortBy priority |> map toRefactoringStep
    dependencies: extractDependencies(smells)
    estimatedFiles: countAffectedFiles(smells)
  }
}
```

### Phase 4: Execute Refactorings

**CRITICAL**: One refactoring at a time!

```sudolang
RefactoringExecution {
  Constraints {
    Apply single change at a time.
    Run tests immediately after each change.
    Revert on failure - investigate separately.
    Never batch multiple refactorings.
  }

  executeStep(step) {
    emit ExecutionState { status: "Applying" }

    apply(step)
    runTests()

    match testResult {
      "Passing" => {
        emit ExecutionState { status: "Complete" }
        continue
      }
      "Failing" => {
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
finalValidation(baseline, changes) {
  require {
    Run complete test suite.
    Compare behavior with baseline.
    Review all changes together.
    Verify no business logic altered.
  }

  emit RefactoringComplete {
    refactoringsApplied: changes |> count
    testsStatus: "All passing"
    behaviorPreserved: true
    changesSummary: changes |> map summarize
    qualityImprovements: extractImprovements(changes)
  }
}
```

## Refactoring Catalog

See `reference.md` for complete code smells catalog with mappings to refactoring techniques.

### Quick Reference: Common Refactorings

```sudolang
selectRefactoring(smell) {
  match smell {
    "Long Method" => "Extract Method"
    "Duplicate Code" => ["Extract Method", "Pull Up Method"]
    "Long Parameter List" => "Introduce Parameter Object"
    "Complex Conditional" => ["Decompose Conditional", "Guard Clauses"]
    "Large Class" => "Extract Class"
    "Feature Envy" => "Move Method"
    _ => "Consult reference.md"
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
    Tests exist and pass.
    Baseline behavior documented.
    Single refactoring at a time.
    Tests run after EVERY change.
    No functional changes mixed with refactoring.
  }
}
```

## Agent Delegation for Refactoring

When delegating refactoring tasks, use the TaskPrompt interface:

See: skill/shared/interfaces.sudo.md

```sudolang
createRefactoringTask(refactoring, target, smell, improvement) {
  {
    focus: "Apply $refactoring to $target"
    deliverables [
      "Apply $refactoring technique",
      "Preserve all external behavior",
      "Run tests after change"
    ]
    exclude [
      "Other code changes",
      "Unrelated improvements",
      "Stay within specified scope",
      "Preserve existing feature set",
      "Maintain identical behavior"
    ]
    context [
      "Baseline tests passing",
      "Target smell: $smell",
      "Expected improvement: $improvement"
    ]
    output [
      "Refactored code",
      "Test results",
      "Summary of changes"
    ]
    success [
      "Tests still pass",
      "Smell eliminated",
      "Behavior preserved"
    ]
    termination [
      "Refactoring complete",
      "Tests fail"
    ]
  }
}
```

## Error Recovery

```sudolang
handleRefactoringFailure(refactoring, reason) {
  require {
    Stop immediately - preserve working state.
    Revert the change - restore working state.
    Investigate - why did behavior change?
  }

  emit RefactoringFailed {
    refactoring
    reason
    reverted: true
  }

  presentOptions [
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
RefactoringStatus {
  phase
  currentRefactoring
  totalRefactorings
  target
  technique
  testsStatus
  behaviorStatus
  next
}
```

## Quick Reference

### Golden Rules

```sudolang
GoldenRules {
  Constraints {
    Tests first - ensure tests pass before refactoring.
    One at a time - single refactoring per cycle.
    Test after each - verify immediately.
    Revert on failure - undo immediately, debug separately.
    Structure only - preserve all behavior.
  }
}
```

### Stop Conditions

```sudolang
shouldStop(state) {
  match state {
    { testsStatus: "Failing" } => {
      action: "revert and investigate"
      stop: true
    }
    { behaviorStatus: "Changed" } => {
      action: "revert immediately"
      stop: true
    }
    { uncoveredCode: true } => {
      action: "add tests first or skip"
      stop: true
    }
    { userRequestedStop: true } => {
      action: "stop"
      stop: true
    }
    _ => { stop: false }
  }
}
```

### Success Criteria

```sudolang
isSuccess(result) {
  require {
    All tests pass.
    Behavior identical to baseline.
    Code quality improved.
    Changes reviewed.
  }
}
```
