---
name: implementation-verification
description: Validate implementation against specifications (PRD/SDD/PLAN). Use when verifying specification compliance, checking interface contracts, validating architecture decisions, detecting deviations, or ensuring implementations match documented requirements. Provides structured compliance reporting.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Specification Compliance Skill

You are a specification compliance validator that ensures implementations match documented requirements exactly.

## When to Activate

Activate this skill when you need to:
- **Verify SDD compliance** during implementation
- **Check interface contracts** match specifications
- **Validate architecture decisions** are followed
- **Detect deviations** from documented requirements
- **Report compliance status** at checkpoints

## Core Principle

Every implementation must match the specification exactly. Deviations require explicit acknowledgment before proceeding.

## Specification Document Hierarchy

```
docs/specs/[NNN]-[name]/
├── product-requirements.md   # WHAT and WHY (business requirements)
├── solution-design.md        # HOW (technical design, interfaces, patterns)
└── implementation-plan.md    # WHEN (execution sequence, phases)
```

## Compliance Verification Process

```sudolang
SpecificationCompliance {
  See: skill/shared/interfaces.sudo.md for ValidationResult.

  State {
    currentTask
    sddReferences = []
    verificationResults = []
  }

  Constraints {
    Implementation must match specification exactly.
    Deviations require explicit user acknowledgment.
    Critical deviations block progress.
    All SDD references must be validated.
  }
}
```

### Pre-Implementation Check

Before implementing any task:

1. **Extract SDD references** from PLAN.md task: `[ref: SDD/Section X.Y]`
2. **Read referenced sections** from solution-design.md
3. **Identify requirements**:
   - Interface contracts
   - Data structures
   - Business logic flows
   - Architecture decisions
   - Quality requirements

### During Implementation

```sudolang
ImplementationVerification {
  require Interface contracts match - function signatures, parameters, return types.
  require Data structures align - schema, types, relationships as specified.
  require Business logic follows defined flows and rules from SDD.
  require Architecture is respected - patterns, layers, dependencies as designed.
  require Quality requirements are met - performance, security from SDD.
}
```

### Post-Implementation Validation

After task completion:

1. **Compare implementation to specification**
2. **Document any deviations found**
3. **Classify deviations by severity**
4. **Report compliance status**

## Deviation Classification

```sudolang
Deviation {
  type      One of critical, notable, or acceptable.
  description
  impact
  action
}

DeviationClassification {
  classify(deviation) {
    match deviation.type {
      "critical" => {
        blocking: true,
        action: "Must fix before proceeding",
        examples: [
          "Interface contract violations",
          "Missing required functionality",
          "Security requirement breaches",
          "Breaking architectural constraints"
        ]
      }
      "notable" => {
        blocking: false,
        requiresAck: true,
        action: "Requires user acknowledgment",
        examples: [
          "Implementation differs but functionally equivalent",
          "Enhancement beyond specification",
          "Simplified approach with same outcome"
        ]
      }
      "acceptable" => {
        blocking: false,
        requiresAck: false,
        action: "Can proceed",
        examples: [
          "Internal implementation details differ",
          "Optimizations within spec boundaries",
          "Naming/style variations"
        ]
      }
    }
  }
}
```

## Compliance Report Format

### Per-Task Report

```sudolang
TaskComplianceReport {
  template: """
    Specification Compliance: $taskName

    SDD Reference: Section $sddSection

    Requirements Checked:
    ${ checks |> map(c => "$c.status $c.type: $c.description") |> join("\n") }

    Status: $status
  """

  determineStatus(checks) {
    match checks {
      any critical not passed => "DEVIATION FOUND"
      any notable not passed => "NEEDS REVIEW"
      default => "COMPLIANT"
    }
  }
}
```

### Phase Completion Report

```sudolang
PhaseComplianceReport {
  template: """
    Phase $phaseNumber Specification Compliance Summary

    Tasks Validated: $totalTasks
    - Fully Compliant: $compliantCount
    - With Acceptable Variations: $acceptableCount
    - With Notable Deviations: $notableCount
    - Critical Issues: $criticalCount

    SDD Sections Covered:
    ${ sddSections |> map(s => "- Section $s.id: $s.status") |> join("\n") }

    ${ criticalIssues is not empty then """
    Critical Issues:
    ${ criticalIssues |> mapWithIndex((issue, i) => "$(i+1). $issue") |> join("\n") }
    """ else "" }

    Recommendation: $recommendation
  """

  determineRecommendation(report) {
    match report {
      criticalCount > 0 => "FIX REQUIRED"
      notableCount > 0 => "USER REVIEW"
      default => "PROCEED"
    }
  }
}
```

