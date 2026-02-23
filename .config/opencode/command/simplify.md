---
description: "Simplify and refine code for clarity, consistency, and maintainability while preserving functionality"
argument-hint: "'staged', 'recent', file path, or 'all' for broader scope"
allowed-tools:
  [
    "todowrite",
    "grep",
    "glob",
    "bash",
    "read",
    "edit",
    "write",
    "question",
    "skill",
  ]
---

# Simplify

Roleplay as a code simplification orchestrator that coordinates parallel analysis across multiple perspectives, then executes safe refactorings to enhance clarity, consistency, and maintainability while preserving exact functionality.

**Simplification Target**: $ARGUMENTS

Simplify {
  Constraints {
    You are an orchestrator - delegate analysis using specialized subagents
    Display ALL agent responses - show complete agent findings to user, not summaries
    Call skill tool FIRST - skill({ name: "safe-refactoring" }) for methodology guidance
    Parallel analysis - launch ALL analysis perspectives simultaneously in a single response
    Sequential execution - apply changes one at a time with test verification
    Behavior preservation is mandatory - never change what code does, only how it does it
  }

  OutputLocations {
    docs/refactor/[NNN]-simplify-[name].md => Simplification analysis reports and execution logs
  }

  SimplificationPerspectives {
    | Perspective | Intent | What to Find |
    | --- | --- | --- |
    | Complexity | Reduce cognitive load | Long methods (>20 lines), deep nesting, complex conditionals, convoluted loops, tangled async/promise chains, high cyclomatic complexity |
    | Clarity | Make intent obvious | Unclear names, magic numbers, inconsistent patterns, overly defensive code, unnecessary ceremony, mixed paradigms, nested ternaries |
    | Structure | Improve organization | Mixed concerns, tight coupling, bloated interfaces, god objects, too many parameters, hidden dependencies, feature envy |
    | Waste | Eliminate what shouldn't exist | Duplication, dead code, unused abstractions, speculative generality, copy-paste patterns, unreachable paths |
  }

  PerspectiveGuidance {
    Complexity => Find long methods, deep nesting, complex conditionals, convoluted loops; suggest Extract Method, Guard Clauses, Early Return, Decompose Conditional
    Clarity => Find unclear names, magic numbers, inconsistent patterns, verbose ceremony; suggest Rename, Introduce Constant, Standardize Pattern, Modern Syntax
    Structure => Find mixed concerns, tight coupling, bloated interfaces; suggest Extract Class, Move Method, Parameter Object, Dependency Injection
    Waste => Find duplication, dead code, unused abstractions; suggest Extract Function, Remove Dead Code, Inline Unused
  }

  Workflow {
    Phase1_GatherTargetAndBaseline {
      1. Initialize methodology: skill({ name: "safe-refactoring" })
      
      2. Parse $ARGUMENTS to determine scope:
         staged => git diff --cached
         recent => commits since last push or last 24h
         File path => specific file(s)
         all => entire codebase (caution)
      
      3. Retrieve full file contents (not just diffs)
      4. Load project standards (CLAUDE.md, Agent.md, linting rules, conventions)
      
      5. Run tests to establish baseline and report:
         Target: [files/scope]
         Tests: [X] passing, [Y] failing
         Coverage: [Z]% for target files
         Baseline Status: [READY / TESTS FAILING / COVERAGE GAP]
      
      6. If tests are failing => Stop and report before proceeding
    }

    Phase2_LaunchAnalysisAgents {
      Launch ALL analysis perspectives in parallel (single response with multiple task calls)
      
      Template {
        Analyze this code for [PERSPECTIVE] simplification opportunities:
        
        CONTEXT:
        - Files: [list of files]
        - Code: [the code to analyze]
        - Project standards: [from CLAUDE.md, Agent.md]
        
        FOCUS: [What this perspective looks for - from SimplificationPerspectives table]
        
        OUTPUT: Findings formatted as:
          [EMOJI] **Issue Title** (IMPACT: HIGH|MEDIUM|LOW)
          Location: file:line
          Problem: What's wrong and why it matters
          Refactoring: Specific technique to apply
          Example: Before/after if helpful
      }
    }

    Phase3_SynthesizeFindings {
      1. Collect all findings from analysis agents
      2. Deduplicate overlapping findings (keep highest impact)
      3. Rank by: Impact (High > Medium > Low), then Independence (isolated changes first)
      4. Filter out findings in untested code (flag for user decision)
      
      PresentationFormat {
        ## Simplification Analysis: [target]
        
        ### Summary
        
        | Perspective | High | Medium | Low |
        | --- | --- | --- | --- |
        | Complexity | X | X | X |
        | Clarity | X | X | X |
        | Structure | X | X | X |
        | Waste | X | X | X |
        | **Total** | X | X | X |
        
        ### High Impact Opportunities
        
        **[Complexity] Long Method in calculateTotal** (HIGH)
        Location: src/billing.ts:45-120
        Problem: 75-line method with 4 responsibilities
        Refactoring: Extract Method - Split into validateOrder, applyDiscounts, calculateTax, formatResult
        
        ### Medium Impact Opportunities
        ...
        
        ### Low Impact Opportunities
        ...
        
        ### Untested Code (Requires Decision)
        - src/legacy.ts:10-50 - No test coverage, skip or add tests first?
      }
    }

    Phase4_PlanAndConfirm {
      Create prioritized execution plan:
        Order: Independent changes first, then dependent changes
        1. [Extract Method] - billing.ts:45 - Risk: Low - Tests: checked
        2. [Rename] - utils.ts:12 - Risk: Low - Tests: checked
        3. [Guard Clauses] - auth.ts:30 - Risk: Medium - Tests: checked
        Estimated: [N] refactorings across [M] files
        Execution: One at a time with test verification
      
      Use question with options:
        "Document and proceed" => Save plan to docs/refactor/[NNN]-simplify-[name].md, then execute
        "Proceed without documenting" => Execute simplifications directly
        "Apply high-impact only" => Execute only high-impact changes
        "Review each change individually" => Interactive approval for each change
        "Cancel" => Abort simplification
      
      If user chooses to document => Create file with target scope, baseline metrics, findings summary, planned refactorings, risk assessment BEFORE execution
    }

    Phase5_ExecuteSimplifications {
      CRITICAL: One refactoring at a time!
      
      For EACH simplification {
        1. Apply single change
        2. Run tests immediately
        3. If pass => Continue to next
        4. If fail => Revert immediately, report, decide next action
      }
      
      Progress format:
        Executing Simplification [N] of [Total]
        Target: file:line
        Refactoring: [Technique]
        Status: [Applying / Testing / Complete / Reverted]
        Tests: [Passing / Failing]
    }

    Phase6_FinalSummary {
      PresentationFormat {
        ## Simplification Complete
        
        **Applied**: [N] of [M] planned changes
        **Tests**: All passing
        **Behavior**: Preserved
        
        ### Changes Summary
        
        | File | Refactoring | Before | After |
        | --- | --- | --- | --- |
        | billing.ts | Extract Method | 75 lines | 4 functions, 20 lines each |
        | utils.ts | Rename | calc() | calculateTotalWithTax() |
        
        ### Quality Improvements
        
        - Reduced average method length from X to Y lines
        - Eliminated N lines of duplicate code
        - Improved naming clarity in M locations
        - Reduced cyclomatic complexity by Z%
        
        ### Skipped
        
        - legacy.ts:10 - No test coverage (user declined)
      }
    }

    Phase7_NextSteps {
      Use question with options:
        "Commit these changes"
        "Run full test suite"
        "Address skipped items (add tests first)"
        "Done"
    }
  }

  ClarityOverBrevity {
    | Avoid | Prefer |
    | --- | --- |
    | Nested ternaries | if/else or switch |
    | Dense one-liners | Multi-line with clear steps |
    | Clever tricks | Obvious implementations |
    | Abbreviations | Descriptive names |
    | Magic numbers | Named constants |
  }

  AntiPatterns {
    DontOverSimplify {
      Combining concerns for "fewer files"
      Inlining everything for "fewer abstractions"
      Removing helpful abstractions that aid understanding
    }
    
    DontMixConcerns {
      Simplification + feature changes together
      Multiple refactorings before running tests
      Refactoring untested code without adding tests
    }
  }

  ErrorRecovery {
    TestsFailAfterChange {
      Simplification Paused
      Change: [What was attempted]
      Result: Tests failing
      Action: Reverted to working state
      
      Options:
        1. Try alternative approach
        2. Add tests first, then retry
        3. Skip this simplification
        4. Stop and review all changes
    }
    
    NoTestCoverage {
      Untested Code Detected
      Target: [file:line]
      Coverage: None
      
      Options:
        1. Add characterization tests first (recommended)
        2. Proceed with manual verification (risky)
        3. Skip this file
    }
  }
}

## Important Notes

- **Parallel analysis, sequential execution** - Analyze fast, change safely
- **Behavior preservation is mandatory** - External functionality must remain identical
- **Test after every change** - Never batch changes before verification
- **Revert on failure** - Working code beats simplified code
- **Balance is key** - Simple enough to understand, not so simple it's inflexible
- **Confirm before writing documentation** - Always ask user before persisting plans to docs/
