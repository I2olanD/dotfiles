# OpenCode Configuration

> This is a copy of repo [https://github.com/rsmdt/the-startup]

A comprehensive AI Agent configuration providing specialized agents, reusable skills, and workflow commands for software development.

## Structure

```
opencode/
├── agent/              # Specialized AI agents
├── command/            # Workflow commands (/slash commands)
├── skill/              # Reusable expertise modules
└── templates/          # Document templates (PRD, SDD, etc.)
```

---

## Agents

Agents are specialized AI personas that handle specific domains. They're organized into teams:

### The Chief

**File:** `agent/the-chief.md`

Project CTO that performs rapid complexity assessment and routes work to appropriate specialists. Identifies parallel execution opportunities and eliminates bottlenecks.

### The Meta-Agent

**File:** `agent/the-meta-agent.md`

Designs and generates new Claude Code sub-agents. Validates agent specifications and refactors existing agents to follow best practices.

### The Analyst Team

| Agent                    | Purpose                                                                   |
| ------------------------ | ------------------------------------------------------------------------- |
| `feature-prioritization` | Prioritize features, evaluate trade-offs, establish success metrics       |
| `project-coordination`   | Break down projects, identify dependencies, coordinate work streams       |
| `requirements-analysis`  | Clarify requirements, document specifications, define acceptance criteria |

### The Architect Team

| Agent                  | Purpose                                                                 |
| ---------------------- | ----------------------------------------------------------------------- |
| `quality-review`       | Review architecture and code quality, security assessments              |
| `system-architecture`  | Design scalable systems, technology selection, deployment architecture  |
| `system-documentation` | Create architectural docs, ADRs, integration guides, runbooks           |
| `technology-research`  | Research solutions, evaluate technologies, proof-of-concept development |

### The Designer Team

| Agent                          | Purpose                                                      |
| ------------------------------ | ------------------------------------------------------------ |
| `accessibility-implementation` | Implement WCAG compliance, screen reader support             |
| `design-foundation`            | Create design systems, component libraries, style guides     |
| `interaction-architecture`     | Design navigation, user flows, wireframes                    |
| `user-research`                | Conduct user interviews, usability testing, persona creation |

### The Software Engineer Team

| Agent                      | Purpose                                                 |
| -------------------------- | ------------------------------------------------------- |
| `api-development`          | Design REST/GraphQL APIs, documentation, SDK generation |
| `component-development`    | Design UI components, state management patterns         |
| `domain-modeling`          | Model business domains, entities, persistence design    |
| `performance-optimization` | Optimize bundle size, rendering, memory usage           |

### The Platform Engineer Team

| Agent                    | Purpose                                                    |
| ------------------------ | ---------------------------------------------------------- |
| `containerization`       | Docker images, Kubernetes deployments, container workflows |
| `data-architecture`      | Schema modeling, migration planning, storage optimization  |
| `deployment-automation`  | CI/CD pipelines, blue-green/canary deployments             |
| `infrastructure-as-code` | Terraform, CloudFormation, Pulumi modules                  |
| `performance-tuning`     | System profiling, database optimization, capacity planning |
| `pipeline-engineering`   | ETL/ELT workflows, stream processing, data quality         |
| `production-monitoring`  | Metrics, logging, alerting, SLI/SLO definition             |

### The QA Engineer Team

| Agent                 | Purpose                                                     |
| --------------------- | ----------------------------------------------------------- |
| `exploratory-testing` | Manual testing, edge case discovery, usability validation   |
| `performance-testing` | Load testing, stress testing, capacity planning             |
| `test-execution`      | Test strategy, automation implementation, coverage analysis |

---

## Commands

Workflow commands invoked via `/command-name`:

| Command      | Description                                                     |
| ------------ | --------------------------------------------------------------- |
| `/specify`   | Create specifications (PRD → SDD → PLAN workflow)               |
| `/implement` | Execute implementation plans phase-by-phase                     |
| `/review`    | Multi-agent code review (security, performance, quality, tests) |
| `/analyze`   | Discover business rules, patterns, and interfaces               |
| `/debug`     | Systematic bug diagnosis through conversation                   |
| `/refactor`  | Safe code refactoring with behavior preservation                |
| `/validate`  | Validate specifications or implementations                      |
| `/document`  | Generate documentation for code and APIs                        |
| `/init`      | Initialize configuration                                        |

---

## Skills

Reusable expertise modules loaded by agents. Organized by category:

### Cross-Cutting Skills

Universal skills available to all agents:

| Skill                      | Purpose                                         |
| -------------------------- | ----------------------------------------------- |
| `codebase-navigation`      | Navigate and understand project structures      |
| `coding-conventions`       | Security, performance, accessibility standards  |
| `documentation-extraction` | Interpret docs, READMEs, specs, configs         |
| `error-recovery`           | Error patterns, validation, recovery strategies |
| `feature-prioritization`   | RICE/MoSCoW frameworks, KPIs, roadmaps          |
| `pattern-detection`        | Identify existing codebase patterns             |
| `requirements-elicitation` | Gather and clarify requirements                 |
| `tech-stack-detection`     | Auto-detect project tech stacks                 |

### Design Skills

| Skill                    | Purpose                                     |
| ------------------------ | ------------------------------------------- |
| `accessibility-design`   | WCAG 2.1 AA compliance, keyboard navigation |
| `user-insight-synthesis` | Interview techniques, persona creation      |
| `user-research`          | Research planning, participant recruitment  |

### Development Skills

| Skill                    | Purpose                              |
| ------------------------ | ------------------------------------ |
| `api-contract-design`    | REST/GraphQL patterns, OpenAPI specs |
| `architecture-selection` | Architecture decision frameworks     |
| `data-modeling`          | Schema design, entity relationships  |
| `domain-driven-design`   | DDD patterns, bounded contexts       |
| `technical-writing`      | ADRs, system docs, runbooks          |
| `test-design`            | Test pyramid, coverage strategies    |

### Infrastructure Skills

| Skill                        | Purpose                                  |
| ---------------------------- | ---------------------------------------- |
| `deployment-pipeline-design` | Pipeline design, deployment strategies   |
| `observability-design`       | Monitoring, distributed tracing, SLI/SLO |

### Quality Skills

| Skill                  | Purpose                              |
| ---------------------- | ------------------------------------ |
| `code-quality-review`  | Code smells, design patterns         |
| `exploratory-testing`  | Manual testing methodologies         |
| `performance-analysis` | Profiling, bottleneck identification |
| `security-assessment`  | OWASP patterns, vulnerability review |
| `test-strategy-design` | Test planning, framework selection   |

---

## Templates

Document templates in `templates/`:

- `product-requirements.md` - PRD template
- `solution-design.md` - SDD template
- `implementation-plan.md` - Implementation plan template
- `definition-of-done.md` - DoD checklist
- `definition-of-ready.md` - DoR checklist
- `task-definition-of-done.md` - Task-level DoD

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

Agents are automatically selected based on task type, or explicitly via the Task tool with `subagent_type`.

### Skill Loading

Skills are loaded automatically based on agent configuration in YAML frontmatter:

```yaml
skills: codebase-navigation, tech-stack-detection, pattern-detection
```

---

## Specification Workflow

The recommended development workflow:

1. `/specify` - Create PRD, SDD, and implementation plan
2. `/validate` - Validate specification quality
3. `/implement` - Execute the plan phase-by-phase
4. `/review` - Multi-agent code review
