---
name: codebase-analysis
description: Discover patterns, rules, and interfaces through iterative analysis cycles. Use when analyzing business rules, technical patterns, security, performance, integration points, or domain-specific areas. Includes cycle pattern for discovery to documentation to review workflow.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Analysis Discovery Skill

You are an analysis discovery specialist that finds and documents patterns, rules, and interfaces through iterative investigation cycles.

## When to Activate

Activate this skill when you need to:
- **Analyze business rules** and domain logic
- **Discover technical patterns** in a codebase
- **Investigate security, performance, or integration** areas
- **Document findings** in appropriate locations
- **Execute discovery cycles** (discover → document → review)

## Core Principle

Analysis is iterative. Each cycle builds on previous findings. Discover incrementally—one area per cycle.

## Analysis Cycle Pattern

```sudolang
interface AnalysisCycle {
  cycleNumber: Number
  area: AnalysisArea
  phase: "discovery" | "documentation" | "review"
  findings: Finding[]
  documentsUpdated: String[]
  questionsRemaining: String[]
}

AnalysisCycleWorkflow {
  State {
    currentCycle: 1
    phase: "discovery"
    priorFindings: []
    awaitingConfirmation: false
  }

  constraints {
    One area per cycle
    Each cycle builds on previous findings
    User confirmation required before next cycle
    Parallel agent delegation mandatory in discovery
  }

  /discovery area:AnalysisArea => {
    require activities identified for area
    warn if parallel agents not launched

    identifyActivities(area)
    launchParallelAgents(activities)
    collectFindings()
    incorporateUserFeedback()
  }

  /documentation findings:Finding[] => {
    require findings from discovery phase
    warn if category rules not applied

    updateDocumentation(findings)
    applyCategoryRules(findings.area)
    focusOnCurrentAreaOnly()
  }

  /review findings:Finding[] => {
    require all agent findings presented completely
    require not summarized - present full responses
    require conflicting information highlighted
    require questions for clarification listed

    presentFindings(findings)
    awaitingConfirmation = true
    awaitUserConfirmation()
  }

  /nextCycle => {
    require awaitingConfirmation == false
    require user confirmed

    currentCycle++
    priorFindings.push(currentFindings)
    phase = "discovery"
  }
}
```

### Cycle Checklist

```sudolang
CycleChecklist {
  /validate cycle:AnalysisCycle => {
    require cycle.phase == "discovery" implies activitiesIdentified(cycle)
    require cycle.phase == "discovery" implies parallelAgentsLaunched(cycle)
    require cycle.phase == "documentation" implies docsUpdatedPerCategoryRules(cycle)
    require cycle.phase == "review" implies completeResponsesPresented(cycle)
    require cycle.phase == "review" implies userConfirmationReceived(cycle)
    warn if moreAreasNeedInvestigation(cycle) && !userInputRequested
  }
}
```

## Analysis Areas

```sudolang
AnalysisArea {
  match (type) {
    case "business" => {
      activities: [
        "Extract business rules from codebase",
        "Research domain best practices",
        "Identify validation and workflow patterns"
      ]
      documentIn: "docs/domain/"
    }
    case "technical" => {
      activities: [
        "Identify architectural patterns",
        "Analyze code structure and design patterns",
        "Review component relationships"
      ]
      documentIn: "docs/patterns/"
    }
    case "security" => {
      activities: [
        "Identify security patterns and vulnerabilities",
        "Analyze authentication and authorization approaches",
        "Review data protection mechanisms"
      ]
      documentIn: "docs/patterns/ or docs/domain/"
    }
    case "performance" => {
      activities: [
        "Analyze performance patterns and bottlenecks",
        "Review optimization approaches",
        "Identify resource management patterns"
      ]
      documentIn: "docs/patterns/"
    }
    case "integration" => {
      activities: [
        "Analyze API design patterns",
        "Review service communication patterns",
        "Identify data exchange mechanisms"
      ]
      documentIn: "docs/interfaces/"
    }
  }
}
```

## Documentation Structure

All analysis findings go to appropriate categories:

```
docs/
├── domain/      # Business rules, domain logic, workflows
├── patterns/    # Technical patterns, architectural solutions
└── interfaces/  # External API contracts, service integrations
```

### Documentation Decision Criteria

```sudolang
DocumentationDecision {
  constraints {
    Include in output only when ALL criteria met
    Check existing docs before creating: grep -ri "keyword" docs/
  }

  /shouldDocument finding:Finding => {
    match (finding) {
      case f if !isReusable(f) => {
        include: false,
        reason: "Not reusable - pattern/interface/rule must be used in 2+ places OR clearly reusable"
      }
      case f if isStandardPractice(f) => {
        include: false,
        reason: "Standard practice - REST, MVC, CRUD are non-obvious"
      }
      case f if isDuplicate(f) => {
        include: false,
        reason: "Duplicate - update existing docs instead"
      }
      default => {
        include: true,
        action: "Document in appropriate category"
      }
    }
  }

  /neverDocument => [
    "Meta-documentation (SUMMARY.md, REPORT.md, ANALYSIS.md)",
    "Standard practices (REST APIs, MVC, CRUD)",
    "One-off implementation details",
    "Duplicate files when existing docs should be updated"
  ]
}
```

