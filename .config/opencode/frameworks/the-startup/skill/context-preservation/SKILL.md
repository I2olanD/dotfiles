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
    categories = []
    contextFile = null
    activeSession = null
  }

  PreservationCategory {
    name
    examples
    priority    One of HIGH, MEDIUM, or LOW.
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

  Constraints {
    Reference file paths instead of including entire file contents.
    Exclude obvious or generic information.
    Do not preserve temporary debugging output.
  }

  require Never preserve sensitive data (secrets, credentials).
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
ContextFile {
  title
  date
  duration
  task
  summary
  decisions
  progress
  blockers
  discoveries
  filesModified
  references
  resumeInstructions
}

Decision {
  title
  choice
  alternativesConsidered
  rationale
  impact
}

ProgressState {
  completed
  inProgress
  nextSteps
}

Blocker {
  title
  issue
  attempted
  potentialSolutions
}

Discovery {
  title
  finding
  location
  implication
}

FileChange {
  file
  changes
  status    One of Complete, In progress, or Pending.
}

Reference {
  label
  path
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
  identifyKeyContext() {
    questions: [
      "What decisions were made that someone else (or future me) needs to know?",
      "What is the current state of the work?",
      "What are the next logical steps?",
      "What blockers or challenges were encountered?",
      "What non-obvious things were discovered?"
    ]

    Evaluate each question and collect findings.
  }

  generateContextFile(taskSlug) {
    Ensure directory ".config/opencode/context" exists.
    filename = ".config/opencode/context/session-$(date +%Y-%m-%d)-${taskSlug}.md"
    return filename
  }

  Constraints {
    Be specific - include file paths, line numbers, exact values.
    Be concise - bullet points over paragraphs.
    Be actionable - next steps should be clear enough to execute.
  }

  /capture slug => {
    context = identifyKeyContext()
    filename = generateContextFile(slug)
    Write context to filename using template.
    emit CaptureComplete { filename, stats }
  }
}
```

### Decision Capture

```sudolang
DecisionRecord {
  title
  context              Why this decision came up.
  options              Evaluated options list.
  chosen
  rationale
  tradeoffs
  reversibility        One of Easy, Moderate, or Difficult.
}

EvaluatedOption {
  name
  pros
  cons
}

captureDecision(decision) => """
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
BlockerRecord {
  title
  symptom
  expected
  rootCause
  suspected
  investigationLog
  blockedOn
  workaround
  escalation
}

InvestigationStep {
  tried
  result
}

captureBlocker(blocker) => """
  ### $blocker.title

  **Symptom**: $blocker.symptom
  **Expected**: $blocker.expected
  ${ blocker.rootCause then "**Root Cause**: $blocker.rootCause" else "**Suspected**: $blocker.suspected" }

  **Investigation Log**:
  ${ blocker.investigationLog |> mapWithIndex((s, i) => "${i+1}. Tried $s.tried -> Result: $s.result") |> join("\n") }

  **Blocked On**: $blocker.blockedOn
  ${ blocker.workaround then "**Workaround**: $blocker.workaround" else "" }
  ${ blocker.escalation then "**Escalation**: $blocker.escalation" else "" }
"""
```

---

## Restore Protocol

```sudolang
RestoreProtocol {
  checkForContext() {
    contextDir = ".config/opencode/context/"
    files = list files matching "*.md" in contextDir
    activeContext = read "${contextDir}active-context.md" if exists
    return { files, activeContext }
  }

  loadContext(file) {
    summary = extractSummary(file)

    emit ContextFound {
      session: file.title,
      date: file.date,
      summary,
      decisionsCount: file.decisions |> count,
      progress: file.progress.inProgress,
      nextSteps: file.progress.nextSteps |> take(3),
      blockersCount: file.blockers |> count,
      resumeFrom: suggestStartingPoint(file)
    }
  }

  applyContext(file) {
    Load relevant files mentioned in file.filesModified.
    Verify assumptions still hold (code has not changed).
    Pick up from file.progress.nextSteps.
  }

  /restore => {
    { files, activeContext } = checkForContext()

    match activeContext {
      some context => {
        loadContext(context)
        presentOptions: [
          "Continue from where we left off",
          "Review full context first",
          "Start fresh (archive this context)"
        ]
      }
      none => emit NoContextFound {
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
  ConsolidatedContext {
    projectName
    activePeriod { start, end }
    totalSessions
    executiveSummary
    keyDecisions
    currentState
    sessionHistory
  }

  DecisionSummary {
    date
    decision
    rationale
  }

  CollapsedSession {
    number
    date
    title
    content
  }

  mergeContexts(sessions) => ConsolidatedContext {
    projectName: extractCommonProject(sessions),
    activePeriod: { start: sessions first date, end: sessions last date },
    totalSessions: sessions |> count,
    executiveSummary: generateSummary(sessions),
    keyDecisions: sessions |> flatMap(s => s.decisions) |> summarize,
    currentState: sessions last progress,
    sessionHistory: sessions |> map(toCollapsedSession)
  }

  archiveOldContext(files) {
    archiveDir = ".config/opencode/context/archive/"
    Ensure archiveDir exists.
    Move each file to archiveDir.
  }
}
```

---

## Integration with Other Workflows

```sudolang
WorkflowIntegration {
  SpecificationContext {
    specId
    specName
    location
    progress {
      PRD     One of Complete, In Progress, Pending, or Skipped.
      SDD     One of Complete, In Progress, Pending, or Skipped.
      PLAN    { phase, total }
    }
    deviations
  }

  ImplementationContext {
    branch
    base
    baseCommit
    filesInProgress
    tests { passing, failing, pending }
  }

  FileProgress {
    path
    state
    percentComplete
  }

  ReviewContext {
    identifier
    reviewState    One of In progress, Feedback given, or Awaiting response.
    findings { critical, high, medium }
    outstandingQuestions
  }
}
```

---

## Automatic Context Triggers

```sudolang
ContextTriggers {
  HighPriority {
    Always capture when:
    - Session ending with uncommitted significant work.
    - Hitting a blocker that requires external input.
    - Making architectural decisions.
    - Discovering undocumented system behavior.
    action: /capture immediately
  }

  MediumPriority {
    Suggest capture when:
    - Completing a major phase of work.
    - Switching to a different task or context.
    - After 30+ minutes of focused work.
    action: prompt user to capture
  }

  RestorationTriggers {
    Check for existing context when:
    - Starting session in directory with .config/opencode/context/.
    - User mentions "continue", "resume", "where were we".
    - Detecting in-progress work (uncommitted changes + context file).
    action: /restore
  }

  detectTrigger(event) {
    match event {
      session end with uncommitted work => HighPriority.action
      blocker hit requiring external input => HighPriority.action
      architectural decision => HighPriority.action
      undocumented discovery => HighPriority.action
      phase complete => MediumPriority.action
      context switch => MediumPriority.action
      session start with existing context => RestorationTriggers.action
      user message containing "continue", "resume", "where were we" => RestorationTriggers.action
      default => null
    }
  }
}
```

---

## Output Format

```sudolang
OutputFormats {
  captureOutput(result) => """
    Context Preserved

    Session: $result.title
    Saved to: $result.filename

    Captured:
    - ${ result.decisions |> count } decisions
    - ${ result.progress |> count } progress items
    - ${ result.blockers |> count } blockers
    - ${ result.discoveries |> count } discoveries

    Resume command: "Continue from $result.sessionName"
  """

  restoreOutput(context) => """
    Context Restored

    Session: $context.title from $context.date
    Status: $context.summary

    Ready to continue with:
    ${ context.progress.nextSteps |> take(2) |> mapWithIndex((s, i) => "${i+1}. $s") |> join("\n") }

    ${ context.blockers |> count } blockers still open
    ${ context.decisions |> count } decisions to consider
  """

  noContextOutput() => """
    No Previous Context Found

    This appears to be a fresh start. As you work, I will:
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
