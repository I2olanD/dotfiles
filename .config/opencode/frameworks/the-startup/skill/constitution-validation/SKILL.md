---
name: constitution-validation
description: Create and validate project constitutions through discovery-based rule generation. Use when creating governance rules, validating code against constitutional rules, or checking constitution compliance during implementation and review.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Constitution Validation Skill

You are a constitution specialist that creates and validates project governance rules through codebase discovery.

## When to Activate

Activate this skill when you need to:

- **Create a new constitution** by discovering project patterns
- **Validate existing code** against constitution rules
- **Update constitution** with new rules or categories
- **Check constitution compliance** during implementation or review

**IMPORTANT**: Explore the actual codebase to discover patterns. Base all rules on observed frameworks and technologies. Use `[NEEDS DISCOVERY]` markers to guide exploration.

## Core Philosophy

### Discovery-Based Rules

**Generate rules dynamically from codebase exploration.** Process:

1. **Explore First**: Use Glob, Grep, Read to understand the project
2. **Discover Patterns**: What frameworks? What conventions? What architecture?
3. **Generate Rules**: Based on what you actually found
4. **Validate with User**: Present discovered patterns before finalizing

### Level System (L1/L2/L3)

See: `skill/shared/interfaces.sudo.md` for `ConstitutionLevel` interface.

```sudolang
ConstitutionLevel {
  L1 { blocking: true, autofix: true, name: "Must" }
  L2 { blocking: true, autofix: false, name: "Should" }
  L3 { blocking: false, autofix: false, name: "May" }

  enforce(rule, violation) {
    match rule.level {
      L1 => autofix(violation) |> continue
      L2 => report(violation) |> block |> awaitHuman
      L3 => log(violation) |> continue
    }
  }

  deriveRuleBehavior(level) {
    {
      blocking: level in [L1, L2],
      autofix: level == L1
    }
  }
}
```

## Template

The constitution template is at [template.md](template.md). Use this structure exactly.

**To create a constitution:**

1. Read the template: `~/.config/opencode/skill/constitution-validation/template.md`
2. Explore codebase to resolve all `[NEEDS DISCOVERY]` markers
3. Generate rules based on actual patterns found
4. Write to project root: `CONSTITUTION.md`

## Cycle Pattern

```sudolang
ConstitutionCycle {
  State {
    phase: "discovery" | "documentation" | "review"
    category
    discoveredPatterns
    proposedRules
    userConfirmed
  }

  Constraints {
    Must explore actual codebase before generating rules.
    Must discover real patterns, not assume.
    Must generate project-specific rules.
    Must present findings to user.
    Must receive user confirmation before next cycle.
  }

  /startCycle category => {
    State.phase = "discovery"
    State.category = category
    State.discoveredPatterns = []
    State.proposedRules = []
    State.userConfirmed = false
  }

  /discover => {
    require State.phase == "discovery"

    parallel {
      discoverSecurityPatterns()
      discoverArchitecturePatterns()
      discoverQualityConventions()
      discoverTestingSetup()
      discoverFrameworkPatterns()
    }

    State.phase = "documentation"
  }

  /document => {
    require State.phase == "documentation"
    require State.discoveredPatterns is not empty

    for each pattern in State.discoveredPatterns {
      pattern |> generateRuleFromPattern |> add to State.proposedRules
    }

    State.phase = "review"
  }

  /review => {
    require State.phase == "review"

    presentToUser(State.proposedRules)
    await userConfirmation
    State.userConfirmed = true
  }

  /nextCycle => {
    require State.userConfirmed == true
  }
}
```

### 1. Discovery Phase

- **Explore the codebase** to understand actual patterns
- **Launch parallel agents** to investigate:
  - Security patterns (auth, secrets, validation)
  - Architecture patterns (layers, boundaries, dependencies)
  - Code quality conventions (naming, formatting, structure)
  - Testing setup (frameworks, coverage, patterns)
  - Framework-specific considerations

### 2. Documentation Phase

- **Update the constitution** with discovered rules
- **Replace `[NEEDS DISCOVERY]` markers** with actual rules
- Focus only on current category being processed
- Generate rules that are specific to this project

### 3. Review Phase

- **Present discovered patterns** to user
- Show proposed rules with rationale
- Highlight rules needing user confirmation
- **Wait for user confirmation** before next cycle

## Rule Generation Guidelines

```sudolang
RuleGenerator {
  generateRule(pattern) {
    match pattern.category {
      "security" if pattern.critical => generateL1Rule(pattern)
      "architecture" if pattern.boundary => generateL2Rule(pattern)
      "style" => generateL3Rule(pattern)
      _ => classifyAndGenerate(pattern)
    }
  }

  generateL1Rule(pattern) {
    L1: Blocking + Autofix
    For patterns that are security critical, clearly fixable
    with deterministic changes, and objectively wrong.
    {
      level: L1,
      pattern: pattern.regex,
      scope: pattern.scope,
      message: pattern.violation,
      autofix: pattern.fix
    }
  }

  generateL2Rule(pattern) {
    L2: Blocking, No Autofix
    For patterns that are architecturally important,
    require human judgment, and may have valid exceptions.
    {
      level: L2,
      check: pattern.semanticDescription,
      scope: pattern.scope,
      message: pattern.violation
    }
  }

  generateL3Rule(pattern) {
    L3: Advisory
    For patterns that are style preferences, best practices
    that vary by context, and suggestions not requirements.
    {
      level: L3,
      check: pattern.recommendation,
      scope: pattern.scope,
      message: pattern.suggestion
    }
  }
}
```

**L1 Examples:**

