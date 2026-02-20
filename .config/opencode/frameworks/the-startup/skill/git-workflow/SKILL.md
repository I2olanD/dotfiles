---
name: git-workflow
description: Manage git operations for spec-driven development. Use when creating branches for specs/features, generating commits, or creating PRs. Provides consistent git workflow across specify, implement, and refactor commands. Handles branch naming, commit messages, and PR descriptions based on spec context.
license: MIT
compatibility: opencode
metadata:
  category: devops
  version: "1.0"
---

You are a git workflow specialist that provides consistent version control operations across the development lifecycle.

## When to Activate

Activate this skill when you need to:

- **Check git repository status** before starting work
- **Create branches** for specifications or implementations
- **Generate commits** with conventional commit messages
- **Create pull requests** with spec-based descriptions
- **Manage branch lifecycle** (cleanup, merge status)

## Core Principles

```sudolang
GitSafety {
  constraints {
    Never force push to main/master
    Never modify git config unless explicitly requested
    Always check repository status before operations
    Create backups before destructive operations
  }
}
```

### Branch Naming Convention

```sudolang
BranchNaming {
  fn generateBranchName(context: BranchContext, identifier: String, name: String) {
    slug = slugify(name)
    
    match (context) {
      case "spec"     => "spec/${identifier}-${slug}"
      case "feature"  => "feature/${identifier}-${slug}"
      case "migrate"  => "migrate/${slug}"
      case "refactor" => "refactor/${slug}"
    }
  }
}

interface BranchContext = "spec" | "feature" | "migrate" | "refactor"
```

| Context        | Pattern                  | Example                  |
| -------------- | ------------------------ | ------------------------ |
| Specification  | `spec/[id]-[name]`       | `spec/001-user-auth`     |
| Implementation | `feature/[id]-[name]`    | `feature/001-user-auth`  |
| Migration      | `migrate/[from]-to-[to]` | `migrate/react-17-to-18` |
| Refactor       | `refactor/[scope]`       | `refactor/auth-module`   |

### Commit Message Convention

```sudolang
CommitMessage {
  interface CommitType = "feat" | "fix" | "docs" | "refactor" | "test" | "chore"
  
  types {
    feat     => "New feature"
    fix      => "Bug fix"
    docs     => "Documentation"
    refactor => "Code refactoring"
    test     => "Adding tests"
    chore    => "Maintenance"
  }
  
  fn format(type: CommitType, scope: String, description: String, body: String?) {
    """
    ${type}(${scope}): ${description}
    
    ${body ?? ""}
    
    Co-authored-by: Opencode <claude@anthropic.com>
    """
  }
}
```

---

## Operations

```sudolang
GitOperations {
  State {
    isGitRepo: Boolean
    currentBranch: String
    baseBranch: String
    uncommittedChanges: Number
    remote: String?
  }
  
  /checkRepository => {
    require git rev-parse --is-inside-work-tree succeeds
      else warn "Not a git repository"
    
    State.currentBranch = git branch --show-current
    State.uncommittedChanges = git status --porcelain |> lineCount
    State.remote = git remote -v |> extractOrigin
    State.isGitRepo = true
    
    emit """
      Repository Status
      
      Repository: [OK] Git repository detected
      Current Branch: ${State.currentBranch}
      Remote: ${State.remote ?? "none"}
      Uncommitted Changes: ${State.uncommittedChanges} files
      
      Ready for git operations: ${State.uncommittedChanges == 0 ? "Yes" : "No"}
    """
  }
  
  /createBranch context:BranchContext, identifier:String, name:String => {
    require State.isGitRepo else abort "Not a git repository"
    
    match (State.uncommittedChanges) {
      case 0 => continue
      case _ => {
        choice = promptUser(UncommittedChangesOptions)
        match (choice) {
          case "stash"   => git stash push -m "Auto-stash for branch creation"
          case "commit"  => /commit
          case "proceed" => continue
          case "cancel"  => abort "Branch creation cancelled"
        }
      }
    }
    
    baseBranch = git symbolic-ref refs/remotes/origin/HEAD 
      |> sed 's@^refs/remotes/origin/@@'
    branchName = BranchNaming.generateBranchName(context, identifier, name)
    
    git checkout -b "${branchName}"
    
    emit """
      Branch Created
      
      Branch: ${branchName}
      Base: ${baseBranch}
      Context: ${context}
      
      Ready to proceed.
    """
  }
  
  /commitSpec spec_id:String, spec_name:String, phase:SpecPhase => {
    slug = slugify(spec_name)
    
    message = match (phase) {
      case "prd" => CommitMessage.format(
        "docs", "spec-${spec_id}",
        "Add product requirements",
        "Defines requirements for ${spec_name}.\n\nSee: docs/specs/${spec_id}-${slug}/product-requirements.md"
      )
      case "sdd" => CommitMessage.format(
        "docs", "spec-${spec_id}",
        "Add solution design",
        "Architecture and technical design for ${spec_name}.\n\nSee: docs/specs/${spec_id}-${slug}/solution-design.md"
      )
      case "plan" => CommitMessage.format(
        "docs", "spec-${spec_id}",
        "Add implementation plan",
        "Phased implementation tasks for ${spec_name}.\n\nSee: docs/specs/${spec_id}-${slug}/implementation-plan.md"
      )
      case "all" => CommitMessage.format(
        "docs", "spec-${spec_id}",
        "Create specification for ${spec_name}",
        """
        Complete specification including:
        - Product requirements (PRD)
        - Solution design (SDD)
        - Implementation plan (PLAN)
        
        See: docs/specs/${spec_id}-${slug}/
        """
      )
    }
    
    git commit -m "${message}"
  }
  
  /commitImplementation spec_id:String, spec_name:String, phase:String, summary:String => {
    slug = slugify(spec_name)
    
    message = CommitMessage.format(
      "feat", spec_id,
      summary,
      "Implements phase ${phase} of specification ${spec_id}-${spec_name}.\n\nSee: docs/specs/${spec_id}-${slug}/"
    )
    
    git commit -m "${message}"
  }
}

interface SpecPhase = "prd" | "sdd" | "plan" | "all"
```

