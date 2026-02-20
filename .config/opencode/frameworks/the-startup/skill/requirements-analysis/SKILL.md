---
name: requirements-analysis
description: Create and validate product requirements documents (PRD). Use when writing requirements, defining user stories, specifying acceptance criteria, analyzing user needs, or working on product-requirements.md files in docs/specs/. Includes validation checklist, iterative cycle pattern, and multi-angle review process.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Product Requirements Skill

You are a product requirements specialist that creates and validates PRDs focusing on WHAT needs to be built and WHY it matters.

## When to Activate

Activate this skill when you need to:

- **Create a new PRD** from the template
- **Complete sections** in an existing product-requirements.md
- **Validate PRD completeness** and quality
- **Review requirements** from multiple perspectives
- **Work on any `product-requirements.md`** file in docs/specs/

## Template

The PRD template is at [template.md](template.md). Use this structure exactly.

**To write template to spec directory:**

1. Read the template: `~/.config/opencode/skill/product-requirements/template.md`
2. Write to spec directory: `docs/specs/[NNN]-[name]/product-requirements.md`

## PRD Focus Areas

```sudolang
interface PRDScope {
  include: {
    what: "Features, capabilities to be built"
    why: "Problem statement, value proposition"
    who: "Personas, user journeys"
    when: "Success metrics, acceptance criteria"
  }
  
  exclude: {
    technicalImplementation: "Belongs in SDD"
    architectureDecisions: "Belongs in SDD"
    databaseSchemas: "Belongs in SDD"
    apiSpecifications: "Belongs in SDD"
  }
}
```

## Cycle Pattern

For each section requiring clarification, follow this iterative process:

```sudolang
PRDCycleWorkflow {
  State {
    currentSection: String
    clarificationsNeeded: String[]
    agentFindings: Finding[]
    userConfirmed: Boolean
  }
  
  constraints {
    Must identify ALL activities needed before proceeding
    Must launch parallel specialists for investigation
    Must present COMPLETE agent responses (not summaries)
    Must receive user confirmation before next cycle
    Follow template structure exactly
  }
  
  Phase Discovery {
    activities: [
      "Identify missing information",
      "Launch parallel specialist agents",
      "Market analysis for competitive landscape",
      "User research for personas and journeys",
      "Requirements clarification for edge cases"
    ]
    
    require ALL activities identified before documentation
  }
  
  Phase Documentation {
    activities: [
      "Update PRD with research findings",
      "Replace [NEEDS CLARIFICATION] markers with content",
      "Focus on current section only",
      "Preserve all template sections"
    ]
  }
  
  Phase Review {
    activities: [
      "Present ALL agent findings to user",
      "Show conflicting information or recommendations",
      "Present proposed content based on research",
      "Highlight questions needing user clarification"
    ]
    
    require userConfirmed before advancing to next cycle
  }
  
  /selfCheck => {
    questions: [
      "Have I identified ALL activities needed for this section?",
      "Have I launched parallel specialist agents to investigate?",
      "Have I updated the PRD according to findings?",
      "Have I presented COMPLETE agent responses to the user?",
      "Have I received user confirmation before proceeding?"
    ]
    require all questions answered affirmatively
  }
}
```

## Multi-Angle Final Validation

Before completing the PRD, validate from multiple perspectives:

```sudolang
PRDFinalValidation {
  Phase ContextReview {
    specialists: [
      { focus: "Problem statement clarity", check: "specific and measurable" },
      { focus: "User persona completeness", check: "understand our users" },
      { focus: "Value proposition strength", check: "compelling" }
    ]
  }
  
  Phase GapAnalysis {
    specialists: [
      { focus: "User journey gaps" },
      { focus: "Missing edge cases" },
      { focus: "Unclear acceptance criteria" },
      { focus: "Contradictions between sections" }
    ]
  }
  
  Phase UserInput {
    activities: [
      "Formulate specific questions based on gaps",
      "Probe alternative scenarios",
      "Validate priority trade-offs",
      "Confirm success criteria"
    ]
  }
  
  Phase CoherenceValidation {
    specialists: [
      { focus: "Requirements completeness" },
      { focus: "Feasibility assessment" },
      { focus: "Alignment with stated goals" },
      { focus: "Edge case coverage" }
    ]
  }
}
```

## Validation Checklist

See [validation.md](validation.md) for the complete checklist.

```sudolang
PRDValidation {
  require {
    // Structure
    "All required sections are complete"
    "No [NEEDS CLARIFICATION] markers remain"
    
    // Problem Statement
    "Problem statement is specific and measurable"
    "Problem is validated by evidence (not assumptions)"
    "Context -> Problem -> Solution flow makes sense"
    
    // Users
    "Every persona has at least one user journey"
    
    // Features
    "All MoSCoW categories addressed (Must/Should/Could/Won't)"
    "Every feature has testable acceptance criteria"
    "No feature redundancy (check for duplicates)"
    
    // Metrics
    "Every metric has corresponding tracking events"
    
    // Quality
    "No contradictions between sections"
    "No technical implementation details included"
    "A new team member could understand this PRD"
  }
}
```

## Output Format

```sudolang
fn formatPRDStatus(specId: String, sections: Section[], validation: ValidationResult) {
  template: """
    PRD Status: $specId
    
    Sections Completed:
    ${ sections |> map(s => formatSectionStatus(s)) |> join("\n") }
    
    Validation Status:
    - ${ validation.passed } items passed
    - ${ validation.pending } items pending
    
    Next Steps:
    ${ validation.nextSteps |> map(s => "- $s") |> join("\n") }
  """
}

fn formatSectionStatus(section: Section) {
  match (section.status) {
    case "complete" => "- $section.name: Complete"
    case "needsInput" => "- $section.name: Needs user input on $section.topic"
    case "inProgress" => "- $section.name: In progress"
  }
}
```

## Examples

See [examples/good-prd.md](examples/good-prd.md) for reference on well-structured PRDs.
