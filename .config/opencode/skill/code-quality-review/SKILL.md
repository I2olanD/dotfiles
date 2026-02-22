---
name: code-quality-review
description: Systematic code review patterns, quality dimensions, anti-pattern detection, and constructive feedback techniques. Use when reviewing code changes, assessing codebase quality, identifying technical debt, or mentoring through reviews. Covers correctness, design, security, performance, and maintainability.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Code Quality Review Methodology

Systematic patterns for reviewing code and providing constructive, actionable feedback that improves both code quality and developer skills.

## When to Activate

- Reviewing pull requests or merge requests
- Assessing overall codebase quality
- Identifying and prioritizing technical debt
- Mentoring developers through code review
- Establishing code review standards for teams
- Auditing code for security or compliance

## Review Dimensions

Every code review should evaluate these six dimensions:

```sudolang
ReviewDimensions {
  dimensions [
    "correctness",
    "design",
    "readability",
    "security",
    "performance",
    "testability"
  ]

  Constraints {
    All six dimensions must be evaluated.
    Findings must include dimension category.
    Critical issues block approval regardless of dimension.
  }
}
```

### 1. Correctness

Does the code work as intended?

```sudolang
CorrectnessReview {
  require {
    Solves the stated problem.
    Boundary conditions handled.
    Failures gracefully managed.
    Inputs validated at boundaries.
    Null/undefined cases covered.
  }
}
```

### 2. Design

Is the code well-structured?

```sudolang
DesignReview {
  require {
    Each function/class does one thing.
    Complexity hidden appropriately.
    Dependencies minimized.
    Related things stay together.
    Can be modified without major changes.
  }
}
```

### 3. Readability

Can others understand this code?

```sudolang
ReadabilityReview {
  require {
    Names reveal intent.
    The "why" explained, not the "what".
    Style consistent.
    Cyclomatic complexity reasonable (<10).
    Control flow straightforward.
  }
}
```

### 4. Security

Is the code secure?

```sudolang
SecurityReview {
  require {
    All inputs sanitized.
    Auth checks present where needed.
    Permissions verified.
    Sensitive data protected.
    No known vulnerabilities in dependencies.
  }
}
```

### 5. Performance

Is the code efficient?

```sudolang
PerformanceReview {
  require {
    Time complexity appropriate.
    Allocations reasonable.
    Database/network calls optimized.
    Caching used where beneficial.
    Race conditions avoided.
  }
}
```

### 6. Testability

Can this code be tested?

```sudolang
TestabilityReview {
  require {
    Critical paths tested.
    Tests verify behavior, not implementation.
    External dependencies mockable.
    Tests reliable and repeatable.
    Boundary conditions tested.
  }
}
```

## Anti-Pattern Catalog

Common code smells and their remediation:

### Method-Level Anti-Patterns

```sudolang
detectMethodAntiPattern(code) {
  match code {
    { lines: n } if n > 20 => {
      pattern: "Long Method"
      signs: "Multiple responsibilities"
      remediation: "Extract Method"
    }
    { paramCount: n } if n > 4 => {
      pattern: "Long Parameter List"
      signs: ">3-4 parameters"
      remediation: "Introduce Parameter Object"
    }
    { hasCopyPaste: true } => {
      pattern: "Duplicate Code"
      signs: "Copy-paste patterns"
      remediation: "Extract Method, Template Method"
    }
    { nestedConditions: n } if n > 2 => {
      pattern: "Complex Conditionals"
      signs: "Nested if/else, switch statements"
      remediation: "Decompose Conditional, Strategy Pattern"
    }
    { hasMagicNumbers: true } => {
      pattern: "Magic Numbers"
      signs: "Hardcoded values without context"
      remediation: "Extract Constant"
    }
    { hasDeadCode: true } => {
      pattern: "Dead Code"
      signs: "Unreachable or unused code"
      remediation: "Delete it"
    }
  }
}
```

### Class-Level Anti-Patterns

```sudolang
detectClassAntiPattern(classInfo) {
  match classInfo {
    { lines: n, responsibilities: r } if n > 500 || r > 3 => {
      pattern: "God Object"
      signs: ">500 lines, many responsibilities"
      remediation: "Extract Class"
    }
    { hasBehavior: false, hasGettersSetters: true } => {
      pattern: "Data Class"
      signs: "Only getters/setters, no behavior"
      remediation: "Move behavior to class"
    }
    { usesExternalDataExtensively: true } => {
      pattern: "Feature Envy"
      signs: "Method uses another class's data extensively"
      remediation: "Move Method"
    }
    { coupledTightly: true } => {
      pattern: "Inappropriate Intimacy"
      signs: "Classes know too much about each other"
      remediation: "Move Method, Extract Class"
    }
    { usesInheritedBehavior: false, inherits: true } => {
      pattern: "Refused Bequest"
      signs: "Subclass doesn't use inherited behavior"
      remediation: "Replace Inheritance with Delegation"
    }
    { justification: "minimal" } => {
      pattern: "Lazy Class"
      signs: "Does too little to justify existence"
      remediation: "Inline Class"
    }
  }
}
```

