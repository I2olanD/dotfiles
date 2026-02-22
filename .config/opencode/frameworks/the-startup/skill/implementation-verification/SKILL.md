---
name: implementation-verification
description: "Verify that implementation matches specifications exactly, checking interface contracts, architecture decisions, data models, and business logic compliance"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Implementation Verification

Roleplay as a specification compliance validator that ensures implementations match documented requirements exactly.

ImplementationVerification {
  Activation {
    When to use this skill:
    - Verify SDD compliance during implementation
    - Check interface contracts match specifications
    - Validate architecture decisions are followed
    - Detect deviations from documented requirements
    - Report compliance status at checkpoints
  }

  CorePrinciple {
    Constraints {
      1. Every implementation must match the specification exactly
      2. Deviations require explicit acknowledgment before proceeding
      3. Include file:line for every finding -- no generic observations
    }
  }

  SpecificationDocumentHierarchy {
    ```
    docs/specs/[NNN]-[name]/
      product-requirements.md   # WHAT and WHY (business requirements)
      solution-design.md        # HOW (technical design, interfaces, patterns)
      implementation-plan.md    # WHEN (execution sequence, phases)
    ```
  }

  ComplianceVerificationProcess {
    PreImplementationCheck {
      Before implementing any task:
      1. Extract SDD references from PLAN.md task: `[ref: SDD/Section X.Y]`
      2. Read referenced sections from solution-design.md
      3. Identify requirements:
         - Interface contracts
         - Data structures
         - Business logic flows
         - Architecture decisions
         - Quality requirements
    }

    DuringImplementation {
      For each task, verify:
      - [ ] Interface contracts match -- Function signatures, parameters, return types
      - [ ] Data structures align -- Schema, types, relationships as specified
      - [ ] Business logic follows -- Defined flows and rules from SDD
      - [ ] Architecture respected -- Patterns, layers, dependencies as designed
      - [ ] Quality met -- Performance, security requirements from SDD
    }

    PostImplementationValidation {
      After task completion:
      1. Compare implementation to specification
      2. Document any deviations found
      3. Classify deviations by severity
      4. Report compliance status
    }
  }

  DeviationClassification {
    CriticalDeviations {
      Definition: Must fix before proceeding
      - Interface contract violations
      - Missing required functionality
      - Security requirement breaches
      - Breaking architectural constraints
    }

    NotableDeviations {
      Definition: Require acknowledgment
      - Implementation differs but functionally equivalent
      - Enhancement beyond specification
      - Simplified approach with same outcome
    }

    AcceptableVariations {
      Definition: Can proceed
      - Internal implementation details differ
      - Optimizations within spec boundaries
      - Naming/style variations
    }
  }

  InterfaceVerification {
    APIEndpoints {
      ```
      Verifying: POST /api/users
      SDD Spec: Section 4.2.1

      Request Schema:
        PASS body.email: string (required)
        PASS body.password: string (min 8 chars)
        FAIL body.role: missing (spec requires optional role param)

      Response Schema:
        PASS 201: { id, email, createdAt }
        PASS 400: { error: string }
        NOTE 409: Added conflict handling (not in spec, beneficial)
      ```
    }

    DataModels {
      ```
      Verifying: User Model
      SDD Spec: Section 3.1.2

      Fields:
        PASS id: UUID (primary key)
        PASS email: string (unique)
        PASS passwordHash: string
        NOTE lastLoginAt: timestamp (added, not in spec)
        FAIL role: enum (missing from implementation)

      Relationships:
        PASS hasMany: sessions
        PASS belongsTo: organization
      ```
    }
  }

  ArchitectureDecisionVerification {
    Format {
      For each ADR in SDD:
      ```
      ADR-1: [Decision Title]
      Implementation Status:

      Decision: [What was decided]
      Evidence: [Where implemented]
      Compliance: [Matched / Deviated]

      If deviated:
        Deviation: [What differs]
        Impact: [Consequences]
        Action: [Fix / Accept with rationale]
      ```
    }
  }

  TraceabilityMatrix {
    Build a requirements-to-implementation map:
    ```
    +-------------------+-----------------------+--------+
    | Requirement       | Implementation        | Status |
    +-------------------+-----------------------+--------+
    | PRD-1: User auth  | src/auth/login.ts     | PASS   |
    | PRD-2: Validation | src/validators/*.ts   | PASS   |
    | SDD-3: Repo layer | src/repositories/*.ts | PASS   |
    | SDD-4: Rate limit | NOT FOUND             | FAIL   |
    +-------------------+-----------------------+--------+
    ```
  }

  ValidationCommands {
    Run these at checkpoints:
    ```bash
    # Type checking (if TypeScript)
    npm run typecheck

    # Linting
    npm run lint

    # Test suite
    npm test

    # Build verification
    npm run build
    ```
  }

  ComplianceGates {
    BeforeProceedingToNextPhase {
      All must be true:
      - [ ] All critical deviations resolved
      - [ ] Notable deviations acknowledged by user
      - [ ] Validation commands pass
      - [ ] SDD coverage for phase is complete
    }

    BeforeFinalCompletion {
      - [ ] All phases compliant
      - [ ] All interfaces verified
      - [ ] All architecture decisions respected
      - [ ] Quality requirements met
      - [ ] User confirmed any variations
    }
  }

  ReportFormats {
    PerTaskReport {
      ```
      Specification Compliance: [Task Name]

      SDD Reference: Section [X.Y]

      Requirements Checked:
      PASS Interface: [function/endpoint] matches signature
      PASS Data: [model/schema] matches structure
      PASS Logic: [flow/rule] implemented correctly
      NOTE Enhancement: [description] - beyond spec but compatible
      FAIL Deviation: [description] - requires fix

      Status: [COMPLIANT / DEVIATION FOUND / NEEDS REVIEW]
      ```
    }

    PhaseCompletionReport {
      ```
      Phase [X] Specification Compliance Summary

      Tasks Validated: [N]
      - Fully Compliant: [X]
      - With Acceptable Variations: [Y]
      - With Notable Deviations: [Z]
      - Critical Issues: [W]

      SDD Sections Covered:
      - Section 2.1: Compliant
      - Section 2.2: Compliant
      - Section 3.1: Variation documented

      Critical Issues (if any):
      1. [Description and required fix]

      Recommendation: [PROCEED / FIX REQUIRED / USER REVIEW]
      ```
    }
  }

  IntegrationWithOtherSkills {
    Works alongside:
    - `skill({ name: "specification-validation" })` -- Comprehensive spec quality checks
    - `skill({ name: "drift-detection" })` -- Spec-implementation alignment monitoring
    - `skill({ name: "constitution-validation" })` -- Governance compliance
    - `skill({ name: "specification-management" })` -- Read spec metadata and locate documents
  }

  QuickReference {
    AlwaysCheck {
      - Interface signatures match exactly
      - Required fields are present
      - Business logic follows specified flows
      - Architecture patterns are respected
    }

    DocumentDeviations {
      - What differs from spec
      - Why it differs (if known)
      - Impact assessment
      - Recommended action
    }

    GateCompliance {
      - Critical = must fix
      - Notable = must acknowledge
      - Acceptable = can proceed
    }
  }
}
