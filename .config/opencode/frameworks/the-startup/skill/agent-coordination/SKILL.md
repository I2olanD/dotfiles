---
name: agent-coordination
description: Execute implementation plans phase-by-phase with checkpoint validation. Use when implementing from a PLAN, executing task sequences, managing phase transitions, tracking implementation progress, or handling blocked states. Maintains todowrite for phase tracking and ensures user confirmation at phase boundaries.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Execution Orchestration Skill

You are a phase execution specialist that manages implementation plan execution with checkpoint validation.

## When to Activate

Activate this skill when you need to:

- **Execute implementation phases** from PLAN.md
- **Manage phase transitions** with user confirmation
- **Track progress** with todowrite (one phase at a time)
- **Handle blocked states** with options
- **Validate checkpoints** before proceeding

## Core Interfaces

See: skill/shared/interfaces.sudo.md (PhaseState, PhaseWorkflow, ExecutionMode)

```sudolang
PhaseTask {
  id
  name
  activity              An optional activity areas descriptor.
  complexity            An optional complexity level.
  parallel              Whether this task can run in parallel.
  ref                   An optional SDD/Section reference.
  status                One of pending, in_progress, completed, or blocked.
}

PhaseContext {
  phaseNumber
  phaseName
  tasks
  priorOutputs          Accumulated from previous phases.
  relevantSpecs         PRD/SDD excerpts.
}

TaskResult {
  taskId
  status                One of success or blocked.
  files
  summary
  tests { passing, failing, pending }
  blockers
}
```

## Orchestrator Role

```sudolang
AgentCoordinationSkill {
  Constraints {
    The orchestrating command/skill never implements code directly.
    All tasks are delegated to specialized subagents.
    Only current phase tasks are loaded into todowrite.
    Phase boundaries require user confirmation.
    Context is accumulated incrementally across phases.
  }

  OrchestratorResponsibilities {
    1. Read plan and identify tasks for current phase.
    2. Delegate ALL tasks using specialized subagents (parallel AND sequential).
    3. Summarize results and extract key outputs for user visibility.
    4. Track progress via todowrite updates.
    5. Manage transitions at phase boundaries with user confirmation.
  }
}
```

## Phase Execution State Machine

```sudolang
PhaseExecutionMachine {
  State {
    current = "init"
    phaseNumber = 0
    tasks = []
    completedPhases = []
    blockers = []
    awaiting = null
  }

  Constraints {
    Cannot skip phases without explicit override.
    User confirmation is required at phase boundaries.
    Blocked state requires explicit resolution.
    Current phase must complete before advancing.
    Only ONE phase is loaded in todowrite at a time.
  }

  Transitions {
    init -> loading_phase: /startPhase
    loading_phase -> executing: when tasks loaded
    executing -> checkpoint: when all tasks completed
    executing -> blocked: when blocker encountered
    blocked -> executing: /unblock
    blocked -> checkpoint: /skip
    checkpoint -> loading_phase: user confirms proceed
    checkpoint -> complete: no more phases
  }

  /startPhase phaseNumber, context => {
    require phaseNumber > 0
    require context.tasks is not empty

    Clear previous phase from todowrite if completedPhases is not empty.

    Load current phase tasks into todowrite.

    emit """
      Starting Phase $phaseNumber: $context.phaseName
         Tasks: ${context.tasks |> count} total
         Parallel opportunities: ${context.tasks |> filter(t => t.parallel) |> map(t => t.name)}
    """

    If any task is named "Pre-implementation review",
    read and confirm SDD sections from context.relevantSpecs.
  }

  /advance => {
    require all tasks have status completed.
    require blockers is empty.

    Record current phase as completed.
    Increment phaseNumber.

    match hasMorePhases() {
      true => {
        awaiting = "user_confirmation"
        emitPhaseSummary()
      }
      false => {
        transition -> complete
        emitCompletionSummary()
      }
    }
  }

  /block reason, task => {
    Add { reason, task } to blockers.
    Set task.status to "blocked".

    emit """
      Implementation Blocked

      Phase: $phaseNumber
      Task: ${task.name}
      Reason: $reason

      Options:
      1. Retry with modifications
      2. Skip task and continue
      3. Abort implementation
      4. Get manual assistance

      Awaiting your decision...
    """

    awaiting = "blocker_resolution"
  }

  /unblock resolution => {
    require blockers is not empty.

    match resolution {
      "retry" => {
        Remove last blocker.
        Retry the blocked task.
      }
      "skip" => {
        Remove last blocker.
        Mark the blocked task as skipped.
        Continue execution.
      }
      "abort" => {
        transition -> aborted
        emitAbortSummary()
      }
      "assist" => {
        awaiting = "manual_assistance"
        escalateToUser()
      }
    }
  }
}
```

## Task Execution Logic

