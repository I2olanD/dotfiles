---
description: "Validate specifications, implementations, constitution compliance, or understanding. Includes spec quality checks, drift detection, and constitution enforcement."
argument-hint: "spec ID (e.g., 005), file path, 'constitution', 'drift', or description of what to validate"
allowed-tools: ["bash", "grep", "glob", "read", "edit", "write", "question"]
---

# Validate

Roleplay as a validation orchestrator that ensures quality and correctness across specifications, implementations, and governance.

**Validation Request**: $ARGUMENTS

Validate {

    Constraints {
        Cover all applicable validation perspectives thoroughly.
        Launch all applicable validation perspectives simultaneously where possible.
        Include file paths and line numbers for all findings.
        Every finding must have a clear, actionable fix recommendation.
        Advisory by default — provide recommendations without blocking.
        Never skip constitution L1/L2 violations — these are blocking.
        Never present findings without specific file:line references.
        Never summarize agent findings — present complete results.
    }

    ValidationModes {
        match (target) {
        /^\d{3}/                 => Spec Validation
        file path                => File Validation
        "drift" | "check drift"  => Drift Detection
        "constitution"           => Constitution Validation
        "$X against $Y"          => Comparison Validation
        freeform text            => Understanding Validation
        }
    }

    SpecValidation {
        Input: spec ID like `005` or `005-feature-name`
        Validates specification documents for quality and readiness.
        Sub-modes: PRD only → document quality | PRD+SDD → cross-doc alignment | All → pre-impl readiness
        Perspectives: Completeness, Consistency, Coverage + ambiguity detection
    }

    FileValidation {
        Input: file path like `src/auth.ts` or `.engineer/design.md`
        Validates individual files for quality and completeness.
        For spec files: structure, [NEEDS CLARIFICATION] markers, checklist completion, ambiguity
        For implementation files: TODO/FIXME markers, code completeness, spec correspondence
        Perspectives: Completeness, Consistency, Alignment
    }

    DriftDetection {
        Input: "drift" or "check drift"
        Detects divergence between specifications and implementation.
        Perspectives: Drift, Alignment, Consistency
    }

    DriftTypes {
        Scope Creep  => Implementation adds features not in spec
        Missing      => Spec requires feature not implemented
        Contradicts  => Implementation conflicts with spec
        Extra        => Unplanned work that may be valuable
    }

    DriftPhilosophy {
        DriftIsInformation: Drift isn't inherently bad — it's valuable feedback.
        Scope creep may indicate incomplete requirements.
        Missing items may reveal unrealistic timelines.
        Contradictions may surface spec ambiguities.
        The goal is awareness and conscious decision-making, not rigid compliance.

        DriftLogging: All drift decisions should be logged to spec README under "## Drift Log":
        | Date | Phase | Drift Type | Status | Notes |
        Status values: Acknowledged | Updated | Deferred
    }

    ConstitutionValidation {
        Input: "constitution"
        Enforces project governance rules from CONSTITUTION.md.
        Perspective: Constitution only
    }

    ConstitutionLevels {
        | Level | Behavior |
        |-------|----------|
        | L1 (Must) | Blocking, AI auto-corrects before proceeding |
        | L2 (Should) | Blocking, requires human action |
        | L3 (May) | Advisory only, non-blocking |
    }

    ConstitutionGracefulDegradation {
        No CONSTITUTION.md    => Report "No constitution found. Skipping constitution checks."
        Invalid rule format   => Skip rule, warn user, continue with other rules
        Scope matches no files => Report as info, not a failure
    }

    ComparisonValidation {
        Input: "$X against $Y" or "validate X matches Y"
        Compares source (implementation) against reference (specification).
        Perspectives: Alignment, Consistency, Coverage

        Process:
        1. Extract requirements/components from reference.
        2. Check each against source implementation.
        3. Build traceability matrix.
        4. Report coverage and deviations.
    }

    UnderstandingValidation {
        Input: freeform like "Is my approach correct?"
        Validates understanding, approach, or design decisions.
        Perspectives: Alignment, Completeness

        Findings categorized as:
        Correct understanding
        Partially correct (with clarification)
        Misconception (with correction)
    }

    Perspectives {
        | Perspective | Intent | What to Validate |
        |-------------|--------|-----------------|
        | Completeness | Ensure nothing is missing | All required sections exist, no [NEEDS CLARIFICATION] markers, no TODO/FIXME in impl, required artifacts present |
        | Consistency | Check internal alignment | Terminology consistent, no contradictory statements, cross-references valid, PRD→SDD→PLAN traceability |
        | Alignment | Verify documented patterns exist in code | Documented patterns present in implementation, interface contracts match code signatures |
        | Coverage | Assess specification depth | All requirements have acceptance criteria, edge cases addressed, error handling documented, measurable targets |
        | Drift | Detect spec-implementation divergence | Scope creep, missing features, contradictions, extra unplanned work |
        | Constitution | Enforce governance rules | L1/L2/L3 rule enforcement per CONSTITUTION.md |
    }

    PerspectivesByMode {
        | Validation Mode | Perspectives Applied |
        |----------------|---------------------|
        | Spec Validation | Completeness, Consistency, Coverage + ambiguity detection |
        | File Validation | Completeness, Consistency, Alignment |
        | Drift Detection | Drift, Alignment, Consistency |
        | Constitution | Constitution |
        | Comparison | Alignment, Consistency, Coverage |
        | Understanding | Alignment, Completeness |
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
        }

        AmbiguityScore {
        0-5%:   Excellent clarity
        5-15%:  Acceptable
        15-25%: Recommend clarification
        25%+:   High ambiguity — address before implementation
        }
    }

    AssessmentLevels {
        | Level | Condition |
        |-------|-----------|
        | Excellent | No failures, no warnings |
        | Good | No failures, 1-3 warnings |
        | Needs Attention | No failures, 4+ warnings |
        | Critical | Any failures present |
    }

    Workflow {

        Phase1_ParseMode {
            Determine validation mode from $ARGUMENTS using ModeDetection.
        }

        Phase2_GatherContext {
            match (mode) {
                Spec Validation    => load spec documents (PRD, SDD, PLAN), identify cross-references
                Drift Detection    => load spec + identify implementation files + extract requirements
                Constitution       => check for CONSTITUTION.md, parse rules by category
                File Validation    => read target file + surrounding context
                Comparison         => load both sources for comparison
            }
        }

        Phase3_LaunchValidation {
            Launch parallel subagents per applicable perspectives simultaneously in a single response.
        }

        Phase4_SynthesizeFindings {
            Process findings:
                1. Deduplicate by location (within 5 lines), keeping highest severity and merging complementary details.
                2. Sort by severity (descending).
                3. Group by category.

            Mode-specific synthesis:
                Drift        => categorize by type (Scope Creep, Missing, Contradicts, Extra)
                Constitution => separate by level (L1 autofix, L2 manual, L3 advisory)
                Spec         => include ambiguity score

            Calculate assessment level (Excellent / Good / Needs Attention / Critical).
        }

        Phase5_NextSteps {
            match (validationMode) {
                Constitution => Ask user: Apply autofixes (L1) | Show violations | Skip
                Drift        => Ask user: Acknowledge | Update implementation | Update spec | Defer
                Spec | File  => Ask user: Address failures | Show details | Continue anyway
            }
        }
    }

}

## Integration with Other Skills

- /implement — drift check at phase boundaries, constitution check at checkpoints
- /specify — architecture alignment during SDD phase

## Important Notes

- Validation mode is determined from $ARGUMENTS: spec ID → Spec, file path → File, "drift" → Drift, "constitution" → Constitution
- Constitution L1/L2 violations are BLOCKING — never skip these; L3 is advisory only
- Drift is information, not failure — present options: acknowledge, update implementation, update spec, or defer
- Include specific file:line references for every finding — no finding without a location
- Ambiguity score (0-5% excellent, 5-15% acceptable, 15-25% clarify, 25%+ high) applied to spec validation
