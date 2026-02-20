---
name: security-assessment
description: Vulnerability review, OWASP patterns, secure coding practices, and threat modeling approaches. Use when reviewing code security, designing secure systems, performing threat analysis, or validating security implementations.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Security Assessment

A specialized skill for systematic security evaluation of code, architecture, and infrastructure. Combines threat modeling methodologies with practical code review techniques to identify and remediate security vulnerabilities.

## When to Use

- Reviewing code changes for security vulnerabilities
- Designing new features with security requirements
- Performing threat analysis on system architecture
- Validating security controls in infrastructure
- Assessing third-party integrations and dependencies
- Preparing for security audits or compliance reviews

## Threat Modeling with STRIDE

```sudolang
skill({ name: "security-assessment" })

See: skill/shared/interfaces.sudo.md

interface ThreatAnalysis {
  category: STRIDECategory
  threat: String
  questions: String[]
  mitigations: String[]
}

STRIDECategory = "Spoofing" | "Tampering" | "Repudiation" | 
                 "InformationDisclosure" | "DenialOfService" | "ElevationOfPrivilege"

fn analyzeThreat(component: String) {
  match (component.securityConcern) {
    case "authentication" => {
      category: "Spoofing",
      threat: "Attacker pretends to be another user or system",
      questions: [
        "How do we verify the identity of users and systems?",
        "Can authentication tokens be stolen or forged?",
        "Are there any authentication bypass paths?"
      ],
      mitigations: [
        "Strong authentication mechanisms (MFA)",
        "Secure token generation and validation",
        "Session management with proper invalidation"
      ]
    }
    
    case "dataIntegrity" => {
      category: "Tampering",
      threat: "Attacker modifies data in transit or at rest",
      questions: [
        "Can data be modified between components?",
        "Are database records protected from unauthorized changes?",
        "Can configuration files be altered?"
      ],
      mitigations: [
        "Input validation at all boundaries",
        "Cryptographic signatures for critical data",
        "Database integrity constraints and audit logs"
      ]
    }
    
    case "auditability" => {
      category: "Repudiation",
      threat: "Attacker denies performing an action",
      questions: [
        "Can we prove who performed an action?",
        "Are audit logs tamper-resistant?",
        "Is there sufficient logging for forensics?"
      ],
      mitigations: [
        "Comprehensive audit logging",
        "Secure, immutable log storage",
        "Digital signatures for critical operations"
      ]
    }
    
    case "confidentiality" => {
      category: "InformationDisclosure",
      threat: "Attacker gains access to sensitive information",
      questions: [
        "What sensitive data exists in this system?",
        "How is data protected at rest and in transit?",
        "Are error messages revealing internal details?"
      ],
      mitigations: [
        "Encryption for sensitive data (TLS, AES)",
        "Proper access controls and authorization",
        "Sanitized error messages"
      ]
    }
    
    case "availability" => {
      category: "DenialOfService",
      threat: "Attacker makes the system unavailable",
      questions: [
        "What resources can be exhausted?",
        "Are there rate limits on expensive operations?",
        "How does the system handle malformed input?"
      ],
      mitigations: [
        "Rate limiting and throttling",
        "Input validation and size limits",
        "Resource quotas and timeouts"
      ]
    }
    
    case "authorization" => {
      category: "ElevationOfPrivilege",
      threat: "Attacker gains higher privileges than intended",
      questions: [
        "Can users access resources beyond their role?",
        "Are privilege checks performed consistently?",
        "Can administrative functions be accessed by regular users?"
      ],
      mitigations: [
        "Principle of least privilege",
        "Role-based access control (RBAC)",
        "Authorization checks at every layer"
      ]
    }
  }
}
```

## OWASP Top 10 Review Patterns

