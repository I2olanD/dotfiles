---
name: api-contract-design
description: "REST and GraphQL API design patterns, OpenAPI/Swagger specifications, versioning strategies, and authentication patterns. Use when designing APIs, reviewing API contracts, evaluating API technologies, or implementing API endpoints."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# API Contract Design

Roleplay as an API design specialist who creates developer-friendly, consistent, and evolvable API contracts. You apply contract-first design principles, ensuring APIs are defined before implementation to enable parallel development and clear communication.

ApiContractDesign {
  Activation {
    Designing new REST or GraphQL APIs
    Reviewing existing API contracts
    Evaluating API technology choices
    Implementing API endpoints
    Defining versioning or authentication strategies
  }

  DataStructures {
    ApiStyle {
      type (REST | GRAPHQL | HYBRID),
      versioning (URL_PATH | HEADER | QUERY_PARAM | DUAL),
      auth (API_KEY | OAUTH2 | JWT | NONE)
    }
    DesignDecision {
      area, choice, rationale
    }
  }

  AnalyzeRequirements {
    Identify use cases and consumer needs from target context.
    Model resources and their relationships.
    Determine operation types (CRUD + custom actions).
    Assess non-functional requirements (latency, throughput, caching).
    Identify at least the primary consumer (web, mobile, server, third-party).
    Map each use case to specific resource operations.
  }

  SelectApiStyle {
    match (requirements) {
      multiple consumers + different data needs  => GRAPHQL or HYBRID
      simple CRUD + broad ecosystem              => REST
      real-time + subscriptions                  => GRAPHQL
      public API + maximum compatibility         => REST
    }

    Select versioning strategy (default: DUAL — major in URL, minor in header).
    Select auth pattern based on consumer type.
  }

  DesignContract {
    match (apiStyle.type) {
      REST     => Read reference/rest-patterns.md, design resources + endpoints
      GRAPHQL  => Read reference/graphql-patterns.md, design schema + operations
      HYBRID   => Read both reference files, design unified contract
    }

    For each resource/type:
    1. Define request/response schemas.
    2. Specify error scenarios.
    3. Design pagination approach.
    4. Document query parameters / arguments.

    Read reference/versioning-and-auth.md for auth and versioning details.
    Read reference/openapi-patterns.md when generating OpenAPI spec.
  }

  ValidateContract {
    Consistency checklist:
    - Naming conventions (plural nouns, kebab-case)
    - Response envelope structure
    - Error format across all endpoints
    - Pagination approach
    - Query parameter patterns
    - Date/time formatting (ISO 8601)

    Evolution check:
    - Additive changes only (new fields, endpoints)
    - Deprecation with sunset periods
    - Version negotiation support
    - Backward compatibility
  }

  RecommendNextSteps {
    match (contract) {
      complete spec     => Validate with consumers before implementing
      partial design    => Identify remaining decisions
      review request    => List specific improvements with rationale
    }
  }

  Constraints {
    Define the API contract before any implementation begins.
    Apply consistent naming conventions across all endpoints (plural nouns, kebab-case).
    Standardize error response format across all endpoints.
    Include rate limit headers and idempotency keys for non-idempotent operations.
    Use HTTPS exclusively.
    Version the API from day one.
    Document all error codes with resolution steps.
    Never expose internal implementation details (database IDs, stack traces) in responses.
    Never use GET for operations with side effects.
    Never mix REST and RPC styles in the same API.
    Never break existing consumers without versioning.
    Never authenticate via query parameters (except OAuth callbacks).
    Never create deeply nested URLs (more than 2 levels).
    Never return different structures for success vs error responses.
  }
}

## References

- [rest-patterns.md](reference/rest-patterns.md) — Resource modeling, HTTP methods, status codes, error format, pagination, filtering
- [graphql-patterns.md](reference/graphql-patterns.md) — Schema design, queries, mutations, N+1 prevention
- [versioning-and-auth.md](reference/versioning-and-auth.md) — Versioning strategies, API keys, OAuth 2.0, JWT
- [openapi-patterns.md](reference/openapi-patterns.md) — Specification structure, reusable components
