---
name: tdd
description: Apply Test-Driven Development methodology with Red-Green-Refactor cycle. Use when implementing new features, fixing bugs, or when test-first development is required. Covers when to use TDD, cycle execution, and integration with existing test practices.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Test-Driven Development (TDD)

A development methodology where tests are written before implementation code. The test defines the expected behavior, and implementation satisfies that expectation.

## When to Use TDD

### Mandatory TDD Scenarios

```sudolang
TDDMandatory {
  scenarios [
    "New feature development with clear requirements",
    "Bug fixes (reproduce the bug with a failing test first)",
    "API contract implementation (test the contract before building)",
    "Business rule implementation (encode rules as tests)",
    "Refactoring without existing tests (add characterization tests first)"
  ]
}
```

### Optional TDD Scenarios

```sudolang
TDDOptional {
  scenarios [
    "Exploratory/spike work (prototype first, test later)",
    "UI layout (visual testing may be more appropriate)",
    "Generated code (test the generator, not the output)",
    "Configuration files (validation tests instead)"
  ]
}
```

### Skip TDD When

```sudolang
SkipTDD {
  scenarios [
    "One-off scripts not meant for reuse",
    "Pure data migrations with rollback capability",
    "Third-party integrations with mocked tests already exist"
  ]
}
```

---

## The Red-Green-Refactor Cycle

```
    ┌─────────────────────────────────────────┐
    │                                         │
    │   ┌─────┐   ┌───────┐   ┌──────────┐   │
    │   │ RED │ → │ GREEN │ → │ REFACTOR │ ──┘
    │   └─────┘   └───────┘   └──────────┘
    │      │
    │      └── Start here: Write a failing test
    │
```

### Phase 1: Red (Write Failing Test)

**Goal:** Define expected behavior before writing any implementation.

```sudolang
RedPhase {
  Constraints {
    Test MUST fail before proceeding.
    Test MUST fail for the RIGHT reason (missing implementation, not syntax error).
    Test MUST be minimal - test ONE behavior.
  }

  steps [
    "Write a test that describes the desired behavior",
    "Run the test - verify it FAILS",
    "Confirm failure is due to missing implementation"
  ]

  artifacts ["failing test", "clear error message showing missing behavior"]

  /validate => {
    require test runs and status is FAIL
    require failure reason is not SyntaxError
    require failure reason is not ImportError
  }
}
```

**Example - Red Phase:**

```typescript
// RED: Write failing test first
describe('PaymentValidator', () => {
  it('rejects negative payment amounts', () => {
    const validator = new PaymentValidator();

    const result = validator.validate({ amount: -50 });

    expect(result.valid).toBe(false);
    expect(result.error).toBe('Amount must be positive');
  });
});

// Run: npm test
// Result: FAIL - PaymentValidator is not defined (correct failure!)
```

### Phase 2: Green (Make It Pass)

**Goal:** Write the MINIMUM code to make the test pass.

```sudolang
GreenPhase {
  Constraints {
    Write ONLY enough code to pass the test.
    Do NOT optimize or refactor yet.
    Do NOT add features not covered by tests.
    Code can be ugly - that is OK for now.
  }

  steps [
    "Write the simplest implementation that passes",
    "Run the test - verify it PASSES",
    "Do not add anything beyond what the test requires"
  ]

  artifacts ["passing test", "minimal implementation"]

  /validate => {
    require test runs and status is PASS
  }

  antiPatterns [
    "Implementing multiple features at once",
    "Optimizing before tests pass",
    "Adding error handling not required by tests",
    "Writing 'complete' solution instead of minimal"
  ]
}
```

**Example - Green Phase:**

```typescript
// GREEN: Minimal implementation to pass
class PaymentValidator {
  validate(payment: { amount: number }) {
    if (payment.amount < 0) {
      return { valid: false, error: 'Amount must be positive' };
    }
    return { valid: true };
  }
}

// Run: npm test
// Result: PASS
```

### Phase 3: Refactor (Improve Structure)

**Goal:** Improve code quality while keeping all tests green.

```sudolang
RefactorPhase {
  Constraints {
    All tests MUST remain passing.
    Improve structure without changing behavior.
    Apply design patterns where appropriate.
    Remove duplication.
  }

  steps [
    "Identify code smells or improvements",
    "Make ONE small change",
    "Run tests - verify still PASSING",
    "Repeat until satisfied"
  ]

  artifacts ["clean code", "all tests passing"]

  improvements [
    "Extract methods/functions",
    "Rename for clarity",
    "Remove duplication",
    "Apply design patterns",
    "Improve error messages"
  ]

  /validate => {
    require all tests run and status is PASS
    require no new behavior added
  }
}
```

