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
# See: skill/shared/interfaces.sudo.md for ValidationResult, Finding

SpecificationValidation {
  State {
    mode: ValidationMode
    target: String
    documents: DocumentSet
    findings: Finding[]
    ambiguityScore: Number
  }

  constraints {
    Advisory only - user decides on actions
    Always check for [NEEDS CLARIFICATION] markers
    Always check checklist completion status
    Cross-references must be validated
    Report ambiguity percentage for all text validations
  }
}

ValidationMode: enum {
  Specification  // Spec ID input (e.g., "005", "005-feature")
  File           // File path input (e.g., "src/auth.ts")
  Comparison     // "Check X against Y" input
  Understanding  // Freeform validation request
}

interface DocumentSet {
  prd: Document?
  sdd: Document?
  plan: Document?
  implementation: File[]?
  constitution: Document?
}
```

## Mode Detection

```sudolang
fn detectMode(input: String) {
  match (input) {
    case input if input.matches(/^\d{3}(-|$)/) => ValidationMode.Specification
    case input if input.contains("/") || input.matches(/\.\w+$/) => ValidationMode.File
    case input if input.containsAny(["against", "matches", "compare"]) => ValidationMode.Comparison
    default => ValidationMode.Understanding
  }
}
```

## Mode A: Specification Validation

**Input**: Spec ID like `005` or `005-feature-name`

Validates specification documents for quality and readiness.

```sudolang
fn validateSpecification(specId: String) {
  documents = loadSpecDocuments(specId)
  
  subMode = match (documents) {
    case { prd, sdd: null, plan: null } => "DocumentQuality"
    case { prd, sdd, plan: null } => "CrossDocumentAlignment"
    case { prd, sdd, plan, implementation: null } => "PreImplementationReadiness"
    case { prd, sdd, plan, implementation } => "PostImplementationCompliance"
  }
  
  validateBySubMode(subMode, documents)
}
```

## Mode B: File Validation

**Input**: File path like `src/auth.ts` or `docs/design.md`

```sudolang
fn validateFile(path: String) {
  fileType = match (path) {
    case path if path.endsWith(".md") && isSpecFile(path) => "specification"
    case path if path.endsWith(".md") => "documentation"
    case path if isCodeFile(path) => "implementation"
    default => "other"
  }
  
  match (fileType) {
    case "specification" => validateSpecFile(path)
    case "implementation" => validateCodeFile(path)
    default => validateGenericFile(path)
  }
}

fn validateSpecFile(path: String) {
  require file exists at path
  
  checks = [
    checkSectionCompleteness(path),
    checkClarificationMarkers(path),
    checkChecklistCompletion(path),
    detectAmbiguity(path)
  ]
  
  warn if clarificationMarkers > 0 =>
    "Found [NEEDS CLARIFICATION] markers requiring resolution"
  
  warn if checklistCompletion < 100 =>
    "Incomplete checklist items found"
}

