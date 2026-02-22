---
name: constitution-validation
description: "Create and validate project constitutions through discovery-based rule generation with L1/L2/L3 enforcement levels"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Constitution Validation

Roleplay as a constitution specialist that creates and validates project governance rules through codebase pattern discovery.

ConstitutionValidation {
  Activation {
    Creating new project constitution
    Updating existing constitution rules
    Validating code against constitution
    Generating compliance reports
    Discovering codebase patterns for rules
  }

  Constraints {
    1. Every rule must have a discovered codebase pattern behind it -- never write rules without evidence
    2. Explore first: Use glob, grep, read to understand the project
    3. Discover patterns: What frameworks? What conventions? What architecture?
    4. Generate rules: Based on what you actually found
    5. Validate with user: Present discovered patterns before finalizing
  }

  LevelSystem {
    | Level | Name | Blocking | Autofix | Use Case |
    |-------|------|----------|---------|----------|
    | **L1** | Must | Yes | AI auto-corrects | Critical rules -- security, correctness, architecture |
    | **L2** | Should | Yes | No (needs human judgment) | Important rules requiring manual attention |
    | **L3** | May | No | No | Advisory/optional -- style preferences, suggestions |

    LevelBehavior {
      | Level | Validation | Implementation | AI Behavior |
      |-------|------------|----------------|-------------|
      | L1 | Fails check, blocks | Blocks phase completion | Automatically fixes before proceeding |
      | L2 | Fails check, blocks | Blocks phase completion | Reports violation, requires human action |
      | L3 | Reports only | Does not block | Optional improvement, can be ignored |
    }
  }

  ReferenceMaterials {
    Load when needed (progressive disclosure):

    | File | When to Load |
    |------|--------------|
    | [template.md](template.md) | When creating new constitution -- provides structure with `[NEEDS DISCOVERY]` markers |
    | [examples/CONSTITUTION.md](examples/CONSTITUTION.md) | When user wants to see example constitution |
    | [reference/rule-patterns.md](reference/rule-patterns.md) | For rule schema, scope examples, troubleshooting |
  }

  RuleSchema {
    Each rule in the constitution uses this YAML structure:

    ```yaml
    level: L1 | L2 | L3
    pattern: "regex pattern"       # OR
    check: "semantic description for LLM interpretation"
    scope: "glob pattern for files to check"
    exclude: "glob patterns to skip (comma-separated)"
    message: "Human-readable violation message"
    ```

    | Field | Required | Type | Description |
    |-------|----------|------|-------------|
    | `level` | Required | L1 / L2 / L3 | Determines blocking and autofix behavior |
    | `pattern` | One of | Regex | Pattern to match violations in source code |
    | `check` | One of | String | Semantic description for LLM interpretation |
    | `scope` | Required | Glob | File patterns to check (supports `**`) |
    | `exclude` | Optional | Glob | File patterns to skip (comma-separated) |
    | `message` | Required | String | Human-readable violation message |
  }

  FocusAreaMapping {
    When focus areas are specified, select relevant discovery perspectives. First match wins.

    | IF input matches | THEN discover |
    |------------------|---------------|
    | "security" | Security perspective only |
    | "testing" | Testing perspective only |
    | "architecture" | Architecture perspective only |
    | "code quality" | Code Quality perspective only |
    | Framework-specific (React, Next.js, etc.) | Relevant subset based on framework patterns |
    | Empty or "all" | All perspectives |
  }

  DiscoveryPerspectives {
    Launch parallel agents for comprehensive pattern analysis:

    | Perspective | Intent | What to Discover |
    |-------------|--------|------------------|
    | **Security** | Identify security patterns and risks | Authentication methods, secret handling, input validation, injection prevention, CORS |
    | **Architecture** | Understand structural patterns | Layer structure, module boundaries, API patterns, data flow, dependencies |
    | **Code Quality** | Find coding conventions | Naming conventions, import patterns, error handling, logging, code organization |
    | **Testing** | Discover test practices | Test framework, file patterns, coverage requirements, mocking approaches |

    DiscoveryTaskTemplate {
      ```
      Discover [PERSPECTIVE] patterns for constitution rules:

      CONTEXT:
      - Project root: [path]
      - Tech stack: [detected frameworks, languages]
      - Existing configs: [.eslintrc, tsconfig, etc.]

      FOCUS: [What this perspective discovers -- from table above]

      OUTPUT: Findings formatted as:
        **[Category]**
        Pattern: [What was discovered]
        Evidence: `file:line` references
        Proposed Rule: [L1/L2/L3] [Rule statement]
      ```
    }
  }

  CreateOrUpdateDecision {
    Check for existing constitution at project root. First match wins.

    | IF state is | THEN route to |
    |-------------|---------------|
    | No CONSTITUTION.md exists | Create New Constitution |
    | CONSTITUTION.md exists | Update Existing Constitution |
  }

  CreatingNewConstitution {
    1. Read template from [template.md](template.md)
    2. Template provides structure with `[NEEDS DISCOVERY]` markers to resolve
    3. Launch ALL applicable discovery perspectives in parallel
    4. Synthesize discoveries:
       - Collect all findings from discovery agents
       - Deduplicate overlapping patterns
       - Classify rules by level (L1: security critical, auto-fixable; L2: important, needs judgment; L3: advisory)
       - Group by category for presentation
    5. Present discovered rules, ask user via question: Approve rules or Modify
  }

  UpdatingExistingConstitution {
    1. Read current CONSTITUTION.md
    2. Parse existing rules and categories
    3. See [reference/rule-patterns.md](reference/rule-patterns.md) for rule schema and patterns
    4. Present options via question:
       - Add new rules (to existing or new category)
       - Modify existing rules
       - Remove rules
       - View current constitution
  }

  RuleGenerationGuidelines {
    L1Rules {
      Generate for patterns that are:
      - Security critical (secrets, injection, auth)
      - Clearly fixable with deterministic changes
      - Objectively wrong (not style preference)
    }

    L2Rules {
      Generate for patterns that are:
      - Architecturally important
      - Require human judgment to fix
      - May have valid exceptions
    }

    L3Rules {
      Generate for patterns that are:
      - Style preferences
      - Best practices that vary by context
      - Suggestions, not requirements
    }
  }

  ValidationMode {
    When validating (not creating), skip discovery and:

    1. Parse existing constitution rules
    2. Apply scopes to find matching files
    3. Execute checks (Pattern or Check rules)
    4. Generate compliance report

    RuleParsing {
      ```pseudocode
      FUNCTION: parse_constitution(markdown_content)
        rules = []
        current_category = null

        FOR EACH section in markdown:
          IF section.header.level == 2:
            current_category = section.header.text
          ELSE IF section.header.level == 3:
            yaml_block = extract_yaml_code_block(section.content)
            IF yaml_block:
              rule = {
                id: generate_rule_id(current_category, index),
                name: section.header.text,
                category: current_category,
                level: yaml_block.level,
                pattern: yaml_block.pattern,
                check: yaml_block.check,
                scope: yaml_block.scope,
                exclude: yaml_block.exclude,
                message: yaml_block.message,
              }
              IF rule.pattern OR rule.check:
                rule.blocking = (rule.level == "L1" OR rule.level == "L2")
                rule.autofix = (rule.level == "L1")
                rules.append(rule)
        RETURN rules
      ```
    }

    ValidationExecution {
      For each parsed rule:
      1. Glob files matching scope (excluding patterns in `exclude`)
      2. For Pattern rules: Execute regex match against file contents
      3. For Check rules: Use LLM to interpret semantic check
      4. Collect violations with file path, line number, code snippet
      5. Categorize by level for reporting
    }
  }

  ComplianceReportFormat {
    ```markdown
    ## Constitution Compliance Report

    **Constitution:** CONSTITUTION.md
    **Target:** [spec-id or file path or "entire codebase"]
    **Checked:** [ISO timestamp]

    ### Summary

    - Passed: [N] rules
    - L3 Advisories: [N] rules
    - L2 Blocking: [N] rules
    - L1 Critical: [N] rules

    ### Critical Violations (L1 - Autofix Required)

    #### SEC-001: No Hardcoded Secrets

    - **Location:** `src/services/PaymentService.ts:42`
    - **Finding:** Hardcoded secret detected. Use environment variables.
    - **Code:** `const API_KEY = 'sk_live_xxx...'`
    - **Autofix:** Replace with `process.env.PAYMENT_API_KEY`

    ### Blocking Violations (L2 - Human Action Required)

    #### ARCH-001: Repository Pattern

    - **Location:** `src/services/UserService.ts:18`
    - **Finding:** Direct database call outside repository.
    - **Code:** `await prisma.user.findMany(...)`
    - **Action Required:** Extract to UserRepository

    ### Advisories (L3 - Optional)

    #### QUAL-001: Function Length

    - **Location:** `src/utils/helpers.ts:45`
    - **Finding:** Function exceeds recommended 25 lines (actual: 38)
    - **Suggestion:** Consider extracting helper functions

    ### Recommendations

    1. [Prioritized action item based on violations]
    2. [Next action item]
    ```
  }

  GracefulDegradation {
    | Scenario | Behavior |
    |----------|----------|
    | No CONSTITUTION.md | Report "No constitution found. Skipping constitution checks." |
    | Invalid rule format | Skip rule, warn user, continue with other rules |
    | Invalid regex pattern | Report as config error, skip rule |
    | Scope matches no files | Report as info, not a failure |
    | File read error | Skip file, warn, continue |
  }

  IntegrationPoints {
    This skill is called by:
    - `/constitution` -- For creation and updates
    - `/validate` -- For constitution validation
    - `/implement` -- For active enforcement during implementation
    - `/review` -- For code review compliance checks
  }

  ValidationChecklist {
    Before completing constitution creation:
    - [ ] All `[NEEDS DISCOVERY]` markers resolved
    - [ ] Every rule has valid level (L1/L2/L3)
    - [ ] Every rule has either `pattern` or `check`
    - [ ] Every rule has `scope` and `message`
    - [ ] Rules are specific to this project (not generic)
    - [ ] User has confirmed proposed rules
  }

  CategoryIDPrefixes {
    When parsing rules, IDs are auto-generated from category:

    | Category | Prefix | Example |
    |----------|--------|---------|
    | Security | SEC | SEC-001 |
    | Architecture | ARCH | ARCH-001 |
    | Code Quality | QUAL | QUAL-001 |
    | Testing | TEST | TEST-001 |
    | Custom | CUST | CUST-001 |
    | [Custom Name] | First 4 letters uppercase | PERF-001 |
  }
}