**Example - Refactor Phase:**

```typescript
// REFACTOR: Improve structure, tests still pass
interface PaymentInput {
  amount: number;
  currency?: string;
}

interface ValidationResult {
  valid: boolean;
  error?: string;
}

class PaymentValidator {
  validate(payment: PaymentInput): ValidationResult {
    if (this.isNegativeAmount(payment.amount)) {
      return this.failure('Amount must be positive');
    }
    return this.success();
  }

  private isNegativeAmount(amount: number): boolean {
    return amount < 0;
  }

  private success(): ValidationResult {
    return { valid: true };
  }

  private failure(error: string): ValidationResult {
    return { valid: false, error };
  }
}

// Run: npm test
// Result: PASS (behavior unchanged, structure improved)
```

---

## TDD State Machine

```sudolang
TDDStateMachine {
  State {
    phase
    testCount
    cycleCount
  }

  transitions {
    red => green       When test fails correctly.
    green => refactor  When test passes.
    refactor => red    When starting new behavior.
  }

  Constraints {
    Cannot skip phases.
    Must validate phase completion before transition.
    Each cycle produces one unit of tested behavior.
  }

  /startCycle behavior => {
    phase = "red"
    cycleCount++
    write failing test for behavior
  }

  /toGreen => {
    require phase == "red"
    require currentTest status is FAIL
    require currentTest failure reason is missing implementation
    phase = "green"
  }

  /toRefactor => {
    require phase == "green"
    require currentTest status is PASS
    phase = "refactor"
  }

  /nextBehavior => {
    require phase == "refactor"
    require all tests status is PASS
    phase = "red"
  }
}
```

---

## TDD for Different Test Layers

### Unit Test TDD

```sudolang
UnitTDD {
  cycleTime: "1-5 minutes per cycle"
  scope: "Single function or method"
  mocking: "Mock at boundaries only (DB, APIs, filesystem)"

  workflow [
    "Write test for ONE behavior",
    "Implement in isolation",
    "Refactor internals only"
  ]
}
```

### Integration Test TDD

```sudolang
IntegrationTDD {
  cycleTime: "5-15 minutes per cycle"
  scope: "Component interactions"
  mocking: "Mock external services only"

  workflow [
    "Write test for component contract",
    "Implement with real dependencies",
    "Refactor component boundaries"
  ]

  considerations [
    "Setup/teardown test database",
    "Use transactions for isolation",
    "Test realistic data scenarios"
  ]
}
```

### API Contract TDD

```sudolang
ApiContractTDD {
  cycleTime: "10-20 minutes per cycle"
  scope: "HTTP endpoints"

  workflow [
    "Define API contract (request/response)",
    "Write test that calls endpoint",
    "Implement endpoint to satisfy contract",
    "Refactor handler and middleware"
  ]

  testStructure """
    it('POST /payments creates payment and returns 201', async () => {
      const response = await request(app)
        .post('/payments')
        .send({ amount: 100, currency: 'USD' });

      expect(response.status).toBe(201);
      expect(response.body.id).toBeDefined();
    });
  """
}
```

---

## TDD for Bug Fixes

```sudolang
BugFixTDD {
  workflow [
    "1. Write a test that reproduces the bug (RED)",
    "2. Verify test fails with the bug present",
    "3. Fix the bug (GREEN)",
    "4. Verify test passes",
    "5. Refactor if needed"
  ]

  /fixBug bug => {
    Step 1: Reproduce
    test = writeReproductionTest(bug)
    require test runs and status is FAIL

    Step 2: Fix
    implementation = fixCode(bug)
    require test runs and status is PASS

    Step 3: Verify no regression
    require all tests run and status is PASS
  }

  benefits [
    "Bug is documented as a test",
    "Regression is prevented forever",
    "Fix is verified to actually work"
  ]
}
```

**Example - Bug Fix TDD:**

```typescript
// BUG: Discount not applied for exactly 10 items
// Step 1: Reproduce with failing test
it('applies 10% discount for exactly 10 items', () => {
  const cart = new Cart();
  cart.addItem({ price: 10, quantity: 10 });

  expect(cart.total).toBe(90); // 10% off
});
// FAIL: Expected 90, received 100

// Step 2: Fix the bug
// Found: condition was `quantity > 10` instead of `quantity >= 10`

// Step 3: Verify
// PASS: Bug fixed, test passes, regression prevented
```

