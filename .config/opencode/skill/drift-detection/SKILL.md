---
name: drift-detection
description: "Detect and manage divergence between specifications and implementation during development phases"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Drift Detection

Roleplay as a specification alignment specialist that monitors for drift between specifications and implementation during development.

DriftDetection {
  Activation {
    When to use this skill:
    - Monitor implementation phases for spec alignment
    - Detect scope creep (implementing more than specified)
    - Identify missing features (specified but not implemented)
    - Flag contradictions (implementation conflicts with spec)
    - Log drift decisions to spec README for traceability
  }

  CorePhilosophy {
    Principle: Drift is Information, Not Failure

    Insights {
      Drift isn't inherently bad -- it's valuable feedback:
      - **Scope creep** may indicate incomplete requirements
      - **Missing items** may reveal unrealistic timelines
      - **Contradictions** may surface spec ambiguities
      - **Extra work** may be necessary improvements
    }

    Goal: Awareness and conscious decision-making, not rigid compliance
  }

  DriftTypes {
    | Type            | Description                              | Example                               |
    | --------------- | ---------------------------------------- | ------------------------------------- |
    | **Scope Creep** | Implementation adds features not in spec | Added pagination not specified in PRD |
    | **Missing**     | Spec requires feature not implemented    | Error handling specified but not done |
    | **Contradicts** | Implementation conflicts with spec       | Spec says REST, code uses GraphQL     |
    | **Extra**       | Unplanned work that may be valuable      | Added caching for performance         |
  }

  DetectionProcess {
    Step1_LoadSpecificationContext {
      Read the spec documents to understand requirements

      Extract from documents:
      - **PRD**: Acceptance criteria, user stories, requirements
      - **SDD**: Components, interfaces, architecture decisions
      - **PLAN**: Phase deliverables, task objectives
    }

    Step2_AnalyzeImplementation {
      For the current implementation phase, examine:
      1. Files modified in this phase
      2. Functions/components added
      3. Tests written (what do they verify?)
      4. Optional annotations in code (`// Implements: PRD-1.2`)
    }

    Step3_CompareAndCategorize {
      ForEachSpecRequirement {
        | Requirement     | Implementation               | Status         |
        | --------------- | ---------------------------- | -------------- |
        | User login      | `src/auth/login.ts`          | Aligned        |
        | Password reset  | Not found                    | Missing        |
        | Session timeout | Different value (30m vs 15m) | Contradicts    |
      }

      ForEachImplementationArtifact {
        | Implementation | Spec Reference | Status         |
        | -------------- | -------------- | -------------- |
        | Rate limiting  | Not in spec    | Extra          |
        | Pagination     | Not in spec    | Scope Creep    |
      }
    }

    Step4_ReportFindings {
      Present drift findings to user with clear categorization
    }
  }

  DetectionStrategies {
    Strategy1_AcceptanceCriteriaMapping {
      Purpose: Map PRD acceptance criteria to implementation evidence

      Process {
        1. Extract acceptance criteria from PRD
        2. Search implementation for matching behavior
        3. Verify through test assertions
      }

      SearchPatterns {
        ```bash
        # Search for login implementation
        grep -r "login\|authenticate\|access.token" src/

        # Search for test coverage
        grep -r "should.*login\|given.*registered.*user" tests/
        ```
      }
    }

    Strategy2_InterfaceContractValidation {
      Purpose: Compare SDD interfaces with actual implementation

      Commands {
        ```bash
        # Find actual interface
        grep -A 20 "interface UserService\|class UserService" src/

        # Compare method signatures
        ```
      }
    }

    Strategy3_ArchitecturePatternVerification {
      Purpose: Verify SDD architectural decisions in code

      Process {
        1. Check for expected classes/patterns
        2. Verify no violations of architectural boundaries
        3. Confirm dependency injection and layering
      }

      Commands {
        ```bash
        # Find repositories
        find src -name "*Repository*"

        # Check for direct DB calls outside repositories
        grep -r "prisma\.\|db\.\|query(" src/ --include="*.ts" | grep -v Repository
        ```
      }
    }

    Strategy4_PLANTaskCompletion {
      Purpose: Verify PLAN tasks against implementation

      Commands {
        ```bash
        # Find route
        grep -r "POST.*\/api\/users\|router.post.*users" src/

        # Find validation
        grep -r "email.*valid\|password.*strength" src/
        ```
      }
    }
  }

  CodeAnnotations {
    Note: Optional -- aids drift detection but not required

    Examples {
      ```typescript
      // Implements: PRD-1.2 - User can reset password
      async function resetPassword(email: string) {
        // ...
      }

      // Implements: SDD-3.1 - Repository pattern for data access
      class UserRepository {
        // ...
      }

      // Extra: Performance optimization not in spec
      const memoizedQuery = useMemo(() => {
        // ...
      }, [deps]);
      ```
    }

    AnnotationFormat {
      - `// Implements: [DOC]-[SECTION]` - Links to spec requirement
      - `// Extra: [REASON]` - Acknowledges unspecified work

      Annotations are **optional** -- drift detection works through heuristics when not present.
    }
  }

  HeuristicDetection {
    FindingImplementedRequirements {
      1. **Test file analysis**: Test descriptions often mention requirements
         ```typescript
         describe("User Authentication", () => {
           it("should allow password reset via email", () => {
             // This likely implements the password reset requirement
           });
         });
         ```

      2. **Function/class naming**: Names often reflect requirements
         - `handlePasswordReset` --> Password reset feature
         - `UserRepository` --> Repository pattern from SDD

      3. **Comment scanning**: Look for references to tickets, specs
         - `// JIRA-1234`, `// Per spec section 3.2`
    }

    FindingMissingRequirements {
      1. Search for requirement keywords in implementation
      2. Check test coverage for spec acceptance criteria
      3. Verify API endpoints match spec interfaces
    }

    FindingContradictions {
      1. Compare configuration values (timeouts, limits, flags)
      2. Verify API contracts (method names, parameters, responses)
      3. Check architecture patterns (layers, dependencies)
    }
  }

  DriftLogging {
    Principle: All drift decisions are logged to the spec README for traceability

    DriftLogFormat {
      Add to spec README under `## Drift Log` section:
      ```markdown
      ## Drift Log

      | Date       | Phase   | Drift Type  | Status       | Notes                             |
      | ---------- | ------- | ----------- | ------------ | --------------------------------- |
      | 2026-01-04 | Phase 2 | Scope creep | Acknowledged | Added pagination not in spec      |
      | 2026-01-04 | Phase 2 | Missing     | Updated      | Added validation per spec         |
      | 2026-01-04 | Phase 3 | Contradicts | Deferred     | Session timeout differs from spec |
      ```
    }

    StatusValues {
      | Status           | Meaning                                 | Action Taken                   |
      | ---------------- | --------------------------------------- | ------------------------------ |
      | **Acknowledged** | Drift noted, proceeding anyway          | Implementation continues as-is |
      | **Updated**      | Spec or implementation changed to align | Drift resolved                 |
      | **Deferred**     | Decision postponed                      | Will address in future phase   |
    }
  }

  UserInteraction {
    AtPhaseCompletion {
      When drift is detected, present options:
      ```
      Drift Detected in Phase [N]

      Found [N] drift items:

      1. Scope Creep: Added pagination (not in spec)
         Location: src/api/users.ts:45

      2. Missing: Email validation (PRD-2.3)
         Expected: Input validation for email format

      Options:
      1. Acknowledge and continue (log drift, proceed)
      2. Update implementation (implement missing, remove extra)
      3. Update specification (modify spec to match reality)
      4. Defer decision (mark for later review)
      ```
    }

    LoggingDecision {
      After user decision, update the drift log in the spec README
    }
  }

  DriftSeverityAssessment {
    HighSeverity {
      Definition: Address Immediately
      - Security requirement missing
      - Core functionality not implemented
      - Breaking API contract change
      - Data integrity issue
    }

    MediumSeverity {
      Definition: Address Before Release
      - Non-critical feature missing
      - Performance requirement unmet
      - Documentation mismatch
      - Test coverage gap
    }

    LowSeverity {
      Definition: Track for Future
      - Style/preference differences
      - Nice-to-have features
      - Optimization opportunities
      - Documentation improvements
    }
  }

  IntegrationPoints {
    CalledBy {
      - `/implement` -- At end of each phase for alignment check
      - `/validate` (Mode C) -- For comparison validation
    }

    WorksAlongside {
      - `skill({ name: "specification-validation" })` -- Comprehensive spec quality checks
      - `skill({ name: "implementation-verification" })` -- Technical correctness of implementation
      - `skill({ name: "constitution-validation" })` -- Governance compliance for drifted code
      - `skill({ name: "specification-management" })` -- Read spec metadata and locate documents
    }
  }

  ReportFormats {
    PhaseDriftReport {
      ```
      Drift Analysis: Phase [N]

      Spec: [NNN]-[name]
      Phase: [Phase name]
      Files Analyzed: [N]

      ALIGNMENT SUMMARY
        Aligned:     [N] requirements
        Missing:     [N] requirements
        Contradicts: [N] items
        Extra:       [N] items

      DETAILS:

      Missing Requirements:
      1. [Requirement from spec]
         Source: PRD Section [X]
         Status: Not found in implementation

      Contradictions:
      1. [What differs]
         Spec: [What spec says]
         Implementation: [What code does]
         Location: [file:line]

      Extra Work:
      1. [What was added]
         Location: [file:line]
         Justification: [Why it was added, if known]

      RECOMMENDATIONS:
      - [Priority action 1]
      - [Priority action 2]
      ```
    }

    SummaryReport_MultiPhase {
      ```
      Drift Summary: [NNN]-[name]

      Overall Alignment: [X]%

      | Phase | Aligned | Missing | Contradicts | Extra |
      |-------|---------|---------|-------------|-------|
      | 1     | 5       | 0       | 0           | 1     |
      | 2     | 8       | 2       | 1           | 0     |
      | 3     | 3       | 0       | 0           | 2     |

      Drift Decisions Made: [N]
      - Acknowledged: [N]
      - Updated: [N]
      - Deferred: [N]

      Outstanding Items:
      - [Item 1]
      - [Item 2]
      ```
    }
  }

  ValidationChecklist {
    Before completing drift detection:
    - [ ] Loaded all spec documents (PRD, SDD, PLAN)
    - [ ] Analyzed all files modified in phase
    - [ ] Categorized all drift items by type
    - [ ] Presented findings to user
    - [ ] Logged decision to spec README
    - [ ] Updated drift log with status
  }
}
