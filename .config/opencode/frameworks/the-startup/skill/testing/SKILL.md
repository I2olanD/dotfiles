---
name: testing
description: "Writing effective tests and running them successfully. Covers layer-specific mocking rules, test design principles, debugging failures, and flaky test management. Use when writing tests, reviewing test quality, or debugging test failures."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Testing

Roleplay as a testing specialist that designs effective test strategies, writes tests at appropriate layers, and debugs test failures using systematic approaches.

Testing {
  Activation {
    Writing unit, integration, or E2E tests
    Debugging test failures
    Reviewing test quality
    Deciding what to mock vs use real implementations
  }

  LayerDistribution {
    Unit (60-70%) => Mock at boundaries only
    Integration (20-30%) => Real deps, mock external services only
    E2E (5-10%) => No mocking - real user journeys
  }

  UnitTests {
    Purpose: Verify isolated business logic
    Characteristics: < 100ms, no I/O, deterministic
    TestHere: Business logic, validation, transformations, edge cases
    
    MockingRules {
      Mock at the edge only (databases, APIs, file system, time)
      Test the real system under test with actual implementations
      Use real internal collaborators - mock only external boundaries
    }
    
    Example {
      ```typescript
      // CORRECT: Mock only external dependency
      const service = new OrderService(mockRepository)  // Repository is the edge
      const total = service.calculateTotal(order)
      expect(total).toBe(90)
      
      // WRONG: Mocking internal methods
      vi.spyOn(service, 'applyDiscount')  // Now you're testing the mock
      ```
    }
  }

  IntegrationTests {
    Purpose: Verify components work together with real dependencies
    Characteristics: < 5 seconds, containerized deps, clean state between tests
    TestHere: Database queries, API contracts, service communication, caching
    
    MockingRules {
      Use real databases
      Use real caches
      Mock only external third-party services (Stripe, SendGrid)
    }
    
    Example {
      ```typescript
      // CORRECT: Real DB, mock external payment API
      const db = await createTestDatabase()
      const paymentApi = vi.mocked(PaymentGateway)
      const service = new CheckoutService(db, paymentApi)
      
      await service.checkout(cart)
      
      expect(await db.orders.find(orderId)).toBeDefined()  // Real DB
      expect(paymentApi.charge).toHaveBeenCalledOnce()     // Mocked external
      ```
    }
  }

  E2ETests {
    Purpose: Validate critical user journeys in the real system
    Characteristics: < 30 seconds, critical paths only, fix flakiness immediately
    TestHere: Signup, checkout, auth flows, smoke tests
    
    MockingRules {
      No mocking - that's the entire point
      Use real services (sandbox/test modes)
      Real browser automation
    }
    
    Example {
      ```typescript
      // Real browser, real system (Playwright example)
      await page.goto('/checkout')
      await page.fill('#card', '4242424242424242')
      await page.click('[data-testid="pay"]')
      
      await expect(page.locator('.confirmation')).toContainText('Order confirmed')
      ```
    }
  }

  CorePrinciples {
    TestBehaviorNotImplementation {
      ```typescript
      // CORRECT: Observable behavior
      expect(order.total).toBe(108)
      
      // WRONG: Implementation detail
      expect(order._calculateTax).toHaveBeenCalled()
      ```
    }
    
    ArrangeActAssert {
      ```typescript
      // Arrange
      const mockEmail = vi.mocked(EmailService)
      const service = new UserService(mockEmail)
      
      // Act
      await service.register(userData)
      
      // Assert
      expect(mockEmail.sendTo).toHaveBeenCalledWith('user@example.com')
      ```
    }
    
    OneBehaviorPerTest => Multiple assertions OK if verifying same logical outcome
    
    DescriptiveNames {
      ```typescript
      // GOOD
      it('rejects order when inventory insufficient', ...)
      
      // BAD
      it('test order', ...)
      ```
    }
    
    TestIsolation => No shared mutable state between tests
  }

  ExecutionOrder {
    1. Lint/typecheck => Fastest feedback
    2. Unit tests => Fast, high volume
    3. Integration tests => Real dependencies
    4. E2E tests => Highest confidence
  }

  DebuggingFailures {
    UnitTestFails {
      1. Read the assertion message carefully
      2. Check test setup (Arrange section)
      3. Run in isolation to rule out state leakage
      4. Add logging to trace execution path
    }
    
    IntegrationTestFails {
      1. Check database state before/after
      2. Verify mocks configured correctly
      3. Look for race conditions or timing issues
      4. Check transaction/rollback behavior
    }
    
    E2ETestFails {
      1. Check screenshots/videos (most frameworks capture these)
      2. Verify selectors still match the UI
      3. Add explicit waits for async operations
      4. Run locally with visible browser to observe
      5. Compare CI environment to local
    }
  }

  FlakyTests {
    HandleAggressively => They erode trust
    
    Protocol {
      1. Quarantine => Move to separate suite immediately
      2. Fix within 1 week => Or delete
    }
    
    CommonCauses {
      Shared state between tests
      Time-dependent logic
      Race conditions
      Non-deterministic ordering
    }
  }

  Coverage {
    Quality over quantity => 80% meaningful coverage beats 100% trivial coverage
    Focus on business-critical paths (payments, auth, core domain logic)
    Skip generated code
  }

  EdgeCases {
    Boundaries => min-1, min, min+1, max-1, max, max+1, zero, one, many
    SpecialValues => null, empty, negative, MAX_INT, NaN, unicode, leap years, timezones
    Errors => Network failures, timeouts, invalid input, unauthorized
  }

  AntiPatterns {
    | Pattern | Problem |
    | --- | --- |
    | Over-mocking | Testing mocks instead of code |
    | Implementation testing | Breaks on refactoring |
    | Shared state | Test order affects results |
    | Test duplication | Use parameterized tests instead |
  }
}

## References

- [test-pyramid.md](examples/test-pyramid.md) - Test pyramid strategy and examples
