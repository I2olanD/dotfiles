---
description: "Parallel multi-agent codebase health check across type safety, dead code, test coverage, security, and performance dimensions. Produces a unified prioritized report."
argument-hint: "package or directory to audit (e.g., 'packages/api', 'src/', or 'all')"
allowed-tools:
  ["bash", "grep", "glob", "read", "write", "edit", "question", "skill"]
---

# Audit

Roleplay as a senior engineering lead who runs comprehensive parallel audits across a codebase and synthesizes findings into a single actionable report.

**Audit Target**: $ARGUMENTS

Audit {

    Constraints {
        Launch all applicable audit dimensions simultaneously in a single response.
        Each dimension agent must return structured findings with file, line, severity, and suggested fix.
        Synthesize findings into a unified report sorted by severity.
        Deduplicate findings that overlap across dimensions (e.g., dead code found by both Dead Code and Type Safety agents).
        Include a strengths section — highlight what's done well.
        Dead Code dimension is identification-only — delegate removals to /sweep for safe-removal verification.
        Never present raw per-dimension dumps — synthesize into one report.
        Never block on one dimension to start another — all run in parallel.
    }

    AuditDimensions {
        | Dimension | Intent | What to Find | Activation |
        |-----------|--------|-------------|------------|
        | Type Safety | Find unsafe type patterns | `any` types, unsafe casts (`as`), missing null checks, untyped function parameters, implicit any returns | Typed languages (TypeScript, Go, Rust, Java) |
        | Dead Code | Identify unused code (identification only — removals via /sweep) | Unused exports, orphaned files, unreachable branches, unused dependencies | Always |
        | Test Coverage | Find untested paths | Untested public functions, missing edge case tests, untested error paths, low-coverage modules | Projects with test infrastructure |
        | Security | Find vulnerabilities | Input validation gaps, auth/authz issues, injection risks, hardcoded secrets, unsafe deserialization | Projects with runtime code |
        | Performance | Find efficiency issues | N+1 queries, unnecessary re-renders, missing memoization, blocking operations, large bundle contributors | Projects with runtime code |
    }

    FindingFormat {
        Each agent must return findings as:
        | Field | Description |
        |-------|-------------|
        | file | File path |
        | line | Line number or range |
        | severity | CRITICAL / HIGH / MEDIUM / LOW |
        | dimension | Which audit dimension found it |
        | description | What the issue is |
        | suggested_fix | How to fix it |
    }

    SeverityGuidelines {
        CRITICAL => Data loss, security vulnerability, production crash risk
        HIGH     => Significant bug risk, major performance issue, blocking technical debt
        MEDIUM   => Code quality issue, moderate risk, missing coverage for important path
        LOW      => Minor improvement, style suggestion, optional optimization
    }

    Workflow {

        Phase1_Scope {
            Determine audit scope from $ARGUMENTS.

            match (target) {
                "all"       => audit entire project (for monorepos: suggest package-level scoping first)
                directory   => audit specified directory
                empty       => ask user for target
            }

            Identify project structure, tech stack, and test infrastructure.
            Determine which dimensions apply using Activation rules from AuditDimensions.
            Skip dimensions that don't match the project type (e.g., skip Type Safety for untyped languages).
        }

        Phase2_LaunchAudits {
            Launch parallel subagents for all applicable dimensions simultaneously in a single response.

            Each agent receives:
            - Target scope
            - Dimension-specific checklist from AuditDimensions
            - Required output format from FindingFormat
            - Instruction to include file:line references for every finding
        }

        Phase3_Synthesize {
            1. Collect all findings from dimension agents.
            2. Deduplicate: findings within 5 lines of the same file, keep highest severity, merge descriptions.
            3. Sort by severity (descending), then by file path.
            4. Assign unified IDs: C1, C2, H1, H2, M1, L1...
            5. Build summary statistics: findings per dimension, severity distribution.
            6. Identify strengths: areas with good coverage, clean patterns, solid security.
        }

        Phase4_Report {
            Present unified report:

            1. Executive Summary — total findings by severity, overall health assessment
            2. Strengths — what's done well across the codebase
            3. Critical + High Findings — with code examples for non-obvious fixes
            4. Medium + Low Findings — table format only
            5. Dimension Breakdown — findings per dimension with trends

            Health assessment:
            match (criticalCount, highCount) {
                (0, 0)     => Healthy
                (0, 1..3)  => Good with minor issues
                (0, 4+)    => Needs attention
                (1+, _)    => Critical issues — address immediately
            }
        }

        Phase5_NextSteps {
            Ask user:
                "Fix all critical and high issues" — auto-apply fixes with tests
                "Fix specific findings" — select by ID
                "Export report" — save to .engineer/audits/YYYY-MM-DD-audit.md
                "Run /sweep for dead code" — delegate to sweep command
                "Done" — no action
        }
    }

}

## Integration with Other Skills

- /sweep — for deep dead code analysis with proof-before-removal (more thorough than audit's dead code dimension)
- /review — for PR-scoped review (audit is codebase-wide)
- /test — for running and fixing test suite after audit-driven changes

## Important Notes

- Launch all applicable dimension agents simultaneously — skip dimensions that don't match the project type
- Deduplicate cross-dimension findings (e.g., dead code found by both Type Safety and Dead Code agents)
- Include strengths section — codebase health is not just about problems
- Health assessment drives urgency: Critical issues block, High issues need attention, Medium/Low are optional
- Dead code dimension is identification-only — delegate actual removals to /sweep which applies the safe-removal protocol (code-quality-review skill)
