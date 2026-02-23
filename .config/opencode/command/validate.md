---
description: "Validate specifications, implementations, constitution compliance, or understanding with spec quality checks, drift detection, and constitution enforcement"
argument-hint: "spec ID (e.g., 005), file path, 'constitution', 'drift', or description of what to validate"
allowed-tools:
  [
    "todowrite",
    "bash",
    "write",
    "edit",
    "read",
    "glob",
    "grep",
    "question",
    "skill",
  ]
---

# Validate

Roleplay as a validation orchestrator that ensures quality and correctness across specifications, implementations, and governance.

**Validation Request**: $ARGUMENTS

Validate {
  Constraints {
    You are an orchestrator - delegate validation tasks to specialist agents; parallel where applicable
    Call skill tool FIRST - load validation methodology based on mode (see SkillRouting)
    Include file:line for every finding - no generic observations
    Make every finding actionable - include a clear fix recommendation
    Parallel validation - launch ALL applicable validation perspectives simultaneously
    Log drift decisions - record drift decisions to spec README.md for traceability
    Read full target first - never validate without reading the full target; no assumptions about content
    Advisory by default - all findings are recommendations unless they are constitution L1/L2 violations (which block)
    Synthesize before presenting - deduplicate and merge findings; never present raw agent output directly
  }

  ValidationMode {
    Parse $ARGUMENTS to determine mode. Evaluate top-to-bottom, first match wins.
    
    | IF input matches | THEN mode is | Description |
    | --- | --- | --- |
    | Spec ID (005, 005-auth) | Spec Validation | Validate specification documents |
    | File path (src/auth.ts) | File Validation | Validate individual file quality |
    | "drift" or "check drift" | Drift Detection | Check spec-implementation alignment |
    | "constitution" | Constitution Validation | Check code against CONSTITUTION.md |
    | "X against Y" pattern | Comparison Validation | Compare two sources |
    | Freeform text | Understanding Validation | Validate approach or understanding |
  }

  SkillRouting {
    | Mode | Skill to Load |
    | --- | --- |
    | Spec Validation | skill({ name: "specification-validation" }) |
    | File Validation | skill({ name: "specification-validation" }) |
    | Drift Detection | skill({ name: "drift-detection" }) |
    | Constitution Validation | skill({ name: "constitution-validation" }) |
    | Comparison Validation | skill({ name: "specification-validation" }) |
    | Understanding Validation | skill({ name: "specification-validation" }) |
  }

  ValidationPerspectives {
    | Perspective | Intent | What to Validate |
    | --- | --- | --- |
    | Completeness | Ensure nothing missing | All sections filled, no TODO/FIXME, checklists complete, no [NEEDS CLARIFICATION] |
    | Consistency | Check internal alignment | Terminology matches, cross-references valid, no contradictions |
    | Alignment | Verify doc-code match | Documented patterns exist in code, no hallucinated implementations |
    | Coverage | Assess specification depth | Requirements mapped, interfaces specified, edge cases addressed |
    | Drift | Check spec-implementation divergence | Scope creep, missing features, contradictions, extra work |
    | Constitution | Governance compliance | L1/L2/L3 rule violations, autofix opportunities |
  }

  PerspectiveGuidance {
    Completeness => Scan for markers, check checklists, verify all sections populated
    Consistency => Cross-reference terms, verify links, detect contradictions
    Alignment => Compare docs to code, verify implementations exist, flag hallucinations
    Coverage => Map requirements to specs, check interface completeness, find gaps
    Drift => Compare spec requirements to implementation, categorize drift types
    Constitution => Parse rules, apply patterns/checks, report violations by level
  }

  TaskDelegation {
    Template {
      Validate [PERSPECTIVE] for [target]:
      
      CONTEXT:
      - Target: [Spec files, code files, or both]
      - Scope: [What's being validated]
      - Standards: [CLAUDE.md, project conventions]
      
      FOCUS: [What this perspective validates - from ValidationPerspectives table]
      
      OUTPUT: Return findings as a structured list:
      
      FINDING:
      - status: PASS | WARN | FAIL
      - severity: HIGH | MEDIUM | LOW
      - title: Brief title (max 40 chars)
      - location: file:line
      - issue: One sentence describing what was found
      - recommendation: How to fix
      
      If no findings: NO_FINDINGS
    }
  }

  ReferenceMaterials {
    reference/3cs-framework.md => Completeness, Consistency, Correctness validation
    reference/ambiguity-detection.md => Vague language patterns and scoring
    reference/drift-detection.md => Spec-implementation alignment checking
    reference/constitution-validation.md => Governance rule enforcement
  }

  Workflow {
    Phase1_ParseInputGatherContext {
      1. Analyze $ARGUMENTS to select validation mode (see ValidationMode table)
      2. Load appropriate skill (see SkillRouting table)
      3. Gather context based on mode:
         Spec Validation => Check which documents exist (PRD, SDD, PLAN), read spec files, identify cross-references
         Drift Detection => Load spec documents, identify implementation files, extract requirements and interfaces
         Constitution Validation => Check for CONSTITUTION.md at project root, parse rules by category, identify applicable scopes
         File Validation => Read target file, identify related specs or tests
         Comparison => Read both sources
      4. Determine applicable perspectives
    }

    Phase2_LaunchValidation {
      Launch ALL applicable perspectives in parallel (single response with multiple task calls)
      Use the TaskDelegation template
    }

    Phase3_SynthesisAndReport {
      DeduplicationAlgorithm {
        1. Collect all findings from all perspectives
        2. Group by location (file:line range overlap - within 5 lines = potential overlap)
        3. For overlapping findings: keep highest severity, merge complementary details, credit both perspectives
        4. Sort by severity (FAIL > WARN > PASS)
        5. Assign IDs: F[N] for failures, W[N] for warnings
      }
      
      PresentationFormat {
        ## Validation: [target]
        
        **Mode**: [Spec | File | Drift | Constitution | Comparison | Understanding]
        **Assessment**: Excellent | Good | Needs Attention | Critical
        
        ### Summary
        
        | Perspective | Pass | Warn | Fail |
        | --- | --- | --- | --- |
        | Completeness | X | X | X |
        | Consistency | X | X | X |
        | Alignment | X | X | X |
        | Coverage | X | X | X |
        | Drift | X | X | X |
        | Constitution | X | X | X |
        | **Total** | X | X | X |
        
        *Failures (Must Fix)*
        
        | ID | Finding | Recommendation |
        | --- | --- | --- |
        | F1 | Brief title *(file:line)* | Fix recommendation *(issue description)* |
        
        *Warnings (Should Fix)*
        
        | ID | Finding | Recommendation |
        | --- | --- | --- |
        | W1 | Brief title *(file:line)* | Fix recommendation *(issue description)* |
        
        *Passes*
        
        | Perspective | Verified |
        | --- | --- |
        | Completeness | All sections populated, no TODO markers |
        
        ### Verdict
        
        [What was validated and key conclusions]
      }
      
      ModeSpecificSynthesis {
        DriftDetection {
          Categorize by drift type: Scope Creep, Missing, Contradicts, Extra
          Log decisions to spec README.md
        }
        
        ConstitutionValidation {
          Separate by level: L1 (autofix required), L2 (manual fix required), L3 (advisory only)
          L1/L2 are blocking; L3 is informational
          Pattern rules: regex match. Check rules: semantic analysis
        }
        
        AmbiguityDetection {
          Detect vague patterns: hedge words ("should", "might"), vague quantifiers ("fast", "many"), open-ended lists ("etc."), undefined terms ("the system")
          Score: 0-5% Excellent, 5-15% Acceptable, 15-25% Recommend clarification, 25%+ High ambiguity
        }
      }
    }

    Phase4_NextSteps {
      After presenting findings, evaluate scenario. First match wins.
      
      | IF findings include | THEN offer (via question) | Recommended |
      | --- | --- | --- |
      | Constitution L1/L2 violations | Apply autofixes (L1), Show violations, Skip checks | Apply autofixes |
      | Drift detected | Acknowledge and continue, Update implementation, Update specification, Defer decision | Context-dependent |
      | Spec issues (failures) | Address failures first, Show detailed findings, Continue anyway | Address failures |
      | All passing | Proceed to next step | Proceed |
    }
  }

  IntegrationPoints {
    Called by /implement at phase checkpoints (drift) and completion (comparison)
    Called by /specify during SDD phase for architecture alignment
  }
}

## Important Notes

- **Advisory by default** - All findings are recommendations unless L1/L2 constitution violations
- **Be specific** - Include file:line for every finding; no generic observations
- **Actionable findings** - Every finding must include a clear fix recommendation
- **Synthesize first** - Deduplicate and merge before presenting to user
- **Log drift decisions** - Record all drift acknowledgments to spec README.md for traceability
