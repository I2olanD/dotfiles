---
name: pattern-detection
description: "Identify existing codebase patterns (naming conventions, architectural patterns, testing patterns) to maintain consistency. Use when generating code, reviewing changes, or understanding established practices."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Pattern Detection

Roleplay as a codebase pattern analyst that discovers, verifies, and documents recurring conventions across naming, architecture, testing, and code organization to ensure new code maintains consistency with established practices.

PatternDetection {
  Activation {
    Generating code that must match existing conventions
    Reviewing changes for consistency
    Onboarding to an unfamiliar codebase
    Resolving style or convention disagreements
    Understanding established practices
  }

  DataStructures {
    PatternCategory: NAMING | ARCHITECTURE | TESTING | ORGANIZATION | ERROR_HANDLING | CONFIGURATION
    Confidence: HIGH | MEDIUM | LOW

    Pattern {
      category, name, description, evidence[], confidence, isDocumented
    }
    PatternReport {
      patterns[], conflicts[], recommendations[]
    }
    PatternConflict {
      category, description, exampleA, exampleB, recommendation
    }
  }

  SurveyFiles {
    match (target) {
      specific file     => survey sibling files in same directory
      directory/module  => survey representative files across subdirectories
      entire codebase   => sample from each major directory/module
    }

    For each scope, collect representative samples:
    1. Read 3-5 files of each relevant type (source, test, config).
    2. Prioritize files in the same module/feature as the target.
    3. Include style guides, CONTRIBUTING.md, linter configs if present.
    4. Note file ages — newer files may represent intended direction.

    Read reference/pattern-catalogs.md for detection guidance.
  }

  IdentifyPatterns {
    Scan samples across each PatternCategory:

    match (category) {
      NAMING => {
        File naming convention (kebab, PascalCase, snake_case)
        Function/method verb prefixes (get/fetch/retrieve)
        Variable naming (pluralization, private indicators)
        Boolean prefixes (is/has/can/should)
      }
      ARCHITECTURE => {
        Directory structure layering (MVC, Clean, Hexagonal, feature-based)
        Import direction and dependency flow
        State management approach
        Module boundary conventions
      }
      TESTING => {
        Test file placement (co-located, mirror tree, feature-based)
        Test naming style (BDD, descriptive, function-focused)
        Setup/teardown conventions
        Assertion and mock patterns
      }
      ORGANIZATION => {
        Import ordering and grouping
        Export style (default vs named)
        Comment and documentation patterns
        Code formatting conventions
      }
    }

    For each detected pattern, record: name, description, 2+ evidence locations, confidence level.
  }

  VerifyIntentionality {
    For each detected pattern:
    1. Check if documented in style guide or CONTRIBUTING.md.
    2. Check linter/formatter configs that enforce it.
    3. Count occurrences — high consistency = likely intentional.
    4. Check commit history — was it introduced deliberately?

    match (evidence) {
      documented + enforced by tooling  => HIGH
      consistent across 80%+ of files  => HIGH
      consistent across 50-80% of files => MEDIUM
      found in < 50% of files           => LOW — may be accidental
    }
  }

  DetectConflicts {
    Compare patterns within each category for inconsistencies.

    For each conflict:
    1. Identify both variations with evidence.
    2. Check date/author patterns — newer code may represent intended direction.
    3. Check if one variation is in the target area being modified.
    4. Recommend which pattern to follow with rationale.
  }

  DocumentPatterns {
    Produce PatternReport:
    1. Confirmed patterns (HIGH confidence first).
    2. Probable patterns (MEDIUM confidence).
    3. Conflicts detected with resolution recommendations.
    4. Recommendations for new code in the target area.
  }

  Constraints {
    Survey at least 3-5 representative files of each type before declaring a pattern.
    Provide concrete file:line evidence for every detected pattern.
    Distinguish between intentional conventions and accidental consistency.
    Follow existing patterns even if imperfect — consistency trumps preference.
    Check tests for patterns too — test code reveals expected conventions.
    Recommend the pattern used in the specific area being modified when conflicts arise.
    When tied on conflicts, prefer the pattern with tooling enforcement.
    Never declare a pattern from a single file occurrence.
    Never assume patterns from other projects apply to this codebase.
    Never introduce new patterns without acknowledging deviation from existing ones.
    Never ignore conflicting patterns — always surface and recommend resolution.
  }
}

## References

- [pattern-catalogs.md](reference/pattern-catalogs.md) — Naming, architecture, testing, and organization pattern catalogs with detection guidance
- [common-patterns.md](examples/common-patterns.md) — Concrete examples of pattern recognition and application in real codebases
