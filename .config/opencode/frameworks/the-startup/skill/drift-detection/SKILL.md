---
name: drift-detection
description: Detect divergence between specifications and implementation during development. Use during implementation phases to identify scope creep, missing features, contradictions, or extra work not in spec. Logs drift decisions to spec README.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Drift Detection Skill

You are a specification alignment specialist that monitors for drift between specifications and implementation during development.

## When to Activate

Activate this skill when you need to:

- **Monitor implementation phases** for spec alignment
- **Detect scope creep** (implementing more than specified)
- **Identify missing features** (specified but not implemented)
- **Flag contradictions** (implementation conflicts with spec)
- **Log drift decisions** to spec README for traceability

## Core Philosophy

### Drift is Information, Not Failure

Drift isn't inherently bad—it's valuable feedback:

- **Scope creep** may indicate incomplete requirements
- **Missing items** may reveal unrealistic timelines
- **Contradictions** may surface spec ambiguities
- **Extra work** may be necessary improvements

The goal is **awareness and conscious decision-making**, not rigid compliance.

## Drift Domain Model

```sudolang
DriftItem {
  type
  description
  location?
  specReference?
  justification?
}

DriftAnalysis {
  phase
  specId
  aligned
  driftItems
  alignmentPercentage
}

DriftDecision {
  date
  phase
  driftType
  status
  notes
}
```

## Drift Type State Machine

```sudolang
DriftType {
  State: "scope_creep" | "missing" | "contradicts" | "extra"

  scope_creep {
    description: "Implementation adds features not in spec"
    emoji: "ORANGE_DIAMOND"
    example: "Added pagination not specified in PRD"
  }

  missing {
    description: "Spec requires feature not implemented"
    emoji: "RED_X"
    example: "Error handling specified but not done"
  }

  contradicts {
    description: "Implementation conflicts with spec"
    emoji: "WARNING"
    example: "Spec says REST, code uses GraphQL"
  }

  extra {
    description: "Unplanned work that may be valuable"
    emoji: "ORANGE_DIAMOND"
    example: "Added caching for performance"
  }

  Constraints {
    Every drift item must have exactly one type.
    Type determines available resolution actions.
    Missing and contradicts are higher priority than scope_creep and extra.
  }
}
```

## Drift Status State Machine

```sudolang
DriftStatus {
  State: "detected" | "acknowledged" | "updated" | "deferred"

  detected {
    description: "Drift found, awaiting decision"
    transitions: [acknowledged, updated, deferred]
  }

  acknowledged {
    description: "Drift noted, proceeding anyway"
    action: "Implementation continues as-is"
    Can still be updated later.
    transitions: [updated]
  }

  updated {
    description: "Spec or implementation changed to align"
    action: "Drift resolved"
    This is a terminal state.
  }

  deferred {
    description: "Decision postponed"
    action: "Will address in future phase"
    transitions: [acknowledged, updated]
  }

  Constraints {
    All drift must start in detected state.
    Terminal states cannot transition.
    Decision must be logged before transition.
  }
}
```

## Detection Process

### Step 1: Load Specification Context

Read the spec documents to understand requirements:

```bash
# Using spec.py to get spec metadata
~/.config/opencode/skill/specification-management/spec.py [ID] --read
```

Extract from documents:

- **PRD**: Acceptance criteria, user stories, requirements
- **SDD**: Components, interfaces, architecture decisions
- **PLAN**: Phase deliverables, task objectives

### Step 2: Analyze Implementation

For the current implementation phase, examine:

1. **Files modified** in this phase
2. **Functions/components added**
3. **Tests written** (what do they verify?)
4. **Optional annotations** in code (`// Implements: PRD-1.2`)

### Step 3: Compare and Categorize

```sudolang
analyzeRequirement(requirement, implementation) {
  match findImplementation(requirement, implementation) {
    { found: true, matches: true } => {
      status: "aligned",
      emoji: "GREEN_CHECK"
    }
    { found: true, matches: false } => {
      status: "contradicts",
      emoji: "WARNING",
      details: extractDifferences(requirement, implementation)
    }
    { found: false } => {
      status: "missing",
      emoji: "RED_X"
    }
  }
}

analyzeImplementation(artifact, spec) {
  match findSpecReference(artifact, spec) {
    { found: true } => {
      status: "aligned",
      specRef: reference
    }
    { found: false, isFeature: true } => {
      status: "scope_creep",
      emoji: "ORANGE_DIAMOND"
    }
    { found: false, isFeature: false } => {
      status: "extra",
      emoji: "ORANGE_DIAMOND"
    }
  }
}
```

