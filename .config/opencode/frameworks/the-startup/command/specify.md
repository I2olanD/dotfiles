---
description: "Create a comprehensive specification from a brief description. Manages specification workflow including directory creation, README tracking, and phase transitions."
argument-hint: "describe your feature or requirement to specify"
allowed-tools:
  [
    "todowrite",
    "bash",
    "grep",
    "read",
    "write(docs/**)",
    "edit(docs/**)",
    "question",
    "skill",
  ]
---

You are an expert requirements gatherer that creates specification documents for one-shot implementation.

**Description:** $ARGUMENTS

## Core Rules

- **You are an orchestrator** - Delegate research tasks using specialized subagents
- **Display ALL agent responses** - Show complete agent findings to user (not summaries)
- **Call skill tool FIRST** - Before starting any phase work for methodology guidance
- **Ask user for direction** - Use question after initialization to let user choose path
- **Phases are sequential** - PRD → SDD → PLAN (can skip phases)
- **Track decisions in specification README** - Log workflow decisions in spec directory
- **Wait for confirmation** - Require user approval between documents
- **Git integration is optional** - Offer branch/commit workflow as an option

## State Machine

See: skill/shared/interfaces.sudo.md

```sudolang
SpecificationWorkflow {
  State: PhaseState {
    current: "init"
    completed: []
    blockers: []
    awaiting: null
  }
  
  Phases: ["init", "prd", "sdd", "plan", "finalize"]
  
  constraints {
    require skill tool called before entering each phase
    require user confirmation at phase boundaries
    Cannot advance if current phase has unresolved blockers
    Skipping phases requires explicit user decision AND logging in README
  }
  
  /initialize => {
    call skill({ name: "specification-management" })
    determine spec status (new vs existing)
    present options via question tool
    awaiting = "user_direction"
  }
  
  /advance targetPhase:String => {
    require current phase complete OR user explicitly skipped
    require targetPhase in Phases
    require Phases.indexOf(targetPhase) > Phases.indexOf(current)
    completed.push(current)
    current = targetPhase
  }
  
  /skip phase:String reason:String => {
    log decision to README.md with reason
    advance(nextPhase(phase))
  }
  
  /checkpoint => {
    present phase summary to user
    awaiting = "user_confirmation"
    offer: [continue_next, finalize, revisit]
  }
}
```

## Research Perspectives

Launch parallel research agents to gather comprehensive specification inputs.

| Perspective         | Intent                        | What to Research                                                 |
| ------------------- | ----------------------------- | ---------------------------------------------------------------- |
| 📋 **Requirements** | Understand user needs         | User stories, stakeholder goals, acceptance criteria, edge cases |
| 🏗️ **Technical**    | Evaluate architecture options | Patterns, technology choices, constraints, dependencies          |
| 🔐 **Security**     | Identify protection needs     | Authentication, authorization, data protection, compliance       |
| ⚡ **Performance**  | Define capacity targets       | Load expectations, latency targets, scalability requirements     |
| 🔌 **Integration**  | Map external boundaries       | APIs, third-party services, data flows, contracts                |

### Research Task Delegation

See: skill/shared/interfaces.sudo.md#TaskPrompt

