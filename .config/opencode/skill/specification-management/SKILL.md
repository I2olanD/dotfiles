---
name: specification-management
description: "Provides methodology for scaffolding, status-checking, and managing specification directories including auto-incrementing IDs, README tracking, phase transitions, and decision logging"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Specification Management

Roleplay as a specification workflow orchestrator that manages specification directories and tracks user decisions throughout the PRD to SDD to PLAN workflow.

SpecificationManagement {
  Activation {
    When to use this skill:
    - Create a new specification directory with auto-incrementing ID
    - Check specification status (what documents exist)
    - Track user decisions (e.g., "PRD skipped because requirements in JIRA")
    - Manage phase transitions (PRD to SDD to PLAN)
    - Initialize or update README.md in spec directories
    - Read existing spec metadata via spec.py
  }

  SupportingFiles {
    - [readme-template.md](readme-template.md) -- README template for spec directories
    - [reference.md](reference.md) -- Extended specification metadata protocols
    - [spec.py](spec.py) -- Script for directory creation and metadata reading
  }

  DirectoryManagement {
    Constraints {
      1. Use `spec.py` to create and read specification directories
      2. The `spec.py` script is located in this skill's directory (alongside this SKILL.md file)
      3. Resolve `spec.py` from this skill's directory; the full path depends on your framework installation location
    }

    Commands {
      ```bash
      # Create new spec (auto-incrementing ID)
      spec.py "feature-name"

      # Read existing spec metadata (TOML output)
      spec.py 004 --read

      # Add template to existing spec
      spec.py 004 --add product-requirements
      ```
    }

    TOMLOutputFormat {
      ```toml
      id = "004"
      name = "feature-name"
      dir = "docs/specs/004-feature-name"

      [spec]
      prd = "docs/specs/004-feature-name/product-requirements.md"
      sdd = "docs/specs/004-feature-name/solution-design.md"

      files = [
        "product-requirements.md",
        "solution-design.md"
      ]
      ```
    }
  }

  ReadmeManagement {
    Constraints {
      1. Every spec directory should have a `README.md` tracking decisions and progress
      2. Create README.md when a new spec is created using the [readme-template.md](readme-template.md) template
    }

    UpdateTriggers {
      Update README.md when:
      - Phase transitions occur (start, complete, skip)
      - User makes workflow decisions
      - Context needs to be recorded
    }
  }

  PhaseTransitions {
    Workflow {
      1. Check existing state -- Use `spec.py [ID] --read`
      2. Suggest continuation point based on existing documents (evaluate top-to-bottom, first match wins)
      3. Record decisions in README.md
      4. Update phase status as work progresses
    }

    ContinuationTable {
      | IF state is | THEN suggest |
      |---|---|
      | `plan` exists | "PLAN found. Proceed to implementation?" |
      | `sdd` exists but no `plan` | "SDD found. Continue to PLAN?" |
      | `prd` exists but no `sdd` | "PRD found. Continue to SDD?" |
      | No documents exist | "Start from PRD?" |
    }
  }

  DecisionTracking {
    Constraints {
      1. Log all significant decisions in README.md
    }

    Format {
      ```markdown
      ## Decisions Log

      | Date | Decision | Rationale |
      |------|----------|-----------|
      | 2025-12-10 | PRD skipped | Requirements documented in JIRA-1234 |
      | 2025-12-10 | Start with SDD | Technical spike already completed |
      ```
    }
  }

  WorkflowIntegration {
    RelatedSkills {
      - `requirements-analysis` skill -- PRD creation and validation
      - `architecture-design` skill -- SDD creation and validation
      - `implementation-planning` skill -- PLAN creation and validation
    }

    HandoffPattern {
      1. Specification-management creates directory and README
      2. User confirms phase to start
      3. Context shifts to document-specific work
      4. Document skill activates for detailed guidance
      5. On completion, context returns here for phase transition
    }
  }

  ValidationChecklist {
    Before completing any operation:
    - [ ] spec.py command executed successfully
    - [ ] README.md exists and is up-to-date
    - [ ] Current phase is correctly recorded
    - [ ] All decisions have been logged
    - [ ] User has confirmed next steps
  }
}
