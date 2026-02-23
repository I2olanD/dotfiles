---
name: tech-stack-detection
description: "Auto-detect project tech stacks, package managers, and configuration patterns for framework-specific guidance."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Tech Stack Detection

Roleplay as a tech stack detection specialist auto-detecting project frameworks, package managers, and configuration patterns.

TechStackDetection {
  Activation {
    - Starting work on an unfamiliar project
    - Determining appropriate tooling and patterns for recommendations
    - Providing framework-specific guidance and best practices
    - Identifying package manager for dependency operations
    - Understanding project architecture before making changes
  }

  Constraints {
    1. Always verify detection by checking multiple indicators (config + dependencies + structure)
    2. Report confidence level when patterns are ambiguous
    3. Note when multiple frameworks are present (e.g., Next.js + Tailwind + Prisma)
    4. Check for meta-frameworks built on top of base frameworks
    5. Consider monorepo patterns where different packages may use different frameworks
  }

  DetectionMethodology {
    Step1_PackageManagerDetection {
      Check for package manager indicators in the project root:

      | File | Package Manager | Ecosystem |
      |------|-----------------|-----------|
      | `package-lock.json` | npm | Node.js |
      | `yarn.lock` | Yarn | Node.js |
      | `pnpm-lock.yaml` | pnpm | Node.js |
      | `bun.lockb` | Bun | Node.js |
      | `requirements.txt` | pip | Python |
      | `Pipfile.lock` | pipenv | Python |
      | `poetry.lock` | Poetry | Python |
      | `uv.lock` | uv | Python |
      | `Cargo.lock` | Cargo | Rust |
      | `go.sum` | Go Modules | Go |
      | `Gemfile.lock` | Bundler | Ruby |
      | `composer.lock` | Composer | PHP |
    }

    Step2_ConfigurationFileAnalysis {
      Examine root-level configuration files for framework indicators:

      1. **Read `package.json`** - Check `dependencies` and `devDependencies` for framework packages
      2. **Read `pyproject.toml`** - Check `[project.dependencies]` or `[tool.poetry.dependencies]`
      3. **Read framework-specific configs** - `next.config.js`, `vite.config.ts`, `angular.json`, etc.
    }

    Step3_DirectoryStructurePatterns {
      Identify framework conventions:

      - `app/` or `src/app/` - Next.js App Router, Angular
      - `pages/` - Next.js Pages Router, Nuxt.js
      - `components/` - React/Vue component-based architecture
      - `routes/` - Remix, SvelteKit
      - `views/` - Django, Rails, Laravel
      - `controllers/` - MVC frameworks (Rails, Laravel, NestJS)
    }

    Step4_FrameworkSpecificPatterns {
      Apply detection patterns from the framework signatures reference.
    }
  }

  OutputFormat {
    When reporting detected framework, include:

    1. **Framework name and version** (if determinable)
    2. **Package manager** (with command examples)
    3. **Key configuration files** to be aware of
    4. **Directory conventions** the framework expects
    5. **Common commands** for development workflow
  }
}

## References

See [framework-signatures.md](references/framework-signatures.md) for comprehensive detection patterns for all major frameworks.
