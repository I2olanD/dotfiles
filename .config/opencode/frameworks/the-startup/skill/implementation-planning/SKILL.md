---
name: implementation-planning
description: "Provides methodology for creating actionable implementation plans with TDD phase structure, task granularity principles, specification compliance gates, and deviation protocols"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Implementation Planning

Roleplay as an implementation plan specialist that creates actionable plans breaking features into executable tasks following TDD principles. Plans enable developers to work independently without requiring clarification.

ImplementationPlanning {
  Activation {
    When to use this skill:
    - Create a new PLAN from the template
    - Complete phases in an existing implementation-plan.md
    - Define task sequences and dependencies
    - Plan TDD cycles (Prime to Test to Implement to Validate)
    - Work on any `implementation-plan.md` file in docs/specs/
  }

  SuccessCriteria {
    A plan is complete when:
    - [ ] A developer can follow it independently without additional context
    - [ ] Every task produces a verifiable deliverable (not just an activity)
    - [ ] All PRD acceptance criteria map to specific tasks
    - [ ] All SDD components have corresponding implementation tasks
    - [ ] Dependencies are explicit and no circular dependencies exist
  }

  Template {
    Constraints {
      1. The PLAN template is at [template.md](template.md) -- use this structure exactly
      2. Read the template from this skill's directory
      3. Write to spec directory: `docs/specs/[NNN]-[name]/implementation-plan.md`
    }
  }

  PlanFocusAreas {
    Questions {
      Your plan MUST answer these questions:
      - **WHAT** produces value? (deliverables, not activities)
      - **IN WHAT ORDER** do tasks execute? (dependencies and sequencing)
      - **HOW TO VALIDATE** correctness? (test-first approach)
      - **WHERE** is each task specified? (links to PRD/SDD sections)
    }

    Constraints {
      Keep plans actionable and focused:
      1. Use task descriptions, sequence, and validation criteria
      2. Omit time estimates -- focus on what, not when
      3. Omit resource assignments -- focus on work, not who
      4. Omit implementation code -- the plan guides, implementation follows
    }
  }

  TaskGranularityPrinciple {
    Definition: Track logical units that produce verifiable outcomes. The TDD cycle is the execution method, not separate tracked items.

    GoodTrackingUnits {
      Produces outcome:
      - "Payment Entity" produces working entity with tests
      - "Stripe Adapter" produces working integration with tests
      - "Payment Form Component" produces working UI with tests
    }

    BadTrackingUnits {
      Too granular:
      - "Read payment interface contracts" -- Preparation, not deliverable
      - "Test Payment.validate() rejects negative amounts" -- Part of larger outcome
      - "Run linting" -- Validation step, not deliverable
    }

    StructurePattern {
      ```markdown
      - [ ] **T1.1 Payment Entity** `[activity: domain-modeling]`

        **Prime**: Read payment interface contracts `[ref: SDD/Section 4.2; lines: 145-200]`

        **Test**: Entity validation rejects negative amounts; supports currency conversion; handles refunds

        **Implement**: Create `src/domain/Payment.ts` with validation logic

        **Validate**: Run unit tests, lint, typecheck
      ```

      The checkbox tracks "Payment Entity" as a unit. Prime/Test/Implement/Validate are embedded guidance.
    }
  }

  TDDPhaseStructure {
    Definition: Every task follows red-green-refactor within this pattern

    Phase1_PrimeContext {
      - Read relevant specification sections
      - Understand interfaces and contracts
      - Load patterns and examples
    }

    Phase2_WriteTests_Red {
      - Test behavior before implementation
      - Reference PRD acceptance criteria
      - Cover happy path and edge cases
    }

    Phase3_Implement_Green {
      - Build to pass tests
      - Follow SDD architecture
      - Use discovered patterns
    }

    Phase4_Validate_Refactor {
      - Run automated tests
      - Check code quality (lint, format)
      - Verify specification compliance
    }
  }

  TaskMetadata {
    Annotations {
      ```markdown
      - [ ] T1.2.1 [Task description] `[ref: SDD/Section 5; lines: 100-150]` `[activity: backend-api]`
      ```
    }

    MetadataTable {
      | Metadata | Description |
      |----------|-------------|
      | `[parallel: true]` | Tasks that can run concurrently |
      | `[component: name]` | For multi-component features |
      | `[ref: doc/section; lines: X-Y]` | Links to specifications |
      | `[activity: type]` | Hint for specialist selection |
    }
  }

  CyclePattern {
    DiscoveryPhase {
      - Read PRD and SDD to understand requirements and design
      - Identify activities needed for each implementation area
      - Launch parallel specialist agents to investigate:
        - Task sequencing and dependencies
        - Testing strategies
        - Risk assessment
        - Validation approaches
    }

    DocumentationPhase {
      - Update the PLAN with task definitions
      - Add specification references (`[ref: ...]`)
      - Focus only on current phase being defined
      - Follow template structure exactly
    }

    ReviewPhase {
      - Present task breakdown to user
      - Show dependencies and sequencing
      - Highlight parallel opportunities
      - Wait for user confirmation before next phase
    }

    SelfCheck {
      Ask yourself each cycle:
      1. Have I read the relevant PRD and SDD sections?
      2. Do all tasks trace back to specification requirements?
      3. Are dependencies between tasks clear?
      4. Can parallel tasks actually run in parallel?
      5. Are validation steps included in each phase?
      6. Have I received user confirmation?
    }
  }

  SpecificationCompliance {
    PhaseValidationTask {
      Every phase should include a validation task:
      ```markdown
      - [ ] **T1.3 Phase Validation** `[activity: validate]`

        Run all phase tests, linting, type checking. Verify against SDD patterns and PRD acceptance criteria.
      ```

      For complex phases, validation is embedded in each task's **Validate** step.
    }

    DeviationProtocol {
      When implementation requires changes from the specification:
      1. Document the deviation with clear rationale
      2. Obtain approval before proceeding
      3. Update SDD when the deviation improves the design
      4. Record all deviations in the plan for traceability
    }
  }

  ValidationChecklist {
    See [validation.md](validation.md) for the complete checklist. Key gates:
    - [ ] All specification file paths are correct and exist
    - [ ] Context priming section is complete
    - [ ] All implementation phases are defined
    - [ ] Each phase follows TDD: Prime to Test to Implement to Validate
    - [ ] Dependencies between phases are clear (no circular dependencies)
    - [ ] Parallel work is properly tagged with `[parallel: true]`
    - [ ] Activity hints provided for specialist selection `[activity: type]`
    - [ ] Every phase references relevant SDD sections
    - [ ] Every test references PRD acceptance criteria
    - [ ] Integration and E2E tests defined in final phase
    - [ ] Project commands match actual project setup
    - [ ] A developer could follow this plan independently
  }

  Examples {
    See [examples/phase-examples.md](examples/phase-examples.md) for reference.
  }
}
