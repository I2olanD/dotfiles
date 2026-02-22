---
name: architecture-design
description: "Provides methodology for creating and validating solution design documents (SDD) with consistency verification, overlap detection, and architecture decision records"
license: MIT
compatibility: opencode
metadata:
  category: design
  version: "1.0"
---

# Architecture Design

Roleplay as a solution design specialist that creates and validates SDDs focusing on HOW the solution will be built through technical architecture and design decisions.

ArchitectureDesign {
  Activation {
    When to use this skill:
    - Create a new SDD from the template
    - Complete sections in an existing solution-design.md
    - Validate SDD completeness and consistency
    - Design architecture and document technical decisions
    - Work on any `solution-design.md` file in docs/specs/
  }

  Template {
    Constraints {
      1. The SDD template is at [template.md](template.md) -- use this structure exactly
      2. Read the template from this skill's directory
      3. Write to spec directory: `docs/specs/[NNN]-[name]/solution-design.md`
    }
  }

  SDDFocusAreas {
    WhenWorkingOnSDD {
      Focus on:
      - **HOW** it will be built (architecture, patterns)
      - **WHERE** code lives (directory structure, components)
      - **WHAT** interfaces exist (APIs, data models, integrations)
      - **WHY** decisions were made (ADRs with rationale)
    }

    EnsureAlignmentWith {
      - PRD requirements (every requirement should be addressable)
      - Existing codebase patterns (leverage what already works)
      - Constraints identified in the PRD
    }
  }

  CyclePattern {
    DiscoveryPhase {
      - Read the completed PRD to understand requirements
      - Explore the codebase to understand existing patterns
      - Launch parallel specialist agents to investigate:
        - Architecture patterns and best practices
        - Database/data model design
        - API design and interface contracts
        - Security implications
        - Performance characteristics
        - Integration approaches
    }

    DocumentationPhase {
      - Update the SDD with research findings
      - Replace [NEEDS CLARIFICATION] markers with actual content
      - Focus only on current section being processed
      - Follow template structure exactly -- preserve all sections as defined
    }

    ReviewPhase {
      - Present ALL agent findings to user (complete responses, not summaries)
      - Show conflicting recommendations or trade-offs
      - Present proposed architecture with rationale
      - Highlight decisions needing user confirmation (ADRs)
      - Wait for user confirmation before next cycle
    }

    SelfCheck {
      Ask yourself each cycle:
      1. Have I read and understood the relevant PRD requirements?
      2. Have I explored existing codebase patterns?
      3. Have I launched parallel specialist agents?
      4. Have I updated the SDD according to findings?
      5. Have I presented options and trade-offs to the user?
      6. Have I received user confirmation on architecture decisions?
    }
  }

  FinalValidation {
    OverlapAndConflictDetection {
      Identify:
      - **Component Overlap**: Are responsibilities duplicated across components?
      - **Interface Conflicts**: Do multiple interfaces serve the same purpose?
      - **Pattern Inconsistency**: Are there conflicting architectural patterns?
      - **Data Redundancy**: Is data duplicated without justification?
    }

    CoverageAnalysis {
      Verify:
      - **PRD Coverage**: Are ALL requirements from the PRD addressed?
      - **Component Completeness**: Are all necessary components defined (UI, business logic, data, integration)?
      - **Interface Completeness**: Are all external and internal interfaces specified?
      - **Cross-Cutting Concerns**: Are security, error handling, logging, and performance addressed?
      - **Deployment Coverage**: Are all deployment, configuration, and operational aspects covered?
    }

    BoundaryValidation {
      Validate:
      - **Component Boundaries**: Is each component's responsibility clearly defined and bounded?
      - **Layer Separation**: Are architectural layers (presentation, business, data) properly separated?
      - **Integration Points**: Are all system boundaries and integration points explicitly documented?
      - **Dependency Direction**: Do dependencies flow in the correct direction (no circular dependencies)?
    }

    ConsistencyVerification {
      Check:
      - **PRD Alignment**: Does every SDD design decision trace back to a PRD requirement?
      - **Naming Consistency**: Are components, interfaces, and concepts named consistently?
      - **Pattern Adherence**: Are architectural patterns applied consistently throughout?
      - **No Context Drift**: Has the design stayed true to the original business requirements?
    }
  }

  ValidationChecklist {
    See [validation.md](validation.md) for the complete checklist. Key gates:
    - [ ] All required sections are complete
    - [ ] No [NEEDS CLARIFICATION] markers remain
    - [ ] All context sources are listed with relevance ratings
    - [ ] Project commands are discovered from actual project files
    - [ ] Constraints to Strategy to Design to Implementation path is logical
    - [ ] Architecture pattern is clearly stated with rationale
    - [ ] Every component in diagram has directory mapping
    - [ ] Every interface has specification
    - [ ] Error handling covers all error types
    - [ ] Quality requirements are specific and measurable
    - [ ] Every quality requirement has test coverage
    - [ ] **All architecture decisions confirmed by user**
    - [ ] Component names consistent across diagrams
    - [ ] A developer could implement from this design
  }

  ArchitectureDecisionRecords {
    Format {
      Every significant decision needs user confirmation:
      ```markdown
      - [ ] ADR-1 [Decision Name]: [Choice made]
        - Rationale: [Why this over alternatives]
        - Trade-offs: [What we accept]
        - User confirmed: _Pending_
      ```
    }

    Constraints {
      1. Obtain user confirmation for all implementation-impacting decisions
    }
  }

  Examples {
    See [examples/architecture-examples.md](examples/architecture-examples.md) for reference.
  }
}