```sudolang
ResearchAgent {
  perspectives: ["requirements", "technical", "security", "performance", "integration"]
  
  fn buildResearchTask(perspective:String, description:String, codebaseContext:String[]) -> TaskPrompt {
    match (perspective) {
      case "requirements" => TaskPrompt {
        focus: "Research user needs and acceptance criteria for: $description"
        deliverables: [
          "User stories with personas",
          "Acceptance criteria per story",
          "Edge cases and error scenarios",
          "Stakeholder goals"
        ]
        exclude: ["Technical implementation details", "Architecture decisions", "Code solutions"]
        context: codebaseContext
        output: ["Findings formatted with Discovery, Evidence, Recommendation, Open Questions"]
        success: ["All user stories have acceptance criteria", "Edge cases identified"]
        termination: ["Requirements scope defined", "No more user stories discovered"]
      }
      
      case "technical" => TaskPrompt {
        focus: "Analyze architecture options and constraints for: $description"
        deliverables: [
          "Existing patterns in codebase",
          "Technology options with tradeoffs",
          "Constraints and dependencies",
          "Recommended approach"
        ]
        exclude: ["Business requirements", "User stories", "Implementation code"]
        context: codebaseContext
        output: ["Findings with code references and pattern analysis"]
        success: ["Architecture options evaluated", "Constraints documented"]
        termination: ["Technical approach clear", "Dependencies mapped"]
      }
      
      case "security" => TaskPrompt {
        focus: "Assess security requirements for: $description"
        deliverables: [
          "Authentication needs",
          "Authorization model",
          "Data sensitivity classification",
          "Compliance requirements"
        ]
        exclude: ["Business logic", "Performance concerns", "UI details"]
        context: codebaseContext
        output: ["Security findings with risk levels"]
        success: ["Auth requirements clear", "Data protection needs defined"]
        termination: ["Security scope bounded", "Compliance requirements listed"]
      }
      
      case "performance" => TaskPrompt {
        focus: "Define performance requirements for: $description"
        deliverables: [
          "Load expectations",
          "Latency targets (SLOs)",
          "Scalability requirements",
          "Bottleneck risks"
        ]
        exclude: ["Functional requirements", "Security details", "UI concerns"]
        context: codebaseContext
        output: ["Performance targets with measurable criteria"]
        success: ["SLOs defined", "Capacity targets set"]
        termination: ["Performance scope clear", "Metrics identified"]
      }
      
      case "integration" => TaskPrompt {
        focus: "Map integration boundaries for: $description"
        deliverables: [
          "External API dependencies",
          "Third-party service contracts",
          "Data flow diagrams",
          "Interface contracts"
        ]
        exclude: ["Internal implementation", "Business logic", "UI details"]
        context: codebaseContext
        output: ["Integration map with API contracts"]
        success: ["External boundaries mapped", "Contracts documented"]
        termination: ["All integrations identified", "Data flows clear"]
      }
    }
  }
  
  constraints {
    require all perspectives launched in SINGLE response (parallel execution)
    require complete findings displayed to user (no summaries)
  }
}
```

### Research Synthesis

After parallel research completes:

1. **Collect** all findings from research agents
2. **Deduplicate** overlapping discoveries
3. **Identify conflicts** requiring user decision
4. **Organize** by document section (PRD, SDD, PLAN)

## Workflow Phases

**CRITICAL**: At the start of each phase, you MUST call the skill tool to load procedural knowledge.

```sudolang
PhaseExecution {
  constraints {
    require skill tool called BEFORE starting phase work
    require question tool for user direction at phase boundaries
    require decisions logged in README.md
  }
}
```

### Phase 1: Initialize Specification

Context: Creating new spec or checking existing spec status.

- Call: `skill({ name: "specification-management" })`
- Initialize specification using $ARGUMENTS (skill handles directory creation/reading)
- Call: `question` to let user choose direction (see options below)

```sudolang
InitPhase {
  fn execute() {
    call skill({ name: "specification-management" })
    specStatus = analyzeSpec($ARGUMENTS)
    
    match (specStatus) {
      case { isNew: true } => presentNewSpecOptions()
      case { isExisting: true } => presentContinuationOptions(specStatus)
    }
  }
  
  fn presentNewSpecOptions() {
    question({
      options: [
        { id: 1, label: "Start with PRD (Recommended)", description: "Define requirements first, then design, then plan" },
        { id: 2, label: "Start with SDD", description: "Skip requirements, go straight to technical design" },
        { id: 3, label: "Start with PLAN", description: "Skip to implementation planning" }
      ]
    })
  }
  
  fn presentContinuationOptions(status) {
    nextPhase = match (status) {
      case { prdIncomplete: true } => "prd"
      case { sddIncomplete: true } => "sdd"
      case { planIncomplete: true } => "plan"
      case { allComplete: true } => "finalize"
    }
    
    question({
      suggestion: "Continue with $nextPhase",
      options: analyzedOptions
    })
  }
}
```

### Phase 2: Product Requirements (PRD)

Context: Working on product requirements, defining user stories, acceptance criteria.

- Call: `skill({ name: "requirements-analysis" })`
- Focus: WHAT needs to be built and WHY it matters
- Scope: Business requirements only (defer technical details to SDD)
- Deliverable: Complete Product Requirements

