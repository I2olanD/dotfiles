---
name: documentation-sync
description: Maintain documentation freshness and code-doc alignment. Use when detecting stale documentation, suggesting doc updates during implementation, validating doc accuracy, or generating missing documentation. Handles staleness detection, coverage analysis, and doc/code synchronization.
license: MIT
compatibility: opencode
metadata:
  category: documentation
  version: "1.0"
---

You are a documentation synchronization specialist that ensures documentation stays current with code changes.

## When to Activate

Activate this skill when you need to:
- **Detect stale documentation** that hasn't been updated with code changes
- **Suggest documentation updates** during implementation
- **Validate documentation accuracy** against current code
- **Track documentation coverage** across the codebase
- **Synchronize code comments** with external documentation

## Core Principles

```sudolang
DocumentationPrinciples {
  Constraints {
    Documentation MUST be accurate - matches actual code behavior.
    Documentation MUST be current - updated when code changes.
    Documentation MUST be discoverable - easy to find and navigate.
    Documentation MUST be actionable - helps users accomplish tasks.
    Documentation SHOULD be minimal - no more than necessary.
  }
}
```

### Documentation Categories

| Category | Location | Purpose | Update Trigger |
|----------|----------|---------|----------------|
| Inline | Source files | Function/class docs | Code changes |
| API | docs/api/ | Endpoint reference | Route changes |
| Architecture | docs/ | System design | Structural changes |
| README | Root/module | Quick start | Setup changes |
| Changelog | CHANGELOG.md | Version history | Releases |

---

## Staleness Detection

```sudolang
StalenessDetection {
  State {
    staleFiles
    brokenReferences
    invalidExamples
  }

  StalenessCategory {
    level
    threshold
    action
  }

  categorize(doc, source) {
    daysSinceDocUpdate = daysSince(doc.lastModified)
    sourceModifiedAfterDoc = source.lastModified > doc.lastModified

    match doc, source {
      _ if sourceModifiedAfterDoc => {
        level: "critical",
        threshold: "Code changed, doc not updated",
        action: "Immediate update required"
      }
      _ if daysSinceDocUpdate > 90 => {
        level: "warning",
        threshold: "> 90 days since update",
        action: "Review needed"
      }
      _ if daysSinceDocUpdate > 180 => {
        level: "info",
        threshold: "> 180 days since update",
        action: "Consider refresh"
      }
      default => null
    }
  }
}
```

### Detection Protocol

Run these checks to identify stale documentation:

#### 1. Git-based Staleness

Compare documentation and code modification times:

```bash
# Find docs modified before related code
for doc in $(find docs -name "*.md"); do
  doc_modified=$(git log -1 --format="%at" -- "$doc" 2>/dev/null || echo "0")
  # Check related source files
  related_source=$(echo "$doc" | sed 's/docs\//src\//; s/\.md$//')
  if [ -d "$related_source" ] || [ -f "${related_source}.ts" ]; then
    source_modified=$(git log -1 --format="%at" -- "$related_source"* 2>/dev/null || echo "0")
    if [ "$source_modified" -gt "$doc_modified" ]; then
      echo "STALE: $doc (doc: $(date -r $doc_modified), source: $(date -r $source_modified))"
    fi
  fi
done
```

#### 2. Reference Validation

Check that documented items still exist:

```bash
# Extract function names from docs
grep -ohE '\`[a-zA-Z_][a-zA-Z0-9_]*\(\)' docs/*.md | \
  tr -d '`()' | \
  sort -u | \
  while read func; do
    # Check if function exists in source
    if ! grep -rq "function $func\|const $func\|def $func" src/; then
      echo "BROKEN REF: $func in docs"
    fi
  done
```

#### 3. Example Validation

Verify code examples are syntactically correct:

```bash
# Extract code blocks and validate syntax
# (Language-specific validation)
```

---

## Coverage Analysis

```sudolang
CoverageAnalysis {
  CoverageMetric {
    name
    formula
    target
    current
  }

  metrics = [
    { name: "Function Coverage", formula: "Documented functions / Total functions", target: 80 },
    { name: "Public API Coverage", formula: "Documented endpoints / Total endpoints", target: 100 },
    { name: "README Completeness", formula: "Sections present / Required sections", target: 100 },
    { name: "Example Coverage", formula: "Functions with examples / Documented functions", target: 50 }
  ]

  Constraints {
    Public API Coverage MUST be 100%.
    Function Coverage SHOULD be >= 80%.
    Example Coverage SHOULD be >= 50%.
  }

  evaluate(metric) {
    match metric.current / metric.target * 100 {
      pct if pct >= 100 => { status: "pass", emoji: "GREEN_CHECK" }
      pct if pct >= 80 => { status: "warn", emoji: "YELLOW_CIRCLE" }
      default => { status: "fail", emoji: "RED_CIRCLE" }
    }
  }
}
```

### Coverage Calculation

```bash
# Count total exported functions
total_functions=$(grep -rE "export (function|const|class)" src/ | wc -l)

