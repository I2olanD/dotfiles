---
name: coding-conventions
description: Apply consistent security, performance, and accessibility standards across all recommendations. Use when reviewing code, designing features, or validating implementations. Cross-cutting skill for all agents.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Best Practices

A cross-cutting skill that enforces consistent security, performance, and quality standards across all agent recommendations. This skill provides actionable checklists aligned with industry standards.

## When to Use

- Reviewing code for security vulnerabilities
- Validating performance characteristics of implementations
- Ensuring accessibility compliance in UI components
- Designing error handling strategies
- Auditing existing systems for quality gaps

## Core Domains

```sudolang
CodingConventions {
  State {
    domain: "security" | "performance" | "accessibility" | "error-handling"
    findings
    context
  }

  Constraints {
    Apply security checks before performance optimization.
    Accessibility is a default, not an afterthought.
    Use checklists during code review, not just at the end.
    Document exceptions to standards with rationale.
    Automate checks where possible via linting and testing.
  }
}
```

### Security

Covers common vulnerability prevention aligned with OWASP Top 10. Apply these checks to any code that handles user input, authentication, data storage, or external communications.

See: `checklists/security-checklist.md`

```sudolang
SecurityValidation {
  require All user input is validated at boundaries.
  require Parameterized queries for database operations.
  require Authentication tokens have expiration.
  require Sensitive data encrypted at rest and in transit.
  require No secrets hardcoded in source.

  warn Missing rate limiting on public endpoints.
  warn Verbose error messages exposed to users.
  warn Overly permissive CORS configuration.
}
```

### Performance

Covers optimization patterns for frontend, backend, and database operations. Apply these checks when performance is a concern or during code review.

See: `checklists/performance-checklist.md`

```sudolang
PerformanceValidation {
  require Database queries use appropriate indexes.
  require N+1 query patterns eliminated.
  require Large payloads paginated.
  require Expensive operations cached appropriately.

  warn Synchronous operations that could be async.
  warn Missing lazy loading for non-critical resources.
  warn Unbounded loops or recursion.
  warn Missing connection pooling.
}
```

### Accessibility

Covers WCAG 2.1 Level AA compliance. Apply these checks to all user-facing components to ensure inclusive design.

See: `checklists/accessibility-checklist.md`

```sudolang
AccessibilityValidation {
  require All images have meaningful alt text.
  require Keyboard navigation works for all interactions.
  require Color contrast meets WCAG AA ratio of 4.5 to 1 for text.
  require Form inputs have associated labels.
  require Focus states are visible.

  warn Missing ARIA labels on interactive elements.
  warn Content not accessible via screen reader.
  warn Motion without reduced-motion support.
  warn Time-limited interactions without extensions.
}
```

## Error Handling Patterns

All agents should recommend these error handling approaches:

```sudolang
ErrorHandlingPatterns {
  Constraints {
    Validate inputs at system boundaries.
    Create domain-specific error types with context.
    Never expose internal error details to users.
    Log full context internally, sanitize externally.
    Define criticality levels for graceful degradation.
  }

  selectPattern(scenario) {
    match scenario {
      { location: "boundary" } => FailFast
      { errorType: "domain-specific" } => SpecificErrorTypes
      { audience: "user" } => UserSafeMessages
      { criticality: "optional" } => GracefulDegradation
      { failure: "transient" } => RetryWithBackoff
      _ => FailFast
    }
  }
}
```

### Pattern 1: Fail Fast at Boundaries

Validate inputs at system boundaries and fail immediately with clear error messages. Do not allow invalid data to propagate through the system.

```
// At API boundary
function handleRequest(input) {
  const validation = validateInput(input);
  if (!validation.valid) {
    throw new ValidationError(validation.errors);
  }
  // Process validated input
}
```

### Pattern 2: Specific Error Types

Create domain-specific error types that carry context about what failed and why. Generic errors lose valuable debugging information.

```
class PaymentDeclinedError extends Error {
  constructor(reason, transactionId) {
    super(`Payment declined: ${reason}`);
    this.reason = reason;
    this.transactionId = transactionId;
  }
}
```

### Pattern 3: User-Safe Messages

Never expose internal error details to users. Log full context internally, present sanitized messages externally.

```
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

### Pattern 4: Graceful Degradation

When non-critical operations fail, degrade gracefully rather than failing entirely. Define what is critical vs. optional.

```sudolang
handleDegradation(results) {
  match results {
    [{ status: "rejected", critical: true }, ...] =>
      throw "Cannot load - critical operation failed"
    [{ status: "rejected", critical: false }, ...rest] =>
      continue with placeholders for failed optional operations
    [{ status: "fulfilled" }, ...] =>
      return all values
  }
}
```

```
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

### Pattern 5: Retry with Backoff

For transient failures (network, rate limits), implement exponential backoff with maximum attempts.

```sudolang
RetryStrategy {
  config {
    maxAttempts: 3
    baseDelayMs: 100
    backoffMultiplier: 2
  }

  calculateDelay(attempt) =>
    backoffMultiplier raised to the power of attempt, multiplied by baseDelayMs

  shouldRetry(error, attempt) {
    match error {
      { type: "network" } if attempt < maxAttempts => true
      { status: 429 } if attempt < maxAttempts => true
      { status: 503 } if attempt < maxAttempts => true
      _ => false
    }
  }
}
```

```
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

## Validation Workflow

```sudolang
validateCode(code, domains) {
  findings = []

  domains |> for each domain {
    match domain {
      "security" => findings = findings combined with SecurityValidation check on code
      "performance" => findings = findings combined with PerformanceValidation check on code
      "accessibility" => findings = findings combined with AccessibilityValidation check on code
    }
  }

  return {
    valid: findings |> none where severity is "critical",
    findings,
    summary: generateSummary(findings)
  }
}
```

## References

- `checklists/security-checklist.md` - OWASP-aligned security checks
- `checklists/performance-checklist.md` - Performance optimization checklist
- `checklists/accessibility-checklist.md` - WCAG 2.1 AA compliance checklist
