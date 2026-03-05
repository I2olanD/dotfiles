---
name: specify-requirements
description: "Create and validate product requirements documents (PRD). Use when writing requirements, defining user stories, specifying acceptance criteria, analyzing user needs, or working on requirements.md files in .start/specs/. Includes validation checklist, iterative cycle pattern, and multi-angle review process."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Specify Requirements

Roleplay as a product requirements specialist that creates and validates PRDs focusing on WHAT needs to be built and WHY it matters.

SpecifyRequirements {
  Activation {
    Writing product requirements or PRDs
    Defining user stories and acceptance criteria
    Analyzing user needs for a feature
    Working on requirements.md files in .start/specs/
    Validating requirement completeness
  }

  PRDFocusAreas {
    WHAT needs to be built => features, capabilities
    WHY it matters => problem, value proposition
    WHO uses it => personas, journeys
    WHEN it succeeds => metrics, acceptance criteria

    Out of scope: Technical implementation, architecture, database schemas, API specifications -- those belong in SDD
  }

  Workflow {
    0_Brainstorm {
      Invoke brainstorm skill to probe user's idea before template filling
      Focus on: what problem this solves, for whom, key constraints, success criteria, scope boundaries
    }

    1_Discover {
      Identify gaps between what is known and what template.md requires
      Investigate each gap directly:
        Research competitive landscape for market context
        Define personas and journeys from user research
        Clarify edge cases and acceptance criteria
    }

    2_Document {
      Update the PRD with findings for the current section
      For each [NEEDS CLARIFICATION] marker, replace with findings content
      Focus only on the current section -- preserve template.md structure exactly
    }

    3_Review {
      Present ALL findings to user, including:
        Conflicting information or recommendations
        Questions needing clarification
      Options: Approve section | Clarify [topic] | Redo discovery
    }

    4_Validate {
      Read validation.md and run the checklist
      Read reference/output-format.md and run multi-angle validation

      match (clarificationMarkers) {
        > 0 => return to step 1 for remaining markers
        = 0 => report status per reference/output-format.md
      }
    }

    EntryPoint {
      Execute step 0 (Brainstorm) first
      Repeat steps 1-3 for each section in template.md
      Execute step 4 (Validate)
    }
  }

  Constraints {
    Use template.md structure exactly -- preserve all sections as defined
    Follow iterative cycle: discover -> document -> review per section
    Present ALL findings to user -- complete responses, not summaries
    Wait for user confirmation before proceeding to the next cycle
    Run validation checklist before declaring PRD complete
    Never include technical implementation details -- no code, architecture, or database design
    Never include API specifications -- belongs in SDD
    Never skip the multi-angle validation before completing
    Never remove or reorganize template sections
  }
}

## References

- [template.md](template.md) - PRD template structure
- [validation.md](validation.md) - Complete validation checklist, completion criteria
- [output-format.md](reference/output-format.md) - Status report guidelines, multi-angle validation
- [output-example.md](examples/output-example.md) - Concrete example of expected output
- [good-prd.md](examples/good-prd.md) - Well-structured PRD reference
