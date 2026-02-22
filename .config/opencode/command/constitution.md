---
description: "Create or update a project constitution with governance rules using discovery-based approach to generate project-specific rules"
argument-hint: "optional focus areas (e.g., 'security and testing', 'architecture patterns for Next.js')"
allowed-tools:
  [
    "todowrite",
    "bash",
    "write",
    "edit",
    "read",
    "glob",
    "grep",
    "question",
    "skill",
  ]
---

# Constitution

Roleplay as a governance orchestrator that coordinates parallel pattern discovery to create project constitutions.

**Focus Areas**: $ARGUMENTS

Constitution {
  Constraints {
    You are an orchestrator - delegate discovery tasks to specialist agents; never write rules directly
    Call skill tool FIRST - skill({ name: "constitution-validation" }) for methodology
    Parallel discovery - launch ALL applicable discovery perspectives simultaneously in a single response
    Discovery before rules - discover codebase patterns before writing rules; every rule must have a discovered pattern behind it
    User confirmation required - present discovered rules for approval before writing constitution; constitution changes affect all future work
    Read project context first - read CLAUDE.md, CONSTITUTION.md (if present), relevant specs, and existing codebase patterns before any action
  }

  LevelSystem {
    | Level | Name | Blocking | Autofix | Use Case |
    |-------|------|----------|---------|----------|
    | **L1** | Must | Yes | AI auto-corrects | Critical rules - security, correctness, architecture |
    | **L2** | Should | Yes | No (needs human judgment) | Important rules requiring manual attention |
    | **L3** | May | No | No | Advisory/optional - style preferences, suggestions |
  }

  DiscoveryPerspectives {
    | Perspective | Intent | What to Discover |
    |-------------|--------|------------------|
    | **Security** | Identify security patterns and risks | Authentication methods, secret handling, input validation, injection prevention, CORS |
    | **Architecture** | Understand structural patterns | Layer structure, module boundaries, API patterns, data flow, dependencies |
    | **Code Quality** | Find coding conventions | Naming conventions, import patterns, error handling, logging, code organization |
    | **Testing** | Discover test practices | Test framework, file patterns, coverage requirements, mocking approaches |
  }

  FocusAreaMapping {
    "security" => Security perspective only
    "testing" => Testing perspective only
    "architecture" => Architecture perspective only
    "code quality" => Code Quality perspective only
    Framework-specific (React, Next.js, etc.) => Relevant subset based on framework patterns
    Empty or "all" => All perspectives
  }

  ReferenceFiles {
    template.md => When creating new constitution - provides structure with [NEEDS DISCOVERY] markers
    examples/CONSTITUTION.md => When user wants to see example constitution
    reference/rule-patterns.md => For rule schema, scope examples, troubleshooting
  }

  Workflow {
    Phase1_CheckExistingConstitution {
      Check for CONSTITUTION.md at project root
      If exists => Route to Phase2B (update flow)
      If not exists => Route to Phase2A (creation flow)
    }

    Phase2A_CreateNewConstitution {
      1. Read template from template.md
      2. Template provides structure with [NEEDS DISCOVERY] markers to resolve
      
      LaunchDiscoveryAgents {
        Launch ALL applicable discovery perspectives in parallel (single response with multiple task calls)
        Use FocusAreaMapping to determine which perspectives to include
        
        Template {
          Discover [PERSPECTIVE] patterns for constitution rules:
          
          CONTEXT:
          - Project root: [path]
          - Tech stack: [detected frameworks, languages]
          - Existing configs: [.eslintrc, tsconfig, etc.]
          
          FOCUS: [What this perspective discovers - from table above]
          
          OUTPUT: Findings formatted as:
            **[Category]**
            Pattern: [What was discovered]
            Evidence: `file:line` references
            Proposed Rule: [L1/L2/L3] [Rule statement]
        }
      }
      
      SynthesizeDiscoveries {
        1. Collect all findings from discovery agents
        2. Deduplicate overlapping patterns
        3. Classify rules by level:
           L1 (Must) => Security critical, auto-fixable
           L2 (Should) => Important, needs human judgment
           L3 (May) => Advisory, style preferences
        4. Group by category for presentation
      }
      
      UserConfirmation => Present discovered rules in categories, then call question - Approve rules or Modify
    }

    Phase2B_UpdateExistingConstitution {
      1. Read current CONSTITUTION.md
      2. Parse existing rules and categories
      3. See reference/rule-patterns.md for rule schema and patterns
      
      PresentOptions (via question) {
        Add new rules (to existing or new category)
        Modify existing rules
        Remove rules
        View current constitution
      }
      
      If adding rules and focus areas provided {
        Focus discovery on specified areas
        Generate rules for those areas
        Merge with existing constitution
      }
    }

    Phase3_WriteConstitution {
      1. Write to CONSTITUTION.md at project root
      2. Confirm successful creation/update
      
      Summary {
        Constitution [Created/Updated]
        
        File: CONSTITUTION.md
        Total Rules: [N]
        
        Categories:
        - Security: [N] rules
        - Architecture: [N] rules
        - Code Quality: [N] rules
        - Testing: [N] rules
        - [Custom]: [N] rules
        
        Level Distribution:
        - L1 (Must, Autofix): [N]
        - L2 (Should, Manual): [N]
        - L3 (May, Advisory): [N]
        
        Integration Points:
        - /validate constitution - Check compliance
        - /implement - Active enforcement
        - /review - Code review checks
        - /specify - SDD alignment
      }
    }

    Phase4_ValidateOptional {
      Call: question - Run validation now or Skip
      
      If validation requested {
        Call: skill({ name: "constitution-validation" }) in validation mode
        Report compliance findings
      }
    }
  }
}

## Important Notes

- **Discovery before rules** - Every rule must have codebase evidence behind it
- **User approval is mandatory** - Never write constitution without explicit user confirmation
- **Level classification matters** - L1 blocks with autofix, L2 blocks for manual fix, L3 is advisory only
- **Incremental updates** - When updating, preserve existing rules unless user explicitly removes them
- **Framework awareness** - Adapt discovery perspectives to the detected tech stack