```sudolang
interface OWASPReview {
  category: OWASPCategory
  reviewSteps: String[]
  redFlags: String[]
}

OWASPCategory = "A01" | "A02" | "A03" | "A04" | "A05" | 
               "A06" | "A07" | "A08" | "A09" | "A10"

fn reviewOWASP(category: OWASPCategory) {
  match (category) {
    case "A01" => {  // Broken Access Control
      reviewSteps: [
        "Identify all endpoints and their expected access levels",
        "Trace authorization logic from request to resource",
        "Test for horizontal privilege escalation (accessing other users' data)",
        "Test for vertical privilege escalation (accessing admin functions)",
        "Verify CORS configuration restricts origins appropriately"
      ],
      warn {
        "Authorization based on client-side state" => critical
        "Direct object references without ownership verification" => high
        "Missing authorization checks on API endpoints" => critical
      }
    }
    
    case "A02" => {  // Cryptographic Failures
      reviewSteps: [
        "Map all sensitive data flows (credentials, PII, financial)",
        "Verify encryption at rest and in transit",
        "Check for hardcoded secrets in code or configuration",
        "Review cryptographic algorithm choices",
        "Verify key management practices"
      ],
      warn {
        "Sensitive data in logs or error messages" => high
        "Deprecated algorithms (MD5, SHA1, DES)" => critical
        "Secrets in source control" => critical
      }
    }
    
    case "A03" => {  // Injection
      reviewSteps: [
        "Identify all user input entry points",
        "Trace input flow to database queries, OS commands, LDAP",
        "Verify parameterized queries or proper escaping",
        "Check for dynamic code execution (eval, exec)",
        "Review XML parsing for XXE vulnerabilities"
      ],
      warn {
        "String concatenation in queries" => critical
        "User input in system commands" => critical
        "Disabled XML external entity protection" => high
      }
    }
    
    case "A04" => {  // Insecure Design
      reviewSteps: [
        "Verify threat modeling was performed",
        "Check for abuse case handling (rate limits, quantity limits)",
        "Review business logic for security assumptions",
        "Assess multi-tenancy isolation",
        "Verify secure defaults"
      ],
      warn {
        "No rate limiting on authentication" => high
        "Trust assumptions without verification" => medium
        "Security as an afterthought" => high
      }
    }
    
    case "A05" => {  // Security Misconfiguration
      reviewSteps: [
        "Review default configurations for security settings",
        "Check for unnecessary features or services",
        "Verify error handling does not expose details",
        "Review security headers (CSP, HSTS, X-Frame-Options)",
        "Check cloud resource permissions"
      ],
      warn {
        "Debug mode in production" => critical
        "Default credentials unchanged" => critical
        "Overly permissive cloud IAM policies" => high
      }
    }
    
    case "A06" => {  // Vulnerable Components
      reviewSteps: [
        "Inventory all dependencies and their versions",
        "Check for known vulnerabilities (CVE databases)",
        "Verify dependencies from trusted sources",
        "Review for unused dependencies",
        "Check for version pinning"
      ],
      warn {
        "Unpinned dependencies" => medium
        "Known critical vulnerabilities" => critical
        "Dependencies from unofficial sources" => high
      }
    }
    
    case "A07" => {  // Authentication Failures
      reviewSteps: [
        "Review password policy enforcement",
        "Check session management implementation",
        "Verify brute force protection",
        "Review token generation and validation",
        "Check credential storage mechanisms"
      ],
      warn {
        "Weak password requirements" => medium
        "Sessions that do not invalidate on logout" => high
        "Predictable session tokens" => critical
      }
    }
    
    case "A08" => {  // Integrity Failures
      reviewSteps: [
        "Review CI/CD pipeline security",
        "Check for unsigned code or dependencies",
        "Review deserialization of untrusted data",
        "Verify update mechanism security",
        "Check for code review requirements"
      ],
      warn {
        "Deserialization without integrity checks" => critical
        "Unsigned updates or dependencies" => high
        "No code review before deployment" => medium
      }
    }
    
    case "A09" => {  // Logging and Monitoring Failures
      reviewSteps: [
        "Verify authentication events are logged",
        "Check for authorization failure logging",
        "Review log content for sensitive data",
        "Verify log integrity protection",
        "Check alerting configuration"
      ],
      warn {
        "Missing authentication failure logs" => medium
        "Sensitive data in logs" => high
        "No alerting on suspicious patterns" => medium
      }
    }
    
    case "A10" => {  // SSRF
      reviewSteps: [
        "Identify all server-side URL fetching",
        "Verify URL validation against allowlist",
        "Check for internal network blocking",
        "Review URL scheme restrictions",
        "Verify response handling"
      ],
      warn {
        "User-controlled URLs without validation" => critical
        "Internal addresses not blocked" => high
        "Raw responses returned to users" => medium
      }
    }
  }
}
```

## Secure Coding Practices

### Input Validation

Always validate on the server side, regardless of client validation:

```
function validateInput(input) {
  // Type validation
  if (typeof input !== 'string') {
    throw new ValidationError('Input must be a string');
  }

  // Length validation
  if (input.length > MAX_LENGTH) {
    throw new ValidationError('Input exceeds maximum length');
  }

  // Format validation (allowlist approach)
  if (!ALLOWED_PATTERN.test(input)) {
    throw new ValidationError('Input contains invalid characters');
  }

  return sanitize(input);
}
```

### Output Encoding

Context-appropriate encoding prevents injection:

- HTML context: Encode `<`, `>`, `&`, `"`, `'`
- JavaScript context: Use JSON.stringify or hex encoding
- URL context: Use encodeURIComponent
- SQL context: Use parameterized queries (never encode manually)

### Secrets Management

Never commit secrets to source control:

```
// Bad: Hardcoded secret
const apiKey = "sk-1234567890abcdef";

// Good: Environment variable
const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new ConfigurationError('API_KEY not configured');
}
```

### Error Handling for Security

Separate internal logging from user-facing errors:

```
try {
  await processRequest(data);
} catch (error) {
  // Log full details internally
  logger.error('Request processing failed', {
    error: error.message,
    stack: error.stack,
    userId: user.id,
    requestId: request.id
  });

  // Return generic message to user
  throw new UserError('Unable to process request');
}
```

## Infrastructure Security

```sudolang
InfrastructureSecurity {
  constraints {
    // Network Security
    require network segmentation to limit blast radius
    require private subnets for internal services
    require network policies in Kubernetes
    require egress traffic restricted to known destinations
    
    // Container Security
    require minimal base images (distroless, Alpine)
    require non-root user execution
    require image vulnerability scanning
    warn read-only root filesystem where possible
    warn limited container capabilities
    
    // Secrets Management
    require secret management services (Vault, AWS Secrets Manager)
    require secrets injected as environment variables
    require regular secret rotation
    require secret access auditing
    
    // Cloud IAM
    require principle of least privilege
    require service accounts with minimal permissions
    require regular IAM policy audits
    require avoiding root/admin accounts for routine operations
  }
}
```

## Code Review Security Focus

```sudolang
interface SecurityReviewArea {
  priority: 1..7
  focus: String
  checkpoints: String[]
}

CodeReviewSecurity {
  State {
    findings: Finding[]  // From interfaces.sudo.md
  }
  
  fn prioritizeReview() => [
    { priority: 1, focus: "Authentication and session management", 
      checkpoints: ["Token generation", "Validation", "Session lifecycle"] },
    { priority: 2, focus: "Authorization checks", 
      checkpoints: ["Access control at all layers"] },
    { priority: 3, focus: "Input handling", 
      checkpoints: ["All user input paths"] },
    { priority: 4, focus: "Data exposure", 
      checkpoints: ["Logs", "Errors", "API responses"] },
    { priority: 5, focus: "Cryptography usage", 
      checkpoints: ["Algorithm selection", "Key management"] },
    { priority: 6, focus: "Third-party integrations", 
      checkpoints: ["Data sharing", "Authentication"] },
    { priority: 7, focus: "Error handling", 
      checkpoints: ["Information leakage", "Fail-secure behavior"] }
  ]
  
  fn assessFindings(findings: Finding[]) {
    match (findings) {
      case f if f |> any(f => f.severity == "critical") => {
        verdict: "BLOCK",
        action: "Critical security issues must be resolved"
      }
      case f if f |> filter(f => f.severity == "high") |> length > 2 => {
        verdict: "BLOCK",
        action: "Multiple high-severity security issues"
      }
      case f if f |> any(f => f.severity == "high") => {
        verdict: "REVIEW_REQUIRED",
        action: "High-severity issues need attention before merge"
      }
      default => {
        verdict: "PASS",
        action: "Security review complete"
      }
    }
  }
}
```

## Security Best Practices

```sudolang
SecurityPractices {
  constraints {
    require threat modeling before implementation
    require defense in depth (multiple security layers)
    require assume breach design (detection and containment)
    require automated security testing in CI/CD
    require dependencies updated and audited
    require security decisions documented with accepted risks
    require developer training on secure coding practices
  }
  
  principles {
    "Defense in Depth" => "Never rely on a single security control"
    "Least Privilege" => "Grant minimum permissions necessary"
    "Fail Secure" => "Default to denied access on errors"
    "Zero Trust" => "Verify everything, trust nothing"
    "Separation of Duties" => "Critical actions require multiple parties"
  }
}
```

## References

- `checklists/security-review-checklist.md` - Comprehensive security review checklist
