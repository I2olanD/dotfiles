# The 3 Cs Validation Framework

Core validation methodology for specifications, implementations, and understanding.

## The 3 Cs

### 1. Completeness

All required content is present and filled out.

**Checks:**
- All sections exist and are non-empty
- No `[NEEDS CLARIFICATION]` markers
- Validation checklists complete
- No TODO/FIXME markers (for implementation)
- Required artifacts present

### 2. Consistency

Content aligns internally and across documents.

**Checks:**
- Terminology used consistently
- No contradictory statements
- Cross-references are valid
- PRD requirements trace to SDD components
- SDD components trace to PLAN tasks
- Implementation matches specification

### 3. Correctness

Content is accurate, confirmed, and implementable.

**Checks:**
- ADRs confirmed by user
- Technical feasibility validated
- Dependencies are available
- Acceptance criteria testable
- Business logic is sound
- Interfaces match contracts

---

## Validation Modes

### Mode A: Specification Validation

**Input**: Spec ID like `005` or `005-feature-name`

Validates specification documents for quality and readiness.

**Sub-modes based on documents present:**
- PRD only --> Document quality validation
- PRD + SDD --> Cross-document alignment
- PRD + SDD + PLAN --> Pre-implementation readiness
- All + implementation --> Post-implementation compliance

### Mode B: File Validation

**Input**: File path like `src/auth.ts` or `docs/design.md`

Validates individual files for quality and completeness.

**For specification files:**
- Structure and section completeness
- `[NEEDS CLARIFICATION]` markers
- Checklist completion
- Ambiguity detection

**For implementation files:**
- TODO/FIXME markers
- Code completeness
- Correspondence to spec (if exists)
- Quality indicators

### Mode C: Comparison Validation

**Input**: "Check X against Y", "Validate X matches Y"

Compares source (implementation) against reference (specification).

**Process:**
1. Identify source and reference
2. Extract requirements/components from reference
3. Check each against source
4. Report coverage and deviations

### Mode D: Understanding Validation

**Input**: Freeform like "Is my approach correct?"

Validates understanding, approach, or design decisions.

**Process:**
1. Identify subject of validation
2. Gather relevant context
3. Analyze correctness
4. Provide validation with explanations

### Mode E: Constitution Validation

**Input**: `constitution` or "validate against constitution"

Validates code against project governance rules.

**Process:**
1. Parse CONSTITUTION.md rules
2. Apply scopes to find matching files
3. Execute checks (Pattern or Check rules)
4. Generate compliance report

---

## Comparison Validation Process

When comparing implementation against specification:

### Step 1: Extract Requirements

From the reference document (spec), extract:
- Functional requirements
- Interface contracts
- Data models
- Business rules
- Quality requirements

### Step 2: Check Implementation

For each requirement:
- Search implementation for corresponding code
- Verify behavior matches specification
- Note any deviations or gaps

### Step 3: Build Traceability Matrix

```
+-------------------+-------------------+--------+
| Requirement       | Implementation    | Status |
+-------------------+-------------------+--------+
| User auth         | src/auth.ts       | PASS   |
| Password hash     | src/crypto.ts     | PASS   |
| Rate limiting     | NOT FOUND         | FAIL   |
+-------------------+-------------------+--------+
```

### Step 4: Report Deviations

For each deviation:
- What differs
- Where in code
- Where in spec
- Recommended action

---

## Understanding Validation Process

When validating understanding or approach:

### Step 1: Identify Subject

What is being validated:
- Design approach
- Implementation strategy
- Business logic understanding
- Technical decision

### Step 2: Gather Context

Find relevant:
- Specification documents
- Existing implementations
- Related code
- Documentation

### Step 3: Analyze Correctness

Compare stated understanding against:
- Documented requirements
- Actual implementation
- Best practices
- Technical constraints

### Step 4: Report Findings

Categorize as:
- Correct understanding
- Partially correct (with clarification)
- Misconception (with correction)

---

## Automated Checks

### File Existence and Content

```bash
# Check file exists
test -f [path]

# Check for markers
grep -c "\[NEEDS CLARIFICATION" [file]

# Check checklist status
grep -c "\[x\]" [file]
grep -c "\[ \]" [file]

# Check for TODOs
grep -inE "(TODO|FIXME|XXX|HACK)" [file]
```

### Cross-Reference Check

```bash
# Find all requirement IDs in PRD
grep -oE "REQ-[0-9]+" prd.md

# Search for each in SDD
grep -l "REQ-001" sdd.md
```

---

## Report Formats

### Specification Validation Report

```
Specification Validation: [NNN]-[name]
Mode: [Sub-mode based on documents]

Completeness: [Status]
Consistency: [Status]
Correctness: [Status]
Ambiguity: [X]%

[Detailed findings per category]

Recommendations:
[Prioritized list]
```

### Comparison Report

```
Comparison Validation

Source: [Implementation]
Reference: [Specification]

Coverage: [X]% ([N/M] items)

| Item | Status | Notes |
|------|--------|-------|
...

Deviations:
1. [Deviation with location and fix]
...

Overall: [Status]
```

### Understanding Report

```
Understanding Validation

Subject: [What's being validated]

Correct:
- [Point]

Partially Correct:
- [Point]
  Clarification: [Detail]

Misconceptions:
- [Point]
  Actual: [Correction]

Score: [X]%

Recommendations:
[List]
```

---

## Input Detection

| Pattern | Mode |
|---------|------|
| `^\d{3}` or `^\d{3}-` | Specification (Mode A) |
| Contains `/` or `.ext` | File (Mode B) |
| Contains "against", "matches" | Comparison (Mode C) |
| `constitution` | Constitution (Mode E) |
| Freeform text | Understanding (Mode D) |

## Always Check

- `[NEEDS CLARIFICATION]` markers
- Checklist completion
- ADR confirmation status
- Cross-document references
- TODO/FIXME markers
