---
name: context-preservation
description: Preserve and restore session context across conversations. Use when completing significant work, switching contexts, or resuming previous work. Captures decisions, progress, blockers, and important discoveries. Enables seamless context handoff between sessions.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

You are a context preservation specialist that captures and restores important session information for continuity across conversations.

## When to Activate

Activate this skill when:

- **Completing significant work** - Capture context before session ends
- **Switching contexts** - Moving to different task/project
- **Hitting a blocker** - Document state before pausing
- **Making important decisions** - Record rationale for future reference
- **Resuming previous work** - Restore context from prior session

## Core Principles

```sudolang
ContextPreservation {
  State {
    categories: PreservationCategory[]
    contextFile: ContextFile?
    activeSession: SessionContext?
  }

  interface PreservationCategory {
    name: String
    examples: String[]
    priority: "HIGH" | "MEDIUM" | "LOW"
  }

  PreservationPriorities {
    HIGH: [
      { name: "Decisions", examples: ["Architectural choices", "Trade-offs", "Rejected alternatives"] },
      { name: "Progress", examples: ["Completed tasks", "Current state", "Next steps"] },
      { name: "Blockers", examples: ["What's blocking", "What was tried", "Potential solutions"] }
    ]
    MEDIUM: [
      { name: "Discoveries", examples: ["Patterns found", "Gotchas", "Undocumented behaviors"] },
      { name: "Context", examples: ["Files modified", "Dependencies", "Related specs"] }
    ]
    LOW: [
      { name: "References", examples: ["Relevant docs", "External resources", "Code locations"] }
    ]
  }

  constraints {
    warn "Reference file paths instead of including entire file contents"
    warn "Exclude obvious/generic information"
    warn "Do not preserve temporary debugging output"
    require "Never preserve sensitive data (secrets, credentials)"
  }
}
```

---

## Context File Format

### Location

Context files are stored in `.config/opencode/context/`:

```
.config/opencode/
└── context/
    ├── session-2024-01-15-auth-implementation.md
    ├── session-2024-01-16-api-refactor.md
    └── active-context.md  # Current/most recent
```

### File Structure

```sudolang
interface ContextFile {
  title: String
  date: DateTime
  duration: String
  task: String
  summary: String
  decisions: Decision[]
  progress: ProgressState
  blockers: Blocker[]
  discoveries: Discovery[]
  filesModified: FileChange[]
  references: Reference[]
  resumeInstructions: String[]
}

interface Decision {
  title: String
  choice: String
  alternativesConsidered: String[]
  rationale: String
  impact: String
}

interface ProgressState {
  completed: Task[]
  inProgress: Task[]
  nextSteps: String[]
}

interface Blocker {
  title: String
  issue: String
  attempted: String[]
  potentialSolutions: String[]
}

interface Discovery {
  title: String
  finding: String
  location: String
  implication: String
}

interface FileChange {
  file: String
  changes: String
  status: "Complete" | "In progress" | "Pending"
}

interface Reference {
  label: String
  path: String
}
```

**Template:**

```markdown
# Session Context: [Brief Title]

**Date**: [YYYY-MM-DD HH:MM]
**Duration**: [Approximate session length]
**Task**: [What was being worked on]

## Summary

[2-3 sentence summary of what was accomplished and current state]

## Decisions Made

### [Decision 1 Title]

**Choice**: [What was decided]
**Alternatives Considered**: [Other options]
**Rationale**: [Why this choice]
**Impact**: [What this affects]

## Progress

### Completed

- [x] [Task 1]
- [x] [Task 2]

### In Progress

- [ ] [Current task] - [Current state]

### Next Steps

1. [Next action 1]
2. [Next action 2]

## Blockers

### [Blocker 1]

**Issue**: [What's blocking]
**Attempted**: [What was tried]
**Potential Solutions**: [Ideas to explore]

## Key Discoveries

### [Discovery 1]

**Finding**: [What was discovered]
**Location**: [File:line or general area]
**Implication**: [How this affects work]

## Files Modified

| File         | Changes                | Status      |
| ------------ | ---------------------- | ----------- |
| src/auth.ts  | Added login validation | Complete    |
| src/users.ts | Started refactor       | In progress |

## References

- [Relevant spec]: docs/specs/001-auth/
- [External doc]: https://...
- [Code pattern]: src/utils/validation.ts

## Resume Instructions

When resuming this work:

1. [Specific action to take first]
2. [Context to load]
3. [Things to verify]
```

---

## Capture Protocol

