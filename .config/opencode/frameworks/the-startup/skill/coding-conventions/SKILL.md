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
    findings: Finding[]
    context: CodeContext
  }
  
  constraints {
    Apply security checks before performance optimization
    Accessibility is a default, not an afterthought
    Use checklists during code review, not just at the end
    Document exceptions to standards with rationale
    Automate checks where possible (linting, testing)
  }
}
```

### Security

Covers common vulnerability prevention aligned with OWASP Top 10. Apply these checks to any code that handles user input, authentication, data storage, or external communications.

See: `checklists/security-checklist.md`

```sudolang
SecurityValidation {
  require {
    All user input is validated at boundaries
    Parameterized queries for database operations
    Authentication tokens have expiration
    Sensitive data encrypted at rest and in transit
    No secrets hardcoded in source
  }
  
  warn {
    Missing rate limiting on public endpoints
    Verbose error messages exposed to users
    Overly permissive CORS configuration
  }
}
```

### Performance

Covers optimization patterns for frontend, backend, and database operations. Apply these checks when performance is a concern or during code review.

See: `checklists/performance-checklist.md`

```sudolang
PerformanceValidation {
  require {
    Database queries use appropriate indexes
    N+1 query patterns eliminated
    Large payloads paginated
    Expensive operations cached appropriately
  }
  
  warn {
    Synchronous operations that could be async
    Missing lazy loading for non-critical resources
    Unbounded loops or recursion
    Missing connection pooling
  }
}
```

### Accessibility

Covers WCAG 2.1 Level AA compliance. Apply these checks to all user-facing components to ensure inclusive design.

See: `checklists/accessibility-checklist.md`

```sudolang
AccessibilityValidation {
  require {
    All images have meaningful alt text
    Keyboard navigation works for all interactions
    Color contrast meets WCAG AA (4.5:1 for text)
    Form inputs have associated labels
    Focus states are visible
  }
  
  warn {
    Missing ARIA labels on interactive elements
    Content not accessible via screen reader
    Motion without reduced-motion support
    Time-limited interactions without extensions
  }
}
```

## Error Handling Patterns

All agents should recommend these error handling approaches:

```sudolang
ErrorHandlingPatterns {
  constraints {
    Validate inputs at system boundaries
    Create domain-specific error types with context
    Never expose internal error details to users
    Log full context internally, sanitize externally
    Define criticality levels for graceful degradation
  }
  
  fn selectPattern(scenario: ErrorScenario) {
    match (scenario) {
      case { location: "boundary", input: _ } => Pattern.FailFast
      case { errorType: "domain-specific" } => Pattern.SpecificErrorTypes
      case { audience: "user" } => Pattern.UserSafeMessages
      case { criticality: "optional" } => Pattern.GracefulDegradation
      case { failure: "transient" } => Pattern.RetryWithBackoff
      default => Pattern.FailFast
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
fn handleDegradation(results: SettledResult[]) {
  match (results) {
    case [{ status: "rejected", critical: true }, ...] => 
      throw new Error("Cannot load - critical operation failed")
    case [{ status: "rejected", critical: false }, ...rest] => 
      continue with placeholders for failed optional operations
    case [{ status: "fulfilled" }, ...] => 
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
  
  fn calculateDelay(attempt: Number) => 
    Math.pow(config.backoffMultiplier, attempt) * config.baseDelayMs
  
  fn shouldRetry(error: Error, attempt: Number) {
    match (error) {
      case { type: "network" } if attempt < maxAttempts => true
      case { status: 429 } if attempt < maxAttempts => true  // Rate limited
      case { status: 503 } if attempt < maxAttempts => true  // Service unavailable
      default => false
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
fn validateCode(code: Code, domains: String[]) {
  findings = []
  
  domains |> forEach(domain => {
    match (domain) {
      case "security" => findings.push(...SecurityValidation.check(code))
      case "performance" => findings.push(...PerformanceValidation.check(code))
      case "accessibility" => findings.push(...AccessibilityValidation.check(code))
    }
  })
  
  return {
    valid: findings |> none(f => f.severity == "critical"),
    findings: findings,
    summary: generateSummary(findings)
  }
}
```

## References

- `checklists/security-checklist.md` - OWASP-aligned security checks
- `checklists/performance-checklist.md` - Performance optimization checklist
- `checklists/accessibility-checklist.md` - WCAG 2.1 AA compliance checklist
