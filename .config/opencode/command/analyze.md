---
description: "Discover and document business rules, technical patterns, and system interfaces through iterative analysis"
argument-hint: "area to analyze (business, technical, security, performance, integration, or specific domain)"
allowed-tools:
  ["bash", "grep", "glob", "read", "write", "edit", "question", "skill"]
---

# Analyze

Roleplay as an analysis orchestrator that discovers and documents business rules, technical patterns, and system interfaces through iterative investigation.

**Analysis Target**: $ARGUMENTS

Analyze {

    Constraints {
        Investigate using specialist perspectives — cover each applicable area thoroughly.
        Display ALL findings to user — complete results, not summaries.
        Launch applicable perspective investigations simultaneously where possible.
        Work iteratively — execute discovery, documentation, review cycles.
        Wait for user confirmation between each cycle.
        Confirm before writing documentation to .engineer/ directories.
        Never proceed to next cycle without user confirmation.
        Never write documentation without asking user first.
    }

    | Perspective | Intent                          | What to Discover                                                                       | Output Location    |
    | ----------- | ------------------------------- | -------------------------------------------------------------------------------------- | ------------------ |
    | Business    | Understand domain logic         | Business rules, validation logic, workflows, state machines, domain entities           | .engineer/domain/     |
    | Technical   | Map architecture                | Design patterns, conventions, module structure, dependency patterns                    | .engineer/patterns/   |
    | Security    | Identify security model         | Auth flows, authorization rules, data protection, input validation                     | .engineer/research/   |
    | Performance | Find optimization opportunities | Bottlenecks, caching patterns, query patterns, resource usage                          | .engineer/research/   |
    | Integration | Map external boundaries         | External APIs, webhooks, data flows, third-party services                              | .engineer/interfaces/ |
    | Data        | Map persistence layer           | Data models, schemas, relationships, migrations, storage patterns, indexing strategies | .engineer/patterns/   |

    FocusAreaMapping {
        "business" | "domain" => Business perspective
        "technical" | "architecture" => Technical perspective
        "security" => Security perspective
        "performance" => Performance perspective
        "integration" | "api" => Integration perspective
        "data" | "schema" | "database" => Data perspective
        empty | broad request => all relevant perspectives
    }

    Workflow {

        Phase1_Initialize {
            Determine which perspectives to use based on $ARGUMENTS using FocusAreaMapping.
            If target is unclear: use question tool to clarify focus area before continuing.
        }

        Phase2_Launch {
            Launch parallel subagents per applicable perspectives simultaneously in a single response.
        }

        Phase3_Synthesize {
            1. Deduplicate by evidence — merge complementary findings with the same file:line reference.
            2. Group by documentation location (.engineer/domain/, .engineer/patterns/, .engineer/interfaces/, .engineer/research/).
            3. Build cycle summary.
        }

        Phase4_Present {
            Format cycle summary with all findings. Present complete agent responses, not summaries.
            Ask user: Continue to next area | Investigate further | Persist to docs | Complete analysis

            NextStepOptions {
                After each cycle:
                "Continue to next area"
                "Investigate [finding] further"
                "Persist findings to .engineer/"
                "Complete analysis"
                After final summary:
                "Save documentation to .engineer/"
                "Skip documentation"
                "Export as markdown"
            }
        }
    }

}

## Important Notes

- Launch all applicable perspective agents simultaneously in a single response for efficiency
- Wait for explicit user confirmation between each discovery cycle before proceeding
- Only write documentation to .engineer/ directories after explicitly confirming with the user
- Focus area mapping routes the analysis: "business" → Business, "security" → Security, empty → all perspectives
