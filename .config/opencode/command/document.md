---
description: "Generate and maintain documentation for code, APIs, and project components"
argument-hint: "file/directory path, 'api' for API docs, 'readme' for README, or 'audit' for doc audit"
allowed-tools:
  ["bash", "read", "write", "edit", "glob", "grep", "question", "skill"]
---

# Document

Roleplay as a documentation orchestrator that coordinates parallel documentation generation across multiple perspectives.

**Documentation Target**: $ARGUMENTS

Document {

    Constraints {
        Cover all applicable documentation perspectives thoroughly.
        Launch applicable documentation perspectives simultaneously where possible.
        Check for existing documentation first — update rather than duplicate.
        Match project documentation style and conventions.
        Link to actual file paths and line numbers.
        Never create duplicate documentation when existing docs can be updated.
        Never generate docs without checking existing documentation first.
    }

    Perspectives {
        | Perspective | Intent | What to Document | Output |
        |-------------|--------|-----------------|--------|
        | Code | Make code self-explanatory | Functions, classes, interfaces, types with JSDoc/TSDoc/docstrings | Inline comments |
        | API | Enable integration | Endpoints, request/response schemas, authentication, error codes, OpenAPI spec | .engineer/api/ |
        | README | Enable quick start | Features, installation, configuration, usage examples, troubleshooting | README.md |
        | Audit | Identify documentation gaps | Coverage metrics, stale docs, missing documentation, prioritized backlog | (meta-action) |
        | Capture | Preserve discoveries | Business rules → .engineer/domain/, technical patterns → .engineer/patterns/, external integrations → .engineer/interfaces/ | .engineer/* |
        | Architecture | Document system design decisions | ADRs for key decisions, module overviews, data flow diagrams, technology rationale | .engineer/architecture/ |
    }

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

    KnowledgeCaptureGuidelines {
        Categorization:
        .engineer/domain/      — business rules (WHAT users can do)
        .engineer/patterns/    — technical patterns (HOW we build it)
        .engineer/interfaces/  — external service dependencies

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

        Phase2_LaunchDocumentation {
            Launch parallel subagents per applicable perspectives simultaneously in a single response.

            For Capture perspective: follow categorization rules — .engineer/domain/ for business rules,
            .engineer/patterns/ for technical patterns, .engineer/interfaces/ for external integrations.
        }

        Phase3_SynthesizeResults {
            1. Merge with existing docs — update, don't duplicate.
            2. Check consistency for style alignment.
            3. Resolve conflicts between perspectives.
            4. Apply changes.
        }

        Phase4_PresentSummary {
            Report: files documented, coverage achieved, gaps remaining.
            Ask user: Address remaining gaps | Review stale docs | Done
        }
    }

}

## Important Notes

- Always check for existing documentation before creating new files — update rather than duplicate
- Audit perspective is a meta-action that identifies gaps — it informs which other perspectives to run
- Capture perspective categorizes knowledge: domain (WHAT), patterns (HOW), interfaces (EXTERNAL)
- Use descriptive names for docs: `stripe-payments.md` not `payment.md`, `user-permissions.md` not `rules.md`
