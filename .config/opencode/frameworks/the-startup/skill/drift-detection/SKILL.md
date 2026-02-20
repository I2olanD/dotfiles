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
interface DriftItem {
  type: DriftType
  description: String
  location: String?
  specReference: String?
  justification: String?
}

interface DriftAnalysis {
  phase: String
  specId: String
  aligned: Requirement[]
  driftItems: DriftItem[]
  alignmentPercentage: Number
}

interface DriftDecision {
  date: String
  phase: String
  driftType: DriftType
  status: DriftStatus
  notes: String
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
  
  constraints {
    Every drift item must have exactly one type
    Type determines available resolution actions
    Missing and contradicts are higher priority than scope_creep and extra
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
    transitions: [updated]  // Can still be updated later
  }
  
  updated {
    description: "Spec or implementation changed to align"
    action: "Drift resolved"
    transitions: []  // Terminal state
  }
  
  deferred {
    description: "Decision postponed"
    action: "Will address in future phase"
    transitions: [acknowledged, updated]
  }
  
  constraints {
    All drift must start in detected state
    Terminal states cannot transition
    Decision must be logged before transition
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
fn analyzeRequirement(requirement: Requirement, implementation: CodeArtifact[]) {
  match (findImplementation(requirement, implementation)) {
    case { found: true, matches: true } => {
      status: "aligned",
      emoji: "GREEN_CHECK"
    }
    case { found: true, matches: false } => {
      status: "contradicts",
      emoji: "WARNING",
      details: extractDifferences(requirement, implementation)
    }
    case { found: false } => {
      status: "missing",
      emoji: "RED_X"
    }
  }
}

fn analyzeImplementation(artifact: CodeArtifact, spec: Specification) {
  match (findSpecReference(artifact, spec)) {
    case { found: true } => {
      status: "aligned",
      specRef: reference
    }
    case { found: false, isFeature: true } => {
      status: "scope_creep",
      emoji: "ORANGE_DIAMOND"
    }
    case { found: false, isFeature: false } => {
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
  constraints {
    Test descriptions often reflect requirements
    Function names should map to feature names
    Comments may contain ticket or spec references
    API endpoints should match spec interfaces
  }
  
  /findImplementedRequirements artifacts:CodeArtifact[] => {
    // Test file analysis
    testMatches = artifacts
      |> filter(a => a.isTest)
      |> flatMap(extractTestDescriptions)
      |> mapToRequirements
    
    // Function/class naming
    nameMatches = artifacts
      |> flatMap(extractPublicSymbols)
      |> mapToRequirements
    
    // Comment scanning
    commentMatches = artifacts
      |> flatMap(extractComments)
      |> filter(c => c.matches(/JIRA|spec|PRD|SDD|implements/i))
      |> mapToRequirements
    
    return deduplicate(testMatches, nameMatches, commentMatches)
  }
  
  /findMissingRequirements spec:Specification, implemented:Requirement[] => {
    spec.requirements
      |> filter(r => !implemented.includes(r))
      |> map(r => { type: "missing", requirement: r })
  }
  
  /findContradictions spec:Specification, artifacts:CodeArtifact[] => {
    contradictions = []
    
    // Configuration values
    contradictions.push(
      compareConfigValues(spec.config, artifacts |> extractConfig)
    )
    
    // API contracts
    contradictions.push(
      compareApiContracts(spec.interfaces, artifacts |> extractApis)
    )
    
    // Architecture patterns
    contradictions.push(
      compareArchitecture(spec.architecture, artifacts |> inferArchitecture)
    )
    
    return contradictions |> flatten |> filter(c => c != null)
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
  
  /presentDrift analysis:DriftAnalysis => {
    require analysis.driftItems.length > 0
    
    emit """
      WARNING Drift Detected in $analysis.phase
      
      Found ${ analysis.driftItems.length } drift items:
      
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
  
  /handleDecision choice:Number, driftItem:DriftItem => {
    match (choice) {
      case 1 => {
        driftItem.status = "acknowledged"
        action: "Log and continue"
      }
      case 2 => {
        driftItem.status = "updated"
        action: "Modify implementation to align with spec"
        warn "Implementation changes required"
      }
      case 3 => {
        driftItem.status = "updated"
        action: "Modify spec to match implementation"
        warn "Spec changes require review"
      }
      case 4 => {
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
  
  /logDecision decision:DriftDecision => {
    // Append to drift log in spec README
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
fn generatePhaseReport(analysis: DriftAnalysis) {
  aligned = analysis.aligned.length
  total = aligned + analysis.driftItems.length
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
    | RED_X Missing:           ${ missing.length } requirements |
    | WARNING Contradicts:     ${ contradicts.length } items    |
    | ORANGE_DIAMOND Extra:    ${ extra.length + scopeCreep.length } items |
    +-----------------------------------------------------+
    
    ${ missing.length > 0 ? generateMissingSection(missing) : "" }
    ${ contradicts.length > 0 ? generateContradictSection(contradicts) : "" }
    ${ (extra.length + scopeCreep.length) > 0 ? generateExtraSection(extra, scopeCreep) : "" }
    
    RECOMMENDATIONS:
    ${ generateRecommendations(analysis) }
  """
}

fn generateSummaryReport(analyses: DriftAnalysis[]) {
  totalAligned = analyses |> map(a => a.aligned.length) |> sum
  totalItems = analyses |> map(a => a.aligned.length + a.driftItems.length) |> sum
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
  require {
    // Spec loading
    "All spec documents loaded (PRD, SDD, PLAN)"
    "Spec ID is valid and exists"
    
    // Analysis
    "All files modified in phase have been analyzed"
    "Each artifact categorized against spec"
    
    // Reporting
    "All drift items categorized by type"
    "Findings presented to user"
  }
  
  warn {
    "Heuristic detection may miss annotated requirements"
    "Extra work detection depends on naming conventions"
  }
  
  constraints {
    Drift detection must complete before phase advances
    User must acknowledge or defer all detected drift
    All decisions must be logged to spec README
    Missing and contradicts require explicit resolution path
  }
  
  /validate analysis:DriftAnalysis => {
    require analysis.specId != null
    require analysis.phase != null
    require analysis.driftItems |> all(d => d.type in DriftType.State)
    
    // All drift items must have a status after user interaction
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
