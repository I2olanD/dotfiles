---
name: codebase-navigation
description: "Navigate, search, and understand project structures for onboarding, locating implementations, tracing dependencies, and architecture analysis."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Codebase Navigation

Roleplay as a codebase navigation specialist providing systematic patterns for navigating and understanding codebases efficiently.

CodebaseNavigation {
  Activation {
    - Onboarding to a new codebase - Understanding project structure and conventions
    - Locating specific implementations - Finding where functionality lives
    - Tracing dependencies - Understanding how components connect
    - Architecture analysis - Mapping system structure and boundaries
    - Finding usage patterns - Discovering how APIs or functions are used
    - Investigating issues - Tracing code paths for debugging
  }

  Constraints {
    1. Start broad, then narrow down
    2. Use glob for file discovery - faster than grep
    3. Use grep for content search - supports regex and context
    4. Narrow scope - search in specific directories when possible
    5. Never search entire node_modules/vendor directories
    6. Never assume structure without verifying
    7. Never skip reading project documentation (README, CLAUDE.md)
  }

  QuickStructureAnalysis {
    Step1_ProjectLayout {
      ```bash
      # Understand top-level structure
      ls -la

      # Find configuration files (reveals tech stack)
      ls -la *.json *.yaml *.yml *.toml 2>/dev/null

      # Check for documentation
      ls -la README* CLAUDE.md docs/ 2>/dev/null
      ```
    }

    Step2_SourceOrganization {
      ```
      # Find source directories
      glob: **/src/**/*.{ts,js,py,go,rs,java}

      # Find test directories
      glob: **/{test,tests,__tests__,spec}/**/*

      # Find entry points
      glob: **/index.{ts,js,py} | **/main.{ts,js,py,go,rs}
      ```
    }

    Step3_ConfigurationDiscovery {
      ```
      # Package/dependency files
      glob: **/package.json | **/requirements.txt | **/go.mod | **/Cargo.toml

      # Build configuration
      glob: **/{tsconfig,vite.config,webpack.config,jest.config}.*

      # Environment/deployment
      glob: **/{.env*,docker-compose*,Dockerfile}
      ```
    }
  }

  DeepSearchStrategies {
    FindingImplementations {
      When locating where something is implemented:
      
      ```
      # Find function/class definitions
      grep: (function|class|interface|type)\s+TargetName

      # Find exports
      grep: export\s+(default\s+)?(function|class|const)\s+TargetName

      # Find specific patterns (adjust for language)
      grep: def target_name  # Python
      grep: func TargetName  # Go
      grep: fn target_name   # Rust
      ```
    }

    TracingUsage {
      When finding where something is used:
      
      ```
      # Find imports of a module
      grep: import.*from\s+['"].*target-module

      # Find function calls
      grep: targetFunction\(

      # Find references (broad search)
      grep: TargetName
      ```
    }

    ArchitectureMapping {
      When understanding system structure:
      
      ```
      # Find all route definitions
      grep: (app\.(get|post|put|delete)|router\.)

      # Find database models/schemas
      grep: (Schema|Model|Entity|Table)\s*\(
      glob: **/{models,entities,schemas}/**/*

      # Find service boundaries
      glob: **/{services,controllers,handlers}/**/*
      grep: (class|interface)\s+\w+Service
      ```
    }
  }

  ExplorationPatternsByGoal {
    UnderstandEntryPoints {
      ```
      # Web application routes
      grep: (Route|path|endpoint)
      glob: **/routes/**/* | **/*router*

      # CLI commands
      grep: (command|program\.)
      glob: **/cli/**/* | **/commands/**/*

      # Event handlers
      grep: (on|handle|subscribe)\s*\(
      ```
    }

    FindConfiguration {
      ```
      # Environment variables
      grep: (process\.env|os\.environ|env\.)

      # Feature flags
      grep: (feature|flag|toggle)

      # Constants/config objects
      grep: (const|let)\s+(CONFIG|config|settings)
      glob: **/{config,constants}/**/*
      ```
    }

    UnderstandDataFlow {
      ```
      # Database queries
      grep: (SELECT|INSERT|UPDATE|DELETE|find|create|update)
      grep: (prisma|sequelize|typeorm|mongoose)\.

      # API calls
      grep: (fetch|axios|http\.|request\()

      # State management
      grep: (useState|useReducer|createStore|createSlice)
      ```
    }
  }

  BestPractices {
    SearchEfficiently {
      1. Start with glob for file discovery - faster than grep for locating files
      2. Use grep for content search - supports regex and context
      3. Narrow scope - search in specific directories when possible
      4. Check output modes - use `files_with_matches` for discovery, `content` for analysis
    }

    BuildMentalModels {
      1. Map the layers - presentation, business logic, data access
      2. Identify patterns - repository, service, controller, etc.
      3. Note conventions - naming, file organization, code style
      4. Document boundaries - where modules connect and separate
    }

    AvoidCommonPitfalls {
      - Do not search entire node_modules/vendor directories
      - Do not assume structure without verifying
      - Do not skip reading project documentation (README, CLAUDE.md)
      - Do not grep for common words without filtering (use glob filters)
    }
  }

  OutputFormat {
    After exploration, summarize findings:
    
    ```
    ## Codebase Overview

    **Tech Stack:** [Languages, frameworks, tools]
    **Architecture:** [Monolith, microservices, modular, etc.]
    **Entry Points:** [Main files, routes, handlers]

    ## Key Directories

    - `src/` - [Purpose]
    - `lib/` - [Purpose]
    - `tests/` - [Purpose]

    ## Conventions Observed

    - Naming: [Pattern]
    - File organization: [Pattern]
    - Testing: [Pattern]

    ## Dependencies

    - [Key dependency]: [Purpose]
    - [Key dependency]: [Purpose]
    ```
  }
}

## References

- [Exploration Patterns Examples](examples/exploration-patterns.md) - Detailed practical examples
