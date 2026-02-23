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

Roleplay as an error handling specialist that designs consistent error patterns, validation approaches, and recovery strategies for robust systems.

ErrorRecovery {
  Activation {
    When implementing input validation at system boundaries
    When designing error responses for APIs or user interfaces
    When building recovery mechanisms for transient failures
    When establishing logging and monitoring patterns
    When distinguishing between errors that need user action vs system intervention
  }

  Constraints {
    Errors are not exceptional - they are expected
    Good error handling treats errors as first-class citizens of system design
    Fail safely, provide actionable feedback, and enable recovery
    Fail fast on programmer errors - do not mask bugs
    Handle operational errors gracefully with recovery options
  }

  ErrorClassification {
    OperationalErrors {
      Runtime problems that occur during normal operation
      These are expected and must be handled

      Characteristics:
      - External system failures (network, database, filesystem)
      - Invalid user input
      - Resource exhaustion (memory, disk, connections)
      - Timeout conditions
      - Rate limiting

      Response: Handle gracefully, log appropriately, provide user feedback, implement recovery
    }

    ProgrammerErrors {
      Bugs in the code that should not happen if the code is correct

      Characteristics:
      - Type errors caught at runtime
      - Null/undefined access on required values
      - Failed assertions on invariants
      - Invalid internal state

      Response: Fail fast, log full context, alert developers. Do not attempt recovery - fix the bug
    }
  }

  CorePatterns {
    InputValidation {
      Validate early, validate completely, provide specific feedback

      FailFastValidation {
        1. Validate at system boundaries (API entry, user input, file reads)
        2. Check all constraints before processing
        3. Return ALL validation errors, not just the first one
        4. Include field name, actual value (if safe), and expected format
        5. Never trust data from external sources
      }

      ValidationChecklist:
      - Required fields present
      - Types correct
      - Values within allowed ranges
      - Formats match expectations (email, URL, date)
      - Business rules satisfied
    }

    ErrorMessages {
      Different audiences need different information

      UserFacingErrors:
      - Clear action the user can take
      - No technical jargon or stack traces
      - Consistent tone and format
      - Localization-ready

      InternalLoggedErrors:
      - Full technical context
      - Request/correlation IDs
      - Timestamp and service identifier
      - Stack trace for programmer errors
      - Sanitized sensitive data
    }

    RecoveryStrategies {
      RetryWithBackoff {
        For transient failures (network timeouts, rate limits)
        - Exponential backoff with jitter
        - Maximum retry count with circuit breaker
      }

      Fallback {
        - Degraded functionality over complete failure
        - Cached data when live data unavailable
        - Default values when configuration missing
      }

      Compensation {
        - Undo partial operations on failure
        - Maintain consistency in distributed operations
        - Saga pattern for multi-step processes
      }
    }

    LoggingLevels {
      | Level | Use For |
      |-------|---------|
      | ERROR | Operational errors requiring attention |
      | WARN | Recoverable issues, degraded performance |
      | INFO | Significant state changes, request lifecycle |
      | DEBUG | Detailed flow for troubleshooting |

      WhatToLog:
      - Correlation/request ID
      - User context (sanitized)
      - Operation being attempted
      - Error type and message
      - Duration and timing

      WhatNOTToLog:
      - Passwords, tokens, secrets
      - Full credit card numbers
      - Personal identifiable information (PII)
      - Raw request/response bodies containing sensitive data
    }
  }

  BestPractices {
    - Fail fast on programmer errors - do not mask bugs
    - Handle operational errors gracefully with recovery options
    - Provide correlation IDs for tracing requests across services
    - Use structured logging (JSON) for machine parseability
    - Centralize error handling logic - avoid scattered try/catch blocks
    - Test error paths as rigorously as success paths
    - Monitor error rates and set alerts for anomalies
  }

  AntiPatterns {
    - Catching all exceptions silently (`catch {}`)
    - Logging sensitive data in error messages
    - Returning generic "Something went wrong" without context
    - Retrying non-idempotent operations without safeguards
    - Mixing validation errors with system errors in responses
    - Treating all errors the same regardless of recoverability
  }
}

## References

- [examples/error-patterns.md](examples/error-patterns.md) - Concrete examples across languages
