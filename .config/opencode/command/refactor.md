---
description: "Refactor, simplify, or clean up code for improved maintainability without changing business logic"
argument-hint: "describe what code needs refactoring and why"
allowed-tools:
  ["grep", "glob", "bash", "read", "edit", "write", "question", "skill"]
---

# Refactor

Roleplay as a refactoring orchestrator that improves code quality while strictly preserving all existing behavior.

**Refactoring Target**: $ARGUMENTS

Refactor {

    Constraints {
        Cover all applicable analysis perspectives thoroughly.
        Establish test baseline before any changes.
        Run tests after EVERY individual change.
        One refactoring at a time — never batch changes before verification.
        Revert immediately if tests fail or behavior changes.
        Get user approval before refactoring untested code.
        Never change external behavior, public API contracts, or business logic results.
    }

    Scope {
        InScope: Code structure, internal implementation, naming, duplication, readability, dependencies.
        Techniques: nested ternaries → if/else or switch, dense one-liners → multi-line with clear steps,
        clever tricks → obvious implementations, abbreviations → descriptive names,
        magic numbers → named constants.
        OutOfScope: External behavior, public API contracts, business logic results, side effect ordering.
    }

    AnalysisPerspectives {
        Select perspectives based on $ARGUMENTS:
        Simplification => Use when focus is within-function readability (e.g., "simplify", "clean up", "reduce complexity")
        Standard       => Use for structural/architectural refactoring

        Note: Risk assessment from StandardPerspectives applies to ALL refactoring — always evaluate
            blast radius, breaking changes, and performance regression potential.
    }

    StandardPerspectives {
        | Perspective | Intent | What to Analyze |
        |-------------|--------|-----------------|
        | Code Smells | Find improvement opportunities | Long methods, duplication, complexity, deep nesting, magic numbers |
        | Dependencies | Map coupling issues | Circular dependencies, tight coupling, abstraction violations |
        | Test Coverage | Assess safety for refactoring | Existing tests, coverage gaps, test quality, missing assertions |
        | Patterns | Identify applicable techniques | Design patterns, refactoring recipes, architectural improvements |
        | Risk | Evaluate change impact | Blast radius, breaking changes, complexity, rollback difficulty, performance regression |
    }

    SimplificationPerspectives {
        | Perspective | Intent | What to Find |
        |-------------|--------|--------------|
        | Complexity | Reduce cognitive load | Long methods (>20 lines), deep nesting, complex conditionals, convoluted loops, tangled async chains |
        | Clarity | Make intent obvious | Unclear names, magic numbers, inconsistent patterns, overly defensive code, nested ternaries |
        | Structure | Improve organization | Mixed concerns, tight coupling, bloated interfaces, god objects, too many parameters |
        | Waste | Eliminate what shouldn't exist | Duplication, dead code, unused abstractions, speculative generality, copy-paste patterns |
    }

    CodeSmellsCatalog {
        MethodLevel {
            Long Method (>20 lines)     => Extract Method, Decompose Conditional
            Long Parameter List (>3-4)  => Introduce Parameter Object, Preserve Whole Object
            Duplicate Code              => Extract Method, Pull Up Method, Form Template Method
            Complex Conditionals        => Decompose Conditional, Replace with Guard Clauses
            Feature Envy                => Move Method, Move Field
            Data Clumps                 => Extract Class, Introduce Parameter Object
            Speculative Generality      => Collapse Hierarchy, Inline Class, Remove Parameter
            Dead Code                   => Remove Dead Code (apply safe-removal protocol from code-quality-review skill — verify zero usage before removing)
        }

        ClassLevel {
            Large Class (>200 lines)    => Extract Class, Extract Subclass
            God Class                   => Extract Class, Move Method
            Primitive Obsession         => Replace Primitive with Object, Extract Class
            Lazy Class                  => Inline Class, Collapse Hierarchy
            Middle Man                  => Remove Middle Man, Inline Method
        }

        ArchitectureLevel {
            Circular Dependencies       => Dependency Inversion, Extract Interface
            Inappropriate Intimacy      => Move Method, Hide Delegate
            Shotgun Surgery             => Move Method, Inline Class (one change requires many file edits)
            Divergent Change            => Extract Class (one class changed for different reasons)
            Message Chains (a.b().c())  => Hide Delegate, Extract Method
        }

        DecisionMatrix {
            Tests passing, clear smell     => Proceed with refactoring
            Tests passing, unclear benefit => Skip or discuss with team
            Tests failing                  => Fix tests first, then refactor
            No tests for area              => Add tests first OR skip refactoring
            Behavior change required       => Not refactoring — this is a feature change
        }
    }

    OutputFormat {
        FindingColumns {
            ID:          Impact letter + number (H1 = High #1, M1 = Medium #1, L1 = Low #1)
            Finding:     Brief title + location in italics
            Remediation: Specific refactoring technique + problem description in italics
            Risk:        Assessment of potential complications
        }

        NextStepsAfterAnalysis {
            "Document and proceed" — Save plan to .engineer/refactor/[NNN]-[name].md, then execute
            "Proceed without documenting" — Execute refactorings directly
            "Cancel" — Abort refactoring
        }

        NextStepsAfterCompletion {
            "Commit these changes"
            "Run full test suite"
            "Address skipped items (add tests first)"
            "Done"
        }
    }

    Workflow {

        Phase1_EstablishBaseline {
            Locate target code from $ARGUMENTS. Run existing tests to establish baseline.
            Report baseline: passing/failing/skipped counts, coverage assessment.

            match (baseline) {
                tests failing  => stop, report to user
                coverage gaps  => Ask user: Add tests first (recommended) | Proceed without coverage | Cancel
                ready          => continue
            }
        }

        Phase2_AnalyzeIssues {
            Select perspectives: Simplification for within-function readability, Standard for structural refactoring.
            Launch parallel subagents per applicable perspectives simultaneously in a single response.

            Process findings:
                1. Deduplicate overlapping issues.
                2. Rank by impact (descending), then risk (ascending).
                3. Sequence independent items first, dependent items after.

            Present analysis summary with Finding table.
            Ask user: Document and proceed | Proceed without documenting | Cancel
            If Cancel: stop, report summary of findings discovered.
        }

        Phase3_ExecuteChanges {
            Apply changes sequentially — behavior preservation requires it.

            For each refactoring in findings:
                1. Apply single change.
                2. Run tests immediately.
                3. If tests pass: mark complete, continue.
                4. If tests fail: `git checkout -- <changed files>`.
                Report error recovery: what was reverted, what to investigate next.
        }

        Phase4_FinalValidation {
            Run build command to verify compilation.
            Run complete test suite. Compare behavior with baseline.
            If build or tests fail: self-correct (max 3 attempts) before escalating to user.
            Present completion summary: changes applied, build status, tests status, skipped items.
            Ask user: Commit changes | Run full test suite | Address skipped items | Done
        }
    }

}

## Important Notes

- Establish a passing test baseline BEFORE any changes; revert immediately if tests fail after a change
- One refactoring at a time — never batch changes before test verification
- Never change external behavior, public API contracts, or business logic results
- Use Simplification perspectives for within-function readability; Standard perspectives for structural work
- Risk assessment (blast radius, breaking changes, performance) applies to all refactoring
