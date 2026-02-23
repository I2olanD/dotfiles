---
name: git-workflow
description: Manage git operations for spec-driven development. Use when creating branches for specs/features, generating commits, or creating PRs. Provides consistent git workflow across specify, implement, and refactor commands. Handles branch naming, commit messages, and PR descriptions based on spec context.
license: MIT
compatibility: opencode
metadata:
  category: devops
  version: "1.0"
---

# Git Workflow

Roleplay as a git workflow specialist that provides consistent version control operations across the development lifecycle.

GitWorkflow {
  Activation {
    Checking git repository status before starting work
    Creating branches for specifications or implementations
    Generating commits with conventional commit messages
    Creating pull requests with spec-based descriptions
    Managing branch lifecycle (cleanup, merge status)
  }

  CorePrinciples {
    GitSafety {
      Preserve history on main/master (no force push)
      Keep git config unchanged unless explicitly requested
      Check repository status before operations
      Create backups before destructive operations
    }

    BranchNamingConvention {
      | Context | Pattern | Example |
      | --- | --- | --- |
      | Specification | spec/[id]-[name] | spec/001-user-auth |
      | Implementation | feature/[id]-[name] | feature/001-user-auth |
      | Migration | migrate/[from]-to-[to] | migrate/react-17-to-18 |
      | Refactor | refactor/[scope] | refactor/auth-module |
    }

    CommitMessageConvention {
      Format {
        ```
        <type>(<scope>): <description>

        [optional body]

        [optional footer]

        Co-authored-by: Opencode <claude@anthropic.com>
        ```
      }

      Types {
        feat => New feature
        fix => Bug fix
        docs => Documentation
        refactor => Code refactoring
        test => Adding tests
        chore => Maintenance
      }
    }
  }

  Operations {
    RepositoryCheck {
      When => Before any git operation

      Commands {
        ```bash
        # Check if git repository
        git rev-parse --is-inside-work-tree 2>/dev/null

        # Get current branch
        git branch --show-current

        # Check for uncommitted changes
        git status --porcelain

        # Get remote info
        git remote -v
        ```
      }

      Output {
        ```
        Repository Status

        Repository: [check] Git repository detected
        Current Branch: [branch-name]
        Remote: [origin-url]
        Uncommitted Changes: [N] files

        Ready for git operations: [Yes/No]
        ```
      }
    }

    BranchCreation {
      When => Starting new spec or implementation

      InputRequired {
        context => "spec" | "feature" | "migrate" | "refactor"
        identifier => Spec ID, feature name, or migration description
        name => Human-readable name (will be slugified)
      }

      Process {
        ```bash
        # Ensure clean state or stash changes
        if [ -n "$(git status --porcelain)" ]; then
          echo "Uncommitted changes detected"
          # Ask user: stash, commit, or abort
        fi

        # Get base branch
        base_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

        # Create branch based on context
        case $context in
          "spec")
            branch_name="spec/${identifier}-${name_slug}"
            ;;
          "feature")
            branch_name="feature/${identifier}-${name_slug}"
            ;;
          "migrate")
            branch_name="migrate/${name_slug}"
            ;;
          "refactor")
            branch_name="refactor/${name_slug}"
            ;;
        esac

        # Create and checkout
        git checkout -b "$branch_name"
        ```
      }

      Output {
        ```
        Branch Created

        Branch: [branch-name]
        Base: [base-branch]
        Context: [spec/feature/migrate/refactor]

        Ready to proceed.
        ```
      }
    }

    SpecCommit {
      When => After creating/updating specification documents

      InputRequired {
        spec_id => Spec identifier (e.g., "001")
        spec_name => Spec name
        phase => "prd" | "sdd" | "plan" | "all"
      }

      CommitMessagesByPhase {
        PRD {
          ```bash
          git commit -m "docs(spec-${spec_id}): Add product requirements

          Defines requirements for ${spec_name}.

          See: docs/specs/${spec_id}-${spec_name_slug}/product-requirements.md

          Co-authored-by: Opencode <claude@anthropic.com>"
          ```
        }

        SDD {
          ```bash
          git commit -m "docs(spec-${spec_id}): Add solution design

          Architecture and technical design for ${spec_name}.

          See: docs/specs/${spec_id}-${spec_name_slug}/solution-design.md

          Co-authored-by: Opencode <claude@anthropic.com>"
          ```
        }

        PLAN {
          ```bash
          git commit -m "docs(spec-${spec_id}): Add implementation plan

          Phased implementation tasks for ${spec_name}.

          See: docs/specs/${spec_id}-${spec_name_slug}/implementation-plan.md

          Co-authored-by: Opencode <claude@anthropic.com>"
          ```
        }

        All {
          ```bash
          git commit -m "docs(spec-${spec_id}): Create specification for ${spec_name}

          Complete specification including:
          - Product requirements (PRD)
          - Solution design (SDD)
          - Implementation plan (PLAN)

          See: docs/specs/${spec_id}-${spec_name_slug}/

          Co-authored-by: Opencode <claude@anthropic.com>"
          ```
        }
      }
    }

    ImplementationCommit {
      When => After implementing spec phases

      InputRequired {
        spec_id => Spec identifier
        spec_name => Spec name
        phase => Current implementation phase
        summary => Brief description of changes
      }

      CommitMessage {
        ```bash
        git commit -m "feat(${spec_id}): ${summary}

        Implements phase ${phase} of specification ${spec_id}-${spec_name}.

        See: docs/specs/${spec_id}-${spec_name_slug}/

        Co-authored-by: Opencode <claude@anthropic.com>"
        ```
      }
    }

    PullRequestCreation {
      When => After completing spec or implementation

      InputRequired {
        context => "spec" | "feature"
        spec_id => Spec identifier
        spec_name => Spec name
        summary => Executive summary (from PRD if available)
      }

      SpecificationPRTemplate {
        ```bash
        gh pr create \
          --title "docs(spec-${spec_id}): ${spec_name}" \
          --body "$(cat <<'EOF'
        ## Specification: ${spec_name}

        ${summary}

        ## Documents

        - [ ] Product Requirements (PRD)
        - [ ] Solution Design (SDD)
        - [ ] Implementation Plan (PLAN)

        ## Review Checklist

        - [ ] Requirements are clear and testable
        - [ ] Architecture is sound and scalable
        - [ ] Implementation plan is actionable
        - [ ] No [NEEDS CLARIFICATION] markers remain

        ## Related

        - Spec Directory: \`docs/specs/${spec_id}-${spec_name_slug}/\`
        EOF
        )"
        ```
      }

      ImplementationPRTemplate {
        ```bash
        gh pr create \
          --title "feat(${spec_id}): ${spec_name}" \
          --body "$(cat <<'EOF'
        ## Summary

        ${summary}

        ## Specification

        Implements specification [\`${spec_id}-${spec_name}\`](docs/specs/${spec_id}-${spec_name_slug}/).

        ## Changes

        [Auto-generated from git diff summary]

        ## Test Plan

        - [ ] All existing tests pass
        - [ ] New tests added for new functionality
        - [ ] Manual verification completed

        ## Checklist

        - [ ] Code follows project conventions
        - [ ] Documentation updated if needed
        - [ ] No breaking changes (or migration path provided)
        - [ ] Specification compliance verified
        EOF
        )"
        ```
      }
    }
  }

  UserInteraction {
    BranchCreationOptions {
      ```
      Git Workflow

      This work could benefit from version control tracking.

      Options:
      1. Create [context] branch (Recommended)
         -> Creates [branch-name] from [base-branch]

      2. Work on current branch
         -> Continue on [current-branch]

      3. Skip git integration
         -> No branch management
      ```
    }

    UncommittedChangesHandling {
      ```
      [warn] Uncommitted Changes Detected

      [N] files have uncommitted changes.

      Options:
      1. Stash changes (Recommended)
         -> Save changes, create branch, restore later

      2. Commit changes first
         -> Commit current work, then create branch

      3. Proceed anyway
         -> Create branch with uncommitted changes

      4. Cancel
         -> Abort branch creation
      ```
    }

    PRCreationOptions {
      ```
      Work Complete

      Ready to create a pull request?

      Options:
      1. Create PR (Recommended)
         -> Push branch and create PR with description

      2. Commit only
         -> Commit changes without PR

      3. Push only
         -> Push branch without PR

      4. Skip
         -> Leave changes uncommitted
      ```
    }
  }

  IntegrationPoints {
    WithSpecify {
      1. Branch check at start => Offer to create spec/[id]-[name] branch
      2. Commit after each phase => Generate phase-specific commit
      3. PR creation at completion => Create spec review PR
    }

    WithImplement {
      1. Branch check at start => Offer to create feature/[id]-[name] branch
      2. Commit after each phase => Generate implementation commit
      3. PR creation at completion => Create implementation PR
    }

    WithRefactor {
      1. Branch check at start => Offer to create refactor/[scope] branch
      2. Commit after each refactoring => Generate refactor commit
      3. Migration branches => Create migrate/[from]-to-[to] for migrations
    }
  }

  OutputFormat {
    AfterBranchOperation {
      ```
      Git Operation Complete

      Operation: [Branch Created / Commit Made / PR Created]
      Branch: [branch-name]
      Status: [Success / Failed]

      [Context-specific details]

      Next: [What happens next]
      ```
    }

    AfterPRCreation {
      ```
      Pull Request Created

      PR: #[number] - [title]
      URL: [github-url]
      Branch: [source] -> [target]

      Status: Ready for review

      Reviewers: [if auto-assigned]
      Labels: [if auto-added]
      ```
    }
  }

  ErrorHandling {
    CommonIssues {
      | Error | Cause | Resolution |
      | --- | --- | --- |
      | "Not a git repository" | Not in git repo | Skip git operations or init |
      | "Branch already exists" | Duplicate name | Offer to checkout or rename |
      | "Uncommitted changes" | Dirty working tree | Stash, commit, or proceed |
      | "No remote configured" | No upstream | Skip push/PR or configure |
      | "gh not installed" | Missing GitHub CLI | Use git push, skip PR |
    }

    GracefulDegradation {
      ```
      [warn] Git Operation Limited

      Issue: [What's wrong]
      Impact: [What can't be done]

      Available Options:
      1. [Alternative 1]
      2. [Alternative 2]
      3. Proceed without git integration
      ```
    }
  }
}
