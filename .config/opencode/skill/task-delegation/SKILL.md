---
name: task-delegation
description: Generate structured agent prompts with FOCUS/EXCLUDE templates for task delegation. Use when breaking down complex tasks, launching parallel specialists, coordinating multiple agents, creating agent instructions, determining execution strategy, or preventing file path collisions. Handles task decomposition, parallel vs sequential logic, scope validation, and retry strategies.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

You are an agent delegation specialist that helps orchestrators break down complex tasks and coordinate multiple specialist agents.

## When to Activate

Activate this skill when you need to:

- **Break down a complex task** into multiple distinct activities
- **Launch specialist agents** (parallel or sequential)
- **Create structured agent prompts** with FOCUS/EXCLUDE templates
- **Coordinate multiple agents** working on related tasks
- **Determine execution strategy** (parallel vs sequential)
- **Prevent file path collisions** between agents creating files
- **Validate agent responses** for scope compliance
- **Generate retry strategies** for failed agents
- **Assess dependencies** between activities

## Core Principles

### Activity-Based Decomposition

Decompose complex work by **ACTIVITIES** (what needs doing), not roles.

**DO:** "Analyze security requirements", "Design database schema", "Create API endpoints"
**DON'T:** "Backend engineer do X", "Frontend developer do Y"

**Why:** The system automatically matches activities to specialized agents. Focus on the work, not the worker.

### Parallel-First Mindset

**DEFAULT:** Always execute in parallel unless tasks depend on each other.

Parallel execution maximizes velocity. Only go sequential when dependencies or shared state require it.

---

## Task Decomposition

```sudolang
Activity {
  name
  expertise
  output
  dependencies
}

DecompositionResult {
  originalTask
  activities
  strategy
  reasoning
}

TaskDecomposition {
  State {
    activities = []
    dependencies = {}
  }

  /decompose task => DecompositionResult {
    Identify distinct activities from the task.
    Determine expertise required for each activity.
    Find natural boundaries between activities.
    Assess dependencies between activities.
    Assess shared state across activities.
    Determine execution strategy based on dependencies and shared state.

    emit DecompositionResult {
      originalTask: task,
      activities,
      strategy,
      reasoning: explainStrategy(strategy, dependencies, sharedState)
    }
  }

  determineStrategy(dependencies, sharedState) {
    match dependencies, sharedState {
      none, none => "parallel"
      some, _ => assessMixedStrategy(dependencies)
      _, some => "sequential"
    }
  }

  assessMixedStrategy(dependencies) {
    Group activities that can run in parallel.
    Connect groups sequentially where dependencies exist.
    groups = groupByIndependence(activities)
    match groups {
      multiple groups => "mixed"
      single group => "sequential"
    }
  }
}
```

### When to Decompose

```sudolang
shouldDecompose(task) {
  match task {
    has multiple distinct activities => true
    has independent validatable components => true
    has natural layer boundaries => true
    requires different stakeholder perspectives => true
    exceeds single agent capacity => true

    is single focused activity => false
    has no clear separation of concerns => false
    overhead exceeds benefits => false
    is atomic => false

    default => false
  }
}
```

### Decomposition Examples

**Example 1: Add User Authentication**

```
Original Task: Add user authentication to the application

Activities:
1. Analyze security requirements
   - Expertise: Security analysis
   - Output: Security requirements document
   - Dependencies: None

2. Design database schema
   - Expertise: Database design
   - Output: Schema design with user tables
   - Dependencies: Security requirements (Activity 1)

3. Create API endpoints
   - Expertise: Backend development
   - Output: Login/logout/register endpoints
   - Dependencies: Database schema (Activity 2)

4. Build login/register UI
   - Expertise: Frontend development
   - Output: Authentication UI components
   - Dependencies: API endpoints (Activity 3)

Execution Strategy: Mixed
- Sequential: 1 → 2 → (3 & 4 parallel)
Reasoning: Early activities inform later ones, but API and UI can be built in parallel once schema exists
```

**Example 2: Research Competitive Landscape**

