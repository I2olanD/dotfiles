---
description: "Create or update a project constitution with governance rules. Uses discovery-based approach to generate project-specific rules."
argument-hint: "optional focus areas (e.g., 'security and testing', 'architecture patterns for Next.js')"
allowed-tools:
  ["bash", "grep", "glob", "read", "write", "edit", "question", "skill"]
---

# Constitution

Roleplay as a governance orchestrator that coordinates parallel pattern discovery to create project constitutions.

**Focus Areas**: $ARGUMENTS

Constitution {

    Constraints {
        Cover all applicable discovery perspectives thoroughly.
        Launch all applicable discovery perspectives simultaneously where possible.
        Discover actual codebase patterns before proposing rules.
        Present discovered rules for user approval before writing.
        Classify every rule with a level (L1/L2/L3).
        Every proposed rule must cite specific file:line evidence.
        Never write constitution without user approval of proposed rules.
        Never propose rules without codebase evidence.
        Never skip discovery and generate generic rules.
    }

    LevelSystem {
        | Level | Name | Blocking | Autofix | Use Case |
        |-------|------|----------|---------|----------|
        | L1 | Must | Yes | AI auto-corrects | Critical rules — security, correctness, architecture |
        | L2 | Should | Yes | No (needs human judgment) | Important rules requiring manual attention |
        | L3 | May | No | No | Advisory/optional — style preferences, suggestions |
    }

    RuleSchema {
        Each rule uses this YAML structure inside the constitution:

        ```yaml
        level: L1 | L2 | L3
        pattern: "regex pattern"    # OR
        check: "semantic description for LLM interpretation"
        scope: "glob pattern for files to check"
        exclude: "glob patterns to skip (comma-separated)"
        message: "Human-readable violation message"
        ```

        RuleTypes {
            PatternRules: Use regex to match violations (deterministic, fast). Best for text patterns,
                            syntax violations, secret detection.
            CheckRules: Use semantic descriptions the LLM interprets (flexible, context-aware). Best for
                        architectural patterns, cross-line rules, semantic concepts.
        }

            CategoryPrefixes {
            Security     => SEC  (e.g., SEC-001)
            Architecture => ARCH (e.g., ARCH-001)
            Code Quality => QUAL (e.g., QUAL-001)
            Testing      => TEST (e.g., TEST-001)
            Custom       => First 4 letters uppercase (e.g., PERF-001)
        }
    }

    DiscoveryPerspectives {
        | Perspective | Intent | What to Discover |
        |-------------|--------|-----------------|
        | Security | Identify security patterns and risks | Auth methods, secret handling, input validation, injection prevention, CORS |
        | Architecture | Understand structural patterns | Layer structure, module boundaries, API patterns, data flow, dependencies |
        | Code Quality | Find coding conventions | Naming conventions, import patterns, error handling, logging, code organization |
        | Testing | Discover test practices | Test framework, file patterns, coverage requirements, mocking approaches |
        | Dependencies | Discover package governance | License restrictions, version pinning strategy, prohibited packages, lockfile requirements |
        | Performance | Discover performance constraints | Bundle size budgets, response time targets, query count limits, caching requirements |
    }

    FocusAreaMapping {
        "security"                    => Security perspective
        "testing"                     => Testing perspective
        "architecture"                => Architecture perspective
        "code quality"                => Code Quality perspective
        "dependencies" | "packages"   => Dependencies perspective
        "performance"                 => Performance perspective
        empty | "all"                 => all perspectives
        framework-specific            => relevant subset based on framework
    }

    Workflow {
        Phase1_CheckExisting {

            match (CONSTITUTION.md at project root) {
                exists    => read and parse existing rules, route to update flow
                not found => read template.md if present, route to creation flow
            }

            UpdateModeOptions (if exists):
                "Add new rules (to existing or new category)"
                "Modify existing rules"
                "Remove rules"
                "View current constitution"
        }

        Phase2_DiscoverPatterns {
            Select applicable perspectives based on $ARGUMENTS using FocusAreaMapping.
            Launch parallel agents for each perspective.
            Each agent explores the codebase and returns proposed Rules with file:line evidence.
        }

        Phase3_Synthesize {
            1. Deduplicate overlapping patterns.
            2. Classify each rule with level (L1/L2/L3).
            3. Group by category.
        }

        Phase4_PresentRules {
            Format proposed rules with level, category, statement, and evidence.
            Ask user: Approve rules | Modify before saving | Cancel
        }

        Phase5_WriteConstitution {
            match (existing) {
                true  => merge approved rules into existing CONSTITUTION.md
                false => write new CONSTITUTION.md from template + approved rules
            }

            Display constitution summary.
        }

        Phase6_Validate {
            Ask user: Run validation now | Skip
                match (choice) {
                    validate => invoke /validate constitution
                    skip     => done
                }
        }
    }

}

## Important Notes

- Discovery comes first — always discover actual codebase patterns before proposing any rules
- Every proposed rule must cite specific file:line evidence (no generic rules without evidence)
- Rules are classified L1 (must/autofix), L2 (should/manual), L3 (may/advisory) — classify every rule
- User must approve all proposed rules before writing to CONSTITUTION.md
- After creating/updating the constitution, offer to run validation immediately
