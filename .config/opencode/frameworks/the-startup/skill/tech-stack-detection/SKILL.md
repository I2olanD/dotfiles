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
    packageManager
    ecosystem
    frameworks
    confidence: "high" | "medium" | "low"
  }

  PackageManager {
    name
    lockFile
    ecosystem
  }

  Framework {
    name
    version
    configFiles
    conventions
  }

  Ecosystem = "nodejs" | "python" | "rust" | "go" | "ruby" | "php"

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
detectPackageManager(rootFiles) {
  match rootFiles {
    rootFiles has "package-lock.json" => {
      name: "npm",
      ecosystem: "nodejs"
    }
    rootFiles has "yarn.lock" => {
      name: "Yarn",
      ecosystem: "nodejs"
    }
    rootFiles has "pnpm-lock.yaml" => {
      name: "pnpm",
      ecosystem: "nodejs"
    }
    rootFiles has "bun.lockb" => {
      name: "Bun",
      ecosystem: "nodejs"
    }
    rootFiles has "requirements.txt" => {
      name: "pip",
      ecosystem: "python"
    }
    rootFiles has "Pipfile.lock" => {
      name: "pipenv",
      ecosystem: "python"
    }
    rootFiles has "poetry.lock" => {
      name: "Poetry",
      ecosystem: "python"
    }
    rootFiles has "uv.lock" => {
      name: "uv",
      ecosystem: "python"
    }
    rootFiles has "Cargo.lock" => {
      name: "Cargo",
      ecosystem: "rust"
    }
    rootFiles has "go.sum" => {
      name: "Go Modules",
      ecosystem: "go"
    }
    rootFiles has "Gemfile.lock" => {
      name: "Bundler",
      ecosystem: "ruby"
    }
    rootFiles has "composer.lock" => {
      name: "Composer",
      ecosystem: "php"
    }
    _ => null
  }
}
```

### Step 2: Configuration File Analysis

Examine root-level configuration files for framework indicators:

```sudolang
ConfigAnalysis {
  Constraints {
    Read package.json dependencies and devDependencies for Node.js projects.
    Read pyproject.toml project dependencies or tool.poetry.dependencies for Python.
    Check framework-specific configs: next.config.js, vite.config.ts, angular.json.
  }

  analyzeManifest(ecosystem) {
    match ecosystem {
      "nodejs" => readPackageJson() |> extractDependencies
      "python" => readPyprojectToml() |> extractDependencies
      "rust" => readCargoToml() |> extractDependencies
      "go" => readGoMod() |> extractDependencies
      "ruby" => readGemfile() |> extractDependencies
      "php" => readComposerJson() |> extractDependencies
    }
  }
}
```

### Step 3: Directory Structure Patterns

Identify framework conventions:

```sudolang
matchDirectoryPattern(directories) {
  match directories {
    directories has "app/" or "src/app/" => {
      frameworks: ["Next.js App Router", "Angular"],
      confidence: "medium"  Ambiguous, needs further verification
    }
    directories has "pages/" => {
      frameworks: ["Next.js Pages Router", "Nuxt.js"],
      confidence: "medium"
    }
    directories has "components/" => {
      pattern: "component-based",
      frameworks: ["React", "Vue", "Svelte"],
      confidence: "low"  Very common pattern
    }
    directories has "routes/" => {
      frameworks: ["Remix", "SvelteKit"],
      confidence: "medium"
    }
    directories has "views/" => {
      pattern: "MVC",
      frameworks: ["Django", "Rails", "Laravel"],
      confidence: "low"
    }
    directories has "controllers/" => {
      pattern: "MVC",
      frameworks: ["Rails", "Laravel", "NestJS"],
      confidence: "medium"
    }
    _ => { frameworks: [], confidence: "low" }
  }
}
```

### Step 4: Framework-Specific Patterns

Apply detection patterns from the framework signatures reference.

## Detection Workflow

```sudolang
DetectionWorkflow {
  /execute => {
    Step 1: Package manager from lock files
    lockFiles = glob("*.lock*", "package-lock.json", "go.sum")
    State.packageManager = detectPackageManager(lockFiles)
    State.ecosystem = State.packageManager?.ecosystem

    Step 2: Read manifest files
    manifest = match State.ecosystem {
      "nodejs" => read("package.json")
      "python" => read("pyproject.toml")
      "rust" => read("Cargo.toml")
      "go" => read("go.mod")
      "ruby" => read("Gemfile")
      "php" => read("composer.json")
      _ => null
    }
    dependencies = extractDependencies(manifest)

    Step 3: Match against known frameworks
    frameworkMatches = dependencies |> matchKnownFrameworks

    Step 4: Check config files for confirmation
    configFiles = glob("*.config.*", "angular.json", "nuxt.config.*")
    confirmedFrameworks = verifyWithConfigs(frameworkMatches, configFiles)

    Step 5: Verify with directory structure
    directories = listDirectories(".")
    structureMatches = matchDirectoryPattern(directories)

    Final output
    State.frameworks = crossReference(confirmedFrameworks, structureMatches)
    State.confidence = calculateConfidence(State.frameworks)

    outputResults(State)
  }
}
```

## Output Format

```sudolang
DetectionOutput {
  framework
  version
  packageManager
  configFiles
  directoryConventions
  commonCommands
}

Command {
  purpose
  command
}

outputResults(state) {
  require state.packageManager is not null
  require state.frameworks is not empty

  return {
    framework: state.frameworks first name,
    version: state.frameworks first version,
    packageManager: state.packageManager,
    configFiles: state.frameworks |> flatMap configFiles,
    directoryConventions: state.frameworks |> flatMap conventions,
    commonCommands: generateCommands(state.packageManager, state.frameworks)
  }
}
```

## Best Practices

```sudolang
DetectionBestPractices {
  Constraints {
    Always verify detection by checking multiple indicators (config, dependencies, structure).
    Report confidence level when patterns are ambiguous.
    Note when multiple frameworks are present (e.g., Next.js + Tailwind + Prisma).
    Check for meta-frameworks built on top of base frameworks.
    Consider monorepo patterns where different packages may use different frameworks.
  }

  warn Only one indicator matched means low confidence detection, verify manually.
  warn Multiple conflicting frameworks detected means ambiguous setup, check configs.
  warn No lock file found means package manager uncertain.
}
```

## References

See `references/framework-signatures.md` for comprehensive detection patterns for all major frameworks.