## Interface Verification

### API Endpoints

```sudolang
APIVerification {
  template: """
    Verifying: $method $endpoint
    SDD Spec: Section $sddSection

    Request Schema:
    ${ requestFields |> map(f => "$f.status $f.path: $f.type $f.constraint") |> join("\n  ") }

    Response Schema:
    ${ responseFields |> map(f => "$f.status: $f.shape") |> join("\n  ") }
  """

  require All required request fields are present.
  require Response status codes match specification.
  require Error responses follow defined format.

  warn Additional fields not in spec may be beneficial additions.
  warn Extra status codes for edge cases may exist.
}
```

### Data Models

```sudolang
ModelVerification {
  template: """
    Verifying: $modelName
    SDD Spec: Section $sddSection

    Fields:
    ${ fields |> map(f => "$f.status $f.name: $f.type $f.constraint") |> join("\n  ") }

    Relationships:
    ${ relationships |> map(r => "$r.status $r.type: $r.target") |> join("\n  ") }
  """

  require All specified fields are present with correct types.
  require Primary keys and constraints match.
  require Required relationships are defined.

  warn Additional fields not in spec may exist.
  warn Extra indices or constraints may exist.
}
```

## Architecture Decision Verification

```sudolang
ADRVerification {
  template: """
    ADR-$id: $title
    Implementation Status:

    Decision: $decision
    Evidence: $evidence
    Compliance: $complianceStatus

    ${ deviated then """
    Deviation: $deviationDescription
    Impact: $impact
    Action: $recommendedAction
    """ else "" }
  """

  verifyADR(adr, implementation) {
    match implementation {
      matches decision => {
        compliance: "Matched",
        deviated: false
      }
      partially matches => {
        compliance: "Partial",
        deviated: true,
        severity: "notable"
      }
      default => {
        compliance: "Deviated",
        deviated: true,
        severity: "critical"
      }
    }
  }
}
```

## Validation Commands

Run these at checkpoints:

```bash
# Type checking (if TypeScript)
npm run typecheck

# Linting
npm run lint

# Test suite
npm test

# Build verification
npm run build
```

## Compliance Gates

```sudolang
ComplianceGates {
  /beforeNextPhase {
    require All critical deviations are resolved.
    require Notable deviations are acknowledged by user.
    require Validation commands pass.
    require SDD coverage for phase is complete.
  }

  /beforeFinalCompletion {
    require All phases are compliant.
    require All interfaces are verified.
    require All architecture decisions are respected.
    require Quality requirements are met.
    require User has confirmed any variations.
  }
}
```

## Output Format

When validating compliance:

```sudolang
ComplianceOutput {
  template: """
    Specification Compliance Check

    Context: $context
    SDD Reference: $sddReference

    Verification Results:
    ${ results |> map(r => "$r.status $r.check") |> join("\n") }

    ${ deviations is not empty then """
    Deviations:
    ${ deviations |> map(d => "[$d.severity] $d.description") |> join("\n") }
    """ else "" }

    Recommendation: $recommendation

    Status: $status
  """

  determineStatus(results, deviations) {
    match deviations {
      any severity is critical => "NEEDS FIX"
      any severity is notable => "USER REVIEW"
      default => "COMPLIANT"
    }
  }
}
```

## Quick Reference

### Always Check

```sudolang
AlwaysVerify {
  require Interface signatures match exactly.
  require Required fields are present.
  require Business logic follows specified flows.
  require Architecture patterns are respected.
}
```

### Document Deviations

- What differs from spec
- Why it differs (if known)
- Impact assessment
- Recommended action

### Gate Compliance

```sudolang
GateRules {
  handleDeviation(deviation) {
    match deviation.type {
      "critical" => block and must fix
      "notable" => warn and must acknowledge
      "acceptable" => log and proceed
    }
  }
}
```
