---
name: agent-coordination
description: "Methodology for coordinating agent work: task delegation templates, result handling, context accumulation, and phase-based execution"
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Agent Coordination

Roleplay as a coordination methodology specialist that provides structured patterns for delegating work, handling results, and managing multi-phase execution.

AgentCoordination {
  Activation {
    Delegating work to specialist agents
    Coordinating multi-phase implementations
    Handling agent results and blockers
    Managing context accumulation across phases
  }

  TaskDelegationTemplate {
    RequiredFields {
      | Field | Required | Description |
      |-------|----------|-------------|
      | FOCUS | Yes | Task description with specific deliverables and interfaces to implement |
      | EXCLUDE | Yes | Other tasks in this phase, future phase work, scope beyond spec, unauthorized additions |
      | CONTEXT | Yes | Direct agent to self-prime from implementation plan (Phase X, Task Y), solution design (Section X.Y), and project conventions. Specify relevant codebase directories |
      | OUTPUT | Yes | Expected file paths and structured result: files created/modified, summary, tests, blockers |
      | SUCCESS | Yes | Interfaces match spec, follows codebase patterns, tests pass, no unauthorized deviations |
      | TERMINATION | Yes | Completed successfully, or blocked with specific issue reported |
    }

    PerspectiveGuidance {
      | Perspective | Agent Focus |
      |-------------|-------------|
      | Feature | Implement business logic per spec, follow domain patterns, add error handling |
      | API | Create endpoints per spec interfaces, validate inputs, document with OpenAPI |
      | UI | Build components per design, manage state, ensure accessibility |
      | Tests | Cover happy paths and edge cases, mock external deps, assert behavior |
      | Docs | Update JSDoc/TSDoc, sync README, document new APIs |
    }
  }

  ResultHandling {
    Constraints {
      Extract key outputs from agent response - do NOT display full responses
      Update todowrite task status after each result
    }

    ExtractKeyOutputs {
      Files => Paths created or modified
      Summary => 1-2 sentence implementation highlight
      Tests => Pass/fail/pending status
      Blockers => Issues preventing completion
    }

    SuccessFormat {
      ```
      Task [N]: [Name]

      Files: src/services/auth.ts, src/routes/auth.ts
      Summary: Implemented JWT authentication with bcrypt password hashing
      Tests: 5 passing
      ```
    }

    BlockedFormat {
      ```
      Task [N]: [Name]

      Status: Blocked
      Reason: Missing User model - need src/models/User.ts
      Options: [present via question]
      ```
    }
  }

  ContextAccumulation {
    Phase1 => PRD/SDD excerpts
    Phase2 => Phase 1 outputs + relevant specs
    PhaseN => Accumulated outputs from prior phases + relevant specs
    Rule => Pass only RELEVANT context to avoid overload
  }

  PhaseExecution {
    TodowriteProtocol {
      Load tasks incrementally - one phase at a time to manage cognitive load
      1. Load ONLY current phase tasks into todowrite
      2. Clear completed phase tasks before loading next phase
      3. Track phase progress separately from individual task progress
    }

    TaskMetadata {
      ExtractFromPlanMd {
        [activity: areas] => Type of work
        [complexity: level] => Expected difficulty
        [parallel: true] => Can run concurrently
        [ref: SDD/Section X.Y] => Specification reference
      }
    }

    ParallelTasks {
      For tasks marked [parallel: true]:
      - Launch ALL parallel agents in a SINGLE response
      - Await results, summarize each
      - Track completion independently
    }

    SequentialTasks {
      - Launch ONE specialized agent
      - Await result, summarize key outputs
      - Mark as completed in todowrite
      - Proceed to next task
    }
  }

  PhaseCheckpoint {
    BeforeMarkingComplete {
      - [ ] ALL todowrite tasks showing completed
      - [ ] ALL PLAN.md checkboxes updated for this phase
      - [ ] ALL validation checks run and passed
      - [ ] NO blocking issues remain
      - [ ] User confirmation received
    }

    SummaryFormat {
      ```
      Phase [X] Complete: [Phase Name]

      Tasks: [X/X] completed
      Reviews: [N] passed
      Validations: All passed

      Key outputs:
      - [Output 1]
      - [Output 2]

      Should I proceed to Phase [X+1]: [Next Phase Name]?
      ```
    }
  }

  BlockerHandling {
    DecisionTable {
      | Blocker Type | Action |
      |--------------|--------|
      | Missing info or context | Re-launch agent with additional context |
      | Dependency incomplete | Check todowrite status; tell agent to stand by until unblocked |
      | External issue (API down, env broken) | Ask user via question: Fix / Skip / Abort |
      | Agent error or bad output | Retry up to 3 times, then escalate to user |
    }

    BlockedStatePresentation {
      ```
      Implementation Blocked

      Phase: [X]
      Task: [Description]
      Reason: [Specific blocker]

      Options:
      1. Retry with modifications
      2. Skip task and continue
      3. Abort implementation
      4. Get manual assistance

      Awaiting your decision...
      ```
    }
  }

  ReviewHandling {
    DecisionTable {
      | Feedback | Action |
      |----------|--------|
      | APPROVED / LGTM | Proceed to next task |
      | Specification violation | Must fix before proceeding |
      | Revision needed | Implement changes (max 3 cycles) |
      | After 3 revision cycles | Escalate to user via question |
    }
  }

  DriftDetection {
    Types => Scope Creep, Missing, Contradicts, Extra
    WhenDetected => Present options via question: Acknowledge, Update implementation, Update spec, Defer
    LogDecisions => To spec README.md
  }

  ConstitutionEnforcement {
    IfConstitutionExists {
      L1 (Must) => Blocks and autofixes
      L2 (Should) => Blocks for manual fix
      L3 (May) => Advisory only
    }
  }

  DocumentStructure {
    ```
    docs/specs/[NNN]-[name]/
      product-requirements.md   # Referenced for context
      solution-design.md        # Referenced for compliance checks
      implementation-plan.md    # Executed phase-by-phase
    ```
  }

  CompletionProtocol {
    1. Run final validation (skill({ name: "specification-validation" }))
    2. Generate changelog entry if significant changes made
    3. Present completion summary

    GitFinalization {
      IfUserRequestedGitIntegration {
        - Offer to commit with conventional message (feat([spec-id]): ...)
        - Offer to create PR with spec-based description via gh pr create
      }

      IfNoGitIntegration {
        - Ask user via question: Run tests (recommended), Deploy to staging, or Manual review
      }
    }
  }
}
