---
name: documentation-extraction
description: Interpret existing docs, READMEs, specs, and configuration files efficiently. Use when onboarding to a codebase, verifying implementation against specs, understanding API contracts, or parsing configuration. Covers reading strategies for README, API docs, specs, configs, and cross-referencing with code.
license: MIT
compatibility: opencode
metadata:
  category: documentation
  version: "1.0"
---

# Documentation Reading

Systematic approaches for extracting actionable information from project documentation efficiently while identifying gaps, contradictions, and outdated content.

## When to Use

- Onboarding to an unfamiliar codebase or service
- Verifying implementation matches specification requirements
- Understanding API contracts before integration
- Parsing configuration files for deployment or debugging
- Investigating discrepancies between docs and actual behavior
- Preparing to extend or modify existing functionality

## Reading Strategies by Document Type

```sudolang
DocumentReader {
  Constraints {
    Read files completely - never skim or assume content.
    Verify before trusting - test documented commands and examples.
    Note contradictions immediately as discovered.
    Cross-reference constantly - docs without code verification are unreliable.
  }

  /readDocument(doc) {
    match doc.type {
      "readme" => ReadmeStrategy |> extract(doc)
      "api" => ApiDocStrategy |> extract(doc)
      "spec" => SpecificationStrategy |> extract(doc)
      "config" => ConfigStrategy |> extract(doc)
      "adr" => AdrStrategy |> extract(doc)
      _ => GenericStrategy |> extract(doc)
    }
  }
}
```

### README Files

READMEs are entry points. Extract these elements in order:

1. **Project Purpose**: First paragraph usually states what the project does
2. **Quick Start**: Look for "Getting Started", "Installation", or "Usage" sections
3. **Prerequisites**: Dependencies, environment requirements, version constraints
4. **Architecture Hints**: Links to other docs, directory structure descriptions
5. **Maintenance Status**: Last updated date, badges, contribution activity

```sudolang
ReadmeStrategy {
  extract(readme) {
    1. Scan headings to build mental map (30 seconds)
    2. Read purpose/description section fully
    3. Locate quick start commands - test if they work
    4. Note any "gotchas" or "known issues" sections
    5. Identify links to deeper documentation
  }

  warn {
    when noUpdateIn12Months(readme) && isActiveProject(readme) =>
      "No update in 12+ months on active project"
    when quickStartFails(readme) =>
      "Quick start commands that fail"
    when hasDeprecatedDependencies(readme) =>
      "References to deprecated dependencies"
    when missingLicenseOrSecurity(readme) =>
      "Missing license or security sections"
  }
}
```

### API Documentation

Extract information in this priority:

1. **Authentication**: How to authenticate (API keys, OAuth, tokens)
2. **Base URL / Endpoints**: Entry points and environment variations
3. **Request Format**: Headers, body structure, content types
4. **Response Format**: Success/error shapes, status codes
5. **Rate Limits**: Throttling, quotas, retry policies
6. **Versioning**: How versions are specified, deprecation timeline

```sudolang
ApiDocStrategy {
  extract(apiDoc) {
    1. Find authentication section first - nothing works without it
    2. Locate a simple endpoint (health check, list operation)
    3. Trace a complete request/response cycle
    4. Note pagination patterns for list endpoints
    5. Identify error response structure
    6. Check for SDK/client library availability
  }

  require Authentication method documented.
  require At least one endpoint traceable end-to-end.
  require Response schema verifiable against real responses.

  /crossReference(endpoint) {
    Compare documented endpoints against actual network calls.
    Verify response schemas match real responses.
    Test documented error codes actually occur.
  }
}
```

### Technical Specifications

Specifications define expected behavior. Extract:

1. **Requirements List**: Numbered requirements, acceptance criteria
2. **Constraints**: Technical limitations, compatibility requirements
3. **Data Models**: Entity definitions, relationships, constraints
4. **Interfaces**: API contracts, message formats, protocols
5. **Non-Functional Requirements**: Performance, security, scalability targets

```sudolang
SpecificationStrategy {
  extract(spec) {
    1. Identify document type (PRD, SDD, RFC, ADR)
    2. Locate requirements or acceptance criteria section
    3. Extract testable assertions (MUST, SHALL, SHOULD language)
    4. Map requirements to implementation locations
    5. Note any open questions or TBD items
  }

  verify(requirements) {
    requirements |> map(req => {
      status: match checkImplementation(req) {
        found && matches => "Implemented"
        found && partial => "Partial"
        found && conflicts => "Contradicted"
        notFound => "Missing"
      },
      requirement: req,
      location: findImplementationLocation(req)
    })
  }
}
```

### Configuration Files

Configuration files control runtime behavior. Approach by file type:

```sudolang
ConfigStrategy {
  extract(config) {
    match config.type {
      "package_manifest" => extractPackageManifest(config)
      "environment" => extractEnvironmentConfig(config)
      "build_deploy" => extractBuildDeployConfig(config)
      _ => extractGenericConfig(config)
    }
  }

  extractPackageManifest(manifest) {
    package.json, Cargo.toml, pyproject.toml
    1. Project metadata: name, version, description
    2. Entry points: main, bin, exports
    3. Dependencies: runtime vs dev, version constraints
    4. Scripts/commands: available automation
    5. Engine requirements: Node version, Python version
  }

  extractEnvironmentConfig(env) {
    .env, config.yaml, settings.json
    1. Required variables (those without defaults)
    2. Environment-specific overrides
    3. Secret references (never actual values)
    4. Feature flags and toggles
    5. Service URLs and connection strings
  }

  extractBuildDeployConfig(deploy) {
    Dockerfile, CI configs, terraform
    1. Base images or providers
    2. Build stages and dependencies
    3. Environment variable injection points
    4. Secret management approach
    5. Output artifacts and destinations
  }

  readingPattern(config) {
    1. Identify configuration format and schema (if available)
    2. List all configurable options
    3. Determine which have defaults vs require values
    4. Trace where configuration values are consumed in code
    5. Note any environment-specific overrides
  }
}
```