### Step 4: Report Findings

Present drift findings to user with clear categorization.

## Code Annotations (Optional)

Developers can optionally annotate code to aid drift detection:

```typescript
// Implements: PRD-1.2 - User can reset password
async function resetPassword(email: string) {
  // ...
}

// Implements: SDD-3.1 - Repository pattern for data access
class UserRepository {
  // ...
}

// Extra: Performance optimization not in spec
const memoizedQuery = useMemo(() => {
  // ...
}, [deps]);
```

**Annotation Format:**

- `// Implements: [DOC]-[SECTION]` - Links to spec requirement
- `// Extra: [REASON]` - Acknowledges unspecified work

Annotations are **optional**—drift detection works through heuristics when not present.

## Heuristic Detection

```sudolang
HeuristicDetection {
  Constraints {
    Test descriptions often reflect requirements.
    Function names should map to feature names.
    Comments may contain ticket or spec references.
    API endpoints should match spec interfaces.
  }

  /findImplementedRequirements artifacts => {
    Test file analysis
    testMatches = artifacts
      |> filter(a => a.isTest)
      |> flatMap(extractTestDescriptions)
      |> mapToRequirements

    Function and class naming
    nameMatches = artifacts
      |> flatMap(extractPublicSymbols)
      |> mapToRequirements

    Comment scanning
    commentMatches = artifacts
      |> flatMap(extractComments)
      |> filter(c => c matches /JIRA|spec|PRD|SDD|implements/i)
      |> mapToRequirements

    deduplicate(testMatches, nameMatches, commentMatches)
  }

  /findMissingRequirements spec, implemented => {
    spec.requirements
      |> filter(r => r not in implemented)
      |> map(r => { type: "missing", requirement: r })
  }

  /findContradictions spec, artifacts => {
    configContradictions = compareConfigValues(spec.config, artifacts |> extractConfig)
    apiContradictions = compareApiContracts(spec.interfaces, artifacts |> extractApis)
    archContradictions = compareArchitecture(spec.architecture, artifacts |> inferArchitecture)

    [configContradictions, apiContradictions, archContradictions]
      |> flatten
      |> filter(c => c != null)
  }
}
```

## Drift Logging

All drift decisions are logged to the spec README for traceability.

### Drift Log Format

Add to spec README under `## Drift Log` section:

```markdown
## Drift Log

| Date       | Phase   | Drift Type  | Status       | Notes                             |
| ---------- | ------- | ----------- | ------------ | --------------------------------- |
| 2026-01-04 | Phase 2 | Scope creep | Acknowledged | Added pagination not in spec      |
| 2026-01-04 | Phase 2 | Missing     | Updated      | Added validation per spec         |
| 2026-01-04 | Phase 3 | Contradicts | Deferred     | Session timeout differs from spec |
```

## User Interaction

```sudolang
DriftInteraction {
  State: "presenting" | "awaiting_decision" | "logging" | "complete"

  /presentDrift analysis => {
    require analysis has drift items

    emit """
      WARNING Drift Detected in $analysis.phase

      Found ${ analysis.driftItems |> count } drift items:

      ${ analysis.driftItems |> enumerate |> map((item, i) =>
        "${ i + 1 }. ${ item.type.emoji } ${ item.type |> capitalize }: ${ item.description }
           Location: ${ item.location ?? 'N/A' }"
      ) |> join("\n\n") }
    """

    State = "awaiting_decision"
  }

  /promptDecision => {
    require State == "awaiting_decision"

    emit """
      Options:
      1. Acknowledge and continue (log drift, proceed)
      2. Update implementation (implement missing, remove extra)
      3. Update specification (modify spec to match reality)
      4. Defer decision (mark for later review)
    """
  }

  /handleDecision choice, driftItem => {
    match choice {
      1 => {
        driftItem.status = "acknowledged"
        action: "Log and continue"
      }
      2 => {
        driftItem.status = "updated"
        action: "Modify implementation to align with spec"
        warn "Implementation changes required"
      }
      3 => {
        driftItem.status = "updated"
        action: "Modify spec to match implementation"
        warn "Spec changes require review"
      }
      4 => {
        driftItem.status = "deferred"
        action: "Mark for future review"
      }
      default => {
        warn "Invalid choice, please select 1-4"
        return
      }
    }

    State = "logging"
    /logDecision driftItem
    State = "complete"
  }

  /logDecision decision => {
    Append to drift log in spec README.
    appendToReadme(decision)
  }
}
```

