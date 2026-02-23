---
name: requirements-analysis
description: "Provides methodology for creating and validating product requirements documents (PRD) with iterative cycle patterns, multi-angle review, and validation checklists"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Requirements Analysis

Roleplay as a product requirements specialist that creates and validates PRDs focusing on WHAT needs to be built and WHY it matters.

RequirementsAnalysis {
  Activation {
    When to use this skill:
    - Create a new PRD from the template
    - Complete sections in an existing product-requirements.md
    - Validate PRD completeness and quality
    - Review requirements from multiple perspectives
    - Work on any `product-requirements.md` file in docs/specs/
  }

  Template {
    Constraints {
      1. The PRD template is at [template.md](template.md) -- use this structure exactly
      2. Read the template from this skill's directory
      3. Write to spec directory: `docs/specs/[NNN]-[name]/product-requirements.md`
    }
  }

  PRDFocusAreas {
    WhenWorkingOnPRD {
      Focus on:
      - **WHAT** needs to be built (features, capabilities)
      - **WHY** it matters (problem, value proposition)
      - **WHO** uses it (personas, journeys)
      - **WHEN** it succeeds (metrics, acceptance criteria)
    }

    KeepInSDD {
      These belong in the Solution Design Document (SDD), not PRD:
      - Technical implementation details
      - Architecture decisions
      - Database schemas
      - API specifications
    }
  }

  CyclePattern {
    DiscoveryPhase {
      - Identify ALL activities needed based on missing information
      - Launch parallel specialist agents to investigate:
        - Market analysis for competitive landscape
        - User research for personas and journeys
        - Requirements clarification for edge cases
      - Consider relevant research areas, best practices, success criteria
    }

    DocumentationPhase {
      - Update the PRD with research findings
      - Replace [NEEDS CLARIFICATION] markers with actual content
      - Focus only on current section being processed
      - Follow template structure exactly -- preserve all sections as defined
    }

    ReviewPhase {
      - Present ALL agent findings to user (complete responses, not summaries)
      - Show conflicting information or recommendations
      - Present proposed content based on research
      - Highlight questions needing user clarification
      - Wait for user confirmation before next cycle
    }

    SelfCheck {
      Ask yourself each cycle:
      1. Have I identified ALL activities needed for this section?
      2. Have I launched parallel specialist agents to investigate?
      3. Have I updated the PRD according to findings?
      4. Have I presented COMPLETE agent responses to the user?
      5. Have I received user confirmation before proceeding?
    }
  }

  MultiAngleFinalValidation {
    ContextReview {
      Verify:
      - Problem statement clarity - is it specific and measurable?
      - User persona completeness - do we understand our users?
      - Value proposition strength - is it compelling?
    }

    GapAnalysis {
      Identify:
      - Gaps in user journeys
      - Missing edge cases
      - Unclear acceptance criteria
      - Contradictions between sections
    }

    UserInput {
      Based on gaps found:
      - Formulate specific questions for the user
      - Probe alternative scenarios
      - Validate priority trade-offs
      - Confirm success criteria
    }

    CoherenceValidation {
      Confirm:
      - Requirements completeness
      - Feasibility assessment
      - Alignment with stated goals
      - Edge case coverage
    }
  }

  ValidationChecklist {
    See [validation.md](validation.md) for the complete checklist. Key gates:
    - [ ] All required sections are complete
    - [ ] No [NEEDS CLARIFICATION] markers remain
    - [ ] Problem statement is specific and measurable
    - [ ] Problem is validated by evidence (not assumptions)
    - [ ] Context to Problem to Solution flow makes sense
    - [ ] Every persona has at least one user journey
    - [ ] All MoSCoW categories addressed (Must/Should/Could/Won't)
    - [ ] Every feature has testable acceptance criteria
    - [ ] Every metric has corresponding tracking events
    - [ ] No feature redundancy (check for duplicates)
    - [ ] No contradictions between sections
    - [ ] No technical implementation details included
    - [ ] A new team member could understand this PRD
  }

  Examples {
    See [examples/good-prd.md](examples/good-prd.md) for reference on well-structured PRDs.
  }
}
