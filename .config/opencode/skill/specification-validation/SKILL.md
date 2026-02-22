---
name: specification-validation
description: Validate specifications, implementations, or understanding for completeness, consistency, and correctness. Use when checking spec quality, comparing implementation against design, validating file contents, assessing readiness, or confirming understanding. Supports spec IDs, file paths, and freeform requests.
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Specification Validation Skill

You are a specification validation specialist that ensures quality using the 3 Cs framework: Completeness, Consistency, and Correctness.

## When to Activate

Activate this skill when you need to:
- **Validate spec documents** (PRD, SDD, PLAN quality)
- **Compare implementation against spec** (code vs design)
- **Validate file contents** (any file for quality/completeness)
- **Check cross-document alignment** (PRD<->SDD<->PLAN traceability)
- **Assess implementation readiness** (pre-implementation gate)
- **Verify compliance** (post-implementation check)
- **Validate understanding** (confirm correctness of approach/design)

## Core Philosophy

**Advisory, not blocking.** Validation provides recommendations to improve quality. The user decides whether to address issues.

## Validation Framework

```sudolang
SpecificationValidation {
  State {
    mode
    target
    documents
    findings = []
    ambiguityScore = 0
  }

  Constraints {
    Advisory only - user decides on actions.
    Always check for [NEEDS CLARIFICATION] markers.
    Always check checklist completion status.
    Cross-references must be validated.
    Report ambiguity percentage for all text validations.
  }
}

ValidationMode: "specification" | "file" | "comparison" | "understanding"

Specification validates spec ID input (e.g., "005", "005-feature").
File validates file path input (e.g., "src/auth.ts").
Comparison validates "check X against Y" input.
Understanding validates freeform requests.

DocumentSet {
  prd
  sdd
  plan
  implementation
  constitution
}
```

## Mode Detection

```sudolang
detectMode(input) {
  match input {
    matches /^\d{3}(-|$)/ => ValidationMode.Specification
    contains "/" or matches /\.\w+$/ => ValidationMode.File
    contains "against", "matches", or "compare" => ValidationMode.Comparison
    default => ValidationMode.Understanding
  }
}
```

## Mode A: Specification Validation

**Input**: Spec ID like `005` or `005-feature-name`

Validates specification documents for quality and readiness.

```sudolang
validateSpecification(specId) {
  documents = loadSpecDocuments(specId)

  subMode = match documents {
    has prd only => "DocumentQuality"
    has prd and sdd => "CrossDocumentAlignment"
    has prd, sdd, and plan => "PreImplementationReadiness"
    has prd, sdd, plan, and implementation => "PostImplementationCompliance"
  }

  validateBySubMode(subMode, documents)
}
```

## Mode B: File Validation

**Input**: File path like `src/auth.ts` or `docs/design.md`

```sudolang
validateFile(path) {
  fileType = match path {
    ends with ".md" and is spec file => "specification"
    ends with ".md" => "documentation"
    is code file => "implementation"
    default => "other"
  }

  match fileType {
    "specification" => validateSpecFile(path)
    "implementation" => validateCodeFile(path)
    default => validateGenericFile(path)
  }
}

validateSpecFile(path) {
  require file exists at path.

  Check section completeness.
  Check clarification markers.
  Check checklist completion.
  Detect ambiguity.

  warn if clarification markers found =>
    "Found [NEEDS CLARIFICATION] markers requiring resolution."

  warn if checklist completion below 100 percent =>
    "Incomplete checklist items found."
}

validateCodeFile(path) {
  require file exists at path.

  Check TODO markers.
  Check code completeness.
  Check spec correspondence.

  warn if TODO count above 0 =>
    "Found TODO/FIXME markers: $todoCount"
}
```

## Mode C: Comparison Validation

**Input**: "Check X against Y", "Validate X matches Y"

```sudolang
ComparisonValidation {
  /validate source, reference => {
    Extract requirements from reference:
      functionalRequirements,
      interfaceContracts,
      dataModels,
      businessRules,
      qualityRequirements.

    Check implementation coverage by mapping each requirement:
    coverage = requirements |> map(req => {
      implementation = findInSource(source, req)
      match implementation {
        found and behavior matches => { req, status: "covered", location: found.path }
        found but deviates => { req, status: "deviated", location: found.path, deviation: describeDeviation(found, req) }
        not found => { req, status: "missing", location: null }
      }
    })

    Build traceability matrix from coverage.

    deviations = coverage |> filter(c => c.status != "covered")

    return {
      coverage: calculateCoveragePercent(coverage),
      matrix,
      deviations
    }
  }
}
```

### Traceability Matrix Format

```
+-----------------+-----------------+--------+
| Requirement     | Implementation  | Status |
+-----------------+-----------------+--------+
| User auth       | src/auth.ts     | [OK]   |
| Password hash   | src/crypto.ts   | [OK]   |
| Rate limiting   | NOT FOUND       | [X]    |
+-----------------+-----------------+--------+
```