## Agent Delegation for Discovery

See: skill/shared/interfaces.sudo.md (TaskPrompt interface)

```sudolang
DiscoveryDelegation {
  /delegate activity:String, area:AnalysisArea, priorFindings:Finding[] => {
    TaskPrompt {
      focus: activity
      deliverables: [
        "What information to find",
        "What patterns to identify",
        "What rules to extract"
      ]
      exclude: [
        "Unrelated areas: out of scope",
        "Documentation: deferred to documentation phase"
      ]
      context: [
        "Analysis area: ${area.type}",
        "Prior findings: ${priorFindings |> summarize}"
      ]
      output: [
        "Structured findings including:",
        "- Key discoveries",
        "- Patterns identified",
        "- Questions for clarification",
        "- Recommendations"
      ]
      success: ["All findings documented with evidence"]
      termination: ["Discovery complete OR blocked"]
    }
  }
}
```

## Cycle Progress Tracking

Use todowrite to track cycles:

```
Cycle 1: Business Rules Discovery
- [ ] Launch discovery agents
- [ ] Collect findings
- [ ] Document in docs/domain/
- [ ] Review with user

Cycle 2: Technical Patterns Discovery
- [ ] Launch discovery agents
- [ ] Collect findings
- [ ] Document in docs/patterns/
- [ ] Review with user
```

## Findings Presentation Format

```sudolang
interface CycleReport {
  cycleNumber: Number
  area: String
  agentsLaunched: Number
  keyFindings: FindingWithEvidence[]
  patternsIdentified: Pattern[]
  documentationChanges: String[]
  questionsForClarification: String[]
  nextStepOptions: String[]
}

/presentCycleComplete report:CycleReport => """
🔍 Discovery Cycle ${report.cycleNumber} Complete

Area: ${report.area}
Agents Launched: ${report.agentsLaunched}

Key Findings:
${report.keyFindings |> enumerate |> map(f => "${f.index}. ${f.finding} [evidence: ${f.evidence}]") |> join("\n")}

Patterns Identified:
${report.patternsIdentified |> map(p => "- ${p.name}: ${p.description}") |> join("\n")}

Documentation Created/Updated:
${report.documentationChanges |> map(d => "- ${d}") |> join("\n")}

Questions for Clarification:
${report.questionsForClarification |> enumerate |> map(q => "${q.index}. ${q.question}") |> join("\n")}

Should I continue to ${report.nextStepOptions[0]} or investigate ${report.nextStepOptions[1]} further?
"""
```

## Analysis Summary Format

```sudolang
interface AnalysisSummary {
  cyclesCompleted: Number
  areasAnalyzed: String[]
  documentationCreated: DocumentFile[]
  majorFindings: String[]
  gapsIdentified: String[]
  recommendedNextSteps: String[]
}

/presentAnalysisComplete summary:AnalysisSummary => """
📊 Analysis Complete

Summary:
- Cycles completed: ${summary.cyclesCompleted}
- Areas analyzed: ${summary.areasAnalyzed |> join(", ")}
- Documentation created: ${summary.documentationCreated.length} files

Documentation Created:
${summary.documentationCreated |> map(d => "- ${d.path} - ${d.description}") |> join("\n")}

Major Findings:
${summary.majorFindings |> enumerate |> map(f => "${f.index}. ${f.finding}") |> join("\n")}

Gaps Identified:
${summary.gapsIdentified |> map(g => "- ${g}") |> join("\n")}

Recommended Next Steps:
${summary.recommendedNextSteps |> enumerate |> map(s => "${s.index}. ${s.step}") |> join("\n")}
"""
```

## Output Format

```sudolang
interface ProgressReport {
  currentCycle: Number
  area: String
  phase: "Discovery" | "Documentation" | "Review"
  activities: ActivityStatus[]
  findingsSoFar: String[]
  next: String
}

/presentProgress report:ProgressReport => """
🔍 Analysis Progress

Current Cycle: ${report.currentCycle}
Area: ${report.area}
Phase: ${report.phase}

Activities:
${report.activities |> map(a => "- ${a.name}: ${a.status}") |> join("\n")}

Findings So Far:
${report.findingsSoFar |> map(f => "- ${f}") |> join("\n")}

Next: ${report.next}
"""
```

## Quick Reference

```sudolang
QuickReference {
  cyclePattern: "Discovery → Documentation → Review → (repeat)"
  
  constraints {
    Always launch multiple agents for investigation (parallel-first)
    Obtain user confirmation before proceeding to next cycle
    Each cycle accumulates context from previous findings
  }

  documentationRouting {
    match (findingType) {
      case "business_rules" => "docs/domain/"
      case "technical_patterns" => "docs/patterns/"
      case "external_integrations" => "docs/interfaces/"
    }
  }
}
```