```
Original Task: Research competitive landscape for pricing strategy

Activities:
1. Analyze competitor A pricing
   - Expertise: Market research
   - Output: Competitor A pricing analysis
   - Dependencies: None

2. Analyze competitor B pricing
   - Expertise: Market research
   - Output: Competitor B pricing analysis
   - Dependencies: None

3. Analyze competitor C pricing
   - Expertise: Market research
   - Output: Competitor C pricing analysis
   - Dependencies: None

4. Synthesize findings
   - Expertise: Strategic analysis
   - Output: Unified competitive analysis
   - Dependencies: All competitor analyses (Activities 1-3)

Execution Strategy: Mixed
- Parallel: 1, 2, 3 → Sequential: 4
Reasoning: Each competitor analysis is independent, synthesis requires all results
```

---

## Documentation Decision Making

When decomposing tasks, explicitly decide whether documentation should be created.

```sudolang
DocumentationDecision {
  Constraints {
    Include documentation in OUTPUT only when ALL criteria are met.
    External service integration must be involved (Stripe, Auth0, AWS, etc.).
    Content must be reusable (pattern/interface/rule used in 2+ places OR clearly reusable).
    Content must be non-obvious (not standard practices like REST, MVC, CRUD).
    Content must not be a duplicate (check existing docs first).
  }

  decideDocumentation(task) {
    existingDocs = search("docs/", task.keywords)

    match existingDocs, task {
      found, _ => { action: "update", path: found.path }
      none, task if meetsAllCriteria(task) => { action: "create", path: determineCategory(task) }
      default => { action: "none", reason: "Does not meet documentation criteria" }
    }
  }

  determineCategory(task) {
    match task.type {
      "external_service" => "docs/interfaces/"
      "technical_pattern" => "docs/patterns/"
      "business_rule" => "docs/domain/"
    }
  }

  warn Never create meta-documentation (SUMMARY.md, REPORT.md, ANALYSIS.md).
  warn Never document standard practices (REST APIs, MVC, CRUD).
  warn Never document one-off implementation details.
  warn Never create duplicates when existing docs should be updated.
}
```

---

## Parallel vs Sequential Determination

```sudolang
ExecutionStrategy {
  determineExecutionMode(tasks) {
    match tasks {
      research tasks with no dependencies => "parallel"
      analysis tasks with read-only state => "parallel"
      documentation tasks with unique paths => "parallel"
      code creation tasks with unique files => "parallel"

      build pipeline tasks => "sequential"
      same file editing tasks => "sequential"
      tasks with dependency chain => "sequential"

      default => "sequential"
    }
  }

  Constraints {
    Independent tasks must not depend on another's output.
    No shared state means no simultaneous writes to same data.
    Each task must be separately validatable.
    Tasks must not block each other through resource contention.
    File-creating tasks must have unique file paths.
  }

  warn Sequential is required when a dependency chain exists (Task B needs Task A's output).
  warn Sequential is required when shared state exists (multiple tasks modify same resource).
  warn Sequential is required when validation dependency exists (must validate before proceeding).
  warn Sequential is required when file path collision is possible (multiple tasks write same file).
  warn Sequential is required when business logic requires specific ordering.
}
```

### Mixed Execution Strategy

Many complex tasks benefit from mixed strategies:

**Pattern:** Parallel groups connected sequentially

```
Group 1 (parallel): Tasks A, B, C
    ↓ (sequential)
Group 2 (parallel): Tasks D, E
    ↓ (sequential)
Group 3: Task F
```

**Example:** Authentication implementation

- Group 1: Analyze security, Research best practices (parallel)
- Sequential: Design schema (needs Group 1 results)
- Group 2: Build API, Build UI (parallel)

---

## Agent Prompt Template Generation