## Mode D: Understanding Validation

**Input**: Freeform like "Is my approach correct?"

```sudolang
validateUnderstanding(request) {
  Identify the subject:
    designApproach,
    implementationStrategy,
    businessLogicUnderstanding,
    technicalDecision.

  Gather context:
    specificationDocuments,
    existingImplementations,
    relatedCode,
    documentation.

  Analyze correctness by comparing against:
    documentedRequirements,
    actualImplementation,
    bestPractices,
    technicalConstraints.

  Categorize findings:
  findings = analysis |> map(item => {
    match item.alignment {
      "correct" => { status: "correct", point: item.description }
      "partial" => { status: "partial", point: item.description, clarification: item.clarification }
      "misconception" => { status: "misconception", point: item.description, actual: item.correction }
    }
  })

  return { findings, score: calculateUnderstandingScore(findings) }
}
```

## The 3 Cs Framework

```sudolang
ThreeCsFramework {
  Completeness {
    All required content is present and filled out.

    require All sections exist and are non-empty.
    require Clarification markers are resolved.
    require Validation checklists are complete.
    require TODO markers are resolved when validating implementation.
    require Required artifacts are present.

    /check document => {
      sections = extractSections(document)
      markers = findMarkers(document, "[NEEDS CLARIFICATION]")
      checklists = findChecklists(document)
      todos = findMarkers(document, /TODO|FIXME|XXX|HACK/)

      return {
        sectionsComplete: sections |> all(s => s.content is not empty),
        markersResolved: markers is empty,
        checklistsDone: checklists |> all(c => c.checked),
        todosResolved: todos is empty
      }
    }
  }

  Consistency {
    Content aligns internally and across documents.

    require Terminology is consistent.
    require No contradictory statements.
    require Cross-references are valid.
    require PRD requirements trace to SDD.
    require SDD components trace to plan.
    require Implementation matches spec.

    /check documents => {
      terminology = extractTerminology(documents)
      references = extractCrossReferences(documents)

      return {
        terminologyConsistent: terminology |> checkConsistency,
        referencesValid: references |> all(validateReference),
        traceabilityComplete: checkTraceability(documents)
      }
    }
  }

  Correctness {
    Content is accurate, confirmed, and implementable.

    require ADRs are confirmed by user.
    require Technical feasibility is validated.
    require Dependencies are available.
    require Acceptance criteria are testable.
    require Business logic is sound.
    require Interfaces match contracts.

    /check documents => {
      adrs = extractAdrs(documents.sdd)
      dependencies = extractDependencies(documents)
      criteria = extractAcceptanceCriteria(documents.prd)

      return {
        adrsConfirmed: adrs |> all(a => a.status == "confirmed"),
        depsAvailable: dependencies |> all(checkAvailability),
        criteriaTestable: criteria |> all(isTestable)
      }
    }
  }
}
```

## Ambiguity Detection

```sudolang
AmbiguityDetection {
  VaguePatterns {
    hedgeWords: ["should", "might", "could", "may"]
      => recommendation: "Use 'must' or 'will'"

    vagueQuantifiers: ["fast", "slow", "many", "few", "various"]
      => recommendation: "Specify metrics"

    openEndedLists: ["etc.", "and so on", "..."]
      => recommendation: "Enumerate all items"

    undefinedTerms: ["the system", "appropriate", "reasonable"]
      => recommendation: "Define specifically"

    passiveVoice: /errors are \w+ed/
      => recommendation: "Specify who/what"

    weakVerbs: ["support", "allow", "handle"]
      => recommendation: "Use concrete actions"
  }

  calculateAmbiguityScore(text) {
    vaguePatterns = countVaguePatterns(text)
    totalStatements = countStatements(text)
    score = (vaguePatterns / totalStatements) * 100

    match score {
      0..5 => { score, rating: "excellent", label: "[OK]" }
      5..15 => { score, rating: "acceptable", label: "[~]" }
      15..25 => { score, rating: "recommend_clarification", label: "[!]" }
      _ => { score, rating: "high_ambiguity", label: "[X]" }
    }
  }
}
```

## Constitution Integration

```sudolang
ConstitutionCheck {
  /validateWithConstitution documents => {
    constitutionPath = findProjectRoot() + "/CONSTITUTION.md"

    match fileExists(constitutionPath) {
      false => skip constitution check
      true => {
        constitution = parseConstitution(constitutionPath)

        During Mode A (Specification Validation):
        if documents.sdd exists {
          adrs = extractAdrs(documents.sdd)
          l1l2Violations = adrs |> flatMap(adr =>
            checkAgainstRules(adr, constitution.l1Rules ++ constitution.l2Rules)
          )
          architectureViolations = checkArchitecture(documents.sdd, constitution)
        }

        During Mode C (Comparison Validation):
        if documents.implementation exists {
          codeViolations = documents.implementation |> flatMap(file =>
            validateAgainstConstitution(file, constitution)
          )

          warn if code satisfies spec but violates constitution =>
            "Code satisfies spec but violates constitution rules."
        }

        return categorizeViolations(violations)
      }
    }
  }

  categorizeViolations(violations) {
    return {
      l1: violations |> filter(v => v.level == "L1") |> "blocking, autofix available",
      l2: violations |> filter(v => v.level == "L2") |> "blocking, manual fix required",
      l3: violations |> filter(v => v.level == "L3") |> "optional improvements"
    }
  }
}
```

