# Specification Management Reference

## Spec ID Format

- **Format**: 3-digit zero-padded number (001, 002, ..., 999)
- **Auto-incrementing**: Script scans existing directories to find next ID
- **Directory naming**: `[NNN]-[sanitized-feature-name]`
- **Sanitization**: Lowercase, special chars to hyphens, trim leading/trailing hyphens

## Directory Structure

```
.start/specs/
├── 001-user-authentication/
│   ├── README.md                 # Managed by specification-management skill
│   ├── requirements.md   # Created by requirements-analysis skill
│   ├── solution.md        # Created by architecture-design skill
│   └── plan/README.md    # Created by implementation-planning skill
├── 002-payment-processing/
│   └── ...
└── 003-notification-system/
    └── ...
```

## Script Commands

### Create New Spec
```bash
spec.py "feature name here"
```
**Output:**
```
Created spec directory: .start/specs/005-feature-name-here
Spec ID: 005
Specification directory created successfully
```

### Read Spec Metadata
```bash
spec.py 005 --read
```
**Output (TOML):**
```toml
id = "005"
name = "feature-name-here"
dir = ".start/specs/005-feature-name-here"

[spec]
prd = ".start/specs/005-feature-name-here/requirements.md"
sdd = ".start/specs/005-feature-name-here/solution.md"

files = [
  "product-requirements.md",
  "README.md",
  "solution.md"
]
```

### Add Template to Existing Spec
```bash
spec.py 005 --add specify-requirements
spec.py 005 --add specify-solution
spec.py 005 --add specify-plan
```

## Template Resolution

Templates are resolved in this order:
1. `skills/[template-name]/template.md` (primary)
2. 

## README.md Fields

| Field | Description |
|-------|-------------|
| Created | Date spec was created |
| Current Phase | Active workflow phase |
| Last Updated | Date of last status change |
| Document Status | pending, in_progress, completed, skipped |
| Notes | Additional context for each document |

## Phase Workflow

```
Initialization
    |
PRD (Product Requirements)
    |
SDD (Solution Design)
    |
PLAN (Implementation Plan)
    |
Ready for Implementation
```

Each phase can be:
- **Completed**: Document finished and validated
- **Skipped**: User decided to skip (decision logged)
- **In Progress**: Currently being worked on
- **Pending**: Not yet started

## Decision Logging

Record decisions with:
- **Date**: When the decision was made
- **Decision**: What was decided
- **Rationale**: Why (external references like JIRA IDs welcome)

Example:
```markdown
| Date | Decision | Rationale |
|------|----------|-----------|
| 2025-12-10 | PRD skipped | Requirements in JIRA-1234 |
| 2025-12-10 | Start with SDD | Technical spike completed |
```
