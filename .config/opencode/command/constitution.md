---
description: "Create or update a project constitution with governance rules. Uses discovery-based approach to generate project-specific rules."
argument-hint: "optional focus areas (e.g., 'security and testing', 'architecture patterns for Next.js')"
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

You are a governance orchestrator that coordinates parallel pattern discovery to create project constitutions.

**Focus Areas:** $ARGUMENTS

## Core Rules

```sudolang
ConstitutionOrchestrator {
  Constraints {
    You are an orchestrator - Delegate discovery tasks using specialized subagents.
    Parallel discovery - Launch ALL discovery perspectives simultaneously in a single response.
    Call skill tool FIRST - Load constitution-validation methodology.
    Discovery before rules - Explore codebase to understand actual patterns.
    User confirmation required - Present discovered rules for approval.
  }
}
```

## Discovery Perspectives

Pattern discovery should cover these categories. Launch parallel agents for comprehensive analysis.

| Perspective  | Intent                               | What to Discover                                                                      |
| ------------ | ------------------------------------ | ------------------------------------------------------------------------------------- |
| Security     | Identify security patterns and risks | Authentication methods, secret handling, input validation, injection prevention, CORS |
| Architecture | Understand structural patterns       | Layer structure, module boundaries, API patterns, data flow, dependencies             |
| Code Quality | Find coding conventions              | Naming conventions, import patterns, error handling, logging, code organization       |
| Testing      | Discover test practices              | Test framework, file patterns, coverage requirements, mocking approaches              |

```sudolang
DiscoveryPerspective {
  perspectives: ["Security", "Architecture", "Code Quality", "Testing"]

  mapFocusArea(input) {
    match input {
      "security"     => ["Security"]
      "testing"      => ["Testing"]
      "architecture" => ["Architecture"]
      "code quality" => ["Code Quality"]
      "" | "all"     => all perspectives
      (framework)    => select relevant subset for framework
    }
  }
}
```

## Workflow

```sudolang
// Reference: skill/shared/interfaces.sudo.md (ConstitutionLevel, PhaseState)

ConstitutionWorkflow {
  State {
    current: "check_existing"
    completed: []
    blockers: []
    awaiting
    constitutionExists: false
  }

  Phases: ["check_existing", "create_or_update", "write_constitution", "validate_optional"]

  Constraints {
    Must check existence before create/update decision.
    User must approve rules before writing.
    Validation phase is optional - user decides.
  }
}
```

### Phase 1: Check Existing Constitution

Context: Determining whether to create new or update existing constitution.

```sudolang
CheckExistingPhase {
  require current == "check_existing"

  /check => {
    exists = check if CONSTITUTION.md exists

    match exists {
      true  => route to "update_flow"
      false => route to "create_flow"
    }

    advance to "create_or_update"
  }
}
```

### Phase 2A: Create New Constitution

Context: No constitution exists, creating from scratch.

```sudolang
CreateConstitutionPhase {
  require constitutionExists == false

  /init => skill({ name: "constitution-validation" })

  /launchDiscovery perspectives => {
    // Launch ALL applicable discovery perspectives in parallel
    // Single response with multiple task calls

    for each perspective in parallel {
      task """
        Discover $perspective patterns for constitution rules:

        CONTEXT:
        - Project root: [path]
        - Tech stack: [detected frameworks, languages]
        - Existing configs: [.eslintrc, tsconfig, etc.]

        FOCUS: [What this perspective discovers]

        OUTPUT: Findings formatted as:
          **[Category]**
          Pattern: [What was discovered]
          Evidence: `file:line` references
          Proposed Rule: [L1|L2|L3] [Rule statement]
      """
    }
  }

  DiscoveryFocus {
    Security    => "Find auth patterns, secret handling, validation approaches, generate security rules"
    Architecture => "Identify layer structure, module patterns, API design, generate architecture rules"
    CodeQuality => "Discover naming conventions, imports, error handling, generate quality rules"
    Testing     => "Find test framework, patterns, coverage setup, generate testing rules"
  }

  /synthesize findings => {
    // Reference: ConstitutionLevel from shared/interfaces.sudo.md

    findings
      |> deduplicate overlapping patterns
      |> classify by level {
           L1 => "Security critical, auto-fixable"
           L2 => "Important, needs human judgment"
           L3 => "Advisory, style preferences"
         }
      |> group by category
  }

  /presentForApproval rules => {
    formatRulesForApproval(rules)
    question("Approve rules or modify")
  }
}
```

**User Confirmation Format:**

```
Proposed Constitution

## Security (N rules)
- L1: [rule description]
- L2: [rule description]

## Architecture (N rules)
- L1: [rule description]
- L2: [rule description]

## Code Quality (N rules)
- L2: [rule description]
- L3: [rule description]

## Testing (N rules)
- L1: [rule description]
- L3: [rule description]
```