```sudolang
CaptureProtocol {
  fn identifyKeyContext() {
    questions: [
      "What decisions were made that someone else (or future me) needs to know?",
      "What is the current state of the work?",
      "What are the next logical steps?",
      "What blockers or challenges were encountered?",
      "What non-obvious things were discovered?"
    ]
    
    evaluate each question |> collect findings
  }

  fn generateContextFile(taskSlug: String) {
    ensure directory ".config/opencode/context" exists
    filename = ".config/opencode/context/session-$(date +%Y-%m-%d)-${taskSlug}.md"
    return filename
  }

  constraints {
    require "Be specific - Include file paths, line numbers, exact values"
    require "Be concise - Bullet points over paragraphs"
    require "Be actionable - Next steps should be clear enough to execute"
  }

  /capture slug:String => {
    context = identifyKeyContext()
    filename = generateContextFile(slug)
    write context to filename using template
    emit CaptureComplete { filename, stats }
  }
}
```

### Decision Capture

```sudolang
interface DecisionRecord {
  title: String
  context: String              // Why this decision came up
  options: EvaluatedOption[]
  chosen: String
  rationale: String
  tradeoffs: String[]
  reversibility: "Easy" | "Moderate" | "Difficult"
}

interface EvaluatedOption {
  name: String
  pros: String[]
  cons: String[]
}

fn captureDecision(decision: DecisionRecord) => """
  ### $decision.title

  **Context**: $decision.context
  **Options Evaluated**:
  ${ decision.options |> map(o => "1. $o.name - Pros: $o.pros, Cons: $o.cons") |> join("\n") }

  **Chosen**: $decision.chosen
  **Rationale**: $decision.rationale
  **Trade-offs**: ${ decision.tradeoffs |> join(", ") }
  **Reversibility**: $decision.reversibility
"""
```

### Blocker Capture

```sudolang
interface BlockerRecord {
  title: String
  symptom: String
  expected: String
  rootCause: String?
  suspected: String?
  investigationLog: InvestigationStep[]
  blockedOn: String
  workaround: String?
  escalation: String?
}

interface InvestigationStep {
  tried: String
  result: String
}

fn captureBlocker(blocker: BlockerRecord) => """
  ### $blocker.title

  **Symptom**: $blocker.symptom
  **Expected**: $blocker.expected
  ${ blocker.rootCause ? "**Root Cause**: $blocker.rootCause" : "**Suspected**: $blocker.suspected" }

  **Investigation Log**:
  ${ blocker.investigationLog |> map((s, i) => "${i+1}. Tried $s.tried → Result: $s.result") |> join("\n") }

  **Blocked On**: $blocker.blockedOn
  ${ blocker.workaround ? "**Workaround**: $blocker.workaround" : "" }
  ${ blocker.escalation ? "**Escalation**: $blocker.escalation" : "" }
"""
```

---

## Restore Protocol

```sudolang
RestoreProtocol {
  fn checkForContext() {
    contextDir = ".config/opencode/context/"
    files = list files matching "*.md" in contextDir
    activeContext = read "${contextDir}active-context.md" if exists
    return { files, activeContext }
  }

  fn loadContext(file: ContextFile) {
    summary = extractSummary(file)
    
    emit ContextFound {
      session: file.title,
      date: file.date,
      summary: summary,
      decisionsCount: file.decisions.length,
      progress: file.progress.inProgress,
      nextSteps: file.progress.nextSteps |> take(3),
      blockersCount: file.blockers.length,
      resumeFrom: suggestStartingPoint(file)
    }
  }

  fn applyContext(file: ContextFile) {
    load relevant files mentioned in file.filesModified
    verify assumptions still hold (code hasn't changed)
    pick up from file.progress.nextSteps
  }

  /restore => {
    { files, activeContext } = checkForContext()
    
    match (activeContext) {
      case Some(ctx) => {
        loadContext(ctx)
        presentOptions: [
          "Continue from where we left off",
          "Review full context first",
          "Start fresh (archive this context)"
        ]
      }
      case None => emit NoContextFound {
        message: "This appears to be a fresh start",
        options: [
          "Start fresh",
          "Check for context in parent directory",
          "Create initial context from current state"
        ]
      }
    }
  }
}
```

---

## Context Compression

### For Long-Running Work

When context accumulates over multiple sessions:

```sudolang
ContextCompression {
  interface ConsolidatedContext {
    projectName: String
    activePeriod: { start: Date, end: Date }
    totalSessions: Number
    executiveSummary: String
    keyDecisions: DecisionSummary[]
    currentState: String
    sessionHistory: CollapsedSession[]
  }

  interface DecisionSummary {
    date: Date
    decision: String
    rationale: String
  }

  interface CollapsedSession {
    number: Number
    date: Date
    title: String
    content: String  // Original session content
  }

  fn mergeContexts(sessions: ContextFile[]) => ConsolidatedContext {
    projectName: extractCommonProject(sessions)
    activePeriod: { start: sessions.first.date, end: sessions.last.date }
    totalSessions: sessions.length
    executiveSummary: generateSummary(sessions)
    keyDecisions: sessions |> flatMap(s => s.decisions) |> summarize
    currentState: sessions.last.progress
    sessionHistory: sessions |> map(toCollapsedSession)
  }

  fn archiveOldContext(files: String[]) {
    archiveDir = ".config/opencode/context/archive/"
    ensure archiveDir exists
    
    for each file in files:
      move file to archiveDir
  }
}
```

---

## Integration with Other Workflows

```sudolang
WorkflowIntegration {
  interface SpecificationContext {
    specId: String
    specName: String
    location: String
    progress: {
      PRD: "Complete" | "In Progress" | "Pending" | "Skipped"
      SDD: "Complete" | "In Progress" | "Pending" | "Skipped"
      PLAN: { phase: Number, total: Number }
    }
    deviations: String[]
  }

  interface ImplementationContext {
    branch: String
    base: String
    baseCommit: String
    filesInProgress: FileProgress[]
    tests: { passing: Number, failing: Number, pending: Number }
  }

  interface FileProgress {
    path: String
    state: String
    percentComplete: Number
  }

  interface ReviewContext {
    identifier: String
    reviewState: "In progress" | "Feedback given" | "Awaiting response"
    findings: { critical: Number, high: Number, medium: Number }
    outstandingQuestions: String[]
  }
}
```

---

## Automatic Context Triggers

```sudolang
ContextTriggers {
  HighPriority {
    description: "Always capture"
    triggers: [
      "Session ending with uncommitted significant work",
      "Hitting a blocker that requires external input",
      "Making architectural decisions",
      "Discovering undocumented system behavior"
    ]
    action: /capture immediately
  }

  MediumPriority {
    description: "Suggest capture"
    triggers: [
      "Completing a major phase of work",
      "Switching to a different task/context",
      "After 30+ minutes of focused work"
    ]
    action: prompt user to capture
  }

  RestorationTriggers {
    description: "Check for existing context"
    triggers: [
      "Starting session in directory with .config/opencode/context/",
      'User mentions "continue", "resume", "where were we"',
      "Detecting in-progress work (uncommitted changes + context file)"
    ]
    action: /restore
  }

  fn detectTrigger(event: SessionEvent) {
    match (event) {
      case { type: "session_end", uncommittedWork: true } => HighPriority.action
      case { type: "blocker_hit", requiresExternal: true } => HighPriority.action
      case { type: "decision", architectural: true } => HighPriority.action
      case { type: "discovery", undocumented: true } => HighPriority.action
      case { type: "phase_complete" } => MediumPriority.action
      case { type: "context_switch" } => MediumPriority.action
      case { type: "session_start", contextExists: true } => RestorationTriggers.action
      case { type: "user_message", contains: ["continue", "resume", "where were we"] } => RestorationTriggers.action
      default => null
    }
  }
}
```

---

## Output Format

```sudolang
OutputFormats {
  fn captureOutput(result: CaptureResult) => """
    Context Preserved

    Session: $result.title
    Saved to: $result.filename

    Captured:
    - $result.decisions.length decisions
    - $result.progress.length progress items
    - $result.blockers.length blockers
    - $result.discoveries.length discoveries

    Resume command: "Continue from $result.sessionName"
  """

  fn restoreOutput(context: ContextFile) => """
    Context Restored

    Session: $context.title from $context.date
    Status: $context.summary

    Ready to continue with:
    ${ context.progress.nextSteps |> take(2) |> map((s, i) => "${i+1}. $s") |> join("\n") }

    $context.blockers.length blockers still open
    $context.decisions.length decisions to consider
  """

  fn noContextOutput() => """
    No Previous Context Found

    This appears to be a fresh start. As you work, I'll:
    - Track significant decisions
    - Note blockers and discoveries
    - Preserve context when session ends

    Would you like to:
    1. Start fresh
    2. Check for context in parent directory
    3. Create initial context from current state
  """
}
```
