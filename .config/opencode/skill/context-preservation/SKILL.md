---
name: context-preservation
description: Preserve and restore session context across conversations. Use when completing significant work, switching contexts, or resuming previous work. Captures decisions, progress, blockers, and important discoveries. Enables seamless context handoff between sessions.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Context Preservation

Roleplay as a context preservation specialist that captures and restores important session information for continuity across conversations.

ContextPreservation {
  Activation {
    When completing significant work - Capture context before session ends
    When switching contexts - Moving to different task/project
    When hitting a blocker - Document state before pausing
    When making important decisions - Record rationale for future reference
    When resuming previous work - Restore context from prior session
  }

  Constraints {
    WhatToPreserve {
      | Category        | Examples                                                 | Priority |
      | --------------- | -------------------------------------------------------- | -------- |
      | **Decisions**   | Architectural choices, trade-offs, rejected alternatives | HIGH     |
      | **Progress**    | Completed tasks, current state, next steps               | HIGH     |
      | **Blockers**    | What's blocking, what was tried, potential solutions     | HIGH     |
      | **Discoveries** | Patterns found, gotchas, undocumented behaviors          | MEDIUM   |
      | **Context**     | Files modified, dependencies, related specs              | MEDIUM   |
      | **References**  | Relevant docs, external resources, code locations        | LOW      |
    }

    WhatNOTToPreserve {
      - Entire file contents (reference paths instead)
      - Obvious/generic information
      - Temporary debugging output
      - Sensitive data (secrets, credentials)
    }
  }

  ContextFileFormat {
    Location {
      Context files are stored in `.config/opencode/context/`:

      ```
      .config/opencode/
      └── context/
          ├── session-2024-01-15-auth-implementation.md
          ├── session-2024-01-16-api-refactor.md
          └── active-context.md  # Current/most recent
      ```
    }

    FileStructure {
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

      ### [Decision 2 Title]

      ...

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
    }
  }

  CaptureProtocol {
    EndOfSessionCapture {
      When significant work is being completed or session is ending:

      Step1_IdentifyKeyContext {
        Ask yourself:
        - What decisions were made that someone else (or future me) needs to know?
        - What is the current state of the work?
        - What are the next logical steps?
        - What blockers or challenges were encountered?
        - What non-obvious things were discovered?
      }

      Step2_GenerateContextFile {
        ```bash
        # Create context directory if needed
        mkdir -p .config/opencode/context

        # Generate timestamped filename
        filename=".config/opencode/context/session-$(date +%Y-%m-%d)-[task-slug].md"
        ```
      }

      Step3_WriteContext {
        Use the file structure template above, focusing on:
        - Be specific: Include file paths, line numbers, exact values
        - Be concise: Bullet points over paragraphs
        - Be actionable: Next steps should be clear enough to execute
      }
    }

    DecisionCapture {
      When an important decision is made during the session:

      ```markdown
      ### [Decision Title]

      **Context**: [Why this decision came up]
      **Options Evaluated**:

      1. [Option A] - [Pros/Cons]
      2. [Option B] - [Pros/Cons]
      3. [Option C] - [Pros/Cons]

      **Chosen**: [Option X]
      **Rationale**: [Why this option]
      **Trade-offs**: [What we're giving up]
      **Reversibility**: [How hard to change later]
      ```
    }

    BlockerCapture {
      When encountering a blocker:

      ```markdown
      ### [Blocker Title]

      **Symptom**: [What's happening]
      **Expected**: [What should happen]
      **Root Cause**: [If known] / **Suspected**: [If unknown]

      **Investigation Log**:

      1. Tried [X] -> Result: [Y]
      2. Tried [A] -> Result: [B]

      **Blocked On**: [Specific thing needed]
      **Workaround**: [If any exists]
      **Escalation**: [Who/what could help]
      ```
    }
  }

  RestoreProtocol {
    SessionStartRestoration {
      When resuming previous work:

      Step1_CheckForContext {
        ```bash
        # Find recent context files
        ls -la .config/opencode/context/*.md

        # Check for active context
        cat .config/opencode/context/active-context.md
        ```
      }

      Step2_LoadContext {
        Read the context file and present a summary:

        ```
        Previous Session Context Found

        Session: [Title] ([Date])
        Summary: [Brief summary]

        Decisions Made: [N]
        Current Progress: [Status]
        Next Steps: [First 2-3 items]
        Open Blockers: [N]

        Resume from: [Suggested starting point]

        Would you like to:
        1. Continue from where we left off
        2. Review full context first
        3. Start fresh (archive this context)
        ```
      }

      Step3_ApplyContext {
        When continuing:
        - Load relevant files mentioned in context
        - Verify assumptions still hold (code hasn't changed)
        - Pick up from documented next steps
      }
    }
  }

  ContextCompression {
    ForLongRunningWork {
      When context accumulates over multiple sessions:

      MergeStrategy {
        ```markdown
        # Consolidated Context: [Project/Feature Name]

        **Active Period**: [Start date] - [Current date]
        **Total Sessions**: [N]

        ## Executive Summary

        [High-level summary of entire effort]

        ## Key Decisions (All Sessions)

        | Date   | Decision   | Rationale         |
        | ------ | ---------- | ----------------- |
        | [Date] | [Decision] | [Brief rationale] |

        ## Current State

        [As of most recent session]

        ## Complete History

        <details>
        <summary>Session 1: [Date] - [Title]</summary>
        [Collapsed content from session 1]
        </details>

        <details>
        <summary>Session 2: [Date] - [Title]</summary>
        [Collapsed content from session 2]
        </details>
        ```
      }

      Archival {
        Old context files should be:
        1. Merged into consolidated context
        2. Moved to `.config/opencode/context/archive/`
        3. Retained for reference but not auto-loaded
      }
    }
  }

  IntegrationWithOtherWorkflows {
    WithSpecifications {
      When working on a spec-based implementation:

      ```markdown
      ## Specification Context

      Spec: [ID] - [Name]
      Location: docs/specs/[ID]-[name]/

      Progress vs Spec:

      - PRD: [Status]
      - SDD: [Status]
      - PLAN: [Phase X of Y]

      Deviations from Spec:

      - [Any changes made from original plan]
      ```
    }

    WithImplementation {
      When implementing features:

      ```markdown
      ## Implementation Context

      Branch: feature/[name]
      Base: main (at commit [sha])

      Files in Progress:
      | File | State | % Complete |
      |------|-------|------------|
      | [path] | [state] | [N]% |

      Tests:

      - [N] passing
      - [N] failing
      - [N] pending
      ```
    }

    WithReview {
      When in the middle of code review:

      ```markdown
      ## Review Context

      PR/Branch: [identifier]
      Review State: [In progress / Feedback given / Awaiting response]

      Findings So Far:

      - Critical: [N]
      - High: [N]
      - Medium: [N]

      Outstanding Questions:

      - [Question 1]
      - [Question 2]
      ```
    }
  }

  AutomaticContextTriggers {
    HighPriorityTriggers {
      Always Capture:
      - Session ending with uncommitted significant work
      - Hitting a blocker that requires external input
      - Making architectural decisions
      - Discovering undocumented system behavior
    }

    MediumPriorityTriggers {
      Suggest Capture:
      - Completing a major phase of work
      - Switching to a different task/context
      - After 30+ minutes of focused work
    }

    ContextRestorationTriggers {
      - Starting session in directory with `.config/opencode/context/`
      - User mentions "continue", "resume", "where were we"
      - Detecting in-progress work (uncommitted changes + context file)
    }
  }

  OutputFormats {
    WhenCapturingContext {
      ```
      Context Preserved

      Session: [Title]
      Saved to: .config/opencode/context/[filename].md

      Captured:
      - [N] decisions
      - [N] progress items
      - [N] blockers
      - [N] discoveries

      Resume command: "Continue from [session name]"
      ```
    }

    WhenRestoringContext {
      ```
      Context Restored

      Session: [Title] from [Date]
      Status: [Current state summary]

      Ready to continue with:
      1. [First next step]
      2. [Second next step]

      [N] blockers still open
      [N] decisions to consider
      ```
    }

    WhenNoContextFound {
      ```
      No Previous Context Found

      This appears to be a fresh start. As you work, I'll:
      - Track significant decisions
      - Note blockers and discoveries
      - Preserve context when session ends

      Would you like to:
      1. Start fresh
      2. Check for context in parent directory
      3. Create initial context from current state
      ```
    }
  }
}