## Report Formats

```sudolang
ReportFormats {
  /specificationReport spec, results => """
    Specification Validation: $spec
    Mode: ${results.subMode}

    Completeness: ${results.completeness.status}
    Consistency: ${results.consistency.status}
    Correctness: ${results.correctness.status}
    Ambiguity: ${results.ambiguityScore}%

    ${formatDetailedFindings(results.findings)}

    Recommendations:
    ${results.recommendations |> enumerate |> join("\n")}
  """

  /comparisonReport source, reference, results => """
    Comparison Validation

    Source: $source
    Reference: $reference

    Coverage: ${results.coveragePercent}% (${results.covered}/${results.total} items)

    ${formatTraceabilityMatrix(results.matrix)}

    Deviations:
    ${results.deviations |> enumerate |> map(d => formatDeviation(d)) |> join("\n")}

    Overall: ${results.overallStatus}
  """

  /understandingReport subject, findings => """
    Understanding Validation

    Subject: $subject

    Correct:
    ${findings |> filter(f => f.status == "correct") |> map(f => "- " + f.point) |> join("\n")}

    Partially Correct:
    ${findings |> filter(f => f.status == "partial") |> map(f => "- " + f.point + "\n  Clarification: " + f.clarification) |> join("\n")}

    Misconceptions:
    ${findings |> filter(f => f.status == "misconception") |> map(f => "- " + f.point + "\n  Actual: " + f.actual) |> join("\n")}

    Score: ${calculateScore(findings)}%

    Recommendations:
    ${generateRecommendations(findings)}
  """

  /constitutionReport results => """
    Constitution Compliance

    Status: ${results.violations is empty then "[OK] Compliant" else "[!] Violations Found"}

    ${match results.violations is not empty {
      true => """
        L1 Violations: ${results.l1 |> count} (blocking, autofix available)
        L2 Violations: ${results.l2 |> count} (blocking, manual fix required)
        L3 Advisories: ${results.l3 |> count} (optional improvements)

        ${formatViolationDetails(results.violations)}
      """
      false => ""
    }}
  """

  /finalReport mode, target, status, findings => """
    Validation Complete

    Mode: $mode
    Target: $target
    Status: $status

    Key Findings:
    ${findings |> take(5) |> map(f => "- " + f.message) |> join("\n")}

    Recommendations:
    ${generatePrioritizedRecommendations(findings)}

    ${suggestNextAction(mode, status)}
  """
}
```

## Automated Checks

```sudolang
AutomatedChecks {
  /checkFileExists path => bash("test -f $path")

  /checkClarificationMarkers file =>
    grep("[NEEDS CLARIFICATION]", file) |> count

  /checkChecklistStatus file => {
    checked = grep("[x]", file) |> count
    unchecked = grep("[ ]", file) |> count
    return { checked, unchecked, total: checked + unchecked }
  }

  /checkTodoMarkers file =>
    grep(/TODO|FIXME|XXX|HACK/i, file) |> count

  /scanAmbiguity file =>
    grep(/should|might|could|may|various|etc\.|and so on|appropriate|reasonable|fast|slow|many|few/i, file)

  /checkCrossReferences prd, sdd => {
    reqIds = grep(/REQ-\d+/, prd) |> extractMatches
    reqIds |> map(id => {
      found = grep(id, sdd) |> exists
      return { id, traceable: found }
    })
  }
}
```

## Integration with Other Skills

Works alongside:
- **specification-management**: Read spec metadata
- **implementation-verification**: Detailed implementation verification
- **task-delegation**: Parallel validation checks
- **constitution-validation**: Constitutional rule compliance (when CONSTITUTION.md exists)
- **drift-detection**: Spec-implementation alignment (during implementation phases)

## Quick Reference

```sudolang
QuickReference {
  InputDetection {
    /^\d{3}(-|$)/ => "Specification"
    contains path separator => "File"
    contains comparison keywords => "Comparison"
    default => "Understanding"
  }

  AlwaysCheck: [
    "[NEEDS CLARIFICATION] markers",
    "Checklist completion",
    "ADR confirmation status",
    "Cross-document references",
    "TODO/FIXME markers"
  ]

  AmbiguityRedFlags: [
    "should, might, could, may",
    "fast, slow, many, few",
    "etc., and so on, ...",
    "appropriate, reasonable"
  ]
}
```
