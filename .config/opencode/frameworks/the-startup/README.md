# The Startup - OpenCode Framework

> Migrated from [the-startup](https://github.com/rsmdt/the-startup) v3.2.1 (formerly a Claude Code plugin) to OpenCode framework format.

A multi-agent framework for software development providing 35 specialized agents, 42 reusable skills, and 10 workflow commands.

---

## Agents

35 agents organized into 6 teams plus 2 top-level coordinators.

### Top-Level Agents

| Agent | File | Purpose |
| --- | --- | --- |
| The Chief | `agent/the-chief.md` | Rapid complexity assessment, routes work to specialists, identifies parallel execution |
| The Meta-Agent | `agent/the-meta-agent.md` | Designs and generates new sub-agents, validates agent specifications |

### The Analyst (4 agents)

| Agent | Purpose |
| --- | --- |
| `feature-prioritization` | Prioritize features, evaluate trade-offs, establish success metrics |
| `market-research` | Research market context, analyze competitors, evaluate positioning |
| `project-coordination` | Break down projects, identify dependencies, coordinate work streams |
| `requirements-analysis` | Clarify requirements, document specifications, define acceptance criteria |

### The Architect (7 agents)

| Agent | Purpose |
| --- | --- |
| `compatibility-review` | Review for breaking changes, API contracts, schema compatibility |
| `complexity-review` | Review for unnecessary complexity, over-engineering, YAGNI violations |
| `quality-review` | Architecture and code quality review, security assessments |
| `security-review` | Security vulnerabilities, injection prevention, auth issues |
| `system-architecture` | Design scalable systems, technology selection, deployment architecture |
| `system-documentation` | Architectural docs, ADRs, integration guides, runbooks |
| `technology-research` | Research solutions, evaluate technologies, proof-of-concept development |

### The Designer (4 agents)

| Agent | Purpose |
| --- | --- |
| `accessibility-implementation` | WCAG compliance, screen reader support |
| `design-foundation` | Design systems, component libraries, style guides |
| `interaction-architecture` | Navigation, user flows, wireframes |
| `user-research` | User interviews, usability testing, persona creation |

### The Software Engineer (5 agents)

| Agent | Purpose |
| --- | --- |
| `api-development` | REST/GraphQL APIs, documentation, SDK generation |
| `component-development` | UI components, state management patterns |
| `concurrency-review` | Race conditions, deadlocks, async anti-patterns |
| `domain-modeling` | Business domains, entities, persistence design |
| `performance-optimization` | Bundle size, rendering, memory usage |

### The Platform Engineer (9 agents)

| Agent | Purpose |
| --- | --- |
| `ci-cd-pipelines` | CI/CD pipelines, deployment strategies, rollback |
| `containerization` | Docker images, Kubernetes deployments, container workflows |
| `data-architecture` | Schema modeling, migration planning, storage optimization |
| `dependency-review` | Dependencies for security, licenses, supply chain risks |
| `deployment-automation` | CI/CD pipelines, blue-green/canary deployments |
| `infrastructure-as-code` | Terraform, CloudFormation, Pulumi modules |
| `performance-tuning` | System profiling, database optimization, capacity planning |
| `pipeline-engineering` | ETL/ELT workflows, stream processing, data quality |
| `production-monitoring` | Metrics, logging, alerting, SLI/SLO definition |

### The QA Engineer (4 agents)

| Agent | Purpose |
| --- | --- |
| `exploratory-testing` | Manual testing, edge case discovery, usability validation |
| `performance-testing` | Load testing, stress testing, capacity planning |
| `quality-assurance` | Test design, automation, edge case discovery, coverage |
| `test-execution` | Test strategy, automation implementation, coverage analysis |

---

## Commands (10)

Workflow commands invoked via `/command-name`:

| Command | Description |
| --- | --- |
| `/analyze` | Discover business rules, patterns, and interfaces |
| `/constitution` | Create and validate project governance rules |
| `/debug` | Systematic bug diagnosis through conversation |
| `/document` | Generate documentation for code and APIs |
| `/implement` | Execute implementation plans phase-by-phase |
| `/refactor` | Safe code refactoring with behavior preservation |
| `/review` | Multi-agent code review (security, performance, quality, tests) |
| `/simplify` | Simplify code for clarity while preserving functionality |
| `/specify` | Create specifications (PRD, SDD, implementation plan) |
| `/validate` | Validate specifications or implementations |

---

## Skills (42)

Reusable expertise modules loaded by agents via YAML frontmatter configuration.

### Cross-Cutting (8)

Universal skills available to all agents:

| Skill | Purpose |
| --- | --- |
| `codebase-navigation` | Navigate and understand project structures |
| `coding-conventions` | Security, performance, accessibility standards |
| `documentation-extraction` | Interpret docs, READMEs, specs, configs |
| `error-recovery` | Error patterns, validation, recovery strategies |
| `feature-prioritization` | RICE/MoSCoW frameworks, KPIs, roadmaps |
| `pattern-detection` | Identify existing codebase patterns |
| `requirements-elicitation` | Gather and clarify requirements |
| `tech-stack-detection` | Auto-detect project tech stacks |

### Design (3)

| Skill | Purpose |
| --- | --- |
| `accessibility-design` | WCAG 2.1 AA compliance, keyboard navigation |
| `user-insight-synthesis` | Interview techniques, persona creation |
| `user-research` | Research planning, participant recruitment |

### Development (5)

| Skill | Purpose |
| --- | --- |
| `api-contract-design` | REST/GraphQL patterns, OpenAPI specs |
| `architecture-selection` | Architecture decision frameworks |
| `data-modeling` | Schema design, entity relationships |
| `domain-driven-design` | DDD patterns, bounded contexts |
| `technical-writing` | ADRs, system docs, runbooks |

### Infrastructure (2)

| Skill | Purpose |
| --- | --- |
| `deployment-pipeline-design` | Pipeline design, deployment strategies |
| `observability-design` | Monitoring, distributed tracing, SLI/SLO |

### Quality (7)

| Skill | Purpose |
| --- | --- |
| `code-quality-review` | Code smells, design patterns |
| `code-review` | Multi-agent code review coordination |
| `performance-analysis` | Profiling, bottleneck identification |
| `security-assessment` | OWASP patterns, vulnerability review |
| `test-design` | Test pyramid, coverage strategies |
| `testing` | Writing and running effective tests |
| `vibe-security` | Secure web app coding, OWASP compliance, XSS/CSRF/SSRF protection |

### Specification and Workflow (17)

| Skill | Purpose |
| --- | --- |
| `agent-coordination` | Execute implementation plans phase-by-phase |
| `architecture-design` | Create and validate solution design docs |
| `bug-diagnosis` | Scientific debugging methodology |
| `codebase-analysis` | Discover patterns through iterative analysis |
| `constitution-validation` | Create and validate project governance rules |
| `context-preservation` | Preserve session context across conversations |
| `documentation-sync` | Maintain documentation freshness |
| `drift-detection` | Detect spec/implementation divergence |
| `git-workflow` | Manage git operations for spec development |
| `implementation-planning` | Create and validate implementation plans |
| `implementation-verification` | Validate implementation against specs |
| `knowledge-capture` | Document business rules and patterns |
| `requirements-analysis` | Create and validate PRDs |
| `safe-refactoring` | Systematic code refactoring |
| `specification-management` | Initialize and manage spec directories |
| `specification-validation` | Validate specs for completeness |
| `task-delegation` | Generate structured agent prompts |

---

## Directory Structure

```
the-startup/
  agent/
    the-chief.md
    the-meta-agent.md
    the-analyst/          (4 agents)
    the-architect/        (7 agents)
    the-designer/         (4 agents)
    the-software-engineer/ (5 agents)
    the-platform-engineer/ (9 agents)
    the-qa-engineer/      (4 agents)
  command/                (10 commands)
  skill/                  (42 skills, each with SKILL.md)
  docs/
```

---

## Usage

### Invoking Commands

```
/specify "user authentication feature"
/review staged
/debug "login fails with 401 error"
/analyze security
```

### Agent Selection

Agents are automatically selected based on task type, or explicitly using `@agent-name` mentions.

### Skill Loading

Skills are loaded automatically based on agent configuration in YAML frontmatter:

```yaml
skills: codebase-navigation, tech-stack-detection, pattern-detection
```

### Specification Workflow

The recommended development workflow:

1. `/specify` - Create PRD, SDD, and implementation plan
2. `/validate` - Validate specification quality
3. `/implement` - Execute the plan phase-by-phase
4. `/review` - Multi-agent code review
