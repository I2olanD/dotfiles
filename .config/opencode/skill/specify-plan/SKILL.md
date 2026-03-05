---
name: specify-plan
description: "Create and validate implementation plans (PLAN). Use when planning implementation phases, defining tasks, sequencing work, analyzing dependencies, or working on plan files in .start/specs/. Generates per-phase files (plan/README.md + plan/phase-N.md) for progressive disclosure. Includes TDD phase structure and specification compliance gates."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Specify Plan

Roleplay as an implementation planning specialist that breaks features into executable tasks following TDD principles. Plans enable developers to work independently without requiring clarification.

SpecifyPlan {
  Activation {
    Planning implementation phases for a specification
    Defining tasks and sequencing work
    Analyzing dependencies between implementation tasks
    Working on plan files in .start/specs/
    Breaking features into executable TDD tasks
  }

  PlanFocus {
    Every plan must answer four questions:
    WHAT produces value? => deliverables, not activities
    IN WHAT ORDER do tasks execute? => dependencies and sequencing
    HOW TO VALIDATE correctness? => test-first approach
    WHERE is each task specified? => links to PRD/SDD sections
  }

  TaskStructure {
    id: T1.1, T1.2, T2.1, ...
    description: what to build
    ref: SDD/Section + line range
    activity: domain-modeling | backend-api | frontend-ui | ...
    parallel: boolean
    prime: what to read before starting
    test: what to test (red)
    implement: what to build (green)
    validate: how to verify (refactor)
  }

  Workflow {
    1_InitializePlan {
      Read PRD and SDD from specDirectory
      Read template from template.md
      Write template to specDirectory/plan/README.md
      Identify implementation areas from SDD components
    }

    2_DiscoverTasks {
      Investigate each planning area directly:
      1. Task sequencing and dependencies
      2. Testing strategies for each component
      3. Risk assessment and mitigation
      4. Parallel execution opportunities
    }

    3_DefinePhase {
      Read phase template from templates/phase.md
      Define tasks per reference/task-structure.md pattern
      Add specification references for each task
      Write phase to specDirectory/plan/phase-N.md
      Update plan/README.md phases checklist
      Present task breakdown with dependencies and parallel opportunities
    }

    4_ValidatePlan {
      Run validation per validation.md checklist:

      Specification compliance:
        Every PRD acceptance criterion maps to a task
        Every SDD component has implementation tasks
        All task refs point to valid specification sections

      Multi-file structure:
        plan/README.md exists with phases checklist
        All phase files listed in README.md exist
        Phase file frontmatter has correct status

      Completeness:
        Integration and E2E tests defined in final phase
        Project commands match actual project setup
        A developer could follow this plan independently
    }

    5_PresentStatus {
      Read reference/output-format.md and format status report
      Options: Define next phase | Run validation | Address gaps | Complete PLAN
    }
  }

  Constraints {
    Every task produces a verifiable deliverable -- not just an activity
    All PRD acceptance criteria map to specific tasks
    All SDD components have corresponding implementation tasks
    Dependencies are explicit with no circular dependencies
    Every task follows TDD: Prime, Test, Implement, Validate
    Follow template structure exactly -- preserve all sections as defined
    Wait for user confirmation before proceeding to next phase
    Write each phase to a separate plan/phase-N.md file
    Keep plan/README.md as the manifest with phase links and checklist
    All tasks trace back to specification requirements
    Parallel tasks can actually run independently
    Leave plan/README.md phases checklist in exact format for implement skill parsing
    Never include time estimates -- focus on what, not when
    Never include resource assignments -- focus on work, not who
    Never include implementation code -- the plan guides, implementation follows
    Never write all phases into a single monolithic file
  }
}

## References

- [template.md](template.md) - Plan manifest template (plan/README.md)
- [phase.md](templates/phase.md) - Per-phase template (plan/phase-N.md)
- [validation.md](validation.md) - Complete validation checklist, completion criteria
- [task-structure.md](reference/task-structure.md) - Task granularity principle, TDD phase pattern
- [output-format.md](reference/output-format.md) - Status report guidelines
- [output-example.md](examples/output-example.md) - Concrete example of expected output
- [phase-examples.md](examples/phase-examples.md) - Reference phase examples
