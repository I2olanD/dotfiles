---
name: specify-meta
description: "Scaffold, status-check, and manage specification directories. Handles auto-incrementing IDs, README tracking, phase transitions, and decision logging in .start/specs/. Used by both specify and implement workflows."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Specify Meta

Roleplay as a specification workflow orchestrator that manages specification directories and tracks user decisions throughout the PRD → SDD → PLAN workflow.

SpecifyMeta {
  Activation {
    Scaffolding new specification directories
    Checking status of existing specifications
    Managing phase transitions in specification workflow
    Logging decisions during specification process
  }

  SpecPhases {
    Initialization => PRD => SDD => PLAN => Ready
  }

  Workflow {
    1_Scaffold {
      Create a new spec with an auto-incrementing ID
      1. Run spec.py "$featureName"
      2. Create README.md from template.md
      3. Report the created spec status
    }

    2_ReadStatus {
      Read existing spec metadata
      1. Run spec.py "$specId" --read
      2. Parse TOML output into SpecStatus

      match (documents) {
        plan exists           => "PLAN found. Proceed to implementation?"
        sdd exists, no plan   => "SDD found. Continue to PLAN?"
        prd exists, no sdd    => "PRD found. Continue to SDD?"
        no documents          => "Start from PRD?"
      }
    }

    3_TransitionPhase {
      Update the spec directory to reflect the new phase
      1. Update README.md document status and current phase
      2. Log the phase transition in the decisions table

      match (phase) {
        PRD  => specify-requirements skill
        SDD  => specify-solution skill
        PLAN => specify-plan skill
      }

      On completion, return here for the next phase transition
    }

    4_LogDecision {
      Append a row to the README.md Decisions Log table
      Update the Last Updated field
    }

    EntryPoint {
      match ($ARGUMENTS) {
        featureName (new)   => execute step 1 (Scaffold)
        specId (existing)   => execute steps 2, 3, and 4 in order
      }
    }
  }

  Constraints {
    Use spec.py for all directory operations
    Create README.md from template.md when scaffolding new specs
    Log all significant decisions with date, decision, and rationale
    Confirm next steps with user before phase transitions
    Never create spec directories manually -- always use spec.py
    Never transition phases without updating README.md
    Never skip decision logging when user makes workflow choices
  }
}

## References

- [spec-management.md](reference/spec-management.md) - Spec ID format, directory structure, script commands, phase workflow
- [template.md](template.md) - Template for spec README.md files
