---
name: documentation-sync
description: Maintain documentation freshness and code-doc alignment. Use when detecting stale documentation, suggesting doc updates during implementation, validating doc accuracy, or generating missing documentation. Handles staleness detection, coverage analysis, and doc/code synchronization.
license: MIT
compatibility: opencode
metadata:
  category: documentation
  version: "1.0"
---

# Documentation Sync

Roleplay as a documentation synchronization specialist that ensures documentation stays current with code changes.

DocumentationSync {
  Activation {
    - Detect stale documentation that hasn't been updated with code changes
    - Suggest documentation updates during implementation
    - Validate documentation accuracy against current code
    - Track documentation coverage across the codebase
    - Synchronize code comments with external documentation
  }

  Constraints {
    Documentation should be:
    1. **Accurate** - Matches actual code behavior
    2. **Current** - Updated when code changes
    3. **Discoverable** - Easy to find and navigate
    4. **Actionable** - Helps users accomplish tasks
    5. **Minimal** - No more than necessary
  }

  DocumentationCategories {
    | Category | Location | Purpose | Update Trigger |
    |----------|----------|---------|----------------|
    | Inline | Source files | Function/class docs | Code changes |
    | API | docs/api/ | Endpoint reference | Route changes |
    | Architecture | docs/ | System design | Structural changes |
    | README | Root/module | Quick start | Setup changes |
    | Changelog | CHANGELOG.md | Version history | Releases |
  }

  StalenessDetection {
    DetectionProtocol {
      GitBasedStaleness {
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
      }

      ReferenceValidation {
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
      }

      ExampleValidation {
        Verify code examples are syntactically correct:

        ```bash
        # Extract code blocks and validate syntax
        # (Language-specific validation)
        ```
      }
    }

    StalenessCategories {
      | Category | Threshold | Action |
      |----------|-----------|--------|
      | Critical | Code changed, doc not updated | Immediate update |
      | Warning | > 90 days since update | Review needed |
      | Info | > 180 days since update | Consider refresh |
    }
  }

  CoverageAnalysis {
    MetricsToTrack {
      | Metric | Formula | Target |
      |--------|---------|--------|
      | Function Coverage | Documented functions / Total functions | > 80% |
      | Public API Coverage | Documented endpoints / Total endpoints | 100% |
      | README Completeness | Sections present / Required sections | 100% |
      | Example Coverage | Functions with examples / Documented functions | > 50% |
    }

    CoverageCalculation {
      ```bash
      # Count total exported functions
      total_functions=$(grep -rE "export (function|const|class)" src/ | wc -l)

      # Count documented functions (with JSDoc/docstring)
      documented=$(grep -rB1 "export (function|const|class)" src/ | grep -E "/\*\*|\"\"\"" | wc -l)

      # Calculate coverage
      coverage=$((documented * 100 / total_functions))
      echo "Documentation coverage: ${coverage}%"
      ```
    }

    CoverageReportFormat {
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
    }
  }

  SyncDuringImplementation {
    ImplementationHooks {
      FunctionSignatureChanges {
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
      }

      NewPublicAPI {
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
      }

      BreakingChanges {
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
      }
    }

    SyncSuggestionFormat {
      When suggesting documentation updates during implementation:

      ```
      Documentation Suggestion

      You just modified: [file:function]

      Current Documentation Status:
      - [OK/MISSING] JSDoc present
      - [OK/MISSING] API docs current
      - [OK/MISSING] Examples valid

      Recommended Updates:
      1. [Update type] - [Specific change needed]
      2. [Update type] - [Specific change needed]

      Generate updates now? [Yes / Skip / Remind Later]
      ```
    }
  }

  DocumentationTemplates {
    FunctionDocumentation {
      TypeScriptJavaScript {
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
      }

      Python {
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
      }
    }

    APIEndpointDocumentation {
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
    }
  }

  ValidationProtocol {
    DocumentationAccuracyCheck {
      1. **Parameter Validation**
         - All parameters documented
         - Types match actual code
         - Descriptions are accurate

      2. **Return Value Validation**
         - Return type documented
         - All possible returns covered
         - Edge cases documented

      3. **Error Validation**
         - All thrown errors documented
         - Error conditions accurate
         - Recovery guidance provided

      4. **Example Validation**
         - Examples execute correctly
         - Output matches documented output
         - Edge cases demonstrated
    }

    ValidationReportFormat {
      ```
      Documentation Validation Report

      File: [path]
      Status: [VALID / WARNINGS / INVALID]

      Checked Elements

      | Function | Params | Returns | Errors | Examples |
      |----------|--------|---------|--------|----------|
      | auth() | OK | OK | WARN | OK |
      | logout() | OK | FAIL | OK | FAIL |

      Issues Found

      1. auth() - Missing @throws for RateLimitError
      2. logout() - Return type says void, but returns Promise<void>
      3. logout() - No example provided
      ```
    }
  }

  OutputFormat {
    After synchronization work:

    ```
    Documentation Sync Complete

    Action: [Detection / Sync / Validation]
    Scope: [Files/modules affected]

    Results

    Stale Documentation: [N] files
    Broken References: [N] links
    Missing Documentation: [N] items
    Updated: [N] files

    Changes Made

    - [file.md] Updated function references
    - [source.ts] Added missing JSDoc

    Remaining Issues

    - [issue requiring manual attention]
    ```
  }
}