```sudolang
AgentPromptGenerator {
  BasePrompt {
    TaskPrompt composition.
    focus       Complete task description with all details.
    exclude     Task-specific things to avoid.
    context     Task background and constraints.
    output      Expected deliverables with exact paths.
    success     Measurable completion criteria.
    termination When to stop.
  }

  FileCreatingPrompt {
    BasePrompt composition.
    discoveryFirst  Environment discovery commands.
  }

  ReviewPrompt {
    reviewFocus  Implementation to review.
    verify       Specific criteria to check.
    context      Background about what is being reviewed.
    output       Review report format.
    success      Review completed with clear decision.
    termination  Review decision made OR blocked.
  }

  ResearchPrompt {
    BasePrompt composition.
    output {
      executiveSummary
      keyFindings
      detailedAnalysis
      recommendations
      references
    }
  }

  /generate taskType, details => Prompt {
    match taskType {
      "implementation" => generateImplementationPrompt(details)
      "file-creating" => generateFileCreatingPrompt(details)
      "review" => generateReviewPrompt(details)
      "research" => generateResearchPrompt(details)
      default => generateBasePrompt(details)
    }
  }

  generateImplementationPrompt(details) {
    BasePrompt {
      focus: details.task,
      exclude: [
        "Do not create new patterns when existing ones work",
        "Do not duplicate existing work",
        ...details.excludes
      ],
      context: [
        ...details.rules,
        "Follow discovered patterns exactly",
        ...details.context
      ],
      output: [
        ...details.outputs,
        "Structured result:",
        "  - Files created/modified: [paths]",
        "  - Summary: [1-2 sentences]",
        "  - Tests: [status]",
        "  - Blockers: [if any]"
      ],
      success: [
        "Follows existing patterns",
        "Integrates with existing system",
        ...details.successCriteria
      ],
      termination: [
        "Completed successfully",
        "Blocked by [specific blockers]",
        "Maximum 3 attempts reached"
      ]
    }
  }

  generateFileCreatingPrompt(details) {
    FileCreatingPrompt {
      discoveryFirst: [
        ...details.discoveryCommands,
        "Identify existing patterns and conventions",
        "Locate where similar files live",
        "Check project structure and naming conventions"
      ],
      ...generateImplementationPrompt(details)
    }
  }
}
```

### Context Insertion Strategy

```sudolang
ContextStrategy {
  chooseStrategy(context) {
    match context {
      small and specific => "direct"
      quick research task => "direct"
      has exact info needed => "direct"

      has spec documents => "self-prime"
      needs full document context => "self-prime"
      orchestrator should stay lightweight => "self-prime"

      default => "direct"
    }
  }

  Direct injection includes relevant rules from CLAUDE.md and Agent.md,
  project constraints, prior outputs for sequential tasks,
  and specification references for implementation.

  Self-priming pattern instructs the agent to
  "Self-prime from: docs/specs/001-auth/implementation-plan.md (Phase 2, Task 3)".
}
```

---

## File Creation Coordination

```sudolang
FileCoordination {
  Constraints {
    File paths must be specified explicitly in each agent's OUTPUT.
    All file paths must be unique across parallel agents.
    Paths must follow project conventions.
    Paths must be deterministic, not ambiguous.
  }

  validatePaths(agents) {
    allPaths = agents |> flatMap(a => a.output.paths)
    duplicates = allPaths |> findDuplicates

    match duplicates {
      empty => { valid: true }
      dups => {
        valid: false,
        error: "Path collision detected",
        duplicates: dups,
        action: "Adjust OUTPUT sections to prevent collisions"
      }
    }
  }

  assignPaths(strategy, agents) {
    match strategy {
      "explicit" => {
        Assign each agent a specific file path.
        agents |> each(a => a.output.path = generateUniquePath(a))
      }
      "discovery-based" => {
        Use placeholder that agent discovers.
        agents |> each(a => a.output.path = "[DISCOVERED_LOCATION]/" + a.uniqueFilename)
      }
      "hierarchical" => {
        Use directory structure to separate agents.
        agents |> each(a => a.output.path = a.category + "/" + a.filename)
      }
    }
  }

  require Each agent has explicit OUTPUT with file path.
  require All file paths are unique.
  require Paths follow project naming conventions.
  require If using DISCOVERY, filenames must differ.
  require No potential for race conditions.
}
```