---

## TDD for Legacy Code

```sudolang
LegacyCodeTDD {
  challenge: "Code exists without tests"

  workflow [
    "1. Add characterization tests (capture current behavior)",
    "2. Verify tests pass with existing code",
    "3. Now safe to refactor or add features using TDD"
  ]

  characterizationTest {
    purpose: "Document what code DOES, not what it SHOULD do"
    approach: "Call code, observe output, write test that expects that output"
  }

  /addCharacterizationTest targetFunction => {
    Run targetFunction with known inputs.
    Observe the output.
    Write test expecting that output.
    Now behavior is locked, safe to refactor.
  }
}
```

---

## Common TDD Challenges

### Challenge: Hard to Test Code

```sudolang
HardToTestCode {
  symptoms [
    "Need to mock many dependencies",
    "Test setup is complex",
    "Tests are brittle"
  ]

  solutions [
    "Extract dependencies to boundaries",
    "Use dependency injection",
    "Split large functions into smaller ones",
    "Consider if design is wrong"
  ]

  principle: "If it's hard to test, the design may need improvement"
}
```

### Challenge: Test Doubles Decisions

```sudolang
TestDoubles {
  types {
    stub: "Returns canned data"
    mock: "Verifies interactions"
    fake: "Working implementation (in-memory DB)"
    spy: "Records calls for later verification"
  }

  guidelines [
    "Prefer stubs over mocks (test behavior, not implementation)",
    "Mock at boundaries only (external services, databases)",
    "Use fakes for complex dependencies (in-memory DB)",
    "Avoid mocking code you own"
  ]
}
```

### Challenge: How Small Should Increments Be?

```sudolang
IncrementSize {
  guideline: "As small as possible while still being meaningful"

  tooSmall [
    "Testing that a variable exists",
    "Testing constructor sets a field"
  ]

  appropriate [
    "Testing one business rule",
    "Testing one error case",
    "Testing one transformation"
  ]

  tooLarge [
    "Testing entire feature at once",
    "Testing multiple behaviors in one test"
  ]
}
```

---

## TDD Quality Checklist

```sudolang
TDDQualityCheck {
  redPhase [
    "Test fails before implementation?",
    "Failure is for the right reason?",
    "Test name describes the behavior?",
    "Test is minimal and focused?"
  ]

  greenPhase [
    "Implementation is minimal?",
    "No extra features added?",
    "Test passes?"
  ]

  refactorPhase [
    "All tests still pass?",
    "Code is cleaner than before?",
    "No behavior changed?",
    "Duplication removed?"
  ]

  overall [
    "Each test documents one behavior?",
    "Tests are independent?",
    "Tests are deterministic?",
    "Test suite runs fast?"
  ]
}
```

---

## Integration with Implementation Planning

TDD integrates with the implementation-planning skill through the Prime-Test-Implement-Validate structure:

```sudolang
TDDPlanIntegration {
  mapping {
    "Prime" => "Understand context before writing tests"
    "Test" => "RED phase - write failing tests"
    "Implement" => "GREEN phase - make tests pass"
    "Validate" => "REFACTOR phase + quality checks"
  }

  taskStructure """
    - [ ] **Payment Validator** `[activity: domain-modeling]`

      **Prime**: Read payment validation rules from SDD Section 4.2

      **Test**: Validator rejects negative amounts; rejects zero; accepts positive; handles currency

      **Implement**: Create PaymentValidator with validation logic

      **Validate**: Run tests, lint, typecheck
  """
}
```

---

## Related Skills

- **testing**: Layer-specific mocking rules, test execution, debugging failures
- **test-design**: Test pyramid, coverage targets, framework patterns
- **implementation-planning**: TDD cycle embedded in task structure
- **safe-refactoring**: Tests required before refactoring (TDD for existing code)

---

## Quick Reference

```sudolang
TDDQuickReference {
  cycle: "RED => GREEN => REFACTOR => (repeat)"

  redRules [
    "Write test first",
    "Test must fail",
    "Fail for right reason"
  ]

  greenRules [
    "Minimal code only",
    "Make test pass",
    "No extras"
  ]

  refactorRules [
    "Keep tests green",
    "Improve structure",
    "No new behavior"
  ]

  mantra: "Make it fail, make it pass, make it better"
}
```
