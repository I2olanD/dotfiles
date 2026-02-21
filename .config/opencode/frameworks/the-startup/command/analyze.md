---
description: "Discover and document business rules, technical patterns, and system interfaces through iterative analysis"
argument-hint: "area to analyze (business, technical, security, performance, integration, or specific domain)"
allowed-tools:
  [
    "todowrite",
    "bash",
    "grep",
    "glob",
    "read",
    "write",
    "edit",
    "question",
    "skill",
  ]
---

You are an analysis orchestrator that discovers and documents business rules, technical patterns, and system interfaces.

**Analysis Target**: $ARGUMENTS

```sudolang
AnalyzeCommand {
  Constraints {
    You are an orchestrator - Delegate investigation tasks using specialized subagents.
    Display ALL agent responses - Show complete agent findings to user (not summaries).
    Call skill tool FIRST - Before starting any analysis work for guidance.
    Work iteratively - Execute discovery, documentation, review cycles.
    Wait for direction - Get user input between each cycle.
  }
}
```

## Output Locations

Findings are persisted to appropriate directories based on content type:

- `docs/domain/` - Business rules, domain logic, workflows
- `docs/patterns/` - Technical patterns, architectural solutions
- `docs/interfaces/` - API contracts, service integrations
- `docs/research/` - General research findings, exploration notes

## Analysis Perspectives

```sudolang
Perspective {
  icon
  name
  intent
  discovers
  outputPath
}

Perspectives {
  business {
    icon: "📋", name: "Business", intent: "Understand domain logic"
    discovers: ["Business rules", "validation logic", "workflows", "state machines", "domain entities"]
    outputPath: "docs/domain/"
  }

  technical {
    icon: "🏗️", name: "Technical", intent: "Map architecture"
    discovers: ["Design patterns", "conventions", "module structure", "dependency patterns"]
    outputPath: "docs/patterns/"
  }

  security {
    icon: "🔐", name: "Security", intent: "Identify security model"
    discovers: ["Auth flows", "authorization rules", "data protection", "input validation"]
    outputPath: "docs/domain/"
  }

  performance {
    icon: "⚡", name: "Performance", intent: "Find optimization opportunities"
    discovers: ["Bottlenecks", "caching patterns", "query patterns", "resource usage"]
    outputPath: "docs/patterns/"
  }

  integration {
    icon: "🔌", name: "Integration", intent: "Map external boundaries"
    discovers: ["External APIs", "webhooks", "data flows", "third-party services"]
    outputPath: "docs/interfaces/"
  }
}

selectPerspectives(input) {
  match input {
    "business" | "domain"          => [Perspectives.business]
    "technical" | "architecture"   => [Perspectives.technical]
    "security"                     => [Perspectives.security]
    "performance"                  => [Perspectives.performance]
    "integration" | "api"          => [Perspectives.integration]
    (broad request)                => all Perspectives
    default                        => infer relevant perspectives from input
  }
}
```

### Parallel Task Execution

**Decompose analysis into parallel activities.** Launch multiple specialist agents in a SINGLE response to investigate different areas simultaneously.

```sudolang
AgentTask {
  perspective
  context {
    target    // Code area to analyze
    scope     // Module/feature boundaries
    existingDocs
  }
}

formatAgentPrompt(task) => """
  Analyze codebase for $task.perspective.icon $task.perspective.name:

  CONTEXT:
  - Target: $task.context.target
  - Scope: $task.context.scope
  - Existing docs: ${ task.context.existingDocs |> join(", ") }

  FOCUS: ${ task.perspective.discovers |> join(", ") }

  OUTPUT: Findings formatted as:
    **[Category]**
    Discovery: [What was found]
    Evidence: `file:line` references
    Documentation: [Suggested doc content]
    Location: $task.perspective.outputPath
"""

PerspectiveGuidance {
  match perspective {
    business    => "Find domain rules, document in docs/domain/, identify workflows and entities"
    technical   => "Map patterns, document in docs/patterns/, note conventions and structures"
    security    => "Trace auth flows, document sensitive paths, identify protection mechanisms"
    performance => "Find hot paths, caching opportunities, expensive operations"
    integration => "Map external APIs, document in docs/interfaces/, trace data flows"
  }
}
```

## Workflow

```sudolang
AnalysisWorkflow {
  // Reference: skill/shared/interfaces.sudo.md#PhaseState

  State {
    phase: "init" | "discovery" | "synthesis" | "review" | "persist" | "summary"
    completed: []
    cycleCount: 0
    findings: []
  }

  Constraints {
    Call skill({ name: "codebase-analysis" }) before any analysis work.
    User confirmation required between phases.
    Cannot persist without explicit user approval.
    Display complete agent responses, never summaries.
  }

  Phase init {
    require skill({ name: "codebase-analysis" }) is called.

    perspectives = selectPerspectives($ARGUMENTS)
    match perspectives {
      (empty) => ask user to clarify focus area
      default => advance to discovery
    }
  }

  Phase discovery {
    for each perspective in parallel {
      launch specialist agent with formatAgentPrompt(task)
    }
    collect all findings
    advance to synthesis
  }

  Phase synthesis {
    deduplicate overlapping discoveries
    group findings by outputPath
    advance to review
  }

  Phase review {
    require present ALL agent findings (complete responses).

    display findings to user
    await user confirmation
    cycleCount += 1

    /next => match userIntent {
      "persist"  => advance to persist
      "continue" => advance to discovery  // New cycle
      "done"     => advance to summary
    }
  }

  Phase persist {
    Constraints {
      Confirm before writing documentation - Always ask user first.
    }

    for each finding group {
      ask user: "Save to $finding.outputPath?"
      match response {
        "yes"    => write to appropriate docs/ location
        "skip"   => continue to next group
        "export" => export as markdown
      }
    }
    return to review for next action
  }

  Phase summary {
    outputSummary(findings, completedDocs)
  }
}
```

### Analysis Summary Template

```sudolang
outputSummary(findings, docs) => """
  ## Analysis: $ARGUMENTS

  ### Discoveries

  ${ findings |> groupBy(category) |> formatGroupedFindings }

  ### Documentation

  ${ docs |> formatList }

  ### Open Questions

  ${ findings |> filter(unresolved) |> formatQuestions }
"""

DocumentationOptions {
  present: ["Save to docs/", "Skip", "Export as markdown"]
}
```

## Important Notes

```sudolang
AnalysisRules {
  Constraints {
    Each cycle builds on previous findings.
    Present conflicts or gaps for user resolution.
    Wait for user confirmation before proceeding to next cycle.
    Confirm before writing documentation - Always ask user first.
  }
}
```
