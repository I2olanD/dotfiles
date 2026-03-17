---
description: "Multi-agent code review with specialized perspectives (security, performance, patterns, simplification, tests)"
argument-hint: "PR number, branch name, file path, or 'staged' for staged changes"
allowed-tools: ["bash", "read", "glob", "grep", "question", "skill"]
---

# Review

Roleplay as a multi-perspective code review orchestrator that coordinates comprehensive review feedback across specialized perspectives.

**Review Target**: $ARGUMENTS

Review {

    Constraints {
        Cover all applicable review perspectives thoroughly.
        Launch all applicable review perspectives simultaneously where possible.
        Provide full file context for each perspective, not just diffs.
        Highlight what's done well in a strengths section.
        Present synthesized output to user — not raw per-perspective dumps.
        Never present findings without actionable fix recommendations.
        Never review without full file context.
    }

    AlwaysReviewPerspectives {
        | Perspective | Intent | What to Look For |
        |-------------|--------|------------------|
        | Security | Find vulnerabilities before production | Auth/authz gaps, injection risks, hardcoded secrets, input validation, CSRF, cryptographic weaknesses |
        | Simplification | Aggressively challenge unnecessary complexity | YAGNI violations, over-engineering, premature abstraction, dead code, "clever" code |
        | Performance | Identify efficiency issues | N+1 queries, algorithm complexity, resource leaks, blocking operations, caching opportunities |
        | Quality | Ensure code meets standards | SOLID violations, naming issues, error handling gaps, pattern inconsistencies, code smells |
        | Testing | Verify adequate coverage | Missing tests for new code paths, edge cases not covered, test quality issues |
    }

    ConditionalPerspectives {
        | Perspective | Intent | Activation Rule |
        |-------------|--------|-----------------|
        | Concurrency | Find race conditions and async issues | Code uses async/await, threading, shared state, parallel operations |
        | Dependencies | Assess supply chain security | Changes to package.json, requirements.txt, go.mod, Cargo.toml, etc. |
        | Compatibility | Detect breaking changes | Modifications to public APIs, database schemas, config formats, migration files |
        | Accessibility | Ensure inclusive design | Frontend/UI component changes |
        | Dead Code | Find orphaned code left behind by changes | Any code deletion, refactoring, or feature removal |
        | Constitution | Check project rules compliance | Project has CONSTITUTION.md |
    }

    SeverityClassification {
        | Level | Definition | Action |
        |-------|------------|--------|
        | CRITICAL | Security vulnerability, data loss risk, or system crash | Must fix before merge |
        | HIGH | Significant bug, performance issue, or breaking change | Should fix before merge |
        | MEDIUM | Code quality issue, maintainability concern, or missing test | Consider fixing |
        | LOW | Style preference, minor improvement, or suggestion | Nice to have |

        | Confidence | Definition |
        |------------|------------|
        | HIGH | Clear violation of established pattern or security rule |
        | MEDIUM | Likely issue but context-dependent |
        | LOW | Potential improvement, may not be applicable |
    }

    CommonClassifications {
        SQL Injection       => CRITICAL / HIGH confidence
        XSS Vulnerability   => CRITICAL / HIGH confidence
        Hardcoded Secret    => CRITICAL / HIGH confidence
        N+1 Query           => HIGH / HIGH confidence
        Missing Auth Check  => CRITICAL / MEDIUM confidence
        No Input Validation => MEDIUM / HIGH confidence
        Long Function       => LOW / HIGH confidence
        Missing Test        => MEDIUM / MEDIUM confidence
    }

    ReviewChecklists {
        Security {
            Auth/Authorization: proper checks before sensitive operations, no privilege escalation, secure sessions
            Injection: SQL uses parameterized statements, XSS prevention (output encoding), command injection prevention
            Data Protection: no hardcoded secrets, sensitive data encrypted, PII handled per policy
            Input Validation: all user inputs validated, proper sanitization, safe deserialization
        }

        DeadCode {
            Orphaned Exports: functions/types exported but no longer imported after the change
            Orphaned Imports: imports that reference removed or renamed symbols
            Unreachable Code: code after early returns, disabled branches, impossible conditions
            Orphaned Dependencies: packages no longer imported after the change (apply safe-removal protocol from code-quality-review skill)
            Orphaned Files: files no longer imported from any other file after the change
        }

        Performance {
            Database: no N+1 queries, efficient indexes, pagination for large datasets, connection pooling
            Computation: efficient algorithms (no O(n²) when O(n) possible), proper caching, no unnecessary recomputations
            Resources: no memory leaks, proper cleanup, async where appropriate, no blocking in event loops
        }

        Quality {
            Structure: single responsibility, functions < 20 lines, no deep nesting (< 4 levels), DRY
            Naming: intention-revealing names, consistent terminology, self-documenting code
            ErrorHandling: errors handled at appropriate level, specific messages, no swallowed exceptions
            Standards: follows coding conventions, consistent with existing patterns, type safety
        }

        Testing {
            Coverage: happy path, error cases, edge cases, boundary conditions
            Quality: tests are independent, deterministic, proper assertions, mocking at boundaries
            Organization: tests match code structure, clear test names, proper setup/teardown
        }
    }

    Workflow {
        Phase1_GatherContext {
            Determine review target from $ARGUMENTS:
                match (target) {
                    /^\d+$/       => gh pr diff $target          (PR number)
                    "staged"      => git diff --cached           (staged changes)
                    containsSlash => read file + recent changes  (file path)
                    default       => git diff main...$target     (branch name)
                }

            Retrieve full file contents for context (not just diff).

            Determine conditional perspectives:
                match (changes) {
                    async/await | Promise | threading  => +Concurrency
                    dependency file changes            => +Dependencies
                    public API | schema changes        => +Compatibility
                    frontend component changes         => +Accessibility
                    CONSTITUTION.md exists             => +Constitution
                }
        }

        Phase2_LaunchReviews {
            Launch parallel subagents per applicable perspectives simultaneously in a single response.
        }

        Phase3_SynthesizeFindings {
            Process findings:
                1. Deduplicate by location (within 5 lines), keeping highest severity and merging complementary details.
                2. Sort by severity descending, then confidence descending.
                3. Assign IDs using pattern: $severityLetter$number (C1, C2, H1, M1, L1...).
                4. Build summary table.

            FindingTable {
                ID:          Severity letter + number (C1, H1, M1, L1)
                Finding:     Brief title + location in italics (e.g., "Missing null check *(auth/service.ts:42)*")
                Remediation: Fix recommendation + issue context in italics
            }

            CodeExampleRules {
                REQUIRED for all Critical findings (before/after style)
                Include for High findings when fix is non-obvious
                Omit for Medium/Low findings (table-only format)
            }

            Determine verdict:
                match (criticalCount, highCount, mediumCount) {
                (> 0, _, _)     => REQUEST CHANGES
                (0, > 3, _)     => REQUEST CHANGES
                (0, 1..3, _)    => APPROVE WITH COMMENTS
                (0, 0, > 0)     => APPROVE WITH COMMENTS
                (0, 0, 0)       => APPROVE
            }
        }

        Phase4_NextSteps {
            match (verdict) {
                REQUEST CHANGES => {
                    "Address critical issues first"
                    "Show me fixes for [specific issue]"
                    "Explain [finding] in more detail"
                }

                APPROVE WITH COMMENTS => {
                    "Apply suggested fixes"
                    "Create follow-up issues for medium findings"
                    "Proceed without changes"
                }

                APPROVE => {
                    "Add to PR comments (if PR review)"
                    "Done"
                }
            }
        }
    }

}

## Important Notes

- Launch all applicable review perspectives simultaneously in a single response for efficiency
- Always include full file context for reviewers, not just the diff
- Deduplicate findings within 5 lines, keeping highest severity and merging complementary details
- Verdict is determined by critical/high counts; always include a strengths section with what's done well
- Code examples required for Critical findings; include for non-obvious High findings only
