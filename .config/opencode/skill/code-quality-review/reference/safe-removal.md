# Safe Removal Protocol

Verification protocol for destructive code changes — dead code removal, dependency removal, unexport operations, and file deletion.

## Core Principle

**Prove safety before acting.** Every removal must pass independent verification signals. When in doubt, keep the code and flag it for manual review.

## Export Removal Verification

Before removing or unexporting any symbol, collect three independent signals:

| Signal | Method | Safe When |
|--------|--------|-----------|
| Static imports | Grep `import.*{symbolName}` and `require.*symbolName` across ALL files | Zero matches outside declaring file |
| Re-exports | Grep `export.*{symbolName}.*from` and `export \*` in index/barrel files | Zero re-export matches |
| Dynamic references | Grep string literals `"symbolName"`, bracket access `[symbolName]`, reflection | Zero dynamic matches |

**Verdict**: Remove ONLY when all three signals show zero usage.

## Dependency Removal Verification

Before removing a package from dependencies:

| Check | Method | Safe When |
|-------|--------|-----------|
| Direct imports | Grep package name in all source files | Zero import/require matches |
| Build tool usage | Check webpack/vite/rollup/esbuild configs, scripts in package.json | Not referenced in build pipeline |
| Peer dependency | Check if other packages require it as peer | Not a required peer |
| Runtime config | Check env files, config files, docker-compose | Not referenced at runtime |
| Transitive | Check if direct deps re-export or depend on it | Not transitively needed |

**Critical**: `devDependencies` used by build tools (bundlers, linters, transpilers, test runners) are NOT dead code.

## File Deletion Verification

Before deleting a file:

| Check | Method | Safe When |
|-------|--------|-----------|
| Import graph | Grep for import/require of the file path | Zero imports from other files |
| Dynamic imports | Grep for lazy/dynamic imports using the file name | Zero dynamic import matches |
| Config references | Check route configs, webpack aliases, test configs | Not referenced in configs |
| Assets | Check if images/styles/fonts are referenced in templates/HTML | Not referenced |

## Common False Positives

| Pattern | Why It's Not Dead | How to Detect |
|---------|-------------------|---------------|
| Plugin entry points | Framework loads them dynamically | Check framework config (routes, plugins, middleware) |
| Event handlers | Registered via string-based event systems | Grep event name strings |
| Reflection targets | Accessed via `Object.keys`, decorators, DI containers | Check DI config, decorator usage |
| Template bindings | Referenced in HTML/JSX string templates | Check template files |
| CLI commands | Loaded dynamically by CLI framework | Check CLI registration |
| Test helpers | Only imported in test files | Must grep test files too |
| Type-only exports | Used in type position only (`import type`) | Grep for `import type.*{symbolName}` |

## Batch Removal Protocol

1. **Maximum 5 removals per batch** — catches false positives early
2. **Run build after each batch** — compilation errors surface immediately
3. **Run tests after each batch** — behavioral regressions surface immediately
4. **Revert entire batch on failure** — isolate which candidate caused the break
5. **Move false positive to KEEP list** — retry remaining candidates

## Red Flags — Stop and Investigate

- Symbol has `@public` or `@api` JSDoc tag
- Symbol is in a package's main entry point
- File is referenced in `package.json` exports/main/types fields
- Dependency is listed in multiple packages in a monorepo
- Code has a `TODO` or `FIXME` comment explaining why it exists
