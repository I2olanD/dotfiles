# Exploration Patterns Examples

Practical examples demonstrating codebase exploration strategies for common scenarios.

## Example 1: Onboarding to a New Project

### Context

You have been assigned to work on an unfamiliar codebase. You need to understand its structure, tech stack, and conventions before making changes.

### Pattern

```bash
# Step 1: Read existing documentation first
read: README.md
read: CLAUDE.md (if exists)

# Step 2: Identify tech stack from config files
glob: package.json | requirements.txt | go.mod | Cargo.toml

# Step 3: Map source structure
glob: **/src/**/*.{ts,js,py,go}

# Step 4: Find entry points
glob: **/index.{ts,js} | **/main.{ts,js,py,go}

# Step 5: Locate tests to understand expected behaviors
glob: **/*.test.{ts,js} | **/*.spec.{ts,js} | **/test_*.py
```

### Explanation

1. **Documentation first** - README and CLAUDE.md often contain project-specific conventions and commands
2. **Config files reveal stack** - package.json shows Node.js, go.mod shows Go, etc.
3. **Source mapping** - understand directory organization
4. **Entry points** - find where execution begins
5. **Tests as documentation** - tests reveal expected behaviors and usage patterns

### Variations

- For monorepos: Start with `glob: **/package.json` to find all packages
- For microservices: Look for `glob: **/Dockerfile` to identify service boundaries
- For legacy code: Check `glob: **/*.sql` for database schema clues

### Anti-Patterns

- Skipping documentation and assuming structure
- Searching entire repo including node_modules/vendor
- Making changes before understanding conventions

---

## Example 2: Finding Where a Feature is Implemented

### Context

You need to modify user authentication but do not know where the code lives.

### Pattern

```
# Step 1: Search for obvious terms
grep: (auth|login|authenticate)
  glob: **/*.{ts,js,py}
  output_mode: files_with_matches

# Step 2: Find route definitions
grep: (login|signin|auth).*route
  glob: **/routes/**/*

# Step 3: Locate service/handler
grep: (AuthService|AuthHandler|authenticate)
  output_mode: content
  -C: 3

# Step 4: Trace imports to find related files
grep: import.*from.*auth
  output_mode: files_with_matches
```

### Explanation

1. **Broad search first** - Find all files mentioning authentication
2. **Route definitions** - Locate API entry points
3. **Service layer** - Find business logic implementations
4. **Import tracing** - Discover related modules and dependencies

### Variations

- For frontend: `grep: (useAuth|AuthContext|AuthProvider)`
- For database: `grep: (users|sessions).*table|schema`
- For middleware: `grep: (middleware|interceptor).*auth`

### Anti-Patterns

- Searching for single common word like "user" (too many results)
- Not narrowing scope after initial discovery
- Ignoring test files (they often show usage patterns)

---

## Example 3: Understanding Data Flow

### Context

You need to understand how data moves from API request to database and back.

### Pattern

```
# Step 1: Find API routes/handlers
grep: (app\.(get|post)|router\.(get|post)|@(Get|Post))
  glob: **/routes/**/* | **/controllers/**/*
  output_mode: content
  -C: 5

# Step 2: Find service layer calls
grep: (Service|Repository)\.(create|find|update|delete)
  output_mode: content
  -C: 3

# Step 3: Find database operations
grep: (prisma|sequelize|mongoose|typeorm)\.\w+\.(find|create|update)
  output_mode: content

# Step 4: Find data transformations
grep: (map|transform|serialize|dto)
  glob: **/{dto,mapper,transformer}/**/*
```

### Explanation

1. **Start at API boundary** - Where requests enter the system
2. **Follow to services** - Business logic layer
3. **Track to database** - Data persistence layer
4. **Find transformations** - How data changes between layers

### Variations

- For event-driven: `grep: (emit|publish|subscribe|on\()`
- For GraphQL: `grep: (Query|Mutation|Resolver)`
- For message queues: `grep: (queue|broker|consume|produce)`

### Anti-Patterns

- Starting from database and working up (harder to follow)
- Ignoring middleware transformations
- Missing async/await patterns that indicate I/O boundaries

---

## Example 4: Mapping Architecture Boundaries

### Context

You need to understand the high-level architecture to plan a refactoring effort.

### Pattern

```
# Step 1: Find module/package boundaries
glob: **/package.json | **/go.mod | **/__init__.py
  (for monorepos: shows internal packages)

# Step 2: Identify layers
glob: **/{controllers,handlers,routes}/**/*
glob: **/{services,usecases,domain}/**/*
glob: **/{repositories,dal,data}/**/*

# Step 3: Find external integrations
grep: (axios|fetch|http\.|request\()
  output_mode: files_with_matches
glob: **/{clients,integrations,adapters}/**/*

# Step 4: Map cross-cutting concerns
glob: **/{middleware,interceptors,guards}/**/*
grep: (logger|cache|metric|trace)
```

### Explanation

1. **Package boundaries** - Physical separation of concerns
2. **Architectural layers** - Presentation, business, data
3. **External boundaries** - Where system meets outside world
4. **Cross-cutting** - Shared functionality across layers

### Variations

- For microservices: Look for `glob: **/Dockerfile` and service definitions
- For modular monolith: Check for internal API contracts
- For plugin architecture: `grep: (plugin|extension|addon)`

### Anti-Patterns

- Assuming standard layer names (every project is different)
- Missing hidden dependencies through global state
- Not checking for circular dependencies

---

## Example 5: Investigating a Bug

### Context

Users report an error message: "Invalid token format". You need to find where this error originates.

### Pattern

```
# Step 1: Search for exact error message
grep: Invalid token format
  output_mode: content
  -C: 10

# Step 2: Find related error handling
grep: (throw|raise|Error).*token
  output_mode: content
  -C: 5

# Step 3: Trace the code path
# (after finding file, search for function callers)
grep: validateToken|parseToken
  output_mode: files_with_matches

# Step 4: Check test files for expected behavior
grep: Invalid token
  glob: **/*.test.{ts,js} | **/test_*.py
  output_mode: content
```

### Explanation

1. **Exact match first** - Find the error source directly
2. **Related errors** - Understand error handling context
3. **Caller analysis** - Who invokes this code
4. **Test context** - What is the expected behavior

### Variations

- For stack traces: Search for function names in the trace
- For database errors: Check migration files and schema definitions
- For runtime errors: Look for environment variable usage

### Anti-Patterns

- Guessing the source without searching
- Not checking test files for expected behavior
- Fixing symptom without understanding root cause

---

## Quick Reference: Search Strategy by Goal

| Goal | Primary Tool | Pattern |
|------|--------------|---------|
| Find file by name | glob | `**/target-name*` |
| Find file by content | grep | `pattern` with `files_with_matches` |
| Understand function | grep | Function name with `-C: 10` for context |
| Find all usages | grep | Call pattern with `files_with_matches` |
| Map directory structure | glob | `**/src/**/*` |
| Find configuration | glob | `**/*.{json,yaml,toml,env}` |
| Trace dependencies | grep | Import/require patterns |
| Find tests | glob | `**/*.test.* | **/*.spec.* | **/test_*` |