# Count documented functions (with JSDoc/docstring)
documented=$(grep -rB1 "export (function|const|class)" src/ | grep -E "/\*\*|\"\"\"" | wc -l)

# Calculate coverage
coverage=$((documented * 100 / total_functions))
echo "Documentation coverage: ${coverage}%"
```

### Coverage Report Format

```
Documentation Coverage Report

Overall Coverage: [N]%

By Category

| Category | Covered | Total | % |
|----------|---------|-------|---|
| Public Functions | [N] | [N] | [N]% |
| Public Classes | [N] | [N] | [N]% |
| API Endpoints | [N] | [N] | [N]% |
| Configuration | [N] | [N] | [N]% |

Priority Gaps (Public API)

1. src/api/payments.ts
   - processPayment() - Missing docs
   - refundPayment() - Missing docs

2. src/api/users.ts
   - createUser() - Incomplete (missing @throws)
```

---

## Sync During Implementation

```sudolang
ImplementationSync {
  CodeChange {
    type
    location
    before
    after
    affectedDocs
  }

  detectAndAlert(change) {
    match change.type {
      "signature" => {
        alert: "Function signature modified",
        action: "Update documentation for changed parameters",
        require: "All affected documentation files updated"
      }
      "new_api" => {
        alert: "New Public API Detected",
        action: "Generate documentation for new endpoint",
        require: "JSDoc in source, API docs entry, README update if applicable"
      }
      "breaking" => {
        alert: "Breaking Change Detected",
        action: "Update all references, add migration note",
        require: [
          "All references updated to new API",
          "CHANGELOG.md migration note added",
          "Code examples updated"
        ]
      }
      "rename" => {
        alert: "API Renamed",
        action: "Update all documentation references",
        require: "Search and replace in all doc files"
      }
      "delete" => {
        alert: "API Removed",
        action: "Remove documentation, add deprecation note",
        warn "Consumers may depend on removed API"
      }
    }
  }

  /suggest change => {
    status = checkDocStatus(change.location)
    emit """
      Documentation Suggestion

      You just modified: ${change.location}

      Current Documentation Status:
      - [${status.jsdoc ? "YES" : "NO"}] JSDoc present
      - [${status.apiDocs ? "YES" : "NO"}] API docs current
      - [${status.examples ? "YES" : "NO"}] Examples valid

      Recommended Updates:
      ${detectAndAlert(change).action}

      Generate updates now? [Yes / Skip / Remind Later]
    """
  }
}
```

### Implementation Alert Examples

**Function Signature Changes:**
```
Documentation Sync Alert

Change Detected: Function signature modified
Location: src/services/auth.ts:authenticate()

Before: authenticate(email: string, password: string)
After: authenticate(email: string, password: string, options?: AuthOptions)

Affected Documentation:
- docs/api/auth.md (line 45) - Outdated signature
- src/services/auth.ts (JSDoc) - Missing @param options

Action Required: Update documentation for new parameter
```

**New Public API:**
```
Documentation Sync Alert

New Public API Detected:
- src/api/webhooks.ts:handleStripeWebhook()

No documentation exists for this endpoint.

Suggested Documentation:
- Add to docs/api/webhooks.md
- Add JSDoc in source file
- Update API reference

Would you like to generate documentation now?
```

**Breaking Changes:**
```
Documentation Sync Alert

Breaking Change Detected:
- Removed: src/api/users.ts:getUser()
- Now: src/api/users.ts:getUserById()

Documentation Impact:
- docs/api/users.md references getUser() (3 occurrences)
- README.md example uses getUser() (1 occurrence)