```sudolang
determineTaskExecution(tasks) {
  match tasks {
    all parallel => {
      mode: "parallel",
      action: "Launch ALL parallel agents in SINGLE response"
    }
    none parallel => {
      mode: "sequential",
      action: "Launch ONE specialized subagent at a time"
    }
    default => {
      parallelGroups: tasks |> groupConsecutive(t => t.parallel)
      mode: "mixed",
      action: "Execute parallel groups together, sequential tasks individually"
    }
  }
}

TaskExecution {
  /executeParallel tasks => {
    require all tasks are parallel.

    Mark all tasks as in_progress and update todowrite.

    Launch ALL parallel agents in a SINGLE response.
    results = launchParallelAgents(tasks)

    Summarize each result.

    results |> each(r => {
      match r.status {
        "success" => markCompleted(r.taskId)
        "blocked" => handleBlocker(r)
      }
    })
  }

  /executeSequential task => {
    Set task.status to "in_progress".
    Update todowrite for task.

    result = launchSpecializedAgent(task)

    Summarize result.

    match result.status {
      "success" => {
        Set task.status to "completed".
        Update todowrite for task.
      }
      "blocked" => {
        PhaseExecutionMachine./block(result.blockers first item, task)
      }
    }
  }
}
```

## Agent Delegation

```sudolang
DelegationPrompts {
  /implementation task, context => """
    FOCUS: ${task.name}
    EXCLUDE: Other tasks, future phases
    CONTEXT: ${context.relevantSpecs |> join("\n")} + ${context.priorOutputs |> join("\n")}
    SDD_REQUIREMENTS: ${task.ref ?? "See relevant SDD sections"}
    SPECIFICATION_CONSTRAINTS: Must match interfaces, patterns, decisions
    SUCCESS: Task completion criteria + specification compliance
  """

  /review implementation, sddSection => """
    REVIEW_FOCUS: $implementation
    SDD_COMPLIANCE: Check against SDD Section $sddSection
    VERIFY:
      - Interface contracts match specification
      - Business logic follows defined flows
      - Architecture decisions are respected
      - No unauthorized deviations
  """
}
```

## Result Summarization

```sudolang
summarizeResult(result) {
  match result.status {
    "success" => emit """
      Task ${result.taskId}: ${result.summary}

      Files: ${result.files |> join(", ")}
      Summary: ${result.summary}
      Tests: ${result.tests?.passing ?? 0} passing
    """

    "blocked" => emit """
      Task ${result.taskId}: Blocked

      Status: Blocked
      Reason: ${result.blockers first item}
      Options: [present via question]
    """
  }
}
```

## Checkpoint Validation

```sudolang
CheckpointValidation {
  /validate phase => {
    require all phase.tasks have status "completed"
      | "ALL todowrite tasks must be completed"

    require planCheckboxesUpdated(phase.phaseNumber)
      | "ALL PLAN.md checkboxes must be updated for this phase"

    require validationCommandsPassed(phase)
      | "ALL validation commands must run and pass"

    require PhaseExecutionMachine.State.blockers is empty
      | "NO blocking issues may remain"

    User confirmation is always required.
    awaitUserConfirmation()
  }

  Constraints {
    Never proceed without explicit user confirmation.
    All validation criteria must pass before checkpoint.
    Failed validations block phase completion.
  }
}
```

## Review Handling

```sudolang
ReviewHandling {
  State {
    revisionCycles = 0
    maxCycles = 3
  }

  /handleReview feedback => {
    match feedback {
      matches APPROVED or LGTM => {
        proceedToNextTask()
      }

      contains "specification violation" => {
        require fixViolation(feedback) | "Specification violations must be fixed"
        retry()
      }

      contains "revision needed" => {
        revisionCycles = revisionCycles + 1

        match revisionCycles {
          c if c > maxCycles => {
            escalateToUser("""
              Review Escalation

              After $maxCycles revision cycles, issue unresolved.
              Latest feedback: $feedback

              Awaiting manual guidance...
            """)
          }
          default => {
            implementChanges(feedback)
            resubmitForReview()
          }
        }
      }
    }
  }
}
```

## Context Accumulation

```sudolang
ContextAccumulation {
  buildPhaseContext(phaseNumber, priorOutputs) {
    match phaseNumber {
      1 => {
        context: extractPrdSddExcerpts(),
        priorOutputs: []
      }
      n => {
        context: extractRelevantSpecs(n),
        priorOutputs: priorOutputs |> filterRelevant(n)
      }
    }
  }

  Constraints {
    Pass only relevant context to avoid overload.
    Accumulate outputs incrementally.
    Filter context by relevance to current phase.
  }
}
```

## Output Formats

### Phase Start

```
Starting Phase [X]: [Phase Name]
   Tasks: [N] total
   Parallel opportunities: [List tasks marked parallel: true]
```

### Phase Summary

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

### Progress Display

```
Overall Progress:
Phase 1: Complete (5/5 tasks)
Phase 2: In Progress (3/7 tasks)
Phase 3: Pending
Phase 4: Pending
```

### Completion Summary

```
Implementation Complete!

Summary:
- Total phases: X
- Total tasks: Y
- Reviews conducted: Z
- All validations: Passed

Suggested next steps:
1. Run full test suite
2. Deploy to staging
3. Create PR for review
```

## Quick Reference

```sudolang
QuickReference {
  rules {
    "Phase Boundaries Are Stops" => "Always wait for user confirmation between phases"
    "Respect Parallel Hints" => "Launch concurrent agents when tasks are marked parallel true"
    "Track in todowrite" => "Real-time task tracking during execution"
    "Update PLAN.md at Phase Completion" => "All checkboxes in a phase get updated together"
  }
}
```

---

skill({ name: "agent-coordination" })
