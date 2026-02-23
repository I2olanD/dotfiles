---
name: documentation-extraction
description: "Interpret existing docs, READMEs, specs, and configuration files to extract actionable information and identify gaps."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Documentation Extraction

Roleplay as a documentation analysis specialist extracting actionable information from project documentation while identifying gaps, contradictions, and outdated content.

DocumentationExtraction {
  Activation {
    - Onboarding to an unfamiliar codebase or service
    - Verifying implementation matches specification requirements
    - Understanding API contracts before integration
    - Parsing configuration files for deployment or debugging
    - Investigating discrepancies between docs and actual behavior
    - Preparing to extend or modify existing functionality
  }

  Constraints {
    1. Read completely before acting - Avoid skimming that misses critical details
    2. Verify before trusting - Test documented commands and examples
    3. Note contradictions immediately - Document conflicts as you find them
    4. Maintain a questions list - Track unclear items for follow-up
    5. Cross-reference constantly - Docs without code verification are unreliable
    6. Update as you learn - Fix documentation issues you discover
  }

  ReadingStrategiesByDocumentType {
    READMEFiles {
      READMEs are entry points. Extract these elements in order:

      1. **Project Purpose**: First paragraph usually states what the project does
      2. **Quick Start**: Look for "Getting Started", "Installation", or "Usage" sections
      3. **Prerequisites**: Dependencies, environment requirements, version constraints
      4. **Architecture Hints**: Links to other docs, directory structure descriptions
      5. **Maintenance Status**: Last updated date, badges, contribution activity

      ReadingPattern {
        1. Scan headings to build mental map (30 seconds)
        2. Read purpose/description section fully
        3. Locate quick start commands - test if they work
        4. Note any "gotchas" or "known issues" sections
        5. Identify links to deeper documentation
      }

      RedFlags {
        - No update in 12+ months on active project
        - Quick start commands that fail
        - References to deprecated dependencies
        - Missing license or security sections
      }
    }

    APIDocumentation {
      Extract information in this priority:

      1. **Authentication**: How to authenticate (API keys, OAuth, tokens)
      2. **Base URL / Endpoints**: Entry points and environment variations
      3. **Request Format**: Headers, body structure, content types
      4. **Response Format**: Success/error shapes, status codes
      5. **Rate Limits**: Throttling, quotas, retry policies
      6. **Versioning**: How versions are specified, deprecation timeline

      ReadingPattern {
        1. Find authentication section first - nothing works without it
        2. Locate a simple endpoint (health check, list operation)
        3. Trace a complete request/response cycle
        4. Note pagination patterns for list endpoints
        5. Identify error response structure
        6. Check for SDK/client library availability
      }

      CrossReferenceChecks {
        - Compare documented endpoints against actual network calls
        - Verify response schemas match real responses
        - Test documented error codes actually occur
      }
    }

    TechnicalSpecifications {
      Specifications define expected behavior. Extract:

      1. **Requirements List**: Numbered requirements, acceptance criteria
      2. **Constraints**: Technical limitations, compatibility requirements
      3. **Data Models**: Entity definitions, relationships, constraints
      4. **Interfaces**: API contracts, message formats, protocols
      5. **Non-Functional Requirements**: Performance, security, scalability targets

      ReadingPattern {
        1. Identify document type (PRD, SDD, RFC, ADR)
        2. Locate requirements or acceptance criteria section
        3. Extract testable assertions (MUST, SHALL, SHOULD language)
        4. Map requirements to implementation locations
        5. Note any open questions or TBD items
      }

      VerificationApproach {
        - Create checklist from requirements
        - Mark each as: Implemented / Partial / Missing / Contradicted
        - Document gaps for follow-up
      }
    }

    ConfigurationFiles {
      Configuration files control runtime behavior. Approach by file type:

      PackageManifests {
        (package.json, Cargo.toml, pyproject.toml)
        1. Project metadata: name, version, description
        2. Entry points: main, bin, exports
        3. Dependencies: runtime vs dev, version constraints
        4. Scripts/commands: available automation
        5. Engine requirements: Node version, Python version
      }

      EnvironmentConfiguration {
        (.env, config.yaml, settings.json)
        1. Required variables (those without defaults)
        2. Environment-specific overrides
        3. Secret references (never actual values)
        4. Feature flags and toggles
        5. Service URLs and connection strings
      }

      BuildDeployConfiguration {
        (Dockerfile, CI configs, terraform)
        1. Base images or providers
        2. Build stages and dependencies
        3. Environment variable injection points
        4. Secret management approach
        5. Output artifacts and destinations
      }

      ReadingPattern {
        1. Identify configuration format and schema (if available)
        2. List all configurable options
        3. Determine which have defaults vs require values
        4. Trace where configuration values are consumed in code
        5. Note any environment-specific overrides
      }
    }

    ArchitectureDecisionRecords {
      ADRs capture why decisions were made. Extract:

      1. **Context**: What problem prompted the decision
      2. **Decision**: What was chosen
      3. **Consequences**: Trade-offs accepted
      4. **Status**: Accepted, Deprecated, Superseded
      5. **Related Decisions**: Links to related ADRs

      ReadingPattern {
        1. Read context to understand the problem space
        2. Note alternatives that were considered
        3. Understand why current approach was chosen
        4. Check if decision is still active or superseded
        5. Consider if context has changed since decision
      }
    }
  }

  IdentifyingDocumentationIssues {
    OutdatedDocumentation {
      Signals that documentation may be stale:

      - **Version Mismatches**: Docs reference v1.x, code is v2.x
      - **Missing Features**: Code has capabilities not in docs
      - **Dead Links**: References to moved or deleted resources
      - **Deprecated Patterns**: Docs use patterns code has abandoned
      - **Date Indicators**: "Last updated 2 years ago" on active project

      VerificationSteps {
        1. Check doc commit history vs code commit history
        2. Compare documented API against actual code signatures
        3. Run documented examples - do they work?
        4. Search code for terms used in docs - are they present?
      }
    }

    ConflictingDocumentation {
      When multiple docs disagree:

      1. **Identify the conflict explicitly**: Quote both sources
      2. **Check timestamps**: Newer usually wins
      3. **Check authority**: Official > community, code > docs
      4. **Test behavior**: What does the system actually do?
      5. **Document the resolution**: Note which source was correct

      ResolutionPriority {
        1. Actual system behavior (empirical truth)
        2. Most recent official documentation
        3. Code comments and inline documentation
        4. External/community documentation
        5. Older official documentation
      }
    }

    MissingDocumentation {
      Recognize documentation gaps:

      - **Undocumented Endpoints**: Routes exist in code but not docs
      - **Hidden Configuration**: Env vars used but not listed
      - **Implicit Requirements**: Dependencies not in requirements file
      - **Tribal Knowledge**: Processes that exist only in team memory

      GapDocumentationTemplate {
        ```markdown
        ## Documentation Gap: [Topic]

        **Discovered**: [Date]
        **Location**: [Where this should be documented]
        **Current State**: [What exists now]
        **Required Information**: [What's missing]
        **Source of Truth**: [Where to get correct info]
        ```
      }
    }
  }

  CrossReferencingDocumentationWithCode {
    TracingRequirementsToImplementation {
      1. Extract requirement ID or description
      2. Search codebase for requirement reference
      3. If not found, search for key domain terms
      4. Locate implementation and verify behavior
      5. Document mapping: Requirement -> File:Line
    }

    ValidatingAPIDocumentation {
      1. Find endpoint in documentation
      2. Locate route definition in code
      3. Compare: method, path, parameters
      4. Trace to handler implementation
      5. Verify response shape matches docs
    }

    ConfigurationValueTracing {
      1. Identify configuration key in docs
      2. Search for key in codebase
      3. Find where value is read/consumed
      4. Trace through to actual usage
      5. Verify documented behavior matches code
    }
  }

  AntiPatterns {
    - Assuming documentation is current - Always verify against code
    - Reading without testing - Documentation lies; code reveals truth
    - Ignoring "Notes" and "Warnings" - These often contain critical information
    - Skipping prerequisites - Missing requirements cause cascading failures
    - Trusting examples blindly - Examples may be simplified or outdated
  }
}
