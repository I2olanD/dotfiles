---
name: error-recovery
description: Consistent error patterns, validation approaches, and recovery strategies. Use when implementing input validation, designing error responses, handling failures gracefully, or establishing logging practices. Covers operational vs programmer errors, user-facing vs internal errors, and recovery mechanisms.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Error Handling

## When to Use

- Implementing input validation at system boundaries
- Designing error responses for APIs or user interfaces
- Building recovery mechanisms for transient failures
- Establishing logging and monitoring patterns
- Distinguishing between errors that need user action vs system intervention

## Philosophy

Errors are not exceptional - they are expected. Good error handling treats errors as first-class citizens of the system design, not afterthoughts. The goal is to fail safely, provide actionable feedback, and enable recovery.

## Error Classification

```sudolang
ErrorType {
  Operational {
    description: "Runtime problems during normal operation - expected and must be handled"
    characteristics: [
      "External system failures (network, database, filesystem)",
      "Invalid user input",
      "Resource exhaustion (memory, disk, connections)",
      "Timeout conditions",
      "Rate limiting"
    ]
    response: "Handle gracefully, log appropriately, provide user feedback, implement recovery"
  }

  Programmer {
    description: "Bugs in code that should not happen if code is correct"
    characteristics: [
      "Type errors caught at runtime",
      "Null/undefined access on required values",
      "Failed assertions on invariants",
      "Invalid internal state"
    ]
    response: "Fail fast, log full context, alert developers. Do not attempt recovery - fix the bug"
  }

  classify(error) {
    match error {
      { source: "external" } => Operational
      { source: "user_input" } => Operational
      { type: "timeout" | "rate_limit" } => Operational
      { type: "resource_exhaustion" } => Operational
      { type: "assertion" | "invariant" } => Programmer
      { type: "type_error" | "null_access" } => Programmer
      default => Operational
    }
  }
}
```

## Core Patterns

### Input Validation

Validate early, validate completely, provide specific feedback.

```sudolang
FailFastValidation {
  Constraints {
    Validate at system boundaries (API entry, user input, file reads).
    Check all constraints before processing.
    Return ALL validation errors, not just the first one.
    Include field name, actual value (if safe), and expected format.
    Never trust data from external sources.
  }

  require "All required fields must be present."
  require "All field types must match expected types."
  require "All values must be within allowed ranges."
  require "Formats must match expectations (email, URL, date)."
  require "All business rules must be satisfied."

  validate(input, schema) {
    errors = []

    schema.fields |> each(field => {
      match field, input[field.name] {
        { required: true }, undefined =>
          errors = errors + [{ field: field.name, error: "required" }]
        { type: expected }, value if typeof(value) != expected =>
          errors = errors + [{ field: field.name, error: "type_mismatch", expected, actual: typeof(value) }]
        { min, max }, value if value < min || value > max =>
          errors = errors + [{ field: field.name, error: "out_of_range", min, max, actual: value }]
        { format: regex }, value if !regex.test(value) =>
          errors = errors + [{ field: field.name, error: "format_invalid", expected: field.format }]
      }
    })

    { valid: errors |> count == 0, errors }
  }
}
```

### Error Messages

Different audiences need different information.

```sudolang
ErrorMessage {
  UserFacing {
    require "Must include clear action the user can take."
    require "No technical jargon or stack traces."
    require "Consistent tone and format."
    require "Localization-ready."
  }

  Internal {
    require "Full technical context."
    require "Request and correlation IDs."
    require "Timestamp and service identifier."
    require "Stack trace for programmer errors."
    require "Sensitive data must be sanitized."
  }

  format(error, audience) {
    match audience {
      "user" => {
        message: error.userMessage || "An error occurred",
        action: error.suggestedAction,
        code: error.publicCode
      }
      "internal" => {
        message: error.technicalMessage,
        correlationId: error.correlationId,
        timestamp: now(),
        service: error.service,
        stack: error.stack,
        context: sanitize(error.context)
      }
    }
  }
}
```

### Recovery Strategies

```sudolang
RecoveryStrategy {
  selectStrategy(error) {
    match error {
      { type: "network_timeout" | "rate_limit" | "transient" } =>
        RetryWithBackoff
      { type: "service_unavailable" | "data_stale" } =>
        Fallback
      { type: "partial_failure" | "distributed_operation" } =>
        Compensation
      { type: "programmer_error" } =>
        FailFast
      default =>
        Fallback
    }
  }

  RetryWithBackoff {
    Constraints {
      Use exponential backoff with jitter.
      Implement maximum retry count.
      Include circuit breaker pattern.
    }

    config {
      maxRetries: 3
      baseDelayMs: 100
      maxDelayMs: 10000
      jitterFactor: 0.1
    }
  }

  Fallback {
    Constraints {
      Prefer degraded functionality over complete failure.
      Use cached data when live data unavailable.
      Apply default values when configuration missing.
    }
  }

  Compensation {
    Constraints {
      Undo partial operations on failure.
      Maintain consistency in distributed operations.
      Use saga pattern for multi-step processes.
    }
  }
}
```

### Logging Levels

```sudolang
LogLevel {
  selectLevel(event) {
    match event {
      { type: "operational_error", requiresAttention: true } => "ERROR"
      { type: "recoverable_issue" | "degraded_performance" } => "WARN"
      { type: "state_change" | "request_lifecycle" } => "INFO"
      { type: "troubleshooting" | "detailed_flow" } => "DEBUG"
      default => "INFO"
    }
  }

  require "Log correlation and request ID."
  require "Log sanitized user context."
  require "Log operation being attempted."
  require "Log error type and message."
  require "Log duration and timing."

  warn "Never log passwords, tokens, or secrets."
  warn "Never log full credit card numbers."
  warn "Never log personal identifiable information (PII)."
  warn "Never log raw request or response bodies containing sensitive data."
}
```

## Best Practices

```sudolang
ErrorHandlingPractices {
  Constraints {
    Fail fast on programmer errors - do not mask bugs.
    Handle operational errors gracefully with recovery options.
    Provide correlation IDs for tracing requests across services.
    Use structured logging (JSON) for machine parseability.
    Centralize error handling logic - avoid scattered try-catch blocks.
    Test error paths as rigorously as success paths.
    Monitor error rates and set alerts for anomalies.
  }
}
```

## Anti-Patterns

```sudolang
ErrorAntiPatterns {
  warn "Catching all exceptions silently (catch {}) hides bugs."
  warn "Logging sensitive data in error messages leaks secrets."
  warn "Returning generic 'Something went wrong' without context frustrates users."
  warn "Retrying non-idempotent operations without safeguards causes data corruption."
  warn "Mixing validation errors with system errors in responses confuses consumers."
  warn "Treating all errors the same regardless of recoverability prevents proper handling."

  detectAntiPattern(code) {
    match code {
      /catch\s*\(\s*\)\s*\{\s*\}/ => "silentCatch"
      /catch.*password|token|secret/ => "sensitiveLogging"
      /throw.*"Something went wrong"/ => "genericMessages"
      default => null
    }
  }
}
```

## References

- [examples/error-patterns.md](examples/error-patterns.md) - Concrete examples across languages
