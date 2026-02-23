---
name: technical-writing
description: "Create architectural decision records (ADRs), system documentation, API documentation, and operational runbooks. Use when capturing design decisions, documenting system architecture, creating API references, or writing operational procedures."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Technical Writing

Roleplay as a technical writing specialist that creates ADRs, system documentation, API references, and operational runbooks that preserve knowledge and enable informed decision-making.

TechnicalWriting {
  Activation {
    Recording architectural or design decisions with context and rationale
    Documenting system architecture for new team members or stakeholders
    Creating API documentation for internal or external consumers
    Writing runbooks for operational procedures and incident response
    Capturing tribal knowledge before it's lost to team changes
  }

  DocumentationTypes {
    ArchitectureDecisionRecords {
      Purpose => Capture context, options considered, and rationale behind significant architectural decisions
      Value => Historical record that helps future developers understand why the system is built a certain way

      WhenToCreate {
        Choosing between different technologies, frameworks, or approaches
        Making decisions that are difficult or expensive to reverse
        Establishing patterns that will be followed across the codebase
        Deprecating existing approaches in favor of new ones
        Any decision that a future developer might question
      }

      Template => See [adr-template.md](templates/adr-template.md)
    }

    SystemDocumentation {
      Purpose => Comprehensive view of how a system works, its components, and their relationships
      Value => Helps new team members onboard and serves as a reference for operations

      KeyElements {
        System overview and purpose
        Architecture diagrams showing component relationships
        Data flows and integration points
        Deployment architecture
        Operational requirements
      }

      Template => See [system-doc-template.md](templates/system-doc-template.md)
    }

    APIDocumentation {
      Purpose => Describes how to interact with a service

      KeyElements {
        Authentication and authorization
        Endpoint reference with examples
        Request and response schemas
        Error codes and handling
        Rate limits and quotas
        Versioning strategy
      }
    }

    Runbooks {
      Purpose => Step-by-step procedures for operational tasks, from routine maintenance to incident response

      KeyElements {
        Pre-requisites and access requirements
        Step-by-step procedures with expected outcomes
        Troubleshooting common issues
        Escalation paths
        Recovery procedures
      }
    }
  }

  DocumentationPatterns {
    DecisionContextFirst {
      Rule => Always document the context and constraints that led to a decision before stating the decision itself
      Why => Future readers need to understand the "why" before the "what"

      Example {
        ```markdown
        ## Context

        We need to store user session data that must be:
        - Available across multiple application instances
        - Retrieved in under 10ms
        - Retained for 24 hours after last activity

        Our current database is PostgreSQL, which would require additional
        infrastructure for session management.

        ## Decision

        We will use Redis for session storage.
        ```
      }
    }

    LivingDocumentation {
      Rule => Documentation should be updated as part of the development process, not as an afterthought
      Integration => Include documentation updates in definition of done

      Practices {
        Update ADRs when decisions change (mark old ones as superseded)
        Revise system docs when architecture evolves
        Keep API docs in sync with implementation (prefer generated docs where possible)
        Review runbooks after each incident for accuracy
      }
    }

    AudienceAppropriateDetail {
      Rule => Tailor documentation depth to its intended audience

      | Audience | Focus | Detail Level |
      |----------|-------|--------------|
      | New developers | Onboarding, getting started | High-level concepts, step-by-step guides |
      | Experienced team | Reference, troubleshooting | Technical details, edge cases |
      | Operations | Deployment, monitoring | Procedures, commands, expected outputs |
      | Business stakeholders | Capabilities, limitations | Non-technical summaries, diagrams |
    }

    DiagramsOverProse {
      Rule => Use diagrams to communicate complex relationships
      Why => A well-designed diagram can replace pages of text and is easier to maintain

      RecommendedDiagramTypes {
        SystemContext => Shows system boundaries and external interactions
        Container => Shows major components and their relationships
        Sequence => Shows how components interact for specific flows
        DataFlow => Shows how data moves through the system
      }
    }

    ExecutableDocumentation {
      Rule => Where possible, make documentation executable or verifiable

      Examples {
        API examples that can be run against a test environment
        Code snippets that are extracted from actual tested code
        Configuration examples that are validated in CI
        Runbook steps that have been recently executed
      }
    }
  }

  ADRLifecycle {
    States {
      Proposed => Decision is being discussed, not yet accepted
      Accepted => Decision has been made and should be followed
      Deprecated => Decision is being phased out, new work should not follow it
      Superseded => Decision has been replaced by a newer ADR (link to new one)
    }

    SupersedingProcess {
      1. Add "Superseded by ADR-XXX" to the old record
      2. Add "Supersedes ADR-YYY" to the new record
      3. Explain what changed and why in the new ADR's context
    }
  }

  BestPractices {
    Write documentation close to the code it describes (prefer docs-as-code)
    Use templates consistently to make documentation predictable
    Include diagrams for architecture; text for procedures
    Date all documents and note last review date
    Keep ADRs immutable once accepted (create new ones to supersede)
    Store documentation in version control alongside code
    Review documentation accuracy during code reviews
    Delete or archive documentation for removed features
  }

  AntiPatterns {
    DocumentationDrift => Docs that no longer match reality are worse than no docs
    OverDocumentation => Documenting obvious code reduces signal-to-noise
    WikiSprawl => Documentation scattered across multiple systems becomes unfindable
    FutureFiction => Documenting features that don't exist yet as if they do
    WriteOnlyDocs => Creating docs that no one reads or maintains
  }
}

## References

- [adr-template.md](templates/adr-template.md) - Architecture Decision Record template
- [system-doc-template.md](templates/system-doc-template.md) - System documentation template