fn validateCodeFile(path: String) {
  require file exists at path
  
  checks = [
    checkTodoMarkers(path),
    checkCodeCompleteness(path),
    checkSpecCorrespondence(path)
  ]
  
  warn if todoCount > 0 =>
    "Found TODO/FIXME markers: $todoCount"
}
```

## Mode C: Comparison Validation

**Input**: "Check X against Y", "Validate X matches Y"

```sudolang
ComparisonValidation {
  /validate source:String, reference:String => {
    // Step 1: Extract requirements from reference
    requirements = extractRequirements(reference) {
      functionalRequirements
      interfaceContracts
      dataModels
      businessRules
      qualityRequirements
    }
    
    // Step 2: Check implementation coverage
    coverage = requirements |> map(req => {
      implementation = findInSource(source, req)
      match (implementation) {
        case found if behaviorMatches(found, req) => { req, status: "covered", location: found.path }
        case found => { req, status: "deviated", location: found.path, deviation: describeDeviation(found, req) }
        case null => { req, status: "missing", location: null }
      }
    })
    
    // Step 3: Build traceability matrix
    matrix = buildTraceabilityMatrix(coverage)
    
    // Step 4: Report deviations
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
fn validateUnderstanding(request: String) {
  // Step 1: Identify subject
  subject = identifySubject(request) {
    designApproach
    implementationStrategy
    businessLogicUnderstanding
    technicalDecision
  }
  
  // Step 2: Gather context
  context = gatherContext(subject) {
    specificationDocuments
    existingImplementations
    relatedCode
    documentation
  }
  
  // Step 3: Analyze correctness
  analysis = compareAgainst(subject, context) {
    documentedRequirements
    actualImplementation
    bestPractices
    technicalConstraints
  }
  
  // Step 4: Categorize findings
  findings = analysis |> map(item => {
    match (item.alignment) {
      case "correct" => { status: "correct", point: item.description }
      case "partial" => { status: "partial", point: item.description, clarification: item.clarification }
      case "misconception" => { status: "misconception", point: item.description, actual: item.correction }
    }
  })
  
  return { findings, score: calculateUnderstandingScore(findings) }
}
```

## The 3 Cs Framework

```sudolang
ThreeCsFramework {
  Completeness {
    description: "All required content is present and filled out"
    
    require allSectionsExist && allSectionsNonEmpty
    require clarificationMarkers == 0
    require validationChecklistsComplete
    require todoMarkers == 0 when validatingImplementation
    require requiredArtifactsPresent
    
    /check document => {
      sections = extractSections(document)
      markers = findMarkers(document, "[NEEDS CLARIFICATION]")
      checklists = findChecklists(document)
      todos = findMarkers(document, /TODO|FIXME|XXX|HACK/)
      
      return {
        sectionsComplete: sections |> all(s => s.content.length > 0),
        markersResolved: markers.length == 0,
        checklistsDone: checklists |> all(c => c.checked),
        todosResolved: todos.length == 0
      }
    }
  }
  
  Consistency {
    description: "Content aligns internally and across documents"
    
    require terminologyConsistent
    require noContradictoryStatements
    require crossReferencesValid
    require prdRequirementsTraceToSdd
    require sddComponentsTraceToPlan
    require implementationMatchesSpec
    
    /check documents:DocumentSet => {
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
    description: "Content is accurate, confirmed, and implementable"
    
    require adrsConfirmedByUser
    require technicalFeasibilityValidated
    require dependenciesAvailable
    require acceptanceCriteriaTestable
    require businessLogicSound
    require interfacesMatchContracts
    
    /check documents:DocumentSet => {
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
  VaguePatterns: Map {
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
  
  fn calculateAmbiguityScore(text: String) {
    vaguePatterns = countVaguePatterns(text)
    totalStatements = countStatements(text)
    score = (vaguePatterns / totalStatements) * 100
    
    return match (score) {
      case 0..5 => { score, rating: "excellent", emoji: "[OK]" }
      case 5..15 => { score, rating: "acceptable", emoji: "[~]" }
      case 15..25 => { score, rating: "recommend_clarification", emoji: "[!]" }
      case _ => { score, rating: "high_ambiguity", emoji: "[X]" }
    }
  }
}
```

## Constitution Integration

```sudolang
ConstitutionCheck {
  /validateWithConstitution documents:DocumentSet => {
    constitutionPath = findProjectRoot() + "/CONSTITUTION.md"
    
    match (fileExists(constitutionPath)) {
      case false => skip constitution check
      case true => {
        constitution = parseConstitution(constitutionPath)
        
        // During Mode A (Specification Validation)
        if (documents.sdd) {
          adrs = extractAdrs(documents.sdd)
          l1l2Violations = adrs |> flatMap(adr => 
            checkAgainstRules(adr, constitution.l1Rules ++ constitution.l2Rules)
          )
          architectureViolations = checkArchitecture(documents.sdd, constitution)
        }
        
        // During Mode C (Comparison Validation)
        if (documents.implementation) {
          codeViolations = documents.implementation |> flatMap(file =>
            validateAgainstConstitution(file, constitution)
          )
          
          warn if satisfiesSpecButViolatesConstitution =>
            "Code satisfies spec but violates constitution rules"
        }
        
        return categorizeViolations(violations)
      }
    }
  }
  
  fn categorizeViolations(violations) {
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
  /specificationReport spec:String, results:ValidationResult => """
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
  
  /comparisonReport source:String, reference:String, results => """
    Comparison Validation
    
    Source: $source
    Reference: $reference
    
    Coverage: ${results.coveragePercent}% (${results.covered}/${results.total} items)
    
    ${formatTraceabilityMatrix(results.matrix)}
    
    Deviations:
    ${results.deviations |> enumerate |> map(d => formatDeviation(d)) |> join("\n")}
    
    Overall: ${results.overallStatus}
  """
  
  /understandingReport subject:String, findings => """
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
    
    Status: ${results.violations.length == 0 ? "[OK] Compliant" : "[!] Violations Found"}
    
    ${match (results.violations.length > 0) {
      case true => """
        L1 Violations: ${results.l1.length} (blocking, autofix available)
        L2 Violations: ${results.l2.length} (blocking, manual fix required)
        L3 Advisories: ${results.l3.length} (optional improvements)
        
        ${formatViolationDetails(results.violations)}
      """
      case false => ""
    }}
  """
  
  /finalReport mode:ValidationMode, target:String, status:String, findings => """
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
  /checkFileExists path:String => bash("test -f $path")
  
  /checkClarificationMarkers file:String => 
    grep("[NEEDS CLARIFICATION]", file) |> count
  
  /checkChecklistStatus file:String => {
    checked = grep("[x]", file) |> count
    unchecked = grep("[ ]", file) |> count
    return { checked, unchecked, total: checked + unchecked }
  }
  
  /checkTodoMarkers file:String =>
    grep(/TODO|FIXME|XXX|HACK/i, file) |> count
  
  /scanAmbiguity file:String =>
    grep(/should|might|could|may|various|etc\.|and so on|appropriate|reasonable|fast|slow|many|few/i, file)
  
  /checkCrossReferences prd:String, sdd:String => {
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
  InputDetection: {
    /^\d{3}(-|$)/ => "Specification"
    containsPathSeparator => "File"
    containsComparisonKeywords => "Comparison"
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
