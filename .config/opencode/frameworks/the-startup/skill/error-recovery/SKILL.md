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
  
  fn classify(error) {
    match (error) {
      case { source: "external" } => Operational
      case { source: "user_input" } => Operational
      case { type: "timeout" | "rate_limit" } => Operational
      case { type: "resource_exhaustion" } => Operational
      case { type: "assertion" | "invariant" } => Programmer
      case { type: "type_error" | "null_access" } => Programmer
      default => Operational  // Safer default
    }
  }
}
```

## Core Patterns

### Input Validation

Validate early, validate completely, provide specific feedback.

```sudolang
FailFastValidation {
  constraints {
    Validate at system boundaries (API entry, user input, file reads)
    Check all constraints before processing
    Return ALL validation errors, not just the first one
    Include field name, actual value (if safe), and expected format
    Never trust data from external sources
  }
  
  require {
    requiredFieldsPresent: "All required fields must be present"
    typesCorrect: "All field types must match expected types"
    valuesInRange: "All values must be within allowed ranges"
    formatsValid: "Formats must match expectations (email, URL, date)"
    businessRulesSatisfied: "All business rules must be satisfied"
  }
  
  fn validate(input, schema) {
    errors = []
    
    schema.fields |> each(field => {
      match (field, input[field.name]) {
        case { required: true }, undefined => 
          errors.push({ field: field.name, error: "required" })
        case { type: expected }, value if typeof(value) != expected =>
          errors.push({ field: field.name, error: "type_mismatch", expected, actual: typeof(value) })
        case { min, max }, value if value < min || value > max =>
          errors.push({ field: field.name, error: "out_of_range", min, max, actual: value })
        case { format: regex }, value if !regex.test(value) =>
          errors.push({ field: field.name, error: "format_invalid", expected: field.format })
      }
    })
    
    { valid: errors.length == 0, errors }
  }
}
```

### Error Messages

Different audiences need different information.

```sudolang
ErrorMessage {
  UserFacing {
    require {
      actionable: "Must include clear action the user can take"
      noJargon: "No technical jargon or stack traces"
      consistent: "Consistent tone and format"
      localizable: "Localization-ready"
    }
  }
  
  Internal {
    require {
      fullContext: "Full technical context"
      correlationId: "Request/correlation IDs"
      timestamp: "Timestamp and service identifier"
      stackTrace: "Stack trace for programmer errors"
      sanitized: "Sensitive data must be sanitized"
    }
  }
  
  fn format(error, audience) {
    match (audience) {
      case "user" => {
        message: error.userMessage || "An error occurred",
        action: error.suggestedAction,
        code: error.publicCode
      }
      case "internal" => {
        message: error.technicalMessage,
        correlationId: error.correlationId,
        timestamp: Date.now(),
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
  fn selectStrategy(error) {
    match (error) {
      case { type: "network_timeout" | "rate_limit" | "transient" } => 
        RetryWithBackoff
      case { type: "service_unavailable" | "data_stale" } => 
        Fallback
      case { type: "partial_failure" | "distributed_operation" } => 
        Compensation
      case { type: "programmer_error" } => 
        FailFast  // Do not attempt recovery
      default => 
        Fallback
    }
  }
  
  RetryWithBackoff {
    constraints {
      Use exponential backoff with jitter
      Implement maximum retry count
      Include circuit breaker pattern
    }
    
    config {
      maxRetries: 3
      baseDelayMs: 100
      maxDelayMs: 10000
      jitterFactor: 0.1
    }
  }
  
  Fallback {
    constraints {
      Prefer degraded functionality over complete failure
      Use cached data when live data unavailable
      Apply default values when configuration missing
    }
  }
  
  Compensation {
    constraints {
      Undo partial operations on failure
      Maintain consistency in distributed operations
      Use saga pattern for multi-step processes
    }
  }
}
```

### Logging Levels

```sudolang
LogLevel {
  fn selectLevel(event) {
    match (event) {
      case { type: "operational_error", requiresAttention: true } => "ERROR"
      case { type: "recoverable_issue" | "degraded_performance" } => "WARN"
      case { type: "state_change" | "request_lifecycle" } => "INFO"
      case { type: "troubleshooting" | "detailed_flow" } => "DEBUG"
      default => "INFO"
    }
  }
  
  require {
    correlationId: "Log correlation/request ID"
    userContext: "Log sanitized user context"
    operation: "Log operation being attempted"
    errorInfo: "Log error type and message"
    timing: "Log duration and timing"
  }
  
  warn {
    passwords: "Never log passwords, tokens, secrets"
    creditCards: "Never log full credit card numbers"
    pii: "Never log personal identifiable information (PII)"
    rawBodies: "Never log raw request/response bodies containing sensitive data"
  }
}
```

## Best Practices

```sudolang
ErrorHandlingPractices {
  constraints {
    Fail fast on programmer errors - do not mask bugs
    Handle operational errors gracefully with recovery options
    Provide correlation IDs for tracing requests across services
    Use structured logging (JSON) for machine parseability
    Centralize error handling logic - avoid scattered try/catch blocks
    Test error paths as rigorously as success paths
    Monitor error rates and set alerts for anomalies
  }
}
```

## Anti-Patterns

```sudolang
ErrorAntiPatterns {
  warn {
    silentCatch: "Catching all exceptions silently (catch {})"
    sensitiveLogging: "Logging sensitive data in error messages"
    genericMessages: "Returning generic 'Something went wrong' without context"
    unsafeRetry: "Retrying non-idempotent operations without safeguards"
    mixedErrors: "Mixing validation errors with system errors in responses"
    uniformTreatment: "Treating all errors the same regardless of recoverability"
  }
  
  fn detectAntiPattern(code) {
    match (code) {
      case /catch\s*\(\s*\)\s*\{\s*\}/ => "silentCatch"
      case /catch.*password|token|secret/ => "sensitiveLogging"
      case /throw.*"Something went wrong"/ => "genericMessages"
      default => null
    }
  }
}
```

## References

- [examples/error-patterns.md](examples/error-patterns.md) - Concrete examples across languages