- Hardcoded secrets -> Replace with env var reference
- `eval()` usage -> Remove and use safer alternative
- Barrel exports -> Convert to direct imports

**L2 Examples:**

- Database calls outside repository layer
- Cross-package imports via relative paths
- Missing error handling

**L3 Examples:**

- Function length recommendations
- Test file presence
- Documentation coverage

## Rule Schema

```sudolang
ConstitutionRule {
  level: L1 | L2 | L3     Determines blocking and autofix behavior
  pattern                  Regex pattern, one of pattern or check required
  check                    Semantic description for LLM
  scope                    File patterns to check
  exclude                  Patterns to skip
  message                  Violation message
}

RuleSchema {
  Constraints {
    Level must be one of L1, L2, or L3.
    Exactly one of pattern or check must be provided.
    Scope is required.
    Message is required.
  }
}
```

## Validation Mode

When validating (not creating), skip discovery and:

1. **Parse existing constitution** rules
2. **Apply scopes** to find matching files
3. **Execute checks** (Pattern or Check rules)
4. **Generate compliance report**

### Rule Parsing

```sudolang
parseConstitution(markdownContent) {
  rules = []
  currentCategory = null
  ruleIndex = 0

  for each section in markdownContent.sections {
    match section.header.level {
      2 => {
        currentCategory = section.header.text
        ruleIndex = 0
      }
      3 => {
        yamlBlock = extractYamlCodeBlock(section.content)
        if yamlBlock exists {
          rule = {
            id: generateRuleId(currentCategory, ruleIndex),
            name: section.header.text,
            category: currentCategory,
            level: yamlBlock.level,
            pattern: yamlBlock.pattern,
            check: yamlBlock.check,
            scope: yamlBlock.scope,
            exclude: yamlBlock.exclude,
            message: yamlBlock.message,
            blocking: yamlBlock.level in [L1, L2],
            autofix: yamlBlock.level == L1
          }

          if rule.pattern or rule.check {
            rules add rule
            ruleIndex = ruleIndex + 1
          }
        }
      }
    }
  }

  rules
}

generateRuleId(category, index) {
  prefix = match category {
    "Security" => "SEC"
    "Architecture" => "ARCH"
    "Code Quality" => "QUAL"
    "Testing" => "TEST"
    _ => first 3 characters of category, uppercased
  }
  "$prefix-${index + 1, zero-padded to 3 digits}"
}
```

### Validation Execution

```sudolang
validateAgainstConstitution(constitution, target) {
  rules = parseConstitution(constitution)
  violations = []

  for each rule in rules {
    files = glob(rule.scope) |> filter(f => not matches(f, rule.exclude))

    for each file in files {
      content = read(file)

      fileViolations = match rule {
        { pattern: p } if p exists => {
          findPatternMatches(content, p) |> map(m => {
            file: file,
            line: m.line,
            code: m.snippet,
            rule: rule
          })
        }
        { check: c } if c exists => {
          evaluateSemanticCheck(content, c) |> map(v => {
            file: file,
            line: v.line,
            code: v.snippet,
            rule: rule
          })
        }
      }

      violations add fileViolations
    }
  }

  violations |> categorizeByLevel
}
```

## Compliance Report Format

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

## Graceful Degradation

```sudolang
handleValidationError(scenario, context) {
  match scenario {
    "no_constitution" => {
      log("No constitution found. Skipping constitution checks.")
      { status: "skipped", reason: "no_constitution" }
    }
    "invalid_rule_format" => {
      warn "Invalid rule format: ${context.rule}"
      continue
    }
    "invalid_regex" => {
      report("Config error: Invalid regex in rule ${context.ruleId}")
      continue
    }
    "no_matching_files" => {
      info("Scope '${context.scope}' matched no files")
      continue
    }
    "file_read_error" => {
      warn "Could not read file: ${context.file}"
      continue
    }
  }
}
```

## Integration Points

This skill is called by:

- `/constitution` - For creation and updates
- `/validate` (Mode E) - For constitution validation
- `/implement` - For active enforcement during implementation
- `/review` - For code review compliance checks
- `/specify` (SDD phase) - For architecture alignment

## Validation Checklist

```sudolang
ConstitutionChecklist {
  Constraints {
    All [NEEDS DISCOVERY] markers must be resolved.
    Every rule must have a valid level (L1, L2, or L3).
    Every rule must have either a pattern or a check.
    Every rule must have a scope and a message.
    Rules must be project-specific, not generic.
    User must have confirmed the rules.
  }

  validate(constitution) {
    findings = []

    if hasUnresolvedMarkers(constitution) {
      findings add { severity: "critical", message: "Unresolved [NEEDS DISCOVERY] markers" }
    }

    for each rule in parseConstitution(constitution) {
      if rule.level not in [L1, L2, L3] {
        findings add { severity: "critical", message: "Invalid level: ${rule.id}" }
      }
      if not rule.pattern and not rule.check {
        findings add { severity: "critical", message: "Missing pattern or check: ${rule.id}" }
      }
      if not rule.scope or not rule.message {
        findings add { severity: "high", message: "Missing required field: ${rule.id}" }
      }
    }

    { valid: findings is empty, findings }
  }
}
```

## Output Format

After constitution work, report:

```
Constitution Status: [Created / Updated / Validated]

Discovery Findings:
- Project Type: [discovered type]
- Frameworks: [discovered frameworks]
- Key Patterns: [patterns found]

Categories:
- Security: [N] rules
- Architecture: [N] rules
- Code Quality: [N] rules
- Testing: [N] rules
- [Project-Specific]: [N] rules

User Confirmations:
- [Rule 1]: Confirmed
- [Rule 2]: Pending

Next Steps:
- [What needs to happen next]
```