## Integration Points

This skill is called by:

- `/implement` - At end of each phase for alignment check
- `/validate` (Mode C) - For comparison validation

## Report Generation

```sudolang
generatePhaseReport(analysis) {
  aligned = analysis.aligned |> count
  total = aligned + (analysis.driftItems |> count)
  percentage = (aligned / total * 100) |> round

  missing = analysis.driftItems |> filter(d => d.type == "missing")
  contradicts = analysis.driftItems |> filter(d => d.type == "contradicts")
  scopeCreep = analysis.driftItems |> filter(d => d.type == "scope_creep")
  extra = analysis.driftItems |> filter(d => d.type == "extra")

  emit """
    CHART Drift Analysis: $analysis.phase

    Spec: $analysis.specId
    Phase: $analysis.phase
    Files Analyzed: ${ analysis.filesAnalyzed }

    +-----------------------------------------------------+
    | ALIGNMENT SUMMARY                                   |
    +-----------------------------------------------------+
    | GREEN_CHECK Aligned:     $aligned requirements      |
    | RED_X Missing:           ${ missing |> count } requirements |
    | WARNING Contradicts:     ${ contradicts |> count } items    |
    | ORANGE_DIAMOND Extra:    ${ (extra |> count) + (scopeCreep |> count) } items |
    +-----------------------------------------------------+

    ${ missing |> count > 0 ? generateMissingSection(missing) : "" }
    ${ contradicts |> count > 0 ? generateContradictSection(contradicts) : "" }
    ${ (extra |> count) + (scopeCreep |> count) > 0 ? generateExtraSection(extra, scopeCreep) : "" }

    RECOMMENDATIONS:
    ${ generateRecommendations(analysis) }
  """
}

generateSummaryReport(analyses) {
  totalAligned = analyses |> map(a => a.aligned |> count) |> sum
  totalItems = analyses |> map(a => (a.aligned |> count) + (a.driftItems |> count)) |> sum
  overallPercentage = (totalAligned / totalItems * 100) |> round

  emit """
    CHART Drift Summary: ${ analyses[0].specId }

    Overall Alignment: $overallPercentage%

    | Phase | Aligned | Missing | Contradicts | Extra |
    |-------|---------|---------|-------------|-------|
    ${ analyses |> map(a => formatPhaseRow(a)) |> join("\n") }

    Drift Decisions Made: ${ countDecisions(analyses) }
    - Acknowledged: ${ countByStatus(analyses, "acknowledged") }
    - Updated: ${ countByStatus(analyses, "updated") }
    - Deferred: ${ countByStatus(analyses, "deferred") }

    Outstanding Items:
    ${ getOutstandingItems(analyses) |> map(i => "- $i") |> join("\n") }
  """
}
```

## Validation Requirements

```sudolang
DriftDetectionValidation {
  require "All spec documents loaded (PRD, SDD, PLAN)."
  require "Spec ID is valid and exists."
  require "All files modified in phase have been analyzed."
  require "Each artifact categorized against spec."
  require "All drift items categorized by type."
  require "Findings presented to user."

  warn "Heuristic detection may miss annotated requirements."
  warn "Extra work detection depends on naming conventions."

  Constraints {
    Drift detection must complete before phase advances.
    User must acknowledge or defer all detected drift.
    All decisions must be logged to spec README.
    Missing and contradicts require explicit resolution path.
  }

  /validate analysis => {
    require analysis.specId != null
    require analysis.phase != null
    require analysis.driftItems |> all(d => d.type in DriftType.State)

    All drift items must have a status after user interaction.
    require analysis.driftItems |> all(d => d.status != "detected")
      else warn "Not all drift items have been addressed"

    emit "GREEN_CHECK Drift Detection Complete"
  }
}
```

## Output Format

After drift detection:

```
CHART Drift Detection Complete

Phase: [Phase name]
Spec: [NNN]-[name]

Alignment: [X/Y] requirements ([%]%)

Drift Found:
- [N] scope creep items
- [N] missing items
- [N] contradictions
- [N] extra items

[User decision prompt if drift found]
```

---

```sudolang
skill({ name: "drift-detection" })
```
