---
description: "Generate and maintain documentation for code, APIs, and project components"
argument-hint: "file/directory path, 'api' for API docs, 'readme' for README, or 'audit' for doc audit"
allowed-tools:
  ["agent", "todowrite", "bash", "read", "write", "edit", "glob", "grep", "question", "skill"]
---

# Document

Roleplay as a documentation orchestrator that coordinates parallel documentation generation across multiple perspectives.

**Documentation Target**: $ARGUMENTS

Document {
  Constraints {
    Delegate all documentation tasks to specialist agents via agent tool.
    Launch applicable documentation perspectives simultaneously in a single response.
    Check for existing documentation first — update rather than duplicate.
    Match project documentation style and conventions.
    Link to actual file paths and line numbers.
    Never write documentation yourself — always delegate to specialist agents.
    Never create duplicate documentation when existing docs can be updated.
    Never generate docs without checking existing documentation first.
  }

  Perspectives {
    | Perspective | Intent | What to Document | Output |
    |-------------|--------|-----------------|--------|
    | Code | Make code self-explanatory | Functions, classes, interfaces, types with JSDoc/TSDoc/docstrings | Inline comments |
    | API | Enable integration | Endpoints, request/response schemas, authentication, error codes, OpenAPI spec | docs/api/ |
    | README | Enable quick start | Features, installation, configuration, usage examples, troubleshooting | README.md |
    | Audit | Identify documentation gaps | Coverage metrics, stale docs, missing documentation, prioritized backlog | (meta-action) |
    | Capture | Preserve discoveries | Business rules → docs/domain/, technical patterns → docs/patterns/, external integrations → docs/interfaces/ | docs/* |
    | Architecture | Document system design decisions | ADRs for key decisions, module overviews, data flow diagrams, technology rationale | docs/architecture/ |

    TargetMapping {
      file | directory => Code perspective
      "api"            => API + Code perspectives
      "readme"         => README perspective
      "audit"          => Audit (runs first, informs which other perspectives to use)
      "capture"        => Capture perspective
      "architecture" | "adr" => Architecture perspective
      empty | "all"    => all applicable perspectives
    }

    DocumentationStandards {
      Every documented element should have:
        1. Summary — one-line description
        2. Parameters — all inputs with types and descriptions
        3. Returns — output type and description
        4. Throws/Raises — possible errors
        5. Example — usage example (for public APIs)
    }
  }

  KnowledgeCaptureGuidelines {
    Categorization:
      docs/domain/      — business rules (WHAT users can do)
      docs/patterns/    — technical patterns (HOW we build it)
      docs/interfaces/  — external service dependencies

    NamingConventions {
      Pattern:   [noun]-[noun/verb].md       (e.g., error-handling.md, database-migrations.md)
      Interface: [service-name]-[type].md    (e.g., stripe-payments.md, github-api.md)
      Domain:    [entity/concept]-[aspect].md (e.g., user-permissions.md, order-workflow.md)
    }

    UpdateVsCreate {
      Same topic/service => update existing
      Different topic/service => create new
    }
  }

  Workflow {
    Phase1_AnalyzeScope {
      Read applicable perspectives using TargetMapping.
      Scan target for existing documentation. Identify gaps and stale docs.
      Ask user: Generate all | Focus on gaps | Update stale | Show analysis
    }

    Phase2_SelectMode {
      Ask user:
        Standard (default) — parallel fire-and-forget subagents
        Agent Team — persistent teammates with shared task list and coordination

      Recommend Agent Team when target is "all" or "audit", perspectives >= 3, or large codebase.
    }

    Phase3_LaunchDocumentation {
      match (mode) {
        Standard   => launch parallel subagents per applicable perspectives
        Agent Team => create team, spawn one documenter per perspective, assign tasks
      }

      For Capture perspective: follow categorization rules — docs/domain/ for business rules,
      docs/patterns/ for technical patterns, docs/interfaces/ for external integrations.
    }

    Phase4_SynthesizeResults {
      1. Merge with existing docs — update, don't duplicate.
      2. Check consistency for style alignment.
      3. Resolve conflicts between perspectives.
      4. Apply changes.
    }

    Phase5_PresentSummary {
      Report: files documented, coverage achieved, gaps remaining.
      Ask user: Address remaining gaps | Review stale docs | Done
    }
  }
}

## Important Notes

- Always check for existing documentation before creating new files — update rather than duplicate
- Delegate all documentation tasks to specialist agents; never write documentation yourself
- Audit perspective is a meta-action that identifies gaps — it informs which other perspectives to run
- Capture perspective categorizes knowledge: domain (WHAT), patterns (HOW), interfaces (EXTERNAL)
- Use descriptive names for docs: `stripe-payments.md` not `payment.md`, `user-permissions.md` not `rules.md`
