---
description: "Validate specifications, implementations, or understanding"
argument-hint: "spec ID (e.g., 005), file path, 'constitution', or description of what to validate"
allowed-tools:
  ["todowrite", "bash", "grep", "glob", "read", "edit", "question", "skill"]
---

You are a validation orchestrator that ensures quality and correctness across specifications, implementations, and understanding.

**Validation Request**: $ARGUMENTS

## Core Rules

```sudolang
ValidationOrchestrator {
  constraints {
    Delegate validation tasks using specialized subagents
    Call skill({ name: "specification-validation" }) FIRST
    Advisory only - provide recommendations without blocking
    Be specific - include file paths and line numbers
  }
}
```

## Validation Perspectives

Launch parallel validation agents to check different quality dimensions.

```sudolang
ValidationPerspective := "completeness" | "consistency" | "alignment" | "coverage"

interface PerspectiveConfig {
  perspective: ValidationPerspective
  emoji: String
  intent: String
  focus: String[]
}

ValidationPerspectives := [
  {
    perspective: "completeness",
    emoji: "✅",
    intent: "Ensure nothing missing",
    focus: [
      "All sections filled",
      "No TODO/FIXME markers",
      "Checklists complete",
      "No [NEEDS CLARIFICATION] markers"
    ]
  },
  {
    perspective: "consistency",
    emoji: "🔗",
    intent: "Check internal alignment",
    focus: [
      "Terminology matches throughout",
      "Cross-references valid",
      "No contradictions"
    ]
  },
  {
    perspective: "alignment",
    emoji: "📍",
    intent: "Verify doc-code match",
    focus: [
      "Documented patterns exist in code",
      "No hallucinated implementations"
    ]
  },
  {
    perspective: "coverage",
    emoji: "📐",
    intent: "Assess specification depth",
    focus: [
      "Requirements mapped",
      "Interfaces specified",
      "Edge cases addressed"
    ]
  }
]
```

### Parallel Task Execution

**Decompose validation into parallel activities.** Launch multiple specialist agents in a SINGLE response to validate different concerns simultaneously.

**For each perspective, describe the validation intent:**

```sudolang
interface ValidationTask {
  perspective: ValidationPerspective
  target: String
  context: {
    targetFiles: String[]     // Spec files, code files, or both
    scope: String             // What's being validated
    standards: String[]       // CLAUDE.md, Agent.md, project conventions
  }
  focus: String[]             // From ValidationPerspectives
}

interface ValidationFinding {
  status: "✅" | "⚠️" | "❌"
  title: String
  severity: "HIGH" | "MEDIUM" | "LOW"
  location: String            // file:line format
  issue: String
  recommendation: String
}

fn formatFinding(f: ValidationFinding) => """
  $f.status **$f.title** (SEVERITY: $f.severity)
  📍 Location: `$f.location`
  🔍 Issue: $f.issue
  ✅ Recommendation: $f.recommendation
"""
```

**Perspective-Specific Guidance:**

```sudolang
fn getAgentFocus(perspective: ValidationPerspective) {
  match (perspective) {
    case "completeness" => [
      "Scan for TODO/FIXME markers",
      "Check checklists are complete",
      "Verify all sections populated"
    ]
    case "consistency" => [
      "Cross-reference terms",
      "Verify links are valid",
      "Detect contradictions"
    ]
    case "alignment" => [
      "Compare docs to code",
      "Verify implementations exist",
      "Flag hallucinations"
    ]
    case "coverage" => [
      "Map requirements to specs",
      "Check interface completeness",
      "Find gaps"
    ]
  }
}
```

### Validation Synthesis

After parallel validation completes:

```sudolang
ValidationSynthesis {
  /synthesize findings:ValidationFinding[] => {
    findings
      |> deduplicate(by: f => f.location + f.issue)
      |> sortBy(f => match (f.severity) {
           case "HIGH" => 0
           case "MEDIUM" => 1
           case "LOW" => 2
         })
      |> groupBy(f => f.category)
  }
}
```

## Workflow

### Phase 1: Parse Input

```sudolang
InputType := "spec_id" | "file_path" | "constitution" | "comparison" | "freeform"

fn parseInput(args: String): InputType {
  match (args) {
    case /^\d{3}$/ => "spec_id"              // e.g., "005"
    case /^\/|\./ => "file_path"             // starts with / or contains .
    case "constitution" => "constitution"
    case /against|vs|compare/ => "comparison"
    default => "freeform"
  }
}

fn getValidationTarget(inputType: InputType, args: String) {
  match (inputType) {
    case "spec_id" => {
      action: "validate specification documents",
      locate: "docs/specs/$args/"
    }
    case "file_path" => {
      action: "validate file (security scan, test coverage, quality)",
      locate: args
    }
    case "constitution" => {
      action: "validate codebase against CONSTITUTION.md",
      locate: "CONSTITUTION.md"
    }
    case "comparison" => {
      action: "compare source to reference",
      parse: "extract X and Y from 'X against Y'"
    }
    case "freeform" => {
      action: "validate understanding/correctness of described concept",
      scope: args
    }
  }
}
```

### Phase 2: Gather Context

```sudolang
ContextGathering {
  constraints {
    Read relevant files, specs, or code
    For specs: check which documents exist (PRD, SDD, PLAN)
    For files: identify related tests and specs
    For constitution: load CONSTITUTION.md rules
  }
}
```

### Phase 3: Apply Validation Checks

```sudolang
ValidationCheck := "completeness" | "consistency" | "correctness" | "ambiguity" | "alignment"

ValidationChecks {
  require(check: "completeness") {
    No [NEEDS CLARIFICATION] markers
    Checklists done
    No TODO/FIXME
  }
  
  require(check: "consistency") {
    Consistent terminology
    No contradictions
    Valid cross-references
  }
  
  require(check: "correctness") {
    Sound logic
    Valid dependencies
    Matching interfaces
  }
  
  warn(check: "ambiguity") {
    Flag vague language: should, might, could
    Flag imprecise quantities: various, many, few, etc.
  }
  
  require(check: "alignment") {
    Documented patterns actually exist in code
    No hallucinated implementations
  }
}
```

### Phase 4: Report Findings

```sudolang
AssessmentLevel := "Excellent" | "Good" | "Needs Attention" | "Critical"

fn determineAssessment(findings: ValidationFinding[]): AssessmentLevel {
  highCount = findings |> filter(f => f.severity == "HIGH") |> length
  mediumCount = findings |> filter(f => f.severity == "MEDIUM") |> length
  
  match (highCount, mediumCount) {
    case (0, 0) => "Excellent"
    case (0, _) => "Good"
    case (1..3, _) => "Needs Attention"
    default => "Critical"
  }
}

interface ValidationReport {
  target: String
  assessment: AssessmentLevel
  findings: ValidationFinding[]
  summary: String
}

fn formatReport(report: ValidationReport) => """
  ## Validation: $report.target
  
  **Assessment**: $report.assessment
  
  ### Findings
  
  ${ report.findings |> groupBy(f => f.category) |> formatGroupedFindings }
  
  ### Summary
  
  $report.summary
"""

fn formatGroupedFindings(grouped) => {
  grouped |> map((category, findings) => """
    **$category**
    ${ findings |> map(f => """
      - [$f.location] - $f.issue
        → $f.recommendation
    """) |> join("\n") }
  """) |> join("\n\n")
}
```

## Important Notes

```sudolang
ValidateCommand {
  constraints {
    Advisory only - all findings are recommendations
    Be specific - include file:line for every finding
    Actionable - every finding should have a clear fix
  }
}
```
