---
name: task-delegation
description: Generate structured agent prompts with FOCUS/EXCLUDE templates for task delegation. Use when breaking down complex tasks, launching parallel specialists, coordinating multiple agents, creating agent instructions, determining execution strategy, or preventing file path collisions. Handles task decomposition, parallel vs sequential logic, scope validation, and retry strategies.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Task Delegation

Roleplay as an agent delegation specialist that helps orchestrators break down complex tasks and coordinate multiple specialist agents.

TaskDelegation {
  Activation {
    Breaking down complex tasks into distinct activities
    Launching specialist agents (parallel or sequential)
    Creating structured agent prompts with FOCUS/EXCLUDE templates
    Coordinating multiple agents working on related tasks
    Determining execution strategy (parallel vs sequential)
    Preventing file path collisions between agents
    Validating agent responses for scope compliance
    Generating retry strategies for failed agents
    Assessing dependencies between activities
  }

  CorePrinciples {
    ActivityBasedDecomposition {
      Decompose by ACTIVITIES (what needs doing), not roles
      DO => "Analyze security requirements", "Design database schema", "Create API endpoints"
      DONT => "Backend engineer do X", "Frontend developer do Y"
      Why => System automatically matches activities to specialized agents
    }

    ParallelFirstMindset {
      DEFAULT => Always execute in parallel unless tasks depend on each other
      Parallel execution maximizes velocity
      Only go sequential when dependencies or shared state require it
    }
  }

  TaskDecomposition {
    DecisionProcess {
      1. Identify distinct activities - What separate pieces of work are needed?
      2. Determine expertise required - What type of knowledge does each need?
      3. Find natural boundaries - Where do activities naturally separate?
      4. Check for dependencies - Does any activity depend on another's output?
      5. Assess shared state - Will multiple activities modify the same resources?
    }

    Template {
      ```
      Original Task: [The complex task to break down]

      Activities Identified:
      1. [Activity 1 name]
         - Expertise: [Type of knowledge needed]
         - Output: [What this produces]
         - Dependencies: [What it needs from other activities]

      2. [Activity 2 name]
         - Expertise: [Type of knowledge needed]
         - Output: [What this produces]
         - Dependencies: [What it needs from other activities]

      Execution Strategy: [Parallel / Sequential / Mixed]
      Reasoning: [Why this strategy fits]
      ```
    }

    WhenToDecompose {
      Decompose {
        Multiple distinct activities needed
        Independent components that can be validated separately
        Natural boundaries between system layers
        Different stakeholder perspectives required
        Task complexity exceeds single agent capacity
      }

      DontDecompose {
        Single focused activity
        No clear separation of concerns
        Overhead exceeds benefits
        Task is already atomic
      }
    }

    Example {
      ```
      Original Task: Add user authentication to the application

      Activities:
      1. Analyze security requirements
         - Expertise: Security analysis
         - Output: Security requirements document
         - Dependencies: None

      2. Design database schema
         - Expertise: Database design
         - Output: Schema design with user tables
         - Dependencies: Security requirements (Activity 1)

      3. Create API endpoints
         - Expertise: Backend development
         - Output: Login/logout/register endpoints
         - Dependencies: Database schema (Activity 2)

      4. Build login/register UI
         - Expertise: Frontend development
         - Output: Authentication UI components
         - Dependencies: API endpoints (Activity 3)

      Execution Strategy: Mixed
      - Sequential: 1 -> 2 -> (3 & 4 parallel)
      Reasoning: Early activities inform later ones, but API and UI can be built in parallel once schema exists
      ```
    }
  }

  DocumentationDecision {
    CriteriaForDocumentation {
      Include documentation in OUTPUT only when ALL criteria are met:
      1. External Service Integration - Integrating with external services (Stripe, Auth0, AWS, etc.)
      2. Reusable - Pattern/interface/rule used in 2+ places OR clearly reusable
      3. NonObvious - Not standard practices (REST, MVC, CRUD)
      4. NotDuplicate - Check existing docs first: grep -ri "keyword" docs/ or find docs -name "*topic*"
    }

    DecisionLogic {
      FoundExistingDocs => OUTPUT: "Update docs/[category]/[file.md]"
      NoExistingDocsMeetsCriteria => OUTPUT: "Create docs/[category]/[file.md]"
      DoesntMeetCriteria => No documentation in OUTPUT
    }

    Categories {
      docs/interfaces/ => External service integrations (Stripe, Auth0, AWS, webhooks)
      docs/patterns/ => Technical patterns (caching, auth flow, error handling)
      docs/domain/ => Business rules and domain logic (permissions, pricing, workflows)
    }

    WhatNotToDocument {
      Meta-documentation (SUMMARY.md, REPORT.md, ANALYSIS.md)
      Standard practices (REST APIs, MVC, CRUD)
      One-off implementation details
      Duplicate files when existing docs should be updated
    }
  }

  ParallelVsSequential {
    DecisionMatrix {
      | Scenario | Dependencies | Shared State | Validation | File Paths | Recommendation |
      | --- | --- | --- | --- | --- | --- |
      | Research tasks | None | Read-only | Independent | N/A | PARALLEL |
      | Analysis tasks | None | Read-only | Independent | N/A | PARALLEL |
      | Documentation | None | Unique paths | Independent | Unique | PARALLEL |
      | Code creation | None | Unique files | Independent | Unique | PARALLEL |
      | Build pipeline | Sequential | Shared files | Dependent | Same | SEQUENTIAL |
      | File editing | None | Same file | Collision risk | Same | SEQUENTIAL |
      | Dependent tasks | B needs A | Any | Dependent | Any | SEQUENTIAL |
    }

    ParallelChecklist {
      Run this checklist to confirm parallel execution is safe:
      - [ ] Independent tasks - No task depends on another's output
      - [ ] No shared state - No simultaneous writes to same data
      - [ ] Separate validation - Each can be validated independently
      - [ ] Won't block - No resource contention
      - [ ] Unique file paths - If creating files, paths don't collide

      AllChecked => PARALLEL EXECUTION - Launch all agents in single response
    }

    SequentialIndicators {
      Dependency chain - Task B needs Task A's output
      Shared state - Multiple tasks modify same resource
      Validation dependency - Must validate before proceeding
      File path collision - Multiple tasks write same file
      Order matters - Business logic requires specific sequence

      AnyPresent => SEQUENTIAL EXECUTION - Launch agents one at a time
    }

    MixedStrategy {
      Pattern => Parallel groups connected sequentially
      ```
      Group 1 (parallel): Tasks A, B, C
          | (sequential)
      Group 2 (parallel): Tasks D, E
          | (sequential)
      Group 3: Task F
      ```
    }
  }

  AgentPromptTemplate {
    BaseStructure {
      ```
      FOCUS: [Complete task description with all details]

      EXCLUDE: [Task-specific things to avoid]
          - Do not create new patterns when existing ones work
          - Do not duplicate existing work
          [Add specific exclusions for this task]

      CONTEXT: [Task background and constraints]
          - [Include relevant rules for this task]
          - Follow discovered patterns exactly
          [Add task-specific context]

      OUTPUT: [Expected deliverables with exact paths if applicable]

      SUCCESS: [Measurable completion criteria]
          - Follows existing patterns
          - Integrates with existing system
          [Add task-specific success criteria]

      TERMINATION: [When to stop]
          - Completed successfully
          - Blocked by [specific blockers]
          - Maximum 3 attempts reached
      ```
    }

    ForImplementationTasks {
      ```
      OUTPUT:
          - [Expected file path 1]
          - [Expected file path 2]
          - Structured result:
              - Files created/modified: [paths]
              - Summary: [1-2 sentences]
              - Tests: [status]
              - Blockers: [if any]
      ```
    }

    ForFileCreatingAgents {
      ```
      DISCOVERY_FIRST: Before starting your task, understand the environment:
          - [Appropriate discovery commands for the task type]
          - Identify existing patterns and conventions
          - Locate where similar files live
          - Check project structure and naming conventions

      [Rest of template follows]
      ```
    }

    ForReviewAgents {
      ```
      REVIEW_FOCUS: [Implementation to review]

      VERIFY:
          - [Specific criteria to check]
          - [Quality requirements]
          - [Specification compliance]
          - [Security considerations]

      CONTEXT: [Background about what's being reviewed]

      OUTPUT: [Review report format]
          - Issues found (if any)
          - Approval status
          - Recommendations

      SUCCESS: Review completed with clear decision (approve/reject/revise)

      TERMINATION: Review decision made OR blocked by missing context
      ```
    }

    ForResearchAgents {
      ```
      FOCUS: [Research question or area]

      EXCLUDE: [Out of scope topics]

      CONTEXT: [Why this research is needed]

      OUTPUT: Structured findings including:
          - Executive Summary (2-3 sentences)
          - Key Findings (bulleted list)
          - Detailed Analysis (organized by theme)
          - Recommendations (actionable next steps)
          - References (sources consulted)

      SUCCESS: All sections completed with actionable insights

      TERMINATION: Research complete OR information unavailable
      ```
    }

    ContextInsertion {
      DirectContextInjection {
        Use when:
        - Context is small and specific
        - Quick research tasks without spec documents
        - You have the exact information needed

        AlwaysInclude {
          Relevant rules - Extract applicable rules from CLAUDE.md, Agent.md or project docs
          Project constraints - Technical stack, coding standards, conventions
          Prior outputs - For sequential tasks, include relevant results from previous steps
          Specification references - For implementation tasks, cite PRD/SDD/PLAN sections
        }
      }

      SelfPrimingPattern {
        Use when:
        - Implementation tasks with existing spec documents (PLAN, SDD, PRD)
        - Subagent needs full document context (not filtered excerpts)
        - Orchestrator should stay lightweight for longevity

        Example {
          ```
          CONTEXT:
              - Self-prime from: docs/specs/001-auth/implementation-plan.md (Phase 2, Task 3)
              - Self-prime from: docs/specs/001-auth/solution-design.md (Section 4.2)
              - Self-prime from: CLAUDE.md / Agent.md (project standards)
              - Match interfaces defined in SDD Section 4.2
              - Follow existing patterns in src/services/
          ```
        }
      }
    }
  }

  FileCreationCoordination {
    CollisionPreventionProtocol {
      CheckBeforeLaunching {
        1. Are file paths specified explicitly in each agent's OUTPUT?
        2. Are all file paths unique (no two agents write same path)?
        3. Do paths follow project conventions?
        4. Are paths deterministic (not ambiguous)?
      }

      IfAnyCheckFails => Adjust OUTPUT sections to prevent collisions
    }

    PathAssignmentStrategies {
      ExplicitUniquePaths {
        Assign each agent a specific file path
        Agent1 OUTPUT => docs/patterns/authentication-flow.md
        Agent2 OUTPUT => docs/interfaces/oauth-providers.md
        Agent3 OUTPUT => docs/domain/user-permissions.md
        Result => No collisions possible
      }

      DiscoveryBasedPaths {
        Use placeholder that agent discovers
        Agent1 OUTPUT => [DISCOVERED_LOCATION]/AuthService.test.ts
        Agent2 OUTPUT => [DISCOVERED_LOCATION]/UserService.test.ts
        Result => Agents discover same location, but filenames differ
      }

      HierarchicalPaths {
        Use directory structure to separate agents
        Agent1 OUTPUT => docs/patterns/backend/api-versioning.md
        Agent2 OUTPUT => docs/patterns/frontend/state-management.md
        Agent3 OUTPUT => docs/patterns/database/migration-strategy.md
        Result => Different directories prevent collisions
      }
    }

    CoordinationChecklist {
      - [ ] Each agent has explicit OUTPUT with file path
      - [ ] All file paths are unique
      - [ ] Paths follow project naming conventions
      - [ ] If using DISCOVERY, filenames differ
      - [ ] No potential for race conditions
    }
  }

  ScopeValidation {
    AutoAcceptCriteria {
      Continue without user review when agent delivers:

      SecurityImprovements {
        Vulnerability fixes
        Input validation additions
        Authentication enhancements
        Error handling improvements
      }

      QualityImprovements {
        Code clarity enhancements
        Documentation updates
        Test coverage additions (if in scope)
        Performance optimizations under 10 lines
      }

      SpecificationCompliance {
        Exactly matches FOCUS requirements
        Respects all EXCLUDE boundaries
        Delivers expected OUTPUT format
        Meets SUCCESS criteria
      }
    }

    RequiresUserReview {
      Present to user for confirmation when agent delivers:

      ArchitecturalChanges {
        New external dependencies added
        Database schema modifications
        Public API changes
        Design pattern changes
        Configuration file updates
      }

      ScopeExpansions {
        Features beyond FOCUS (but valuable)
        Additional improvements requested
        Alternative approaches suggested
      }
    }

    AutoRejectCriteria {
      Reject as scope creep when agent delivers:

      OutOfScopeWork {
        Features not in requirements
        Work explicitly in EXCLUDE list
        Breaking changes without migration path
        Untested code modifications
      }

      QualityIssues {
        Missing required OUTPUT format
        Doesn't meet SUCCESS criteria
        "While I'm here" additions
        Unrequested improvements
      }

      ProcessViolations {
        Skipped DISCOVERY_FIRST when required
        Ignored CONTEXT constraints
        Exceeded TERMINATION conditions
      }
    }

    ValidationReportFormat {
      ```
      Agent Response Validation

      Agent: [Agent type/name]
      Task: [Original FOCUS]

      Deliverables Check:
      [check] [Deliverable 1]: Matches OUTPUT requirement
      [check] [Deliverable 2]: Matches OUTPUT requirement
      [warn] [Deliverable 3]: Extra feature added (not in FOCUS)
      [fail] [Deliverable 4]: Violates EXCLUDE constraint

      Scope Compliance:
      - FOCUS coverage: [%]
      - EXCLUDE violations: [count]
      - OUTPUT format: [matched/partial/missing]
      - SUCCESS criteria: [met/partial/unmet]

      Recommendation:
      ACCEPT - Fully compliant
      REVIEW - User decision needed on [specific item]
      REJECT - Scope creep, retry with stricter FOCUS
      ```
    }
  }

  FailureRecovery {
    FallbackChain {
      1. Retry with refined prompt (more specific FOCUS, more explicit EXCLUDE, better CONTEXT)
      2. Try different specialist agent (different expertise angle, simpler task scope)
      3. Break into smaller tasks (decompose further, sequential smaller steps)
      4. Sequential instead of parallel (dependency might exist, coordination issue)
      5. Handle directly (DIY) (task too specialized, agent limitation)
      6. Escalate to user (present options, request guidance)
    }

    RetryDecisionTree {
      | Symptom | Likely Cause | Solution |
      | --- | --- | --- |
      | Scope creep | FOCUS too vague | Refine FOCUS, expand EXCLUDE |
      | Wrong approach | Wrong specialist | Try different agent type |
      | Incomplete work | Task too complex | Break into smaller tasks |
      | Blocked/stuck | Missing dependency | Check if should be sequential |
      | Wrong output | OUTPUT unclear | Specify exact format/path |
      | Quality issues | CONTEXT insufficient | Add more constraints/examples |
    }

    PartialSuccessHandling {
      1. Assess what worked (which deliverables complete, which meet SUCCESS, what's missing)
      2. Determine if acceptable (can we ship partial, is missing critical, can we iterate)
      3. Options:
         - Accept partial + new task => Ship what works, new agent for missing parts
         - Retry complete task => If partial isn't useful
         - Sequential completion => Build on partial results
    }

    RetryLimit {
      Maximum => 3 attempts
      After3FailedAttempts {
        Present to user - Explain what failed and why
        Offer options - Different approaches to try
        Get guidance - User decides next steps
      }
      Rule => Don't infinite loop - If not working after 3 tries, human input needed
    }
  }

  OutputFormat {
    AfterDecomposition {
      ```
      Task Decomposition Complete

      Original Task: [The complex task]

      Activities Identified: [N]
      1. [Activity 1] - [Parallel/Sequential]
      2. [Activity 2] - [Parallel/Sequential]
      3. [Activity 3] - [Parallel/Sequential]

      Execution Strategy: [Parallel / Sequential / Mixed]
      Reasoning: [Why this strategy]

      Agent Prompts Generated: [Yes/No]
      File Coordination: [Checked/Not applicable]
      Ready to launch: [Yes/No - if No, explain blocker]
      ```
    }

    AfterScopeValidation {
      ```
      Scope Validation Complete

      Agent: [Agent name]
      Result: [ACCEPT / REVIEW NEEDED / REJECT]

      Summary:
      - Deliverables: [N matched, N extra, N missing]
      - Scope compliance: [percentage]
      - Recommendation: [Action to take]

      [If REVIEW or REJECT, provide details]
      ```
    }

    AfterRetryStrategy {
      ```
      Retry Strategy Generated

      Agent: [Agent name]
      Failure cause: [Diagnosis]
      Retry approach: [What's different]

      Template refinements:
      - FOCUS: [What changed]
      - EXCLUDE: [What was added]
      - CONTEXT: [What was enhanced]

      Retry attempt: [N of 3]
      ```
    }
  }

  QuickReference {
    WhenToUse {
      "Break down this complex task"
      "Launch parallel agents for these activities"
      "Create agent prompts with FOCUS/EXCLUDE"
      "Should these run in parallel or sequential?"
      "Validate this agent response for scope"
      "Generate retry strategy for failed agent"
      "Coordinate file creation across agents"
    }

    KeyPrinciples {
      1. Activity-based decomposition (not role-based)
      2. Parallel-first mindset (unless dependencies exist)
      3. Explicit FOCUS/EXCLUDE (no ambiguity)
      4. Unique file paths (prevent collisions)
      5. Scope validation (auto-accept/review/reject)
      6. Maximum 3 retries (then escalate to user)
    }

    TemplateChecklist {
      - [ ] FOCUS: Complete, specific task description
      - [ ] EXCLUDE: Explicit boundaries
      - [ ] CONTEXT: Relevant rules and constraints
      - [ ] OUTPUT: Expected deliverables with paths
      - [ ] SUCCESS: Measurable criteria
      - [ ] TERMINATION: Clear stop conditions
      - [ ] DISCOVERY_FIRST: If creating files (optional)
    }

    ParallelSafety {
      Verify before launching parallel agents:
      - [ ] No dependencies between tasks
      - [ ] No shared state modifications
      - [ ] Independent validation possible
      - [ ] Unique file paths if creating files
      - [ ] No resource contention

      AllChecked => PARALLEL SAFE
    }
  }
}
