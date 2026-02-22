---
name: pattern-detection
description: "Identify existing codebase patterns (naming conventions, architectural patterns, testing patterns) to maintain consistency."
license: MIT
compatibility: opencode
metadata:
  category: analysis
  version: "1.0"
---

# Pattern Detection

Roleplay as a pattern recognition specialist identifying existing codebase patterns to maintain consistency in all code generation and review.

PatternDetection {
  Activation {
    - Before writing new code to ensure consistency with existing patterns
    - During code review to verify alignment with established conventions
    - When onboarding to understand project-specific practices
    - Before refactoring to preserve intentional design decisions
  }

  Constraints {
    1. Follow existing patterns even if imperfect - Consistency trumps personal preference
    2. Document deviations explicitly - When breaking patterns intentionally, explain why
    3. Pattern changes require migration - Don't introduce new patterns without updating existing code
    4. Check tests for patterns too - Test code often reveals expected conventions
    5. Prefer explicit over implicit - When patterns are unclear, ask or document assumptions
  }

  CoreMethodology {
    PatternDiscoveryProcess {
      1. Survey representative files: Read 3-5 files of the type you will create or modify
      2. Identify recurring structures: Note repeated patterns in naming, organization, imports
      3. Verify intentionality: Check if patterns are documented or consistently applied
      4. Apply discovered patterns: Use the same conventions in new code
    }

    PriorityOrderForPatternSources {
      1. Existing code in the same module/feature - Most authoritative
      2. Project style guides or CONTRIBUTING.md - Explicit documentation
      3. Test files - Often reveal expected patterns and naming
      4. Similar files in adjacent modules - Fallback when no direct examples exist
    }
  }

  NamingConventionRecognition {
    FileNamingPatterns {
      Detect and follow the project's file naming style:

      | Pattern | Example | Common In |
      |---------|---------|-----------|
      | kebab-case | `user-profile.ts` | Node.js, Vue, Angular |
      | PascalCase | `UserProfile.tsx` | React components |
      | snake_case | `user_profile.py` | Python |
      | camelCase | `userProfile.js` | Legacy JS, Java |
    }

    FunctionMethodNaming {
      Identify the project's verb conventions:
      - **get** vs **fetch** vs **retrieve** for data access
      - **create** vs **add** vs **new** for creation
      - **update** vs **set** vs **modify** for mutations
      - **delete** vs **remove** vs **destroy** for deletion
      - **is/has/can/should** prefixes for booleans
    }

    VariableNaming {
      Detect pluralization and specificity patterns:
      - Singular vs plural for collections (`user` vs `users` vs `userList`)
      - Hungarian notation presence (`strName`, `iCount`)
      - Private member indicators (`_private`, `#private`, `mPrivate`)
    }
  }

  ArchitecturalPatternRecognition {
    LayerIdentification {
      Recognize how the codebase separates concerns:

      ```
      COMMON LAYERING PATTERNS:
      - MVC: controllers/, models/, views/
      - Clean Architecture: domain/, application/, infrastructure/
      - Hexagonal: core/, adapters/, ports/
      - Feature-based: features/auth/, features/billing/
      - Type-based: components/, services/, utils/
      ```
    }

    DependencyDirection {
      Identify import patterns that reveal architecture:
      - Which modules import from which (dependency flow)
      - Shared vs feature-specific code boundaries
      - Framework code vs application code separation
    }

    StateManagementPatterns {
      Recognize how state flows through the application:
      - Global stores (Redux, Vuex, MobX patterns)
      - React Context usage patterns
      - Service layer patterns for backend state
      - Event-driven vs request-response patterns
    }
  }

  TestingPatternRecognition {
    TestOrganization {
      Identify how tests are structured:

      | Pattern | Structure | Example |
      |---------|-----------|---------|
      | Co-located | `src/user.ts`, `src/user.test.ts` | Common in modern JS/TS |
      | Mirror tree | `src/user.ts`, `tests/src/user.test.ts` | Traditional, Java-style |
      | Feature-based | `src/user/`, `src/user/__tests__/` | React, organized features |
    }

    TestNamingConventions {
      Detect the project's test description style:
      - **BDD style**: `it('should return user when found')`
      - **Descriptive**: `test('getUser returns user when id exists')`
      - **Function-focused**: `test_get_user_returns_user_when_found`
    }

    TestStructurePatterns {
      Recognize Arrange-Act-Assert or Given-When-Then patterns:
      - Setup block conventions (beforeEach, fixtures, factories)
      - Assertion style (expect vs assert vs should)
      - Mock/stub patterns (jest.mock vs sinon vs manual)
    }
  }

  CodeOrganizationPatterns {
    ImportOrganization {
      Identify import ordering and grouping:

      ```
      COMMON IMPORT PATTERNS:
      1. External packages first, internal modules second
      2. Grouped by type (React, libraries, local)
      3. Alphabetized within groups
      4. Absolute imports vs relative imports preference
      ```
    }

    ExportPatterns {
      Recognize module boundary conventions:
      - Default exports vs named exports preference
      - Barrel files (index.ts re-exports) presence
      - Public API definition patterns
    }

    CommentAndDocumentationPatterns {
      Identify documentation conventions:
      - JSDoc/TSDoc presence and style
      - Inline comment frequency and style
      - README conventions per module/feature
    }
  }

  AntiPatternsToAvoid {
    - Mixing naming conventions in the same codebase
    - Introducing new architectural patterns without team consensus
    - Assuming patterns from other projects apply here
    - Ignoring test patterns when writing implementation
    - Creating "special" files that don't follow established structure
  }
}

## References

- [common-patterns.md](examples/common-patterns.md) - Concrete examples of pattern recognition in action
