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
  dimensions: [
    "correctness",
    "design", 
    "readability",
    "security",
    "performance",
    "testability"
  ]
  
  constraints {
    All six dimensions must be evaluated
    Findings must include dimension category
    Critical issues block approval regardless of dimension
  }
}
```

### 1. Correctness

Does the code work as intended?

```sudolang
CorrectnessReview {
  require {
    functionality: "Solves the stated problem"
    edgeCases: "Boundary conditions handled"
    errorHandling: "Failures gracefully managed"
    dataValidation: "Inputs validated at boundaries"
    nullSafety: "Null/undefined cases covered"
  }
}
```

### 2. Design

Is the code well-structured?

```sudolang
DesignReview {
  require {
    singleResponsibility: "Each function/class does one thing"
    abstractionLevel: "Complexity hidden appropriately"
    coupling: "Dependencies minimized"
    cohesion: "Related things stay together"
    extensibility: "Can be modified without major changes"
  }
}
```

### 3. Readability

Can others understand this code?

```sudolang
ReadabilityReview {
  require {
    naming: "Names reveal intent"
    comments: "The 'why' explained, not the 'what'"
    formatting: "Style consistent"
    complexity: "Cyclomatic complexity reasonable (<10)"
    flow: "Control flow straightforward"
  }
}
```

### 4. Security

Is the code secure?

```sudolang
SecurityReview {
  require {
    inputValidation: "All inputs sanitized"
    authentication: "Auth checks present where needed"
    authorization: "Permissions verified"
    dataExposure: "Sensitive data protected"
    dependencies: "No known vulnerabilities"
  }
}
```

### 5. Performance

Is the code efficient?

```sudolang
PerformanceReview {
  require {
    algorithmic: "Time complexity appropriate"
    memory: "Allocations reasonable"
    io: "Database/network calls optimized"
    caching: "Caching used where beneficial"
    concurrency: "Race conditions avoided"
  }
}
```

### 6. Testability

Can this code be tested?

```sudolang
TestabilityReview {
  require {
    testCoverage: "Critical paths tested"
    testQuality: "Tests verify behavior, not implementation"
    mocking: "External dependencies mockable"
    determinism: "Tests reliable and repeatable"
    edgeCases: "Boundary conditions tested"
  }
}
```

## Anti-Pattern Catalog

Common code smells and their remediation:

### Method-Level Anti-Patterns

```sudolang
fn detectMethodAntiPattern(code) {
  match (code) {
    case { lines: n } if n > 20 => {
      pattern: "Long Method",
      signs: "Multiple responsibilities",
      remediation: "Extract Method"
    }
    case { paramCount: n } if n > 4 => {
      pattern: "Long Parameter List",
      signs: ">3-4 parameters",
      remediation: "Introduce Parameter Object"
    }
    case { hasCopyPaste: true } => {
      pattern: "Duplicate Code",
      signs: "Copy-paste patterns",
      remediation: "Extract Method, Template Method"
    }
    case { nestedConditions: n } if n > 2 => {
      pattern: "Complex Conditionals",
      signs: "Nested if/else, switch statements",
      remediation: "Decompose Conditional, Strategy Pattern"
    }
    case { hasMagicNumbers: true } => {
      pattern: "Magic Numbers",
      signs: "Hardcoded values without context",
      remediation: "Extract Constant"
    }
    case { hasDeadCode: true } => {
      pattern: "Dead Code",
      signs: "Unreachable or unused code",
      remediation: "Delete it"
    }
  }
}
```

### Class-Level Anti-Patterns

```sudolang
fn detectClassAntiPattern(classInfo) {
  match (classInfo) {
    case { lines: n, responsibilities: r } if n > 500 || r > 3 => {
      pattern: "God Object",
      signs: ">500 lines, many responsibilities",
      remediation: "Extract Class"
    }
    case { hasBehavior: false, hasGettersSetters: true } => {
      pattern: "Data Class",
      signs: "Only getters/setters, no behavior",
      remediation: "Move behavior to class"
    }
    case { usesExternalDataExtensively: true } => {
      pattern: "Feature Envy",
      signs: "Method uses another class's data extensively",
      remediation: "Move Method"
    }
    case { coupledTightly: true } => {
      pattern: "Inappropriate Intimacy",
      signs: "Classes know too much about each other",
      remediation: "Move Method, Extract Class"
    }
    case { usesInheritedBehavior: false, inherits: true } => {
      pattern: "Refused Bequest",
      signs: "Subclass doesn't use inherited behavior",
      remediation: "Replace Inheritance with Delegation"
    }
    case { justification: "minimal" } => {
      pattern: "Lazy Class",
      signs: "Does too little to justify existence",
      remediation: "Inline Class"
    }
  }
}
```

### Architecture-Level Anti-Patterns

```sudolang
fn detectArchitectureAntiPattern(architecture) {
  match (architecture) {
    case { hasCircularDeps: true } => {
      pattern: "Circular Dependencies",
      signs: "A depends on B depends on A",
      remediation: "Dependency Inversion"
    }
    case { changeImpact: "widespread" } => {
      pattern: "Shotgun Surgery",
      signs: "One change requires many file edits",
      remediation: "Move Method, Extract Class"
    }
    case { implementationExposed: true } => {
      pattern: "Leaky Abstraction",
      signs: "Implementation details exposed",
      remediation: "Encapsulate"
    }
    case { optimizedWithoutMeasurement: true } => {
      pattern: "Premature Optimization",
      signs: "Complex code for unproven performance",
      remediation: "Simplify, measure first"
    }
    case { abstractionsForHypotheticals: true } => {
      pattern: "Over-Engineering",
      signs: "Abstractions for hypothetical requirements",
      remediation: "YAGNI - simplify"
    }
  }
}
```

## Review Prioritization

Focus review effort where it matters most:

```sudolang
fn prioritizeFinding(finding) {
  match (finding) {
    // Priority 1: Critical (Must Fix)
    case { type: "security_vulnerability" } => { priority: 1, label: "Critical", action: "Must Fix" }
    case { type: "injection" } => { priority: 1, label: "Critical", action: "Must Fix" }
    case { type: "auth_bypass" } => { priority: 1, label: "Critical", action: "Must Fix" }
    case { type: "data_loss_risk" } => { priority: 1, label: "Critical", action: "Must Fix" }
    case { type: "data_corruption_risk" } => { priority: 1, label: "Critical", action: "Must Fix" }
    case { type: "breaking_api_change" } => { priority: 1, label: "Critical", action: "Must Fix" }
    case { type: "production_stability_risk" } => { priority: 1, label: "Critical", action: "Must Fix" }
    
    // Priority 2: High (Should Fix)
    case { type: "logic_error" } => { priority: 2, label: "High", action: "Should Fix" }
    case { type: "hot_path_performance" } => { priority: 2, label: "High", action: "Should Fix" }
    case { type: "missing_error_handling" } => { priority: 2, label: "High", action: "Should Fix" }
    case { type: "architecture_violation" } => { priority: 2, label: "High", action: "Should Fix" }
    
    // Priority 3: Medium (Consider Fixing)
    case { type: "code_duplication" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    case { type: "missing_tests" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    case { type: "unclear_naming" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    case { type: "complex_conditionals" } => { priority: 3, label: "Medium", action: "Consider Fixing" }
    
    // Priority 4: Low (Nice to Have)
    case { type: "style_inconsistency" } => { priority: 4, label: "Low", action: "Nice to Have" }
    case { type: "minor_optimization" } => { priority: 4, label: "Low", action: "Nice to Have" }
    case { type: "documentation" } => { priority: 4, label: "Low", action: "Nice to Have" }
    case { type: "refactoring_suggestion" } => { priority: 4, label: "Low", action: "Nice to Have" }
    
    default => { priority: 4, label: "Low", action: "Nice to Have" }
  }
}
```

## Constructive Feedback Patterns

### The Feedback Formula

```sudolang
FeedbackFormula {
  template: "[Observation] + [Why it matters] + [Suggestion] + [Example if helpful]"
  
  constraints {
    Never say "This is wrong" without explanation
    Always explain impact or consequence
    Provide actionable suggestion
    Include code example for complex suggestions
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
fn transformTone(phrase) {
  match (phrase) {
    case "You should..." => "Consider..." or "What about..."
    case "This is wrong" => "This might cause issues because..."
    case "Why didn't you..." => "Have you considered..."
    case "Obviously..." => "One approach is..."
    case "Always/Never do X" => "In this context, X would help because..."
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
  // For changes < 100 lines
  require {
    compiles: "Code compiles and tests pass"
    logic: "Logic appears correct for stated purpose"
    security: "No obvious security issues"
    naming: "Naming is clear"
    noMagic: "No magic numbers or strings"
  }
}

StandardReviewChecklist {
  // For changes 100-500 lines
  // Includes all QuickReviewChecklist items plus:
  require {
    compiles: "Code compiles and tests pass"
    logic: "Logic appears correct for stated purpose"
    security: "No obvious security issues"
    naming: "Naming is clear"
    noMagic: "No magic numbers or strings"
    design: "Design follows project patterns"
    errorHandling: "Error handling is appropriate"
    tests: "Tests cover new functionality"
    noDuplication: "No significant duplication"
    performance: "Performance is reasonable"
  }
}

DeepReviewChecklist {
  // For changes > 500 lines or critical
  // Includes all StandardReviewChecklist items plus:
  require {
    compiles: "Code compiles and tests pass"
    logic: "Logic appears correct for stated purpose"
    security: "No obvious security issues"
    naming: "Naming is clear"
    noMagic: "No magic numbers or strings"
    design: "Design follows project patterns"
    errorHandling: "Error handling is appropriate"
    tests: "Tests cover new functionality"
    noDuplication: "No significant duplication"
    performance: "Performance is reasonable"
    architecture: "Architecture aligns with system design"
    securityImplications: "Security implications considered"
    backwardCompatibility: "Backward compatibility maintained"
    documentation: "Documentation updated"
    migration: "Migration/rollback plan if needed"
  }
}

fn selectChecklist(changeSize) {
  match (changeSize) {
    case { lines: n } if n < 100 => QuickReviewChecklist
    case { lines: n } if n >= 100 && n <= 500 => StandardReviewChecklist
    case { lines: n } if n > 500 => DeepReviewChecklist
    case { critical: true } => DeepReviewChecklist
  }
}
```

## Review Workflow

```sudolang
ReviewWorkflow {
  phases: ["before", "during", "after"]
  
  BeforeReview {
    steps: [
      "Understand context (ticket, discussion, requirements)",
      "Check if CI passes (don't review failing code)",
      "Estimate review complexity and allocate time"
    ]
    
    constraints {
      Do not review code with failing CI
      Context must be understood before detailed review
    }
  }
  
  DuringReview {
    passes: [
      { name: "first", focus: "Understand overall change" },
      { name: "second", focus: "Check correctness and design" },
      { name: "third", focus: "Look for edge cases and security" }
    ]
    
    constraints {
      Document findings as you go
      Complete all three passes for thorough review
    }
  }
  
  AfterReview {
    steps: [
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
  metrics: {
    reviewTurnaround: {
      target: "<24 hours",
      indicates: "Team velocity"
    },
    commentsPerReview: {
      target: "3-10",
      indicates: "Engagement level"
    },
    defectsFound: {
      target: "Decreasing trend",
      indicates: "Quality improvement"
    },
    reviewTime: {
      target: "<60 min for typical PR",
      indicates: "Right-sized changes"
    },
    approvalRate: {
      target: "70-90% first submission",
      indicates: "Clear standards"
    }
  }
}
```

## Anti-Patterns in Reviewing

Avoid these review behaviors:

```sudolang
fn detectReviewerAntiPattern(behavior) {
  match (behavior) {
    case { focusOnStyle: true, ignoresSubstance: true } => {
      pattern: "Nitpicking",
      description: "Focusing on style over substance",
      betterApproach: "Use linters for style"
    }
    case { approvalSpeed: "instant", depth: "shallow" } => {
      pattern: "Drive-by Review",
      description: "Quick approval without depth",
      betterApproach: "Allocate proper time"
    }
    case { blocksForPreferences: true } => {
      pattern: "Gatekeeping",
      description: "Blocking for personal preferences",
      betterApproach: "Focus on objective criteria"
    }
    case { approved: true, comments: 0 } => {
      pattern: "Ghost Review",
      description: "Approval without comments",
      betterApproach: "Add at least one observation"
    }
    case { commentCount: n } if n > 20 => {
      pattern: "Review Bombing",
      description: "Overwhelming with comments",
      betterApproach: "Prioritize and limit to top issues"
    }
    case { turnaround: n } if n > 48 => {
      pattern: "Delayed Review",
      description: "Letting PRs sit for days",
      betterApproach: "Commit to turnaround time"
    }
  }
}
```

## References

- [Review Dimension Details](reference.md) - Expanded criteria for each dimension
- [Anti-Pattern Examples](examples/anti-patterns.md) - Code examples of each anti-pattern
