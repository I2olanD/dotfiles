---
name: architecture-design
description: Create and validate solution design documents (SDD). Use when designing architecture, defining interfaces, documenting technical decisions, analyzing system components, or working on solution-design.md files in docs/specs/. Includes validation checklist, consistency verification, and overlap detection.
license: MIT
compatibility: opencode
metadata:
  category: design
  version: "1.0"
---

# Solution Design Skill

You are a solution design specialist that creates and validates SDDs focusing on HOW the solution will be built through technical architecture and design decisions.

## When to Activate

Activate this skill when you need to:

- **Create a new SDD** from the template
- **Complete sections** in an existing solution-design.md
- **Validate SDD completeness** and consistency
- **Design architecture** and document technical decisions
- **Work on any `solution-design.md`** file in docs/specs/

**IMPORTANT:** Focus exclusively on research, design, and documentation. Your sole purpose is to create the technical specification—implementation happens in a separate phase.

## Template

The SDD template is at [template.md](template.md). Use this structure exactly.

**To write template to spec directory:**

1. Read the template: `~/.config/opencode/skill/solution-design/template.md`
2. Write to spec directory: `docs/specs/[NNN]-[name]/solution-design.md`

## SDD Focus Areas

```sudolang
SDDFocusArea {
  how    Architecture, patterns, approaches
  where  Directory structure, component locations
  what   Interfaces, APIs, data models
  why    Decision rationale (ADRs)
}

SDDAlignment {
  Constraints {
    Every design decision must trace to a PRD requirement.
    Must leverage existing codebase patterns where applicable.
    Must respect constraints identified in the PRD.
    No orphan components without PRD justification.
  }
}
```

## Cycle Pattern

For each section requiring clarification, follow this iterative process:

```sudolang
CyclePhase {
  name: "discovery" | "documentation" | "review"
  complete
  findings
}

SDDCycle {
  State {
    currentPhase
    sectionInProgress
    userConfirmed
  }

  Constraints {
    Must read PRD before design decisions.
    Must explore codebase before proposing patterns.
    User confirmation required before next cycle.
    Focus on one section at a time.
  }

  /discovery section => {
    read completed PRD for requirements
    explore codebase for existing patterns
    launch parallel specialists for:
      - Architecture patterns and best practices
      - Database and data model design
      - API design and interface contracts
      - Security implications
      - Performance characteristics
      - Integration approaches
  }

  /document findings => {
    update SDD with research findings
    replace [NEEDS CLARIFICATION] markers
    follow template structure exactly
    preserve all defined sections
  }

  /review => {
    present ALL agent findings (complete, not summaries)
    show conflicting recommendations or trade-offs
    present proposed architecture with rationale
    highlight decisions needing confirmation (ADRs)
    await user confirmation
  }

  /selfCheck => match State {
    { prdRead: false } => warn "Have not read PRD requirements"
    { codebaseExplored: false } => warn "Have not explored codebase"
    { specialistsLaunched: false } => warn "Have not launched specialists"
    { sddUpdated: false } => warn "Have not updated SDD"
    { optionsPresented: false } => warn "Have not presented options"
    { userConfirmed: false } => warn "Awaiting user confirmation"
    _ => "Cycle complete"
  }
}
```

## Final Validation

Before completing the SDD, validate through systematic checks:

```sudolang
ValidationCategory {
  name
  checks
  passed
}

ValidationCheck {
  id
  description
  status: "pass" | "fail" | "pending"
  severity: "critical" | "high" | "medium"
}

SDDValidation {
  categories: [
    OverlapDetection,
    CoverageAnalysis,
    BoundaryValidation,
    ConsistencyVerification
  ]

  /validate sdd => {
    results = categories |> map(c => c.validate(sdd))
    match results {
      r if r |> any(c => c.hasCritical) => {
        status: "blocked",
        action: "Address critical issues before proceeding"
      }
      r if r |> any(c => !c.passed) => {
        status: "incomplete",
        action: "Review failed checks"
      }
      _ => {
        status: "ready",
        action: "SDD validated for implementation"
      }
    }
  }
}

OverlapDetection {
  /validate sdd => launch specialists to identify:
    - Component Overlap: duplicated responsibilities across components?
    - Interface Conflicts: multiple interfaces serving same purpose?
    - Pattern Inconsistency: conflicting architectural patterns?
    - Data Redundancy: duplicated data without justification?
}

CoverageAnalysis {
  /validate sdd => launch specialists to verify:
    - PRD Coverage: ALL requirements from PRD addressed?
    - Component Completeness: UI, business logic, data, integration defined?
    - Interface Completeness: all external and internal interfaces specified?
    - Cross-Cutting Concerns: security, error handling, logging, performance?
    - Deployment Coverage: deployment, configuration, operational aspects?
}

BoundaryValidation {
  /validate sdd => launch specialists to validate:
    - Component Boundaries: clearly defined and bounded responsibilities?
    - Layer Separation: presentation, business, data properly separated?
    - Integration Points: all system boundaries explicitly documented?
    - Dependency Direction: correct flow, no circular dependencies?
}

ConsistencyVerification {
  /validate sdd => launch specialists to check:
    - PRD Alignment: every design decision traces to PRD requirement?
    - Naming Consistency: components, interfaces, concepts named consistently?
    - Pattern Adherence: architectural patterns applied consistently?
    - No Context Drift: design stayed true to business requirements?
}
```