### Architecture-Level Anti-Patterns

```sudolang
detectArchitectureAntiPattern(architecture) {
  match architecture {
    { hasCircularDeps: true } => {
      pattern: "Circular Dependencies"
      signs: "A depends on B depends on A"
      remediation: "Dependency Inversion"
    }
    { changeImpact: "widespread" } => {
      pattern: "Shotgun Surgery"
      signs: "One change requires many file edits"
      remediation: "Move Method, Extract Class"
    }
    { implementationExposed: true } => {
      pattern: "Leaky Abstraction"
      signs: "Implementation details exposed"
      remediation: "Encapsulate"
    }
    { optimizedWithoutMeasurement: true } => {
      pattern: "Premature Optimization"
      signs: "Complex code for unproven performance"
      remediation: "Simplify, measure first"
    }
    { abstractionsForHypotheticals: true } => {
      pattern: "Over-Engineering"
      signs: "Abstractions for hypothetical requirements"
      remediation: "YAGNI - simplify"
    }
  }
}
```

## Review Prioritization

Focus review effort where it matters most:

```sudolang
prioritizeFinding(finding) {
  match finding {
    Priority 1: Critical (Must Fix)
    { type: "security_vulnerability" } => { priority: 1, label: "Critical", action: "Must Fix" }
    { type: "injection" } => { priority: 1, label: "Critical", action: "Must Fix" }
    { type: "auth_bypass" } => { priority: 1, label: "Critical", action: "Must Fix" }
    { type: "data_loss_risk" } => { priority: 1, label: "Critical", action: "Must Fix" }
    { type: "data_corruption_risk" } => { priority: 1, label: "Critical", action: "Must Fix" }
    { type: "breaking_api_change" } => { priority: 1, label: "Critical", action: "Must Fix" }
    { type: "production_stability_risk" } => { priority: 1, label: "Critical", action: "Must Fix" }

    Priority 2: High (Should Fix)
    { type: "logic_error" } => { priority: 2, label: "High", action: "Should Fix" }
    { type: "hot_path_performance" } => { priority: 2, label: "High", action: "Should Fix" }
    { type: "missing_error_handling" } => { priority: 2, label: "High", action: "Should Fix" }
    { type: "architecture_violation" } => { priority: 2, label: "High", action: "Should Fix" }

    Priority 3: Medium (Consider Fixing)
    { type: "code_duplication" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    { type: "missing_tests" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    { type: "unclear_naming" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    { type: "complex_conditionals" } => { priority: 3, label: "Medium", action: "Consider Fixing" }

    Priority 4: Low (Nice to Have)
    { type: "style_inconsistency" } => { priority: 4, label: "Low", action: "Nice to Have" }
    { type: "minor_optimization" } => { priority: 4, label: "Low", action: "Nice to Have" }
    { type: "documentation" } => { priority: 4, label: "Low", action: "Nice to Have" }
    { type: "refactoring_suggestion" } => { priority: 4, label: "Low", action: "Nice to Have" }

    _ => { priority: 4, label: "Low", action: "Nice to Have" }
  }
}
```

## Constructive Feedback Patterns

### The Feedback Formula

```sudolang
FeedbackFormula {
  template: "[Observation] + [Why it matters] + [Suggestion] + [Example if helpful]"

  Constraints {
    Never say "This is wrong" without explanation.
    Always explain impact or consequence.
    Provide actionable suggestion.
    Include code example for complex suggestions.
  }
}
```

### Good Feedback Examples

```markdown
# Instead of:
"This is wrong"

# Say:
"This query runs inside a loop (line 45), which could cause N+1
performance issues as the dataset grows. Consider using a batch
query before the loop:

```python
users = User.query.filter(User.id.in_(user_ids)).all()
user_map = {u.id: u for u in users}
```
"
```

```markdown
# Instead of:
"Use better names"

# Say:
"The variable `d` on line 23 would be clearer as `daysSinceLastLogin` -
it helps readers understand the business logic without tracing back
to the assignment."
```

### Feedback Tone Guide

```sudolang
transformTone(phrase) {
  match phrase {
    "You should..." => "Consider..." or "What about..."
    "This is wrong" => "This might cause issues because..."
    "Why didn't you..." => "Have you considered..."
    "Obviously..." => "One approach is..."
    "Always/Never do X" => "In this context, X would help because..."
  }
}
```

### Positive Observations

Include what's done well:

```markdown
"Nice use of the Strategy pattern here - it makes adding new
payment methods straightforward."

"Good error handling - the retry logic with exponential backoff
is exactly what we need for this flaky API."

"Clean separation of concerns between the validation and persistence logic."
```

## Review Checklists

```sudolang
QuickReviewChecklist {
  For changes under 100 lines.
  require {
    Code compiles and tests pass.
    Logic appears correct for stated purpose.
    No obvious security issues.
    Naming is clear.
    No magic numbers or strings.
  }
}

StandardReviewChecklist {
  For changes 100-500 lines. Includes all QuickReviewChecklist items plus more.
  require {
    Code compiles and tests pass.
    Logic appears correct for stated purpose.
    No obvious security issues.
    Naming is clear.
    No magic numbers or strings.
    Design follows project patterns.
    Error handling is appropriate.
    Tests cover new functionality.
    No significant duplication.
    Performance is reasonable.
  }
}

DeepReviewChecklist {
  For changes over 500 lines or critical changes. Includes all StandardReviewChecklist items plus more.
  require {
    Code compiles and tests pass.
    Logic appears correct for stated purpose.
    No obvious security issues.
    Naming is clear.
    No magic numbers or strings.
    Design follows project patterns.
    Error handling is appropriate.
    Tests cover new functionality.
    No significant duplication.
    Performance is reasonable.
    Architecture aligns with system design.
    Security implications considered.
    Backward compatibility maintained.
    Documentation updated.
    Migration/rollback plan if needed.
  }
}

selectChecklist(changeSize) {
  match changeSize {
    { lines: n } if n < 100 => QuickReviewChecklist
    { lines: n } if n >= 100 && n <= 500 => StandardReviewChecklist
    { lines: n } if n > 500 => DeepReviewChecklist
    { critical: true } => DeepReviewChecklist
  }
}
```

## Review Workflow

```sudolang
ReviewWorkflow {
  phases ["before", "during", "after"]

  BeforeReview {
    steps [
      "Understand context (ticket, discussion, requirements)",
      "Check if CI passes (don't review failing code)",
      "Estimate review complexity and allocate time"
    ]

    Constraints {
      Do not review code with failing CI.
      Context must be understood before detailed review.
    }
  }

  DuringReview {
    passes [
      { name: "first", focus: "Understand overall change" },
      { name: "second", focus: "Check correctness and design" },
      { name: "third", focus: "Look for edge cases and security" }
    ]

    Constraints {
      Document findings as you go.
      Complete all three passes for thorough review.
    }
  }

  AfterReview {
    steps [
      "Summarize overall impression",
      "Clearly indicate approval status",
      "Distinguish blocking vs non-blocking feedback",
      "Offer to discuss complex suggestions"
    ]
  }
}
```

## Review Metrics

Track review effectiveness:

```sudolang
ReviewMetrics {
  metrics {
    reviewTurnaround {
      target: "<24 hours"
      indicates: "Team velocity"
    }
    commentsPerReview {
      target: "3-10"
      indicates: "Engagement level"
    }
    defectsFound {
      target: "Decreasing trend"
      indicates: "Quality improvement"
    }
    reviewTime {
      target: "<60 min for typical PR"
      indicates: "Right-sized changes"
    }
    approvalRate {
      target: "70-90% first submission"
      indicates: "Clear standards"
    }
  }
}
```

## Anti-Patterns in Reviewing

Avoid these review behaviors:

```sudolang
detectReviewerAntiPattern(behavior) {
  match behavior {
    { focusOnStyle: true, ignoresSubstance: true } => {
      pattern: "Nitpicking"
      description: "Focusing on style over substance"
      betterApproach: "Use linters for style"
    }
    { approvalSpeed: "instant", depth: "shallow" } => {
      pattern: "Drive-by Review"
      description: "Quick approval without depth"
      betterApproach: "Allocate proper time"
    }
    { blocksForPreferences: true } => {
      pattern: "Gatekeeping"
      description: "Blocking for personal preferences"
      betterApproach: "Focus on objective criteria"
    }
    { approved: true, comments: 0 } => {
      pattern: "Ghost Review"
      description: "Approval without comments"
      betterApproach: "Add at least one observation"
    }
    { commentCount: n } if n > 20 => {
      pattern: "Review Bombing"
      description: "Overwhelming with comments"
      betterApproach: "Prioritize and limit to top issues"
    }
    { turnaround: n } if n > 48 => {
      pattern: "Delayed Review"
      description: "Letting PRs sit for days"
      betterApproach: "Commit to turnaround time"
    }
  }
}
```

## References

- [Review Dimension Details](reference.md) - Expanded criteria for each dimension
- [Anti-Pattern Examples](examples/anti-patterns.md) - Code examples of each anti-pattern