---

## Scope Validation & Response Review

```sudolang
ScopeValidation {
  validateResponse(agent, response) {
    match response {
      security improvement => accept(response)
      quality improvement and in scope => accept(response)
      exactly matches FOCUS and respects EXCLUDE => accept(response)

      architectural change => review(response)
      scope expansion and is valuable => review(response)
      adds external dependency => review(response)
      modifies public API => review(response)

      out of scope => reject(response, "Out of scope work")
      in EXCLUDE list => reject(response, "Violates EXCLUDE constraint")
      breaking changes without migration => reject(response, "Breaking changes without migration")
      untested modifications => reject(response, "Untested code modifications")
      unrequested "while I'm here" additions => reject(response, "Unrequested improvements")
      skipped DISCOVERY_FIRST => reject(response, "Skipped DISCOVERY_FIRST")

      default => review(response)
    }
  }

  generateValidationReport(agent, response) {
    """
    Agent Response Validation

    Agent: $agent.name
    Task: $agent.focus

    Deliverables Check:
    ${ response.deliverables |> map(d => checkDeliverable(d)) |> join("\n") }

    Scope Compliance:
    - FOCUS coverage: ${ calculateFocusCoverage(response) }%
    - EXCLUDE violations: ${ countExcludeViolations(response) }
    - OUTPUT format: ${ checkOutputFormat(response) }
    - SUCCESS criteria: ${ checkSuccessCriteria(response) }

    Recommendation:
    ${ generateRecommendation(response) }
    """
  }

  generateRecommendation(response) {
    match response.validation {
      "accept" => "ACCEPT - Fully compliant"
      "review" => "REVIEW - User decision needed on [specific item]"
      "reject" => "REJECT - Scope creep, retry with stricter FOCUS"
    }
  }
}
```

---

## Failure Recovery & Retry Strategies

```sudolang
FailureRecovery {
  State {
    retryCount = 0
    maxRetries = 3
    failureHistory = []
  }

  Constraints {
    Maximum retries is 3 attempts.
    After 3 failed attempts, escalate to user.
    Never infinite loop.
  }

  handleFailure(agent, error) {
    diagnosis = diagnoseFailure(agent, error)

    match diagnosis, State.retryCount {
      _, count if count >= State.maxRetries => escalateToUser(agent, error)
      "scope_creep", _ => retryWithRefinedFocus(agent)
      "wrong_approach", _ => tryDifferentSpecialist(agent)
      "incomplete_work", _ => breakIntoSmallerTasks(agent)
      "blocked", _ => checkSequentialExecution(agent)
      "wrong_output", _ => specifyExactFormat(agent)
      "quality_issues", _ => addMoreContext(agent)
      default => retryWithRefinements(agent)
    }
  }

  diagnoseFailure(agent, error) {
    match error {
      has scope creep => "scope_creep"
      wrong approach => "wrong_approach"
      incomplete work => "incomplete_work"
      is blocked => "blocked"
      wrong output => "wrong_output"
      has quality issues => "quality_issues"
      default => "unknown"
    }
  }

  getRetryAction(symptom) {
    match symptom {
      "scope_creep" => { action: "Refine FOCUS, expand EXCLUDE" }
      "wrong_approach" => { action: "Try different agent type" }
      "incomplete_work" => { action: "Break into smaller tasks" }
      "blocked" => { action: "Check if should be sequential" }
      "wrong_output" => { action: "Specify exact format/path" }
      "quality_issues" => { action: "Add more constraints/examples" }
    }
  }

  handlePartialSuccess(agent, results) {
    completeDeliverables = results |> filter(r => r.complete)
    missingDeliverables = results |> filter(r => not r.complete)

    match completeDeliverables, missingDeliverables {
      complete, missing if canShipPartial(complete) => {
        action: "accept_partial",
        next: launchNewAgentFor(missing)
      }
      _, missing if partialNotUseful(missing) => {
        action: "retry_complete"
      }
      default => {
        action: "sequential_completion",
        buildOn: completeDeliverables
      }
    }
  }
}

FallbackChain {
  steps: [
    { level: 1, action: "Retry with refined prompt", details: "More specific FOCUS, explicit EXCLUDE, better CONTEXT" },
    { level: 2, action: "Try different specialist agent", details: "Different expertise angle, simpler task scope" },
    { level: 3, action: "Break into smaller tasks", details: "Decompose further, sequential smaller steps" },
    { level: 4, action: "Sequential instead of parallel", details: "Dependency might exist, coordination issue" },
    { level: 5, action: "Handle directly (DIY)", details: "Task too specialized, agent limitation" },
    { level: 6, action: "Escalate to user", details: "Present options, request guidance" }
  ]

  nextStep(currentLevel) {
    steps |> find(s => s.level == currentLevel + 1)
  }
}
```

