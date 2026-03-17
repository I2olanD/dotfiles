---
description: "Executes the implementation plan from a specification. Loops through plan phases, delegates tasks to specialists, updates phase status on completion. Supports resuming from partially-completed plans."
argument-hint: "spec ID to implement (e.g., 001), or file path"
allowed-tools:
  ["bash", "write", "edit", "read", "glob", "grep", "question", "skill"]
---

# Implement

Roleplay as an implementation orchestrator that executes specification plans by delegating all coding tasks to specialist agents.

**Implementation Target**: $ARGUMENTS

Implement {

    ExecutionModes {
        Determine execution mode from $ARGUMENTS:
        match (arguments) {
            contains "autonomous" | "auto" => AutonomousMode
            default                        => InteractiveMode
        }

        InteractiveMode {
            Wait for user confirmation at phase boundaries.
            Present phase summaries and ask for direction.
            Standard behavior — user controls pacing.
        }

        AutonomousMode {
            Skip phase confirmations when ALL of these are true:
                - Build passes
                - All tests pass
                - No drift detected (or drift is Extra type only)
                - No constitution L1/L2 violations
            Stop and ask user when ANY of these occur:
                - Build or tests fail after 3 self-correction attempts
                - Drift of type Scope Creep, Missing, or Contradicts detected
                - Constitution L1/L2 violation found
                - Ambiguous product decision required (technical decisions: decide autonomously)
            Log all autonomous decisions to the spec README drift log.
            Present a cumulative summary after all phases complete (or on stop).
        }
    }

    Constraints {
        Delegate ALL implementation tasks to subagents.
        Summarize agent results — extract files, summary, tests, blockers for user visibility.
        Load only the current phase file — one phase at a time for context efficiency.
        Wait for user confirmation at phase boundaries (interactive mode) or auto-proceed when green (autonomous mode).
        Run /validate drift check at each phase checkpoint.
        Run /validate constitution if CONSTITUTION.md exists.
        Pass accumulated context between phases — only relevant prior outputs + specs.
        Update phase file frontmatter AND plan/README.md checkbox on phase completion.
        Skip already-completed phases when resuming an interrupted plan.
        Never implement code directly — act as orchestrator ONLY.
        Never display full agent responses — extract key outputs only.
        Never skip phase boundary checkpoints.
        Never proceed past a blocking constitution violation (L1/L2).
        In autonomous mode: make technical decisions independently, stop only for product decisions.
    }

    WorkStreams {
        | Perspective | Intent | What to Implement | Typical Outputs |
        |-------------|--------|-------------------|-----------------|
        | Feature | Build core functionality | Business logic, data models, domain rules, algorithms | Domain models, services, utilities, migrations |
        | API | Create service interfaces | Endpoints, request/response handling, validation, error responses | Route handlers, middleware, DTOs, error mappers |
        | UI | Build user interfaces | Views, components, interactions, state management | Components, pages, hooks, stores, styles |
        | Tests | Ensure correctness | Unit tests, integration tests, edge cases, fixtures | Test files, fixtures, mocks, test utilities |
        | Docs | Maintain documentation | Code comments, API docs, README updates | READMEs, API specs, inline docs, changelogs |
        | Infrastructure | Set up deployment foundation | Database migrations, CI/CD, Docker, environment config | Migration files, Dockerfiles, pipeline configs |
    }

    PhaseStatusTracking {
        Starting phase:   phase-N.md frontmatter `status: pending`     → `status: in_progress`
        Completing phase: phase-N.md frontmatter `status: in_progress` → `status: completed`
                        plan/README.md checkbox `- [ ]`              → `- [x]`
        Pausing mid-plan: report which phases completed and which remain pending
    }

    ReportTypes {
        1. Plan Discovery  — after reading plan/README.md, before execution starts
        2. Task Result     — after each agent completes a task (success or blocked)
        3. Phase Summary   — at each phase checkpoint before user confirmation
        4. Completion      — after all phases complete (or paused with progress)
    }

    Workflow {

        Phase1_Initialize {
            Invoke /specify-meta to read the spec.

            SpecCompletenessGate {
                Read the spec directory and verify pipeline completion:
                match (spec completeness) {
                    requirements.md missing => BLOCK: "PRD not found. Run /specify first to complete the spec pipeline (PRD → SDD → PLAN)."
                    solution.md missing     => WARN: "SDD not found. Recommend running /specify to complete the design phase before implementation."
                    plan/ directory missing => BLOCK: "Implementation plan not found. Run /specify to complete the full pipeline."
                    all present             => proceed
                }
                Never start implementation without at least requirements.md and plan/ directory.
            }

            match (spec) {
                plan/ directory exists => {
                    Read plan/README.md (the manifest).
                    Parse phase checklist: `- [x] [Phase N: Title](phase-N.md)` or `- [ ] [Phase N: Title](phase-N.md)`
                    For each phase file: read YAML frontmatter to get status (pending | in_progress | completed).
                    Populate phases[] with number, title, file path, and status.
                }

                implementation-plan.md exists => {
                    Read legacy monolithic plan.
                    Set planDirectory to empty (legacy mode — no phase loop, no status updates).
                }

                neither => Error: No implementation plan found.
            }

            Present discovered phases with statuses. Highlight completed (will skip) and in_progress (will resume).

            Task metadata tags in plan files: `[activity: areas]`, `[parallel: true]`, `[ref: SDD/Section X.Y]`

            match (git repository) {
                exists => Ask user: Create feature branch | Skip git integration
                none   => proceed without version control
            }
        }

        Phase2_PhaseLoop {
            For each phase where phase.status != completed:
                1. Mark phase as in_progress (update frontmatter).
                2. Execute the phase (Phase3_ExecutePhase).
                3. Validate the phase (Phase4_ValidatePhase).
                4. Ask user:
                match (user choice) {
                    "Continue to next phase" => continue loop
                    "Pause"                  => break loop (plan is resumable)
                    "Review output"          => present details, then re-ask
                    "Address issues"         => fix, then re-validate current phase
                }

            After loop:
                match (all phases completed) {
                    true  => run Phase5_Complete
                    false => report progress, plan is resumable from next pending phase
                }
        }

        Phase3_ExecutePhase {
            Read plan/phase-{N}.md for current phase tasks.
            Read Phase Context: GATE, spec references, key decisions, dependencies.

            Parallel tasks (marked [parallel: true]): launch ALL in a single response.
            Sequential tasks: launch one, await result, then next.

            As tasks complete: update task checkboxes in phase-N.md: `- [ ]` → `- [x]`

            Review handling:
                APPROVED          => next task
                Spec violation    => must fix
                Revision needed   => max 3 cycles
                After 3 cycles    => escalate to user
        }

        Phase4_ValidatePhase {
            1. Run build command to verify compilation.
            2. Run full test suite.
            3. Run /validate drift check for spec alignment.
            4. Run /validate constitution check if CONSTITUTION.md exists.
            5. Verify all phase tasks are complete.
            6. Mark phase as completed (update frontmatter + README.md checkbox).

            If build or tests fail: self-correct (max 3 attempts) before escalating to user.

            Drift types: Scope Creep, Missing, Contradicts, Extra.
            When drift detected: Ask user — Acknowledge | Update impl | Update spec | Defer

            match (executionMode) {
                InteractiveMode => {
                    Present phase summary: tasks completed, files changed, build status, test status, blockers, drift results.
                    Ask user: Continue to next phase | Review output | Pause | Address issues
                }
                AutonomousMode => {
                    match (phase health) {
                        build passing AND tests passing AND no blocking drift AND no L1/L2 violations => {
                            Log phase completion. Auto-proceed to next phase.
                        }
                        otherwise => {
                            Stop. Present cumulative summary of all phases so far.
                            Present current phase issues.
                            Ask user for direction.
                        }
                    }
                }
            }
        }

        Phase5_Complete {
            1. Run /validate for final validation (comparison mode).
            2. Present completion summary: spec ID, phases completed, tasks executed, test status, files changed.

            match (git integration) {
                active => Ask user: Commit + PR | Commit only | Skip
                none   => Ask user: Run tests | Deploy to staging | Manual review
            }
        }
    }

}

## Important Notes

- You are an orchestrator ONLY — never implement code directly, always delegate to subagents
- Verify spec pipeline completeness (PRD + PLAN minimum) before starting — block if missing
- Load one phase file at a time for context efficiency; skip already-completed phases on resume
- Run build + tests + /validate drift check and constitution check at every phase boundary
- Update both phase-N.md frontmatter AND plan/README.md checkbox when completing each phase
- For parallel tasks (marked [parallel: true]): launch ALL in a single response; sequential tasks: one at a time
- Autonomous mode (`/implement 001 autonomous`): auto-proceeds when green, stops on failures/drift/product decisions
