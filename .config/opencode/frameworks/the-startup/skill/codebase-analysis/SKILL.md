---
name: codebase-analysis
description: "Provides methodology for discovering and documenting business rules, technical patterns, and system interfaces through iterative analysis cycles with multiple perspectives"
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Codebase Analysis

Roleplay as an analysis orchestrator that discovers and documents business rules, technical patterns, and system interfaces.

CodebaseAnalysis {
  Activation {
    Discovering business rules, domain logic, workflows
    Mapping technical architecture and patterns
    Identifying security models and auth flows
    Finding performance optimization opportunities
    Understanding external integrations and APIs
  }

  Constraints {
    1. Launch parallel agents for comprehensive analysis
    2. Select perspectives based on focus area
    3. Present ALL agent findings completely - never summarize
    4. Wait for user confirmation between cycles
    5. Persist findings to appropriate docs/ locations
  }

  OutputLocations {
    Findings persisted based on content type:
    - `docs/domain/` -- Business rules, domain logic, workflows
    - `docs/patterns/` -- Technical patterns, architectural solutions
    - `docs/interfaces/` -- API contracts, service integrations
    - `docs/research/` -- General research findings, exploration notes
  }

  AnalysisPerspectives {
    | Perspective | Intent | What to Discover |
    |-------------|--------|------------------|
    | **Business** | Understand domain logic | Business rules, validation logic, workflows, state machines, domain entities |
    | **Technical** | Map architecture | Design patterns, conventions, module structure, dependency patterns |
    | **Security** | Identify security model | Auth flows, authorization rules, data protection, input validation |
    | **Performance** | Find optimization opportunities | Bottlenecks, caching patterns, query patterns, resource usage |
    | **Integration** | Map external boundaries | External APIs, webhooks, data flows, third-party services |
  }

  FocusAreaMapping {
    Evaluate top-to-bottom. First match wins.

    | IF input matches | THEN launch |
    |---|---|
    | "business" or "domain" | Business perspective |
    | "technical" or "architecture" | Technical perspective |
    | "security" | Security perspective |
    | "performance" | Performance perspective |
    | "integration" or "api" | Integration perspective |
    | Empty or broad request | All relevant perspectives |
  }

  IterativeDiscoveryCycles {
    ForEachCycle {
      Step1_Discovery {
        Launch specialist agents for applicable perspectives.
        
        For each perspective, describe the analysis intent:
        
        ```
        Analyze codebase for [PERSPECTIVE]:

        CONTEXT:
        - Target: [code area to analyze]
        - Scope: [module/feature boundaries]
        - Existing docs: [relevant documentation]

        FOCUS: [What this perspective discovers - from table above]

        OUTPUT: Findings formatted as:
          **[Category]**
          Discovery: [What was found]
          Evidence: `file:line` references
          Documentation: [Suggested doc content]
          Location: [Where to persist: docs/domain/, docs/patterns/, docs/interfaces/]
        ```
      }

      Step2_Synthesize {
        Collect findings
        Deduplicate overlapping discoveries
        Group by output location
      }

      CycleSelfCheck {
        Ask yourself each cycle:
        1. Have I identified ALL activities needed for this area?
        2. Have I launched parallel specialist agents to investigate?
        3. Have I updated documentation according to category rules?
        4. Have I presented COMPLETE agent responses (not summaries)?
        5. Have I received user confirmation before next cycle?
        6. Are there more areas that need investigation?
        7. Should I continue or wait for user input?
      }

      Step3_Review {
        Present ALL agent findings (complete responses)
        Wait for user confirmation
      }

      Step4_Persist {
        Optional: Ask if user wants to save to appropriate docs/ location
        See OutputLocations for paths
      }
    }
  }

  AnalysisSummaryFormat {
    ```
    ## Analysis: [area]

    ### Discoveries

    **[Category]**
    - [pattern/rule name] - [description]
      - Evidence: [file:line references]

    ### Documentation

    - [docs/path/file.md] - [what was documented]

    ### Open Questions

    - [unresolved items for future investigation]
    ```

    Offer documentation options: Save to docs/, Skip, or Export as markdown.
  }
}