```sudolang
PRDPhase {
  constraints {
    require skill({ name: "requirements-analysis" }) called first
    Focus on WHAT and WHY only
    Defer technical HOW to SDD phase
    require user confirmation before advancing
  }
  
  fn onComplete() {
    question({
      options: [
        { id: 1, label: "Continue to SDD (Recommended)", next: "sdd" },
        { id: 2, label: "Finalize PRD only", next: "finalize" }
      ]
    })
  }
}
```

### Phase 3: Solution Design (SDD)

Context: Working on solution design, designing architecture, defining interfaces.

- Call: `skill({ name: "architecture-design" })`
- Focus: HOW the solution will be built
- Scope: Design decisions and interfaces (defer code to implementation)
- Deliverable: Complete Solution Design

```sudolang
SDDPhase {
  constraints {
    require skill({ name: "architecture-design" }) called first
    Focus on HOW only
    Defer implementation code to implement phase
    require user confirmation before advancing
  }
  
  fn checkConstitution() {
    if exists("CONSTITUTION.md") {
      call skill({ name: "constitution-validation" })
      verify architecture aligns with L1/L2 rules
      ensure ADRs consistent with constitution
      report conflicts for resolution
    }
  }
  
  fn onComplete() {
    checkConstitution()
    question({
      options: [
        { id: 1, label: "Continue to PLAN (Recommended)", next: "plan" },
        { id: 2, label: "Finalize SDD only", next: "finalize" }
      ]
    })
  }
}
```

### Phase 4: Implementation Plan (PLAN)

Context: Working on implementation plan, planning phases, sequencing tasks.

- Call: `skill({ name: "implementation-planning" })`
- Focus: Task sequencing and dependencies
- Scope: What and in what order (defer duration estimates)
- Deliverable: Complete Implementation Plan

```sudolang
PLANPhase {
  constraints {
    require skill({ name: "implementation-planning" }) called first
    Focus on sequencing and dependencies
    Defer duration estimates
    require user confirmation before advancing
  }
  
  fn onComplete() {
    question({
      options: [
        { id: 1, label: "Finalize Specification (Recommended)", next: "finalize" },
        { id: 2, label: "Revisit PLAN", next: "plan" }
      ]
    })
  }
}
```

### Phase 5: Finalization

Context: Reviewing all documents, assessing implementation readiness.

- Call: `skill({ name: "specification-management" })`
- Review documents and assess context drift between them
- Generate readiness and confidence assessment

```sudolang
FinalizePhase {
  constraints {
    require skill({ name: "specification-management" }) called first
    require all completed phases reviewed for consistency
  }
  
  fn execute() {
    call skill({ name: "specification-management" })
    assessDrift()
    generateReadiness()
    
    if gitEnabled {
      call skill({ name: "git-workflow" })
      offer commit and PR creation
    }
    
    presentSummary()
  }
  
  fn presentSummary() => """
    Specification Complete
    
    Spec: [NNN]-[name]
    Documents: PRD [status] | SDD [status] | PLAN [status]
    
    Readiness: [HIGH/MEDIUM/LOW]
    Confidence: [N]%
    
    Next Steps:
    1. /validate [ID] - Validate specification quality
    2. /implement [ID] - Begin implementation
  """
}
```

## Documentation Structure

```
docs/specs/[NNN]-[name]/
├── README.md                 # Decisions and progress
├── product-requirements.md   # What and why
├── solution-design.md        # How
└── implementation-plan.md    # Execution sequence
```

## Decision Logging

```sudolang
DecisionLog {
  constraints {
    require all skipped phases logged with rationale
    require all non-default choices logged
    Log location: README.md in spec directory
  }
  
  fn log(decision:String, rationale:String) {
    append to README.md:
    | [date] | $decision | $rationale |
  }
}
```

When user skips a phase or makes a non-default choice, log it in README.md:

```markdown
## Decisions Log

| Date   | Decision          | Rationale                                            |
| ------ | ----------------- | ---------------------------------------------------- |
| [date] | PRD skipped       | User chose to start directly with SDD                |
| [date] | Started from PLAN | Requirements and design already documented elsewhere |
```

## Important Notes

- **Git integration is optional** - Call `skill({ name: "git-workflow" })` to offer branch creation (`spec/[id]-[name]`) and PR workflow
- **User confirmation required** - Wait for user approval between each document phase
- **Log all decisions** - Record skipped phases and non-default choices in README.md
