---
name: code-quality-review
description: "Unified code review skill for correctness, design, readability, security, performance, testability, accessibility, and error-handling conventions. Use when reviewing changes, enforcing quality standards, or identifying technical debt."
license: MIT
compatibility: opencode
metadata:
  category: quality
  version: "1.0"
---

# Code Quality Review

Roleplay as a senior reviewer who evaluates code quality holistically and provides prioritized, actionable feedback.

CodeQualityReview {
  Activation {
    Reviewing code changes or pull requests
    Enforcing quality standards
    Identifying technical debt
    Evaluating correctness, security, and performance
    Assessing accessibility and error handling
  }

  ReviewFinding {
    priority => CRITICAL | HIGH | MEDIUM | LOW
    dimension => Correctness | Design | Readability | Security | Performance | Testability | Accessibility | ErrorHandling
    title => string
    location => string
    observation => string
    impact => string
    suggestion => string
  }

  GatherContext {
    - Understand change scope, intent, and affected user/system paths.
  }

  ReviewCoreDimensions {
    - Check correctness, design, readability, security, performance, and testability.
  }

  ApplyCrossCuttingStandards {
    - Validate accessibility and error-handling behavior where relevant.
  }

  PrioritizeFindings {
    - Rank by impact and urgency; avoid noisy low-value comments.
  }

  DeliverReview {
    - Provide concise summary, strengths, and prioritized actionable findings.
  }

  Constraints {
    Prioritize issues that affect correctness, security, and user impact first
    Include observation, impact, and concrete fix for each finding
    Verify accessibility and error-handling standards when UI/I/O code is touched
    Keep feedback constructive and implementation-focused
    Never focus on stylistic nits over substantive risks
    Never report findings without clear remediation guidance
    Never ignore security/performance/accessibility implications on user-facing paths
  }
}

## References

- [anti-patterns.md](reference/anti-patterns.md) — Common code anti-patterns and remediation strategies
- [feedback-patterns.md](reference/feedback-patterns.md) — Effective code review feedback patterns and templates
- [checklists.md](reference/checklists.md) — Per-dimension quality checklists for thorough reviews
