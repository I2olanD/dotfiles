---
name: tech-stack-detection
description: Auto-detect project tech stacks (React, Vue, Express, Django, etc.). Recognize package managers and configuration patterns. Use when starting work on any project, analyzing dependencies, or providing framework-specific guidance.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Framework Detection

## When to Use

- Starting work on an unfamiliar project
- Determining appropriate tooling and patterns for recommendations
- Providing framework-specific guidance and best practices
- Identifying package manager for dependency operations
- Understanding project architecture before making changes

## Detection System

```sudolang
TechStackDetection {
  State {
    packageManager: PackageManager?
    ecosystem: Ecosystem?
    frameworks: Framework[]
    confidence: "high" | "medium" | "low"
  }

  interface PackageManager {
    name: String
    lockFile: String
    ecosystem: Ecosystem
  }

  interface Framework {
    name: String
    version: String?
    configFiles: String[]
    conventions: String[]
  }

  Ecosystem: "nodejs" | "python" | "rust" | "go" | "ruby" | "php"

  /detect => {
    detectPackageManager()
    analyzeConfigFiles()
    identifyDirectoryPatterns()
    matchFrameworkSignatures()
    outputResults()
  }
}
```

### Step 1: Package Manager Detection

Check for package manager indicators in the project root:

```sudolang
fn detectPackageManager(rootFiles: String[]) {
  match (rootFiles) {
    case files if files.includes("package-lock.json") => {
      name: "npm",
      ecosystem: "nodejs"
    }
    case files if files.includes("yarn.lock") => {
      name: "Yarn",
      ecosystem: "nodejs"
    }
    case files if files.includes("pnpm-lock.yaml") => {
      name: "pnpm",
      ecosystem: "nodejs"
    }
    case files if files.includes("bun.lockb") => {
      name: "Bun",
      ecosystem: "nodejs"
    }
    case files if files.includes("requirements.txt") => {
      name: "pip",
      ecosystem: "python"
    }
    case files if files.includes("Pipfile.lock") => {
      name: "pipenv",
      ecosystem: "python"
    }
    case files if files.includes("poetry.lock") => {
      name: "Poetry",
      ecosystem: "python"
    }
    case files if files.includes("uv.lock") => {
      name: "uv",
      ecosystem: "python"
    }
    case files if files.includes("Cargo.lock") => {
      name: "Cargo",
      ecosystem: "rust"
    }
    case files if files.includes("go.sum") => {
      name: "Go Modules",
      ecosystem: "go"
    }
    case files if files.includes("Gemfile.lock") => {
      name: "Bundler",
      ecosystem: "ruby"
    }
    case files if files.includes("composer.lock") => {
      name: "Composer",
      ecosystem: "php"
    }
    default => null
  }
}
```

### Step 2: Configuration File Analysis

Examine root-level configuration files for framework indicators:

```sudolang
ConfigAnalysis {
  constraints {
    Read package.json dependencies and devDependencies for Node.js projects
    Read pyproject.toml [project.dependencies] or [tool.poetry.dependencies] for Python
    Check framework-specific configs: next.config.js, vite.config.ts, angular.json
  }

  fn analyzeManifest(ecosystem: Ecosystem) {
    match (ecosystem) {
      case "nodejs" => readPackageJson() |> extractDependencies
      case "python" => readPyprojectToml() |> extractDependencies
      case "rust" => readCargoToml() |> extractDependencies
      case "go" => readGoMod() |> extractDependencies
      case "ruby" => readGemfile() |> extractDependencies
      case "php" => readComposerJson() |> extractDependencies
    }
  }
}
```

### Step 3: Directory Structure Patterns

Identify framework conventions:

```sudolang
fn matchDirectoryPattern(directories: String[]) {
  match (directories) {
    case dirs if dirs.includes("app/") || dirs.includes("src/app/") => {
      frameworks: ["Next.js App Router", "Angular"],
      confidence: "medium"  // Ambiguous, needs further verification
    }
    case dirs if dirs.includes("pages/") => {
      frameworks: ["Next.js Pages Router", "Nuxt.js"],
      confidence: "medium"
    }
    case dirs if dirs.includes("components/") => {
      pattern: "component-based",
      frameworks: ["React", "Vue", "Svelte"],
      confidence: "low"  // Very common pattern
    }
    case dirs if dirs.includes("routes/") => {
      frameworks: ["Remix", "SvelteKit"],
      confidence: "medium"
    }
    case dirs if dirs.includes("views/") => {
      pattern: "MVC",
      frameworks: ["Django", "Rails", "Laravel"],
      confidence: "low"
    }
    case dirs if dirs.includes("controllers/") => {
      pattern: "MVC",
      frameworks: ["Rails", "Laravel", "NestJS"],
      confidence: "medium"
    }
    default => { frameworks: [], confidence: "low" }
  }
}
```

### Step 4: Framework-Specific Patterns

Apply detection patterns from the framework signatures reference.

## Detection Workflow

```sudolang
DetectionWorkflow {
  /execute => {
    // Step 1: Package manager from lock files
    lockFiles = glob("*.lock*", "package-lock.json", "go.sum")
    State.packageManager = detectPackageManager(lockFiles)
    State.ecosystem = State.packageManager?.ecosystem

    // Step 2: Read manifest files
    manifest = match (State.ecosystem) {
      case "nodejs" => read("package.json")
      case "python" => read("pyproject.toml")
      case "rust" => read("Cargo.toml")
      case "go" => read("go.mod")
      case "ruby" => read("Gemfile")
      case "php" => read("composer.json")
      default => null
    }
    dependencies = extractDependencies(manifest)

    // Step 3: Match against known frameworks
    frameworkMatches = dependencies |> matchKnownFrameworks

    // Step 4: Check config files for confirmation
    configFiles = glob("*.config.*", "angular.json", "nuxt.config.*")
    confirmedFrameworks = verifyWithConfigs(frameworkMatches, configFiles)

    // Step 5: Verify with directory structure
    directories = listDirectories(".")
    structureMatches = matchDirectoryPattern(directories)
    
    // Final output
    State.frameworks = crossReference(confirmedFrameworks, structureMatches)
    State.confidence = calculateConfidence(State.frameworks)
    
    outputResults(State)
  }
}
```

## Output Format

```sudolang
interface DetectionOutput {
  framework: String
  version: String?
  packageManager: PackageManager
  configFiles: String[]
  directoryConventions: String[]
  commonCommands: Command[]
}

interface Command {
  purpose: String
  command: String
}

fn outputResults(state: State) {
  require state.packageManager != null
  require state.frameworks.length > 0

  return {
    framework: state.frameworks[0].name,
    version: state.frameworks[0].version,
    packageManager: state.packageManager,
    configFiles: state.frameworks |> flatMap(f => f.configFiles),
    directoryConventions: state.frameworks |> flatMap(f => f.conventions),
    commonCommands: generateCommands(state.packageManager, state.frameworks)
  }
}
```

## Best Practices

```sudolang
DetectionBestPractices {
  constraints {
    Always verify detection by checking multiple indicators (config + dependencies + structure)
    Report confidence level when patterns are ambiguous
    Note when multiple frameworks are present (e.g., Next.js + Tailwind + Prisma)
    Check for meta-frameworks built on top of base frameworks
    Consider monorepo patterns where different packages may use different frameworks
  }

  warn when {
    Only one indicator matched => "Low confidence detection, verify manually"
    Multiple conflicting frameworks detected => "Ambiguous setup, check configs"
    No lock file found => "Package manager uncertain"
  }
}
```

## References

See `references/framework-signatures.md` for comprehensive detection patterns for all major frameworks.