---

## Output Format

After delegation work, always report using these formats:

```sudolang
OutputFormats {
  taskDecompositionReport(result) {
    """
    Task Decomposition Complete

    Original Task: $result.originalTask

    Activities Identified: ${ result.activities |> count }
    ${ result.activities |> mapWithIndex((a, i) => "${ i + 1 }. $a.name - [$a.executionMode]") |> join("\n") }

    Execution Strategy: $result.strategy
    Reasoning: $result.reasoning

    Agent Prompts Generated: ${ result.promptsGenerated then "Yes" else "No" }
    File Coordination: ${ result.hasFileCreation then "Checked" else "Not applicable" }
    Ready to launch: ${ result.ready then "Yes" else "No - " + result.blocker }
    """
  }

  scopeValidationReport(agent, result) {
    """
    Scope Validation Complete

    Agent: $agent.name
    Result: $result.verdict

    Summary:
    - Deliverables: $result.matched matched, $result.extra extra, $result.missing missing
    - Scope compliance: $result.compliancePercent%
    - Recommendation: $result.recommendation

    ${ result.verdict != "ACCEPT" then result.details else "" }
    """
  }

  retryStrategyReport(agent, attempt) {
    """
    Retry Strategy Generated

    Agent: $agent.name
    Failure cause: $attempt.diagnosis
    Retry approach: $attempt.approach

    Template refinements:
    - FOCUS: $attempt.focusChanges
    - EXCLUDE: $attempt.excludeAdditions
    - CONTEXT: $attempt.contextEnhancements

    Retry attempt: $attempt.number of 3
    """
  }
}
```

---

## Quick Reference

### When to Use This Skill

- "Break down this complex task"
- "Launch parallel agents for these activities"
- "Create agent prompts with FOCUS/EXCLUDE"
- "Should these run in parallel or sequential?"
- "Validate this agent response for scope"
- "Generate retry strategy for failed agent"
- "Coordinate file creation across agents"

### Key Principles

```sudolang
KeyPrinciples {
  Constraints {
    Activity-based decomposition, not role-based.
    Parallel-first mindset unless dependencies exist.
    Explicit FOCUS/EXCLUDE with no ambiguity.
    Unique file paths to prevent collisions.
    Scope validation: auto-accept, review, or reject.
    Maximum 3 retries, then escalate to user.
  }
}
```

### Template Checklist

```sudolang
TemplateChecklist {
  require FOCUS has a complete, specific task description.
  require EXCLUDE has explicit boundaries.
  require CONTEXT has relevant rules and constraints.
  require OUTPUT has expected deliverables with paths.
  require SUCCESS has measurable criteria.
  require TERMINATION has clear stop conditions.

  DISCOVERY_FIRST is optional and used when creating files.
}
```

### Parallel Execution Safety

```sudolang
ParallelSafetyCheck {
  require No dependencies between tasks.
  require No shared state modifications.
  require Independent validation is possible.
  require Unique file paths if creating files.
  require No resource contention.

  verify(tasks) {
    allChecked = all requirements pass for tasks
    match allChecked {
      true => "PARALLEL SAFE"
      false => "SEQUENTIAL REQUIRED"
    }
  }
}
```