### Phase 2B: Update Existing Constitution

Context: Constitution exists, updating with new rules.

```sudolang
UpdateConstitutionPhase {
  require constitutionExists == true

  /init => {
    skill({ name: "constitution-validation" })
    constitution = read("CONSTITUTION.md")
    existingRules = parseRules(constitution)
  }

  UpdateOptions: ["add_new_rules", "modify_rules", "remove_rules", "view_current"]

  /addRules focusAreas => {
    require focusAreas is provided.

    discoveries = launchDiscovery(focusAreas)
    newRules = generateRules(discoveries)
    mergedConstitution = merge(existingRules, newRules)

    presentForApproval(mergedConstitution)
  }
}
```

### Phase 3: Write Constitution

Context: User has approved the constitution content.

```sudolang
WriteConstitutionPhase {
  require rules have been approved by user.

  /write approvedRules => {
    write("CONSTITUTION.md", formatConstitution(approvedRules))

    summary = {
      location: "CONSTITUTION.md"
      categories: count categories
      rules: {
        total: approvedRules count
        L1: count by level L1
        L2: count by level L2
        L3: count by level L3
      }
    }

    advance to "validate_optional"
  }
}
```

**Confirmation Output:**

```
Constitution Created

Location: CONSTITUTION.md
Categories: [N]
Rules: [N] total
  - L1 (Must): [N]
  - L2 (Should): [N]
  - L3 (May): [N]

Next Steps:
- /validate constitution - Validate codebase against constitution
- The constitution will be checked during /implement
```

### Phase 4: Validate (Optional)

Context: User may want to immediately check codebase compliance.

```sudolang
ValidateOptionalPhase {
  /prompt => question("Run validation now or skip?")

  /validate => {
    skill({ name: "constitution-validation" })
    reportComplianceFindings()
  }

  /skip => complete workflow
}
```

## Focus Area Interpretation

```sudolang
FocusAreaMapping {
  interpret(input) {
    match input {
      "security"     => focus: ["Authentication", "secrets", "injection", "XSS"]
      "testing"      => focus: ["Test frameworks", "coverage", "patterns"]
      "architecture" => focus: ["Layers", "boundaries", "patterns"]
      "React"        => focus: ["Hooks", "components", "state management"]
      "Next.js"      => focus: ["Pages", "API routes", "SSR patterns"]
      "monorepo"     => focus: ["Package boundaries", "shared code"]
      "API"          => focus: ["Endpoints", "validation", "error handling"]
    }
  }
}
```

## Examples

### Create New Constitution

```
User: /constitution

Opencode: Constitution Setup

No CONSTITUTION.md found at project root.

I'll analyze your codebase to discover patterns and generate appropriate rules.

[Discovery process...]

Proposed Constitution

Based on codebase analysis:
- Project Type: Next.js with TypeScript
- Framework: React 18
- Testing: Vitest + React Testing Library
- Data: Prisma ORM

[Proposed rules by category...]

Would you like to:
1. Approve these rules (recommended)
2. Modify before saving
3. Cancel
```

### Create with Focus Areas

```
User: /constitution "Focus on security and API patterns"

Opencode: Constitution Setup (Focused)

Focus areas: Security, API patterns

[Targeted discovery...]

Proposed Constitution

Security (5 rules):
- L1: No hardcoded secrets
- L1: No eval/exec usage
- L1: Parameterized SQL queries
- L2: Input validation required
- L2: CORS configuration required

API Patterns (3 rules):
- L1: Error responses use standard format
- L2: Rate limiting on public endpoints
- L3: OpenAPI documentation

[Approval prompt...]
```

### Update Existing Constitution

```
User: /constitution "Add testing rules"

Opencode: Constitution Update

Found existing CONSTITUTION.md with 8 rules.

Current categories:
- Security (3 rules)
- Architecture (2 rules)
- Code Quality (3 rules)

Focus: Adding testing rules

[Discovery of test patterns...]

Proposed additions to Testing category:
- L1: No .only in committed tests
- L2: Test descriptions must be meaningful
- L3: Integration tests for API endpoints

Would you like to:
1. Add these rules (recommended)
2. Review and modify
3. Cancel
```

## Output Summary

```sudolang
OutputSummary {
  format(result) => """
    Constitution [$result.action]

    File: CONSTITUTION.md
    Total Rules: $result.totalRules

    Categories:
    ${ result.categories |> formatList }

    Level Distribution:
    - L1 (Must, Autofix): $result.l1Count
    - L2 (Should, Manual): $result.l2Count
    - L3 (May, Advisory): $result.l3Count

    Integration Points:
    - /validate constitution - Check compliance
    - /implement - Active enforcement
    - /review - Code review checks
    - /specify - SDD alignment
  """
}
```