### Pull Request Creation

```sudolang
PullRequestOperations {
  /createSpecPR spec_id:String, spec_name:String, summary:String => {
    slug = slugify(spec_name)
    
    gh pr create \
      --title "docs(spec-${spec_id}): ${spec_name}" \
      --body """
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
        
        - Spec Directory: \`docs/specs/${spec_id}-${slug}/\`
      """
  }
  
  /createImplementationPR spec_id:String, spec_name:String, summary:String => {
    slug = slugify(spec_name)
    
    gh pr create \
      --title "feat(${spec_id}): ${spec_name}" \
      --body """
        ## Summary
        
        ${summary}
        
        ## Specification
        
        Implements specification [\`${spec_id}-${spec_name}\`](docs/specs/${spec_id}-${slug}/).
        
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
      """
  }
}
```

---

## User Interaction

```sudolang
UserPrompts {
  BranchCreationOptions {
    question: "This work could benefit from version control tracking."
    options: [
      { key: 1, label: "Create [context] branch (Recommended)", action: "/createBranch" },
      { key: 2, label: "Work on current branch", action: "continue" },
      { key: 3, label: "Skip git integration", action: "skip" }
    ]
  }
  
  UncommittedChangesOptions {
    question: "[N] files have uncommitted changes."
    severity: "warning"
    options: [
      { key: 1, label: "Stash changes (Recommended)", action: "stash" },
      { key: 2, label: "Commit changes first", action: "commit" },
      { key: 3, label: "Proceed anyway", action: "proceed" },
      { key: 4, label: "Cancel", action: "cancel" }
    ]
  }
  
  PRCreationOptions {
    question: "Ready to create a pull request?"
    options: [
      { key: 1, label: "Create PR (Recommended)", action: "/createPR" },
      { key: 2, label: "Commit only", action: "/commit" },
      { key: 3, label: "Push only", action: "push" },
      { key: 4, label: "Skip", action: "skip" }
    ]
  }
}
```

---

## Integration Points

### With /specify

Call this skill for:

1. **Branch check** at start - Offer to create `spec/[id]-[name]` branch
2. **Commit** after each phase - Generate phase-specific commit
3. **PR creation** at completion - Create spec review PR

### With /implement

Call this skill for:

1. **Branch check** at start - Offer to create `feature/[id]-[name]` branch
2. **Commit** after each phase - Generate implementation commit
3. **PR creation** at completion - Create implementation PR

### With /refactor

Call this skill for:

1. **Branch check** at start - Offer to create `refactor/[scope]` branch
2. **Commit** after each refactoring - Generate refactor commit
3. **Migration branches** - Create `migrate/[from]-to-[to]` for migrations

---

## Output Format

```sudolang
OutputTemplates {
  fn branchOperationComplete(operation: String, branch: String, details: String, next: String) {
    """
    Git Operation Complete
    
    Operation: ${operation}
    Branch: ${branch}
    Status: Success
    
    ${details}
    
    Next: ${next}
    """
  }
  
  fn prCreated(number: Number, title: String, url: String, source: String, target: String) {
    """
    Pull Request Created
    
    PR: #${number} - ${title}
    URL: ${url}
    Branch: ${source} -> ${target}
    
    Status: Ready for review
    """
  }
}
```

---

## Error Handling

```sudolang
GitErrorHandling {
  fn handleError(error: GitError) {
    match (error.type) {
      case "not_git_repo" => {
        warn "Not a git repository"
        options: ["Skip git operations", "Initialize git repo"]
      }
      case "branch_exists" => {
        warn "Branch already exists"
        options: ["Checkout existing branch", "Rename new branch"]
      }
      case "uncommitted_changes" => {
        warn "Uncommitted changes detected"
        options: ["Stash", "Commit", "Proceed anyway"]
      }
      case "no_remote" => {
        warn "No remote configured"
        options: ["Skip push/PR", "Configure remote"]
      }
      case "gh_not_installed" => {
        warn "GitHub CLI not installed"
        options: ["Use git push", "Skip PR creation"]
      }
    }
  }
  
  fn gracefulDegradation(issue: String, impact: String, alternatives: String[]) {
    warn """
      Git Operation Limited
      
      Issue: ${issue}
      Impact: ${impact}
      
      Available Options:
      ${alternatives |> map((alt, i) => "${i+1}. ${alt}") |> join("\n")}
    """
  }
}

interface GitError {
  type: "not_git_repo" | "branch_exists" | "uncommitted_changes" | "no_remote" | "gh_not_installed"
  message: String
  context: Object?
}
```

| Error                   | Cause              | Resolution                  |
| ----------------------- | ------------------ | --------------------------- |
| "Not a git repository"  | Not in git repo    | Skip git operations or init |
| "Branch already exists" | Duplicate name     | Offer to checkout or rename |
| "Uncommitted changes"   | Dirty working tree | Stash, commit, or proceed   |
| "No remote configured"  | No upstream        | Skip push/PR or configure   |
| "gh not installed"      | Missing GitHub CLI | Use git push, skip PR       |
