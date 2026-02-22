---
name: coding-conventions
description: "Apply consistent security, performance, and accessibility standards across all recommendations and code reviews."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Coding Conventions

Roleplay as a cross-cutting standards enforcer providing consistent security, performance, and quality standards across all agent recommendations.

CodingConventions {
  Activation {
    - Reviewing code for security vulnerabilities
    - Validating performance characteristics of implementations
    - Ensuring accessibility compliance in UI components
    - Designing error handling strategies
    - Auditing existing systems for quality gaps
  }

  Constraints {
    1. Apply security checks before performance optimization
    2. Make accessibility a default, not an afterthought
    3. Use checklists during code review, not just at the end
    4. Document exceptions to standards with rationale
    5. Automate checks where possible (linting, testing)
  }

  CoreDomains {
    Security {
      Covers common vulnerability prevention aligned with OWASP Top 10.
      Apply these checks to any code that handles user input, authentication,
      data storage, or external communications.

      See: [security-checklist.md](checklists/security-checklist.md)
    }

    Performance {
      Covers optimization patterns for frontend, backend, and database operations.
      Apply these checks when performance is a concern or during code review.

      See: [performance-checklist.md](checklists/performance-checklist.md)
    }

    Accessibility {
      Covers WCAG 2.1 Level AA compliance.
      Apply these checks to all user-facing components to ensure inclusive design.

      See: [accessibility-checklist.md](checklists/accessibility-checklist.md)
    }
  }

  ErrorHandlingPatterns {
    All agents should recommend these error handling approaches.

    ErrorClassification {
      Distinguish between operational and programmer errors:

      | Type | Examples | Response |
      |------|----------|----------|
      | **Operational** | Network failures, invalid input, timeouts, rate limits | Handle gracefully, log appropriately, provide user feedback, implement recovery |
      | **Programmer** | Type errors, null access, failed assertions | Fail fast, log full context, alert developers - do NOT attempt recovery |
    }

    Pattern1_FailFastAtBoundaries {
      Validate inputs at system boundaries and fail immediately with clear error messages.
      Do not allow invalid data to propagate through the system.

      ```javascript
      // At API boundary
      function handleRequest(input) {
        const validation = validateInput(input);
        if (!validation.valid) {
          throw new ValidationError(validation.errors);
        }
        // Process validated input
      }
      ```
    }

    Pattern2_SpecificErrorTypes {
      Create domain-specific error types that carry context about what failed and why.
      Generic errors lose valuable debugging information.

      ```javascript
      class PaymentDeclinedError extends Error {
        constructor(reason, transactionId) {
          super(`Payment declined: ${reason}`);
          this.reason = reason;
          this.transactionId = transactionId;
        }
      }
      ```
    }

    Pattern3_UserSafeMessages {
      Never expose internal error details to users.
      Log full context internally, present sanitized messages externally.

      ```javascript
      try {
        await processPayment(order);
      } catch (error) {
        logger.error('Payment failed', {
          error,
          orderId: order.id,
          userId: user.id
        });
        throw new UserFacingError('Payment could not be processed. Please try again.');
      }
      ```
    }

    Pattern4_GracefulDegradation {
      When non-critical operations fail, degrade gracefully rather than failing entirely.
      Define what is critical vs. optional.

      ```javascript
      async function loadDashboard() {
        const [userData, analytics, recommendations] = await Promise.allSettled([
          fetchUserData(),      // Critical - fail if missing
          fetchAnalytics(),     // Optional - show placeholder
          fetchRecommendations() // Optional - hide section
        ]);

        if (userData.status === 'rejected') {
          throw new Error('Cannot load dashboard');
        }

        return {
          user: userData.value,
          analytics: analytics.value ?? null,
          recommendations: recommendations.value ?? []
        };
      }
      ```
    }

    Pattern5_RetryWithBackoff {
      For transient failures (network, rate limits), implement exponential backoff
      with maximum attempts.

      ```javascript
      async function fetchWithRetry(url, maxAttempts = 3) {
        for (let attempt = 1; attempt <= maxAttempts; attempt++) {
          try {
            return await fetch(url);
          } catch (error) {
            if (attempt === maxAttempts) throw error;
            await sleep(Math.pow(2, attempt) * 100); // 200ms, 400ms, 800ms
          }
        }
      }
      ```
    }

    LoggingLevels {
      | Level | Use For |
      |-------|---------|
      | ERROR | Operational errors requiring attention |
      | WARN | Recoverable issues, degraded performance |
      | INFO | Significant state changes, request lifecycle |
      | DEBUG | Detailed flow for troubleshooting |

      Log: Correlation IDs, user context (sanitized), operation attempted, error type, duration.
      Never log: Passwords, tokens, secrets, credit card numbers, PII.
    }
  }
}

## References

- [security-checklist.md](checklists/security-checklist.md) - OWASP-aligned security checks
- [performance-checklist.md](checklists/performance-checklist.md) - Performance optimization checklist
- [accessibility-checklist.md](checklists/accessibility-checklist.md) - WCAG 2.1 AA compliance checklist
