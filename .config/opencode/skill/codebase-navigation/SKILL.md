---
name: codebase-navigation
description: Navigate, search, and understand project structures. Use when onboarding to a codebase, locating implementations, tracing dependencies, or understanding architecture. Provides patterns for file searching with Glob, code searching with Grep, and systematic architecture analysis.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Codebase Exploration

Systematic patterns for navigating and understanding codebases efficiently.

## When to Use

- **Onboarding to a new codebase** - Understanding project structure and conventions
- **Locating specific implementations** - Finding where functionality lives
- **Tracing dependencies** - Understanding how components connect
- **Architecture analysis** - Mapping system structure and boundaries
- **Finding usage patterns** - Discovering how APIs or functions are used
- **Investigating issues** - Tracing code paths for debugging

## Quick Structure Analysis

Start broad, then narrow down. This three-step pattern works for any codebase.

```sudolang
StructureAnalysis {
  Constraints {
    Always start with project layout before diving into source.
    Read documentation files when present.
    Verify assumptions about structure.
  }

  /analyzeLayout => {
    Step 1: Project Layout
    ls -la                                          Top-level structure
    ls -la *.json *.yaml *.yml *.toml 2>/dev/null   Config files to reveal tech stack
    ls -la README* CLAUDE.md Agent.md docs/ 2>/dev/null  Documentation
  }

  /analyzeSource => {
    Step 2: Source Organization
    Glob: **/src/**/*.{ts,js,py,go,rs,java}         Source directories
    Glob: **/{test,tests,__tests__,spec}/**/*       Test directories
    Glob: **/index.{ts,js,py} | **/main.{ts,js,py,go,rs}  Entry points
  }

  /analyzeConfig => {
    Step 3: Configuration Discovery
    Glob: **/package.json | **/requirements.txt | **/go.mod | **/Cargo.toml  Dependencies
    Glob: **/{tsconfig,vite.config,webpack.config,jest.config}.*  Build config
    Glob: **/{.env*,docker-compose*,Dockerfile}     Environment and deployment
  }
}
```

## Deep Search Strategies

```sudolang
SearchStrategy {
  /findImplementation target, language? => {
    match language {
      "python" => Grep: def $target
      "go" => Grep: func $target
      "rust" => Grep: fn $target
      _ => {
        Generic patterns for JS/TS and others
        Grep: (function|class|interface|type)\s+$target
        Grep: export\s+(default\s+)?(function|class|const)\s+$target
      }
    }
  }

  /traceUsage target => {
    Grep: import.*from\s+['"].*$target    Find imports
    Grep: $target\(                        Find function calls
    Grep: $target                          Broad reference search
  }

  /mapArchitecture => {
    Routes
    Grep: (app\.(get|post|put|delete)|router\.)

    Database models and schemas
    Grep: (Schema|Model|Entity|Table)\s*\(
    Glob: **/{models,entities,schemas}/**/*

    Service boundaries
    Glob: **/{services,controllers,handlers}/**/*
    Grep: (class|interface)\s+\w+Service
  }
}
```

## Exploration Patterns by Goal

```sudolang
ExplorationPatterns {
  /findEntryPoints type => {
    match type {
      "web" => {
        Grep: (Route|path|endpoint)
        Glob: **/routes/**/* | **/*router*
      }
      "cli" => {
        Grep: (command|program\.)
        Glob: **/cli/**/* | **/commands/**/*
      }
      "events" => {
        Grep: (on|handle|subscribe)\s*\(
      }
    }
  }

  /findConfiguration => {
    Grep: (process\.env|os\.environ|env\.)    Environment variables
    Grep: (feature|flag|toggle)                Feature flags
    Grep: (const|let)\s+(CONFIG|config|settings)  Config objects
    Glob: **/{config,constants}/**/*
  }

  /traceDataFlow => {
    Database queries
    Grep: (SELECT|INSERT|UPDATE|DELETE|find|create|update)
    Grep: (prisma|sequelize|typeorm|mongoose)\.

    API calls
    Grep: (fetch|axios|http\.|request\()

    State management
    Grep: (useState|useReducer|createStore|createSlice)
  }
}
```

## Best Practices

```sudolang
NavigationBestPractices {
  Constraints {
    Read project documentation (README, CLAUDE.md, Agent.md) before exploring.
    Verify assumptions about structure rather than assuming.
  }

  warn Searching node_modules or vendor directories wastes time.
  warn Grepping common words without filters produces noise.

  SearchEfficiency {
    Prefer Glob for file discovery as it is faster than grep for locating files.
    Prefer Grep for content search as it supports regex and context.
    Narrow scope to specific directories when possible.
    Use files_with_matches mode for discovery, content mode for analysis.
  }

  MentalModelBuilding {
    Map layers: presentation, business logic, data access.
    Identify patterns: repository, service, controller, and others.
    Note conventions: naming, file organization, code style.
    Document boundaries: where modules connect and separate.
  }
}
```

## Output Format

After exploration, summarize findings:

```sudolang
CodebaseOverview {
  techStack            Languages, frameworks, tools
  architecture         Monolith, microservices, modular, etc.
  entryPoints          Main files, routes, handlers
  keyDirectories       Each with path and purpose
  conventions          Naming, file organization, testing
  dependencies         Each with name and purpose
}

DirectoryInfo {
  path
  purpose
}

ConventionsObserved {
  naming
  fileOrganization
  testing
}

DependencyInfo {
  name
  purpose
}

formatOverview(overview) => """
  ## Codebase Overview

  **Tech Stack:** ${overview.techStack |> join(", ")}
  **Architecture:** ${overview.architecture}
  **Entry Points:** ${overview.entryPoints |> join(", ")}

  ## Key Directories

  ${overview.keyDirectories |> map(d => "- `${d.path}` - ${d.purpose}") |> join("\n")}

  ## Conventions Observed

  - Naming: ${overview.conventions.naming}
  - File organization: ${overview.conventions.fileOrganization}
  - Testing: ${overview.conventions.testing}

  ## Dependencies

  ${overview.dependencies |> map(d => "- ${d.name}: ${d.purpose}") |> join("\n")}
"""
```

## References

- [Exploration Patterns Examples](examples/exploration-patterns.md) - Detailed practical examples
