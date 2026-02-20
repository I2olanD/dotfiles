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
  See: skill/shared/interfaces.sudo.md#ValidationResult
  
  State {
    currentTask: String
    sddReferences: String[]
    verificationResults: ValidationResult[]
  }
  
  constraints {
    Implementation must match specification exactly
    Deviations require explicit user acknowledgment
    Critical deviations block progress
    All SDD references must be validated
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
  require {
    Interface contracts match - Function signatures, parameters, return types
    Data structures align - Schema, types, relationships as specified
    Business logic follows - Defined flows and rules from SDD
    Architecture respected - Patterns, layers, dependencies as designed
    Quality requirements met - Performance, security from SDD
  }
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
interface Deviation {
  type: "critical" | "notable" | "acceptable"
  description: String
  impact: String
  action: String
}

DeviationClassification {
  fn classify(deviation: Deviation) {
    match (deviation.type) {
      case "critical" => {
        emoji: "🔴",
        blocking: true,
        action: "Must fix before proceeding",
        examples: [
          "Interface contract violations",
          "Missing required functionality",
          "Security requirement breaches",
          "Breaking architectural constraints"
        ]
      }
      case "notable" => {
        emoji: "🟡",
        blocking: false,
        requiresAck: true,
        action: "Requires user acknowledgment",
        examples: [
          "Implementation differs but functionally equivalent",
          "Enhancement beyond specification",
          "Simplified approach with same outcome"
        ]
      }
      case "acceptable" => {
        emoji: "🟢",
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
    📋 Specification Compliance: $taskName
    
    SDD Reference: Section $sddSection
    
    Requirements Checked:
    ${ checks |> map(c => "$c.emoji $c.type: $c.description") |> join("\n") }
    
    Status: $status
  """
  
  fn determineStatus(checks) {
    match (checks) {
      case checks if checks |> any(c => c.type == "critical" && !c.passed) =>
        "🔴 DEVIATION FOUND"
      case checks if checks |> any(c => c.type == "notable" && !c.passed) =>
        "🟡 NEEDS REVIEW"
      default =>
        "✅ COMPLIANT"
    }
  }
}
```

### Phase Completion Report

```sudolang
PhaseComplianceReport {
  template: """
    📊 Phase $phaseNumber Specification Compliance Summary
    
    Tasks Validated: $totalTasks
    - Fully Compliant: $compliantCount
    - With Acceptable Variations: $acceptableCount
    - With Notable Deviations: $notableCount
    - Critical Issues: $criticalCount
    
    SDD Sections Covered:
    ${ sddSections |> map(s => "- Section $s.id: $s.emoji $s.status") |> join("\n") }
    
    ${ criticalIssues.length > 0 ? """
    Critical Issues:
    ${ criticalIssues |> map((issue, i) => "$(i+1). $issue") |> join("\n") }
    """ : "" }
    
    Recommendation: $recommendation
  """
  
  fn determineRecommendation(report) {
    match (report) {
      case { criticalCount: c } if c > 0 => "🔴 FIX REQUIRED"
      case { notableCount: n } if n > 0 => "🟡 USER REVIEW"
      default => "✅ PROCEED"
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
    ${ requestFields |> map(f => "$f.emoji $f.path: $f.type $f.constraint") |> join("\n  ") }
    
    Response Schema:
    ${ responseFields |> map(f => "$f.emoji $f.status: $f.shape") |> join("\n  ") }
  """
  
  require {
    All required request fields present
    Response status codes match specification
    Error responses follow defined format
  }
  
  warn {
    Additional fields not in spec (beneficial additions)
    Extra status codes for edge cases
  }
}
```

### Data Models

```sudolang
ModelVerification {
  template: """
    Verifying: $modelName
    SDD Spec: Section $sddSection
    
    Fields:
    ${ fields |> map(f => "$f.emoji $f.name: $f.type $f.constraint") |> join("\n  ") }
    
    Relationships:
    ${ relationships |> map(r => "$r.emoji $r.type: $r.target") |> join("\n  ") }
  """
  
  require {
    All specified fields present with correct types
    Primary keys and constraints match
    Required relationships defined
  }
  
  warn {
    Additional fields not in spec
    Extra indices or constraints
  }
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
    
    ${ deviated ? """
    Deviation: $deviationDescription
    Impact: $impact
    Action: $recommendedAction
    """ : "" }
  """
  
  fn verifyADR(adr, implementation) {
    match (implementation) {
      case impl if impl |> matchesDecision(adr) => {
        compliance: "✅ Matched",
        deviated: false
      }
      case impl if impl |> partiallyMatches(adr) => {
        compliance: "🟡 Partial",
        deviated: true,
        severity: "notable"
      }
      default => {
        compliance: "🔴 Deviated",
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
    require {
      All critical deviations resolved
      Notable deviations acknowledged by user
      Validation commands pass
      SDD coverage for phase is complete
    }
  }
  
  /beforeFinalCompletion {
    require {
      All phases compliant
      All interfaces verified
      All architecture decisions respected
      Quality requirements met
      User confirmed any variations
    }
  }
}
```

## Output Format

When validating compliance:

```sudolang
ComplianceOutput {
  template: """
    📋 Specification Compliance Check
    
    Context: $context
    SDD Reference: $sddReference
    
    Verification Results:
    ${ results |> map(r => "$r.emoji $r.check") |> join("\n") }
    
    ${ deviations.length > 0 ? """
    Deviations:
    ${ deviations |> map(d => "$d.emoji [$d.severity] $d.description") |> join("\n") }
    """ : "" }
    
    Recommendation: $recommendation
    
    Status: $status
  """
  
  fn determineStatus(results, deviations) {
    match (deviations) {
      case d if d |> any(x => x.severity == "critical") => "🔴 NEEDS FIX"
      case d if d |> any(x => x.severity == "notable") => "🟡 USER REVIEW"
      default => "✅ COMPLIANT"
    }
  }
}
```

## Quick Reference

### Always Check

```sudolang
AlwaysVerify {
  require {
    Interface signatures match exactly
    Required fields are present
    Business logic follows specified flows
    Architecture patterns are respected
  }
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
  fn handleDeviation(deviation) {
    match (deviation.type) {
      case "critical" => block |> mustFix
      case "notable" => warn |> mustAcknowledge
      case "acceptable" => log |> proceed
    }
  }
}
```