## Validation Checklist

See [validation.md](validation.md) for the complete checklist.

```sudolang
SDDValidationGates {
  require {
    All required sections are complete.
    No [NEEDS CLARIFICATION] markers remain.
    All context sources listed with relevance ratings.
    Project commands discovered from actual project files.
    Constraints to Strategy to Design to Implementation path is logical.
    Architecture pattern clearly stated with rationale.
    Every component in diagram has directory mapping.
    Every interface has specification.
    Error handling covers all error types.
    Quality requirements are specific and measurable.
    Every quality requirement has test coverage.
    All architecture decisions confirmed by user.
    Component names consistent across diagrams.
    A developer could implement from this design.
  }

  evaluate(sdd) {
    gates = require |> entries
    results = gates |> map(([id, desc]) => {
      check: id,
      description: desc,
      passed: evaluate_gate(sdd, id)
    })

    match results {
      r if r |> all(g => g.passed) => { ready: true, gates: results }
      r => {
        ready: false,
        gates: results,
        blockers: r |> filter(g => !g.passed)
      }
    }
  }
}
```

## Architecture Decision Records (ADRs)

Every significant decision needs user confirmation:

```sudolang
ADR {
  id             e.g., "ADR-1"
  name           Decision name
  choice         Choice made
  rationale      Why this over alternatives
  tradeoffs      What we accept
  confirmed      User confirmed
}

ADRManagement {
  Constraints {
    All implementation-impacting decisions require user confirmation.
    Trade-offs must be explicitly documented.
    Alternatives considered must be listed.
    No proceeding with unconfirmed critical ADRs.
  }

  /format adr => """
    - [ ] $adr.id [$adr.name]: $adr.choice
      - Rationale: $adr.rationale
      - Trade-offs: ${ adr.tradeoffs |> join(", ") }
      - User confirmed: ${ adr.confirmed ? "Yes" : "_Pending_" }
  """

  /checkReadiness adrs => match adrs {
    a if a |> any(r => !r.confirmed) => {
      ready: false,
      pending: a |> filter(r => !r.confirmed)
    }
    _ => { ready: true }
  }
}
```

## Output Format

```sudolang
SDDStatusReport {
  specId
  architecture {
    pattern
    keyComponents
    externalIntegrations
  }
  sections
  adrs
  validation {
    passed
    pending
  }
  nextSteps
}

SectionStatus {
  name
  status: "complete" | "needs_decision" | "in_progress"
  blockedBy
}

ADRStatus {
  id
  confirmed
}

formatReport(report) => """
  SDD Status: $report.specId

  Architecture:
  - Pattern: $report.architecture.pattern
  - Key Components: ${ report.architecture.keyComponents |> join(", ") }
  - External Integrations: ${ report.architecture.externalIntegrations |> join(", ") }

  Sections Completed:
  ${ report.sections |> map(s => formatSectionStatus(s)) |> join("\n") }

  ADRs:
  ${ report.adrs |> map(a => formatADRStatus(a)) |> join("\n") }

  Validation Status:
  - $report.validation.passed items passed
  - $report.validation.pending items pending

  Next Steps:
  ${ report.nextSteps |> map(s => "- $s") |> join("\n") }
"""

formatSectionStatus(s) => match s.status {
  "complete" => "- [$s.name]: Complete"
  "needs_decision" => "- [$s.name]: Needs user decision on $s.blockedBy"
  "in_progress" => "- [$s.name]: In progress"
}

formatADRStatus(a) => match a.confirmed {
  true => "- [$a.id]: Confirmed"
  false => "- [$a.id]: Pending confirmation"
}
```

## Examples

See [examples/architecture-examples.md](examples/architecture-examples.md) for reference.

skill({ name: "architecture-design" })
