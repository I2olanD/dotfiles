---
name: pattern-detection
description: Identify existing codebase patterns (naming conventions, architectural patterns, testing patterns) to maintain consistency. Use when generating code, reviewing changes, or understanding established practices. Ensures new code aligns with project conventions.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Pattern Recognition

## When to Use

- Before writing new code to ensure consistency with existing patterns
- During code review to verify alignment with established conventions
- When onboarding to understand project-specific practices
- Before refactoring to preserve intentional design decisions

## Core Methodology

```sudolang
PatternDiscovery {
  State {
    representativeFiles: File[]
    discoveredPatterns: Pattern[]
    patternSources: Source[]
  }
  
  constraints {
    Survey 3-5 representative files before writing new code
    Patterns must be verified for intentionality before applying
    Most authoritative source takes precedence
  }
  
  /discover fileType:String => {
    1. Survey 3-5 files of $fileType
    2. Identify recurring structures in naming, organization, imports
    3. Verify intentionality via documentation or consistent application
    4. Catalog discovered patterns
  }
  
  /apply pattern:Pattern, newCode:Code => {
    require pattern.verified == true
    apply pattern conventions to newCode
  }
}

PatternSourcePriority {
  fn resolvePattern(query: String) {
    match (availableSources) {
      case { sameModule: patterns } if patterns.length > 0 => 
        patterns  // Most authoritative
      case { styleGuide: documented } if documented => 
        documented  // Explicit documentation
      case { testFiles: patterns } if patterns.length > 0 => 
        patterns  // Often reveal expected patterns
      case { adjacentModules: patterns } if patterns.length > 0 => 
        patterns  // Fallback when no direct examples
      default => warn "No pattern sources found - document assumptions"
    }
  }
}
```

## Naming Convention Recognition

### File Naming Patterns

Detect and follow the project's file naming style:

| Pattern | Example | Common In |
|---------|---------|-----------|
| kebab-case | `user-profile.ts` | Node.js, Vue, Angular |
| PascalCase | `UserProfile.tsx` | React components |
| snake_case | `user_profile.py` | Python |
| camelCase | `userProfile.js` | Legacy JS, Java |

```sudolang
FileNamingDetector {
  fn detectNamingPattern(files: String[]) {
    patterns = files |> map(f => classifyNaming(f))
    dominant = patterns |> groupBy(p => p) |> maxBy(g => g.length)
    
    match (dominant) {
      case "kebab-case" => { style: "kebab-case", example: "user-profile.ts" }
      case "PascalCase" => { style: "PascalCase", example: "UserProfile.tsx" }
      case "snake_case" => { style: "snake_case", example: "user_profile.py" }
      case "camelCase" => { style: "camelCase", example: "userProfile.js" }
      default => warn "Mixed naming conventions detected"
    }
  }
}
```

### Function/Method Naming

Identify the project's verb conventions:

```sudolang
VerbConventions {
  dataAccess: "get" | "fetch" | "retrieve"
  creation: "create" | "add" | "new"
  mutation: "update" | "set" | "modify"
  deletion: "delete" | "remove" | "destroy"
  booleanPrefixes: ["is", "has", "can", "should"]
  
  fn detectVerbConvention(category: String, codebase: Code[]) {
    usages = codebase |> extractFunctions |> filterByCategory(category)
    usages |> groupBy(verb) |> maxBy(g => g.length) |> first
  }
}
```

### Variable Naming

Detect pluralization and specificity patterns:

- Singular vs plural for collections (`user` vs `users` vs `userList`)
- Hungarian notation presence (`strName`, `iCount`)
- Private member indicators (`_private`, `#private`, `mPrivate`)

## Architectural Pattern Recognition

### Layer Identification

Recognize how the codebase separates concerns:

```sudolang
ArchitectureDetector {
  fn detectLayeringPattern(structure: Directory) {
    match (structure.directories) {
      case dirs if hasAll(dirs, ["controllers", "models", "views"]) =>
        { pattern: "MVC", layers: ["controllers", "models", "views"] }
      case dirs if hasAll(dirs, ["domain", "application", "infrastructure"]) =>
        { pattern: "Clean Architecture", layers: ["domain", "application", "infrastructure"] }
      case dirs if hasAll(dirs, ["core", "adapters", "ports"]) =>
        { pattern: "Hexagonal", layers: ["core", "adapters", "ports"] }
      case dirs if dirs |> any(d => d.startsWith("features/")) =>
        { pattern: "Feature-based", layers: extractFeatures(dirs) }
      case dirs if hasAll(dirs, ["components", "services", "utils"]) =>
        { pattern: "Type-based", layers: ["components", "services", "utils"] }
      default => { pattern: "Unknown", layers: dirs }
    }
  }
}
```

### Dependency Direction

Identify import patterns that reveal architecture:

- Which modules import from which (dependency flow)
- Shared vs feature-specific code boundaries
- Framework code vs application code separation

### State Management Patterns

Recognize how state flows through the application:

- Global stores (Redux, Vuex, MobX patterns)
- React Context usage patterns
- Service layer patterns for backend state
- Event-driven vs request-response patterns

## Testing Pattern Recognition

### Test Organization

Identify how tests are structured:

| Pattern | Structure | Example |
|---------|-----------|---------|
| Co-located | `src/user.ts`, `src/user.test.ts` | Common in modern JS/TS |
| Mirror tree | `src/user.ts`, `tests/src/user.test.ts` | Traditional, Java-style |
| Feature-based | `src/user/`, `src/user/__tests__/` | React, organized features |

```sudolang
TestPatternDetector {
  fn detectTestOrganization(projectRoot: Directory) {
    match (projectRoot) {
      case root if hasColocatedTests(root) =>
        { organization: "co-located", testPath: "same directory as source" }
      case root if hasMirrorTree(root) =>
        { organization: "mirror-tree", testPath: "tests/ mirrors src/" }
      case root if hasFeatureTests(root) =>
        { organization: "feature-based", testPath: "__tests__/ in feature dirs" }
      default => warn "Test organization unclear - check existing tests"
    }
  }
  
  fn detectTestNamingStyle(testFiles: File[]) {
    match (testFiles |> extractDescriptions |> classify) {
      case "BDD" => { style: "BDD", example: "it('should return user when found')" }
      case "descriptive" => { style: "descriptive", example: "test('getUser returns user when id exists')" }
      case "function-focused" => { style: "function-focused", example: "test_get_user_returns_user_when_found" }
      default => warn "Mixed test naming styles detected"
    }
  }
}
```

### Test Structure Patterns

Recognize Arrange-Act-Assert or Given-When-Then patterns:

- Setup block conventions (beforeEach, fixtures, factories)
- Assertion style (expect vs assert vs should)
- Mock/stub patterns (jest.mock vs sinon vs manual)

## Code Organization Patterns

### Import Organization

Identify import ordering and grouping:

```sudolang
ImportPatternDetector {
  commonPatterns: [
    "External packages first, internal modules second",
    "Grouped by type (React, libraries, local)",
    "Alphabetized within groups",
    "Absolute imports vs relative imports preference"
  ]
  
  fn detectImportPattern(files: File[]) {
    imports = files |> flatMap(f => extractImports(f))
    
    match (imports) {
      case i if hasExternalFirstPattern(i) =>
        { ordering: "external-first", grouping: detectGrouping(i) }
      case i if hasTypeGrouping(i) =>
        { ordering: "type-grouped", grouping: ["framework", "libraries", "local"] }
      case i if isAlphabetized(i) =>
        { ordering: "alphabetized", grouping: "none" }
      default => { ordering: "unstructured", grouping: "none" }
    }
  }
}
```

### Export Patterns

Recognize module boundary conventions:

- Default exports vs named exports preference
- Barrel files (index.ts re-exports) presence
- Public API definition patterns

### Comment and Documentation Patterns

Identify documentation conventions:

- JSDoc/TSDoc presence and style
- Inline comment frequency and style
- README conventions per module/feature

## Best Practices

```sudolang
PatternRecognitionRules {
  constraints {
    Follow existing patterns even if imperfect - consistency trumps preference
    Document deviations explicitly when breaking patterns intentionally
    Pattern changes require migration - don't introduce without updating existing code
    Check tests for patterns too - test code reveals expected conventions
    Prefer explicit over implicit - when unclear, ask or document assumptions
  }
  
  require {
    New code matches discovered patterns
    Deviations have documented justification
    Migration plan exists before introducing new patterns
  }
  
  warn {
    Mixed naming conventions in same codebase
    New architectural patterns without team consensus
    Patterns assumed from other projects
    Test patterns ignored when writing implementation
    "Special" files that don't follow established structure
  }
}
```

## Anti-Patterns to Avoid

```sudolang
PatternAntiPatterns {
  violations: [
    "Mixing naming conventions in the same codebase",
    "Introducing new architectural patterns without team consensus",
    "Assuming patterns from other projects apply here",
    "Ignoring test patterns when writing implementation",
    "Creating 'special' files that don't follow established structure"
  ]
  
  fn checkForViolation(change: CodeChange) {
    match (change) {
      case c if mixesNamingConventions(c) =>
        { violation: true, type: "mixed-naming", action: "Use consistent naming" }
      case c if introducesNewPattern(c) && !hasTeamConsensus(c) =>
        { violation: true, type: "unapproved-pattern", action: "Get team approval" }
      case c if assumesExternalPatterns(c) =>
        { violation: true, type: "foreign-pattern", action: "Check local conventions" }
      case c if ignoresTestPatterns(c) =>
        { violation: true, type: "test-mismatch", action: "Align with test patterns" }
      case c if createsSpecialFile(c) =>
        { violation: true, type: "special-file", action: "Follow established structure" }
      default => { violation: false }
    }
  }
}
```

## References

- `examples/common-patterns.md` - Concrete examples of pattern recognition in action