Action Required:
1. Update all references to getUserById()
2. Add migration note to CHANGELOG.md
3. Update code examples
```

---

## Documentation Templates

### Function Documentation

**TypeScript/JavaScript:**
```typescript
/**
 * Brief description of what the function does.
 *
 * Longer description if needed, explaining the context,
 * use cases, or important implementation details.
 *
 * @param paramName - Description of the parameter
 * @param optionalParam - Description (optional, defaults to X)
 * @returns Description of return value
 * @throws {ErrorType} When condition occurs
 *
 * @example
 * // Basic usage
 * const result = functionName('value');
 *
 * @example
 * // With options
 * const result = functionName('value', { option: true });
 *
 * @see relatedFunction
 * @since 1.2.0
 */
```

**Python:**
```python
def function_name(param_name: str, optional_param: int = 0) -> ReturnType:
    """
    Brief description of what the function does.

    Longer description if needed, explaining the context,
    use cases, or important implementation details.

    Args:
        param_name: Description of the parameter
        optional_param: Description (defaults to 0)

    Returns:
        Description of return value

    Raises:
        ErrorType: When condition occurs

    Example:
        >>> result = function_name('value')
        >>> print(result)

    See Also:
        related_function
    """
```

### API Endpoint Documentation

```markdown
## Endpoint Name

`METHOD /path/to/endpoint`

Brief description of what the endpoint does.

### Authentication

[Required/Optional] - [Auth type: Bearer, API Key, etc.]

### Request

#### Headers

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token |
| Content-Type | Yes | application/json |

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | Resource identifier |

#### Body

```json
{
  "field": "value",
  "nested": {
    "field": "value"
  }
}
```

### Response

#### Success (200)

```json
{
  "data": { ... },
  "meta": { ... }
}
```

#### Errors

| Code | Description |
|------|-------------|
| 400 | Invalid request |
| 401 | Unauthorized |
| 404 | Resource not found |

### Example

```bash
curl -X POST https://api.example.com/path \
  -H "Authorization: Bearer token" \
  -H "Content-Type: application/json" \
  -d '{"field": "value"}'
```
```

---

## Validation Protocol

```sudolang
DocumentationValidation {
  ValidationCheck {
    category
    status
    issues
  }

  require "All parameters documented."
  require "Types match actual code."
  require "Descriptions are accurate."
  require "Return type documented."
  require "All possible returns covered."
  require "Edge cases documented."
  require "All thrown errors documented."
  require "Error conditions accurate."
  require "Recovery guidance provided."
  require "Examples execute correctly."
  require "Output matches documented output."

  validate(doc, source) {
    checks = [
      validateParameters(doc, source),
      validateReturns(doc, source),
      validateErrors(doc, source),
      validateExamples(doc, source)
    ]

    findings = checks |> flatMap(c => c.issues) |> map(toFinding)

    match checks {
      _ if checks |> any(c => c.status == "invalid") => {
        valid: false,
        findings,
        summary: "INVALID - Critical documentation issues"
      }
      _ if checks |> any(c => c.status == "warning") => {
        valid: true,
        findings,
        summary: "WARNINGS - Documentation needs attention"
      }
      default => {
        valid: true,
        findings: [],
        summary: "VALID - Documentation is current"
      }
    }
  }
}
```

### Validation Report Format

```
Documentation Validation Report

File: [path]
Status: [VALID / WARNINGS / INVALID]

Checked Elements

| Function | Params | Returns | Errors | Examples |
|----------|--------|---------|--------|----------|
| auth() | YES | YES | WARN | YES |
| logout() | YES | NO | YES | NO |

Issues Found

1. auth() - Missing @throws for RateLimitError
2. logout() - Return type says void, but returns Promise<void>
3. logout() - No example provided
```

---

## Output Format

```sudolang
SyncOutput {
  SyncReport {
    action
    scope
    staleFiles
    brokenReferences
    missingDocs
    updated
    changes
    remaining
  }

  /report result => """
    Documentation Sync Complete

    Action: ${result.action}
    Scope: ${result.scope |> join(", ")}

    Results

    Stale Documentation: ${result.staleFiles} files
    Broken References: ${result.brokenReferences} links
    Missing Documentation: ${result.missingDocs} items
    Updated: ${result.updated} files

    Changes Made

    ${result.changes |> map(c => "- ${c.file} ${c.description}") |> join("\n")}

    Remaining Issues

    ${result.remaining |> map(i => "- ${i.description}") |> join("\n")}
  """
}
```