### Architecture Decision Records (ADRs)

ADRs capture why decisions were made. Extract:

1. **Context**: What problem prompted the decision
2. **Decision**: What was chosen
3. **Consequences**: Trade-offs accepted
4. **Status**: Accepted, Deprecated, Superseded
5. **Related Decisions**: Links to related ADRs

```sudolang
AdrStrategy {
  extract(adr) {
    1. Read context to understand the problem space
    2. Note alternatives that were considered
    3. Understand why current approach was chosen
    4. Check if decision is still active or superseded
    5. Consider if context has changed since decision
  }

  isRelevant(adr) {
    match adr.status {
      "Accepted" => true
      "Deprecated" => false
      "Superseded" => check(adr.supersededBy)
      _ => warn "Unknown ADR status"
    }
  }
}
```

## Identifying Documentation Issues

### Outdated Documentation

Signals that documentation may be stale:

- **Version Mismatches**: Docs reference v1.x, code is v2.x
- **Missing Features**: Code has capabilities not in docs
- **Dead Links**: References to moved or deleted resources
- **Deprecated Patterns**: Docs use patterns code has abandoned
- **Date Indicators**: "Last updated 2 years ago" on active project

```sudolang
StalenessDetector {
  warn {
    when versionMismatch(doc, code) =>
      "Docs reference $doc.version, code is $code.version"
    when codeHasUndocumentedFeatures(doc, code) =>
      "Code has capabilities not in docs"
    when hasDeadLinks(doc) =>
      "References to moved or deleted resources"
    when usesDeprecatedPatterns(doc, code) =>
      "Docs use patterns code has abandoned"
    when lastUpdatedTooOld(doc, 2.years) && isActiveProject(code) =>
      "Last updated 2+ years ago on active project"
  }

  verify(doc) {
    1. Check doc commit history vs code commit history
    2. Compare documented API against actual code signatures
    3. Run documented examples - do they work?
    4. Search code for terms used in docs - are they present?
  }
}
```

### Conflicting Documentation

When multiple docs disagree:

```sudolang
ConflictResolver {
  resolve(sources) {
    require at least 2 sources.
    require sources contain conflicting content.

    1. Identify the conflict explicitly: Quote both sources
    2. Check timestamps: Newer usually wins
    3. Check authority: Official > community, code > docs
    4. Test behavior: What does the system actually do?
    5. Document the resolution: Note which source was correct
  }

  ResolutionPriority: [
    "Actual system behavior (empirical truth)",
    "Most recent official documentation",
    "Code comments and inline documentation",
    "External/community documentation",
    "Older official documentation"
  ]

  determineAuthority(source) {
    match source {
      { type: "system_behavior" } => priority: 1
      { type: "official", recent: true } => priority: 2
      { type: "code_comment" } => priority: 3
      { type: "community" } => priority: 4
      { type: "official", recent: false } => priority: 5
      _ => priority: 99
    }
  }
}
```

### Missing Documentation

Recognize documentation gaps:

- **Undocumented Endpoints**: Routes exist in code but not docs
- **Hidden Configuration**: Env vars used but not listed
- **Implicit Requirements**: Dependencies not in requirements file
- **Tribal Knowledge**: Processes that exist only in team memory

```sudolang
GapDetector {
  warn {
    when routeExistsNotInDocs(code, docs) =>
      "Undocumented endpoint: $route"
    when envVarUsedNotListed(code, docs) =>
      "Hidden configuration: $envVar"
    when dependencyNotInManifest(code, manifest) =>
      "Implicit requirement: $dependency"
  }

  GapTemplate: """
    ## Documentation Gap: [Topic]

    **Discovered**: [Date]
    **Location**: [Where this should be documented]
    **Current State**: [What exists now]
    **Required Information**: [What's missing]
    **Source of Truth**: [Where to get correct info]
  """
}
```

## Cross-Referencing Documentation with Code

```sudolang
CrossReferencer {
  /traceRequirement(req) {
    1. Extract requirement ID or description
    2. Search codebase for requirement reference
    3. If not found, search for key domain terms
    4. Locate implementation and verify behavior
    5. Document mapping: Requirement -> File:Line
  }

  /validateApiDoc(endpoint) {
    1. Find endpoint in documentation
    2. Locate route definition in code
    3. Compare: method, path, parameters
    4. Trace to handler implementation
    5. Verify response shape matches docs
  }

  /traceConfig(key) {
    1. Identify configuration key in docs
    2. Search for key in codebase
    3. Find where value is read/consumed
    4. Trace through to actual usage
    5. Verify documented behavior matches code
  }
}
```

## Best Practices

```sudolang
DocumentationExtractionPractices {
  require Read completely before acting - avoid skimming that misses critical details.
  require Verify before trusting - test documented commands and examples.
  require Note contradictions immediately - document conflicts as discovered.
  require Maintain a questions list - track unclear items for follow-up.
  require Cross-reference constantly - docs without code verification are unreliable.
  require Update as you learn - fix documentation issues discovered.
}
```

## Anti-Patterns

```sudolang
DocumentationAntiPatterns {
  Constraints {
    Never assume documentation is current - always verify against code.
    Never read without testing - documentation lies; code reveals truth.
    Never ignore "Notes" and "Warnings" - these often contain critical information.
    Never skip prerequisites - missing requirements cause cascading failures.
    Never trust examples blindly - examples may be simplified or outdated.
  }
}
```
