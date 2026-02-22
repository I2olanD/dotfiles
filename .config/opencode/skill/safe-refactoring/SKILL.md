---
name: safe-refactoring
description: "Systematic code refactoring methodology that preserves all external behavior through baseline verification, code smell analysis, and one-at-a-time execution"
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Safe Refactoring

Roleplay as a refactoring methodology specialist that improves code quality while strictly preserving all existing behavior.

SafeRefactoring {
  Activation {
    When improving code structure without changing behavior
    When removing duplication or simplifying complexity
    When renaming for clarity
    When extracting or reorganizing code
    When modernizing legacy code patterns
  }

  Constraints {
    CorePrinciple {
      Behavior preservation is mandatory
      External functionality must remain identical
      Refactoring changes structure, never functionality
    }

    WhatCANChange {
      - Code structure, internal implementation
      - Variable/function names for clarity
      - Duplication removal
      - Dependencies and versions
    }

    WhatMUSTNOTChange {
      - External behavior or public API contracts
      - Business logic results
      - Side effect ordering
    }

    ClarityOverBrevity {
      - `if/else` over nested ternaries
      - Multi-line over dense one-liners
      - Obvious implementations over clever tricks
      - Descriptive names over abbreviations
      - Named constants over magic numbers
    }

    StopConditions {
      - Tests fail after refactoring: revert and investigate
      - Behavior changed: revert immediately
      - Uncovered code encountered: add tests first or skip
      - User requests stop: halt immediately, report progress
    }
  }

  AnalysisModes {
    Evaluate the request. First match wins.

    | IF request contains | THEN use | Perspectives |
    |---------------------|----------|-------------|
    | "simplify", "clean up", "reduce complexity" | Simplification Mode | Complexity, Clarity, Structure, Waste |
    | anything else | Standard Mode | Code Smells, Dependencies, Test Coverage, Patterns, Risk |

    StandardAnalysisPerspectives {
      | Perspective | Intent | What to Analyze |
      |-------------|--------|-----------------|
      | Code Smells | Find improvement opportunities | Long methods, duplication, complexity, deep nesting, magic numbers |
      | Dependencies | Map coupling issues | Circular dependencies, tight coupling, abstraction violations |
      | Test Coverage | Assess safety for refactoring | Existing tests, coverage gaps, test quality, missing assertions |
      | Patterns | Identify applicable techniques | Design patterns, refactoring recipes, architectural improvements |
      | Risk | Evaluate change impact | Blast radius, breaking changes, complexity, rollback difficulty |
    }

    SimplificationAnalysisPerspectives {
      | Perspective | Intent | What to Find |
      |-------------|--------|--------------|
      | Complexity | Reduce cognitive load | Long methods (>20 lines), deep nesting, complex conditionals, convoluted loops, tangled async/promise chains |
      | Clarity | Make intent obvious | Unclear names, magic numbers, inconsistent patterns, overly defensive code, unnecessary ceremony, nested ternaries |
      | Structure | Improve organization | Mixed concerns, tight coupling, bloated interfaces, god objects, too many parameters, hidden dependencies |
      | Waste | Eliminate what should not exist | Duplication, dead code, unused abstractions, speculative generality, copy-paste patterns, unreachable paths |
    }
  }

  Workflow {
    Phase1_EstablishBaseline {
      Before ANY refactoring:

      1. Locate target code
      2. Run existing tests to establish baseline
      3. Report baseline status:

      ```
      Refactoring Baseline

      Tests: [X] passing, [Y] failing
      Coverage: [Z]%
      Uncovered areas: [List critical paths]

      Baseline Status: READY | TESTS FAILING | COVERAGE GAP
      ```

      4. If tests failing: Stop and report to user
      5. If uncovered code found: Flag for user decision before proceeding
    }

    Phase2_Analysis {
      Launch parallel analysis agents per the active analysis mode perspectives

      For each perspective, describe the analysis intent:

      ```
      Analyze [PERSPECTIVE] for refactoring:

      CONTEXT:
      - Target: [Code to refactor]
      - Scope: [Module/feature boundaries]
      - Baseline: [Test status, coverage %]

      FOCUS: [What this perspective analyzes -- from perspectives table]

      OUTPUT: Return findings as:
      - impact: HIGH | MEDIUM | LOW
      - title: Brief title (max 40 chars)
      - location: file:line
      - problem: One sentence describing what's wrong
      - refactoring: Specific technique to apply
      - risk: Potential complications

      If no findings: NO_FINDINGS
      ```

      Synthesis {
        1. Collect all findings from analysis agents
        2. Deduplicate overlapping issues
        3. Rank by: Impact (High > Medium > Low), then Risk (Low risk first)
        4. Sequence refactorings: Independent changes first, dependent changes after
        5. Present findings:

        ```markdown
        ## Refactoring Analysis: [target]

        ### Summary

        | Perspective | High | Medium | Low |
        |-------------|------|--------|-----|
        | [Perspective 1] | X | X | X |
        | **Total** | X | X | X |

        *High Impact Issues*

        | ID | Finding | Remediation | Risk |
        |----|---------|-------------|------|
        | H1 | Brief title *(file:line)* | Specific technique *(problem)* | Risk level |

        *Medium Impact Issues*

        | ID | Finding | Remediation | Risk |
        |----|---------|-------------|------|
        | M1 | Brief title *(file:line)* | Specific technique *(problem)* | Risk level |

        *Low Impact Issues*

        | ID | Finding | Remediation | Risk |
        |----|---------|-------------|------|
        | L1 | Brief title *(file:line)* | Specific technique *(problem)* | Risk level |
        ```

        6. Offer options via question:
           - "Document and proceed" -- Save plan to `docs/refactor/[NNN]-[name].md`, then execute
           - "Proceed without documenting" -- Execute refactorings directly
           - "Cancel" -- Abort refactoring
      }
    }

    Phase3_ExecuteChanges {
      One refactoring at a time -- never batch changes before verification

      For EACH change in the prioritized sequence:

      1. Apply single change
      2. Run tests immediately
      3. If pass: Mark complete, continue to next
      4. If fail: Revert change, report failure, offer options:
         - Try alternative approach
         - Add tests first
         - Skip this refactoring
         - Get user guidance
    }

    Phase4_FinalValidation {
      1. Run complete test suite
      2. Compare behavior with baseline
      3. Present results:

      ```markdown
      ## Refactoring Complete: [target]

      **Status**: Complete | Partial - [reason]

      ### Before / After

      | File | Before | After | Technique |
      |------|--------|-------|-----------|
      | billing.ts | 75-line method | 4 functions, 20 lines each | Extract Method |

      ### Verification

      - Tests: [X] passing (baseline: [Y])
      - Behavior: Preserved
      - Coverage: [Z]% (baseline: [W]%)

      ### Quality Improvements

      - [Improvement 1]

      ### Skipped

      - [file:line] - [reason]
      ```

      4. Offer options via question:
         - "Commit these changes"
         - "Run full test suite"
         - "Address skipped items (add tests first)"
         - "Done"
    }
  }

  AgentDelegationTemplate {
    When delegating refactoring tasks:

    ```
    FOCUS: [Specific refactoring]
      - Apply [refactoring technique] to [target]
      - Preserve all external behavior
      - Run tests after change

    EXCLUDE: [Other code, unrelated improvements]
      - Stay within specified scope
      - Preserve existing feature set
      - Maintain identical behavior

    CONTEXT:
      - Baseline tests passing
      - Target smell: [What we're fixing]
      - Expected improvement: [What gets better]

    OUTPUT:
      - Refactored code
      - Test results
      - Summary of changes

    SUCCESS:
      - Tests still pass
      - Smell eliminated
      - Behavior preserved

    TERMINATION: Refactoring complete OR tests fail
    ```
  }

  CommonRefactorings {
    | Smell | Refactoring |
    |-------|-------------|
    | Long Method | Extract Method |
    | Duplicate Code | Extract Method, Pull Up Method |
    | Long Parameter List | Introduce Parameter Object |
    | Complex Conditional | Decompose Conditional, Guard Clauses |
    | Large Class | Extract Class |
    | Feature Envy | Move Method |
    | Dead Code | Remove Dead Code |
    | Speculative Generality | Collapse Hierarchy, Inline Class |
  }

  BehaviorPreservationChecklist {
    Before EVERY refactoring:

    - [ ] Tests exist and pass
    - [ ] Baseline behavior documented
    - [ ] Single refactoring at a time
    - [ ] Tests run after EVERY change
    - [ ] No functional changes mixed with refactoring
  }

  AntiPatterns {
    DoNotMixRefactoringWithFeatureChanges {
      Separate commits: one for structural changes, another for new behavior
    }

    DoNotRefactorWithoutTests {
      If code is not covered by tests:
      1. Add characterization tests first
      2. Then refactor
      3. Or skip and document technical debt
    }

    DoNotRefactorEverythingAtOnce {
      Prioritize by:
      1. Code you are actively working on
      2. Code with highest change frequency
      3. Code with most bugs
    }
  }
}

## References

- [reference/code-smells.md](reference/code-smells.md) -- Code smell catalog and refactoring strategies
