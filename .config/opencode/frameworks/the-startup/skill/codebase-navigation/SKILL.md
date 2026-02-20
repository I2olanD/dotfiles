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
  constraints {
    Always start with project layout before diving into source
    Read documentation files when present
    Verify assumptions about structure
  }

  /analyzeLayout => {
    // Step 1: Project Layout
    ls -la                                          // Top-level structure
    ls -la *.json *.yaml *.yml *.toml 2>/dev/null   // Config files (reveals tech stack)
    ls -la README* CLAUDE.md Agent.md docs/ 2>/dev/null  // Documentation
  }

  /analyzeSource => {
    // Step 2: Source Organization
    Glob: **/src/**/*.{ts,js,py,go,rs,java}         // Source directories
    Glob: **/{test,tests,__tests__,spec}/**/*       // Test directories
    Glob: **/index.{ts,js,py} | **/main.{ts,js,py,go,rs}  // Entry points
  }

  /analyzeConfig => {
    // Step 3: Configuration Discovery
    Glob: **/package.json | **/requirements.txt | **/go.mod | **/Cargo.toml  // Dependencies
    Glob: **/{tsconfig,vite.config,webpack.config,jest.config}.*  // Build config
    Glob: **/{.env*,docker-compose*,Dockerfile}     // Environment/deployment
  }
}
```

## Deep Search Strategies

```sudolang
SearchStrategy {
  /findImplementation target:String, language:String? => {
    match (language) {
      case "python" => Grep: def $target
      case "go" => Grep: func $target
      case "rust" => Grep: fn $target
      default => {
        // Generic patterns for JS/TS and others
        Grep: (function|class|interface|type)\s+$target
        Grep: export\s+(default\s+)?(function|class|const)\s+$target
      }
    }
  }

  /traceUsage target:String => {
    Grep: import.*from\s+['"].*$target    // Find imports
    Grep: $target\(                        // Find function calls
    Grep: $target                          // Broad reference search
  }

  /mapArchitecture => {
    // Routes
    Grep: (app\.(get|post|put|delete)|router\.)
    
    // Database models/schemas
    Grep: (Schema|Model|Entity|Table)\s*\(
    Glob: **/{models,entities,schemas}/**/*
    
    // Service boundaries
    Glob: **/{services,controllers,handlers}/**/*
    Grep: (class|interface)\s+\w+Service
  }
}
```

## Exploration Patterns by Goal

```sudolang
ExplorationPatterns {
  /findEntryPoints type:String => {
    match (type) {
      case "web" => {
        Grep: (Route|path|endpoint)
        Glob: **/routes/**/* | **/*router*
      }
      case "cli" => {
        Grep: (command|program\.)
        Glob: **/cli/**/* | **/commands/**/*
      }
      case "events" => {
        Grep: (on|handle|subscribe)\s*\(
      }
    }
  }

  /findConfiguration => {
    Grep: (process\.env|os\.environ|env\.)    // Environment variables
    Grep: (feature|flag|toggle)                // Feature flags
    Grep: (const|let)\s+(CONFIG|config|settings)  // Config objects
    Glob: **/{config,constants}/**/*
  }

  /traceDataFlow => {
    // Database queries
    Grep: (SELECT|INSERT|UPDATE|DELETE|find|create|update)
    Grep: (prisma|sequelize|typeorm|mongoose)\.
    
    // API calls
    Grep: (fetch|axios|http\.|request\()
    
    // State management
    Grep: (useState|useReducer|createStore|createSlice)
  }
}
```

## Best Practices

```sudolang
NavigationBestPractices {
  constraints {
    warn "Searching node_modules or vendor directories wastes time"
    warn "Grepping common words without filters produces noise"
    require "Read project documentation (README, CLAUDE.md, Agent.md) before exploring"
    require "Verify assumptions about structure rather than assuming"
  }

  SearchEfficiency {
    prefer Glob for file discovery         // Faster than grep for locating files
    prefer Grep for content search         // Supports regex and context
    narrow scope to specific directories when possible
    use files_with_matches mode for discovery, content mode for analysis
  }

  MentalModelBuilding {
    map layers: presentation, business_logic, data_access
    identify patterns: repository, service, controller, etc
    note conventions: naming, file_organization, code_style
    document boundaries: where modules connect and separate
  }
}
```

## Output Format

After exploration, summarize findings:

```sudolang
interface CodebaseOverview {
  techStack: String[]       // Languages, frameworks, tools
  architecture: String      // Monolith, microservices, modular, etc.
  entryPoints: String[]     // Main files, routes, handlers
  keyDirectories: DirectoryInfo[]
  conventions: ConventionsObserved
  dependencies: DependencyInfo[]
}

interface DirectoryInfo {
  path: String
  purpose: String
}

interface ConventionsObserved {
  naming: String
  fileOrganization: String
  testing: String
}

interface DependencyInfo {
  name: String
  purpose: String
}

fn formatOverview(overview: CodebaseOverview) => """
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
