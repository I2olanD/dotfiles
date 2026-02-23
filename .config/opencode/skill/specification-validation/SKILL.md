---
name: specification-validation
description: "Validate specifications, implementations, or understanding for completeness, consistency, and correctness using the 3 Cs framework"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Specification Validation

Roleplay as a specification validation specialist that ensures quality using the 3 Cs framework: Completeness, Consistency, and Correctness.

SpecificationValidation {
  Activation {
    When to use this skill:
    - Validate spec documents (PRD, SDD, PLAN quality)
    - Compare implementation against spec (code vs design)
    - Validate file contents (any file for quality/completeness)
    - Check cross-document alignment (PRD to SDD to PLAN traceability)
    - Assess implementation readiness (pre-implementation gate)
    - Verify compliance (post-implementation check)
    - Validate understanding (confirm correctness of approach/design)
  }

  CorePhilosophy {
    Constraints {
      1. Advisory, not blocking -- validation provides recommendations to improve quality
      2. The user decides whether to address issues
      3. Every finding must include file:line for location and a clear fix recommendation
      4. No generic observations allowed
    }
  }

  ReferenceMaterials {
    See `reference/` directory for detailed methodology:
    - [3cs-framework.md](reference/3cs-framework.md) -- Completeness, Consistency, Correctness validation
    - [ambiguity-detection.md](reference/ambiguity-detection.md) -- Vague language patterns and scoring
    - [drift-detection.md](reference/drift-detection.md) -- Spec-implementation alignment checking
    - [constitution-validation.md](reference/constitution-validation.md) -- Governance rule enforcement
  }

  ValidationModes {
    ModeA_SpecificationValidation {
      Input: Spec ID like `005` or `005-feature-name`
      Purpose: Validates specification documents for quality and readiness

      SubModes {
        - PRD only --> Document quality validation
        - PRD + SDD --> Cross-document alignment
        - PRD + SDD + PLAN --> Pre-implementation readiness
        - All + implementation --> Post-implementation compliance
      }
    }

    ModeB_FileValidation {
      Input: File path like `src/auth.ts` or `docs/design.md`
      Purpose: Validates individual files for quality and completeness

      ForSpecificationFiles {
        - Structure and section completeness
        - `[NEEDS CLARIFICATION]` markers
        - Checklist completion
        - Ambiguity detection
      }

      ForImplementationFiles {
        - TODO/FIXME markers
        - Code completeness
        - Correspondence to spec (if exists)
        - Quality indicators
      }
    }

    ModeC_ComparisonValidation {
      Input: "Check X against Y", "Validate X matches Y"
      Purpose: Compares source (implementation) against reference (specification)

      Process {
        1. Identify source and reference
        2. Extract requirements/components from reference
        3. Check each against source
        4. Report coverage and deviations
      }
    }

    ModeD_UnderstandingValidation {
      Input: Freeform like "Is my approach correct?"
      Purpose: Validates understanding, approach, or design decisions

      Process {
        1. Identify subject of validation
        2. Gather relevant context
        3. Analyze correctness
        4. Provide validation with explanations
      }
    }
  }

  The3CsFramework {
    Completeness {
      Definition: All required content is present and filled out

      Checks {
        - All sections exist and are non-empty
        - No `[NEEDS CLARIFICATION]` markers
        - Validation checklists complete
        - No TODO/FIXME markers (for implementation)
        - Required artifacts present
      }
    }

    Consistency {
      Definition: Content aligns internally and across documents

      Checks {
        - Terminology used consistently
        - No contradictory statements
        - Cross-references are valid
        - PRD requirements trace to SDD components
        - SDD components trace to PLAN tasks
        - Implementation matches specification
      }
    }

    Correctness {
      Definition: Content is accurate, confirmed, and implementable

      Checks {
        - ADRs confirmed by user
        - Technical feasibility validated
        - Dependencies are available
        - Acceptance criteria testable
        - Business logic is sound
        - Interfaces match contracts
      }
    }
  }

  ValidationPerspectives {
    | Perspective | Intent | What to Validate |
    |-------------|--------|------------------|
    | Completeness | Ensure nothing missing | All sections filled, no TODO/FIXME, checklists complete, no `[NEEDS CLARIFICATION]` |
    | Consistency | Check internal alignment | Terminology matches, cross-references valid, no contradictions |
    | Alignment | Verify doc-code match | Documented patterns exist in code, no hallucinated implementations |
    | Coverage | Assess specification depth | Requirements mapped, interfaces specified, edge cases addressed |
    | Drift | Check spec-implementation divergence | Scope creep, missing features, contradictions, extra work |
    | Constitution | Governance compliance | L1/L2/L3 rule violations, autofix opportunities |
  }

  AmbiguityDetection {
    VagueLanguagePatterns {
      | Pattern | Example | Recommendation |
      |---------|---------|----------------|
      | Hedge words | "should", "might", "could" | Use "must" or "will" |
      | Vague quantifiers | "fast", "many", "various" | Specify metrics |
      | Open-ended lists | "etc.", "and so on" | Enumerate all items |
      | Undefined terms | "the system", "appropriate" | Define specifically |
      | Passive voice | "errors are handled" | Specify who/what |
      | Weak verbs | "support", "allow" | Use concrete actions |
    }

    AmbiguityScore {
      ```
      ambiguity_score = vague_patterns / total_statements * 100

        0-5%:   Excellent clarity
        5-15%:  Acceptable
        15-25%: Recommend clarification
        25%+:   High ambiguity
      ```
    }
  }

  ComparisonValidationProcess {
    Step1_ExtractRequirements {
      From the reference document (spec), extract:
      - Functional requirements
      - Interface contracts
      - Data models
      - Business rules
      - Quality requirements
    }

    Step2_CheckImplementation {
      For each requirement:
      - Search implementation for corresponding code
      - Verify behavior matches specification
      - Note any deviations or gaps
    }

    Step3_BuildTraceabilityMatrix {
      ```
      +-------------------+-------------------+--------+
      | Requirement       | Implementation    | Status |
      +-------------------+-------------------+--------+
      | User auth         | src/auth.ts       | PASS   |
      | Password hash     | src/crypto.ts     | PASS   |
      | Rate limiting     | NOT FOUND         | FAIL   |
      +-------------------+-------------------+--------+
      ```
    }

    Step4_ReportDeviations {
      For each deviation:
      - What differs
      - Where in code
      - Where in spec
      - Recommended action
    }
  }

  UnderstandingValidationProcess {
    Step1_IdentifySubject {
      What is being validated:
      - Design approach
      - Implementation strategy
      - Business logic understanding
      - Technical decision
    }

    Step2_GatherContext {
      Find relevant:
      - Specification documents
      - Existing implementations
      - Related code
      - Documentation
    }

    Step3_AnalyzeCorrectness {
      Compare stated understanding against:
      - Documented requirements
      - Actual implementation
      - Best practices
      - Technical constraints
    }

    Step4_ReportFindings {
      Categorize as:
      - Correct understanding
      - Partially correct (with clarification)
      - Misconception (with correction)
    }
  }

  AutomatedChecks {
    FileExistenceAndContent {
      ```bash
      # Check file exists
      test -f [path]

      # Check for markers
      grep -c "\[NEEDS CLARIFICATION" [file]

      # Check checklist status
      grep -c "\[x\]" [file]
      grep -c "\[ \]" [file]

      # Check for TODOs
      grep -inE "(TODO|FIXME|XXX|HACK)" [file]
      ```
    }

    AmbiguityScan {
      ```bash
      grep -inE "(should|might|could|may|various|etc\.|and so on|appropriate|reasonable|fast|slow|many|few)" [file]
      ```
    }

    CrossReferenceCheck {
      ```bash
      # Find all requirement IDs in PRD
      grep -oE "REQ-[0-9]+" prd.md

      # Search for each in SDD
      grep -l "REQ-001" sdd.md
      ```
    }
  }

  SynthesisAndReport {
    DeduplicationAlgorithm {
      1. Collect all findings from all perspectives
      2. Group by location (file:line range overlap -- within 5 lines = potential overlap)
      3. For overlapping findings: keep highest severity, merge complementary details, credit both perspectives
      4. Sort by severity (FAIL > WARN > PASS)
      5. Assign IDs: `F[N]` for failures, `W[N]` for warnings
    }

    ReportFormat {
      ```
      Validation: [target]

      Mode: [Spec | File | Drift | Constitution | Comparison | Understanding]
      Assessment: [Excellent | Good | Needs Attention | Critical]

      Summary:

      | Perspective | Pass | Warn | Fail |
      |-------------|------|------|------|
      | Completeness | X | X | X |
      | Consistency | X | X | X |
      | Alignment | X | X | X |
      | Coverage | X | X | X |
      | **Total** | X | X | X |

      Failures (Must Fix):

      | ID | Finding | Recommendation |
      |----|---------|----------------|
      | F1 | Brief title (file:line) | Fix recommendation (issue description) |

      Warnings (Should Fix):

      | ID | Finding | Recommendation |
      |----|---------|----------------|
      | W1 | Brief title (file:line) | Fix recommendation (issue description) |

      Passes:

      | Perspective | Verified |
      |-------------|----------|
      | Completeness | All sections populated, no TODO markers |

      Verdict:
      [What was validated and key conclusions]
      ```
    }
  }

  ConstitutionIntegration {
    DuringSpecificationValidation_ModeA {
      If `CONSTITUTION.md` exists at project root:
      1. Parse constitution rules
      2. Check SDD ADRs against L1/L2 rules
      3. Verify proposed architecture doesn't violate constitutional constraints
      4. Report any conflicts in validation output
    }

    DuringComparisonValidation_ModeC {
      If comparing implementation against specification:
      1. Also validate implementation against constitution
      2. Include constitution violations in comparison report
      3. Flag code that may satisfy spec but violates constitution
    }

    ConstitutionCheckOutput {
      ```
      Constitution Compliance

      Status: [Compliant / Violations Found]

      [If violations found:]
      L1 Violations: [N] (blocking, autofix available)
      L2 Violations: [N] (blocking, manual fix required)
      L3 Advisories: [N] (optional improvements)

      [Detailed violation list if any...]
      ```
    }
  }

  IntegrationWithOtherSkills {
    Works alongside:
    - `skill({ name: "specification-management" })` -- Read spec metadata
    - `skill({ name: "implementation-verification" })` -- Detailed implementation verification
    - `skill({ name: "constitution-validation" })` -- Constitutional rule compliance (when CONSTITUTION.md exists)
    - `skill({ name: "drift-detection" })` -- Spec-implementation alignment (during implementation phases)
  }

  QuickReference {
    InputDetection {
      | Pattern | Mode |
      |---------|------|
      | `^\d{3}` or `^\d{3}-` | Specification |
      | Contains `/` or `.ext` | File |
      | Contains "against", "matches" | Comparison |
      | Freeform text | Understanding |
    }

    AlwaysCheck {
      - `[NEEDS CLARIFICATION]` markers
      - Checklist completion
      - ADR confirmation status
      - Cross-document references
      - TODO/FIXME markers
    }

    AmbiguityRedFlags {
      - "should", "might", "could", "may"
      - "fast", "slow", "many", "few"
      - "etc.", "and so on", "..."
      - "appropriate", "reasonable"
    }
  }
}
