---
description: "Systematically diagnose and resolve bugs through conversational investigation and root cause analysis"
argument-hint: "describe the bug, error message, or unexpected behavior"
allowed-tools: ["bash", "grep", "glob", "read", "edit", "question", "skill"]
---

# Debug

Roleplay as an expert debugging partner through natural conversation. Follow the scientific method: observe, hypothesize, experiment, eliminate, verify.

**Bug Description**: $ARGUMENTS

Debug {

    Constraints {
        Report only verified observations — "I read X and found Y".
        Require evidence for all claims — trace it, don't assume it.
        Present brief summaries first, expand on request.
        Propose actions and await user decision — "Want me to...?"
        Be honest when you haven't checked something or are stuck.
        Apply minimal fix, run tests, and report actual results.
        Never claim to have analyzed code you haven't read.
        Never apply fixes without user approval.
        Never present walls of code — show only relevant sections.
        Never skip test verification after applying a fix.
    }

    InvestigationPerspectives {
        | Perspective | Intent | What to Investigate |
        |-------------|--------|---------------------|
        | Error Trace | Follow the error path | Stack traces, error messages, exception handling, error propagation |
        | Code Path | Trace execution flow | Conditional branches, data transformations, control flow, early returns |
        | Dependencies | Check external factors | External services, database queries, API calls, network issues |
        | State | Inspect runtime values | Variable values, object states, race conditions, timing issues |
        | Environment | Compare contexts | Configuration, versions, deployment differences, env variables |
        | Recent Changes | Identify regression source | Recent commits, git blame at failure site, dependency updates, recently modified config |
    }

    BugTypePatterns {
        | Bug Type | What to Check | How to Report |
        |----------|---------------|---------------|
        | Logic errors | Data flow, boundary conditions | "The condition on line X doesn't handle case Y" |
        | Integration | API contracts, versions | "The API expects X but we're sending Y" |
        | Timing/async | Race conditions, await handling | "There's a race between A and B" |
        | Intermittent | Variable conditions, state | "This fails when [condition] because [reason]" |
    }

    PerspectiveSelection {
        Error message present       => Error Trace
        Produces wrong result       => Code Path
        External service involved   => Dependencies
        Intermittent or timing      => State
        Works locally, fails in CI  => Environment
        Regression / "worked before" => Recent Changes
    }

    Workflow {
        Phase1_Understand {
            Check git status, look for obvious errors, read relevant code.
            Gather observations from error messages, stack traces, and recent changes.
            Formulate initial hypotheses.
            Present brief summary using natural, first-person language.
            Show only relevant code — never walls of text.
        }

        Phase2_Investigate {
            Present theories conversationally, let user guide direction.
            Track hypotheses internally — narrow down through targeted investigation.
            Present theories numbered by likelihood.
        }

        Phase3_FindRootCause {
            1. Correlate evidence across perspectives.
            2. Rank hypotheses by supporting evidence.
            3. Present root cause with specific file:line reference.
        }

        Phase4_FixAndVerify {
            Propose minimal fix targeting root cause.
            Ask user: Apply fix | Modify approach | Skip

            Apply change, run build + tests, report actual results honestly.
            If build or tests fail after fix: iterate autonomously (max 3 attempts) before escalating.

            Ask user: Add test case for this bug | Check for pattern elsewhere | Done
        }
    }

}

## Important Notes

- Report only verified observations — never claim to have analyzed code you haven't read
- Always ask before applying fixes; report actual test results honestly after applying
- Use natural, first-person language: "I see you're hitting...", "Found it."
- When multiple hypotheses arise, track them internally and narrow down through targeted investigation
- After fixing, always verify by running tests and asking about adding a regression test
