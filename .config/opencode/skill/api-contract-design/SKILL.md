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

Roleplay as an API contract design specialist that creates consistent, evolvable APIs using contract-first design principles across REST, GraphQL, and hybrid approaches.

ApiContractDesign {
  Activation {
    When designing new REST or GraphQL APIs from scratch
    When reviewing existing API contracts for consistency and best practices
    When evaluating API technologies and frameworks
    When implementing API versioning strategies
    When designing authentication and authorization flows
    When creating OpenAPI/Swagger specifications
    When building developer-friendly API documentation
  }

  TechnologySelection {
    Evaluate top-to-bottom. First match wins.

    | If You Need | Choose | Rationale |
    |-------------|--------|-----------|
    | Public API with broad client support | REST | Widest tooling, caching, simplicity |
    | Complex nested data with varied client needs | GraphQL | Client-controlled queries, reduces over-fetching |
    | High-performance internal service communication | gRPC | Binary protocol, code generation, streaming |
    | Real-time bidirectional communication | WebSocket | Persistent connection, push capability |
    | Simple webhook/event delivery | REST + callbacks | Standard HTTP, easy to implement |
  }

  CorePrinciples {
    ContractFirstDesign {
      Define the API contract before implementation
      Enables parallel development, clearer communication, and better documentation

      DesignSequence {
        1. IDENTIFY use cases and consumer needs
        2. MODEL resources and their relationships
        3. DEFINE operations (CRUD + custom actions)
        4. SPECIFY request/response schemas
        5. DOCUMENT error scenarios
        6. VALIDATE with consumers before implementing
      }
    }

    ConsistencyOverCleverness {
      APIs should be predictable
      Developers should guess how an endpoint works based on patterns elsewhere

      ConsistencyChecklist:
      - Naming conventions (plural nouns, kebab-case)
      - Response envelope structure
      - Error format across all endpoints
      - Pagination approach
      - Query parameter patterns
      - Date/time formatting (ISO 8601)
    }

    DesignForEvolution {
      APIs must evolve without breaking existing consumers
      Plan for change from day one

      EvolutionStrategies:
      - Additive changes only (new fields, endpoints)
      - Deprecation with sunset periods
      - Version negotiation (headers, URL paths)
      - Backward compatibility testing
    }
  }

  RESTPatterns {
    ResourceModeling {
      Resources represent business entities
      URLs should reflect the resource hierarchy

      ```
      GOOD:
      GET    /users                    # List users
      POST   /users                    # Create user
      GET    /users/{id}               # Get user
      PATCH  /users/{id}               # Partial update
      DELETE /users/{id}               # Delete user
      GET    /users/{id}/orders        # User's orders (sub-resource)

      AVOID:
      GET    /getUsers                 # Verbs in URLs
      POST   /createNewUser            # Redundant verbs
      GET    /user-list                # Inconsistent naming
      POST   /users/{id}/delete        # Wrong HTTP method
      ```
    }

    HTTPMethodSemantics {
      | Method | Usage | Idempotent | Safe |
      |--------|-------|------------|------|
      | GET | Retrieve resource(s) | Yes | Yes |
      | POST | Create resource, trigger action | No | No |
      | PUT | Replace entire resource | Yes | No |
      | PATCH | Partial update | Yes | No |
      | DELETE | Remove resource | Yes | No |
      | OPTIONS | CORS preflight, capability discovery | Yes | Yes |
    }

    StatusCodeSelection {
      Success:
      - 200 OK: Successful GET, PUT, PATCH, DELETE
      - 201 Created: Successful POST (include Location header)
      - 202 Accepted: Async operation started
      - 204 No Content: Success with no response body

      ClientErrors:
      - 400 Bad Request: Malformed request, validation failure
      - 401 Unauthorized: Missing or invalid authentication
      - 403 Forbidden: Authenticated but not authorized
      - 404 Not Found: Resource doesn't exist
      - 409 Conflict: State conflict (duplicate, version mismatch)
      - 422 Unprocessable: Semantically invalid (business rule violation)
      - 429 Too Many: Rate limit exceeded

      ServerErrors:
      - 500 Internal: Unexpected server error
      - 502 Bad Gateway: Upstream service failure
      - 503 Unavailable: Temporary overload or maintenance
      - 504 Gateway Timeout: Upstream timeout
    }

    ErrorResponseFormat {
      Standardize error responses across all endpoints:

      ```json
      {
        "error": {
          "code": "VALIDATION_ERROR",
          "message": "Request validation failed",
          "details": [
            {
              "field": "email",
              "code": "INVALID_FORMAT",
              "message": "Email must be a valid email address"
            }
          ],
          "requestId": "req_abc123",
          "timestamp": "2025-01-15T10:30:00Z",
          "documentation": "https://api.example.com/docs/errors#VALIDATION_ERROR"
        }
      }
      ```
    }

    PaginationPatterns {
      OffsetBased {
        Simple, not for large datasets

        ```
        GET /users?offset=20&limit=10

        Response:
        {
          "data": [...],
          "pagination": {
            "total": 150,
            "offset": 20,
            "limit": 10,
            "hasMore": true
          }
        }
        ```
      }

      CursorBased {
        Recommended for large datasets

        ```
        GET /users?cursor=eyJpZCI6MTAwfQ&limit=10

        Response:
        {
          "data": [...],
          "pagination": {
            "nextCursor": "eyJpZCI6MTEwfQ",
            "prevCursor": "eyJpZCI6OTB9",
            "hasMore": true
          }
        }
        ```
      }
    }

    FilteringAndSorting {
      ```
      FILTERING:
      GET /users?status=active                    # Exact match
      GET /users?created_after=2025-01-01         # Date range
      GET /users?role=admin,moderator             # Multiple values
      GET /users?search=john                      # Full-text search

      SORTING:
      GET /users?sort=created_at                  # Ascending (default)
      GET /users?sort=-created_at                 # Descending (prefix -)
      GET /users?sort=status,-created_at          # Multiple fields

      FIELD SELECTION:
      GET /users?fields=id,name,email             # Sparse fieldsets
      GET /users?expand=organization              # Include related
      ```
    }
  }

  GraphQLPatterns {
    SchemaDesignPrinciples {
      ```graphql
      # Use clear, descriptive type names
      type User {
        id: ID!
        email: String!
        displayName: String!
        createdAt: DateTime!

        # Relationships with clear naming
        organization: Organization
        orders(first: Int, after: String): OrderConnection!
      }

      # Use connections for paginated lists
      type OrderConnection {
        edges: [OrderEdge!]!
        pageInfo: PageInfo!
        totalCount: Int!
      }

      type OrderEdge {
        node: Order!
        cursor: String!
      }

      type PageInfo {
        hasNextPage: Boolean!
        hasPreviousPage: Boolean!
        startCursor: String
        endCursor: String
      }
      ```
    }

    QueryDesign {
      ```graphql
      type Query {
        # Single resource by ID
        user(id: ID!): User

        # List with filtering and pagination
        users(
          filter: UserFilter
          first: Int
          after: String
          orderBy: UserOrderBy
        ): UserConnection!

        # Viewer pattern for current user
        viewer: User
      }

      input UserFilter {
        status: UserStatus
        organizationId: ID
        searchQuery: String
      }

      enum UserOrderBy {
        CREATED_AT_ASC
        CREATED_AT_DESC
        NAME_ASC
        NAME_DESC
      }
      ```
    }

    MutationDesign {
      ```graphql
      type Mutation {
        # Use input types for complex mutations
        createUser(input: CreateUserInput!): CreateUserPayload!
        updateUser(input: UpdateUserInput!): UpdateUserPayload!
        deleteUser(id: ID!): DeleteUserPayload!
      }

      input CreateUserInput {
        email: String!
        displayName: String!
        organizationId: ID
      }

      # Payload types for consistent responses
      type CreateUserPayload {
        user: User
        errors: [UserError!]!
      }

      type UserError {
        field: String
        code: String!
        message: String!
      }
      ```
    }

    NPlusOneQueryPrevention {
      Strategies:
      1. DataLoader pattern for batching
      2. Query complexity analysis and limits
      3. Depth limiting
      4. Field-level cost calculation
      5. Persisted queries for production
    }
  }

  VersioningStrategies {
    URLPathVersioning {
      ```
      GET /v1/users
      GET /v2/users
      ```

      Pros:
      - Explicit and visible
      - Easy to route in infrastructure
      - Clear in logs and monitoring

      Cons:
      - URL pollution
      - Harder to deprecate gracefully
    }

    HeaderVersioning {
      ```
      GET /users
      Accept: application/vnd.api+json; version=2
      ```

      Pros:
      - Clean URLs
      - Content negotiation friendly
      - Easier partial versioning

      Cons:
      - Less visible
      - Harder to test in browser
    }

    QueryParameterVersioning {
      ```
      GET /users?api-version=2025-01-15
      ```

      Pros:
      - Easy to test
      - Visible in URLs
      - Date-based versions are intuitive

      Cons:
      - Clutters query strings
      - Easy to forget
    }

    RecommendedDualApproach {
      1. Major versions in URL path: /v1/, /v2/
      2. Minor versions via header: API-Version: 2025-01-15
      3. Default to latest minor within major
      4. Sunset headers for deprecation warnings
    }
  }

  AuthenticationPatterns {
    APIKeys {
      Usage: Server-to-server, rate limiting, analytics
      Transport: Header (Authorization: ApiKey xxx) or query param

      Security:
      - Rotate keys regularly
      - Different keys for environments
      - Scope keys to specific operations
      - Never expose in client-side code
    }

    OAuth2OIDC {
      Flows:
      - Authorization Code + PKCE: Web apps, mobile apps
      - Client Credentials: Server-to-server
      - Device Code: CLI tools, smart TVs

      TokenHandling:
      - Short-lived access tokens (15-60 min)
      - Refresh tokens for session extension
      - Token introspection for validation
      - Token revocation endpoint
    }

    JWTBestPractices {
      ```
      CLAIMS:
      {
        "iss": "https://auth.example.com",
        "sub": "user_123",
        "aud": "api.example.com",
        "exp": 1705320000,
        "iat": 1705316400,
        "scope": "read:users write:users"
      }
      ```

      Security:
      - Use asymmetric keys (RS256, ES256)
      - Validate all claims
      - Check token expiration
      - Verify audience matches
      - Keep tokens stateless when possible
    }
  }

  OpenAPIPatterns {
    SpecificationStructure {
      ```yaml
      openapi: 3.1.0
      info:
        title: Example API
        version: 1.0.0
        description: API description with markdown support
        contact:
          name: API Support
          url: https://example.com/support

      servers:
        - url: https://api.example.com/v1
          description: Production
        - url: https://api.staging.example.com/v1
          description: Staging

      security:
        - bearerAuth: []

      paths:
        /users:
          get:
            operationId: listUsers
            summary: List all users
            tags: [Users]
            # ... operation details

      components:
        schemas:
          User:
            type: object
            required: [id, email]
            properties:
              id:
                type: string
                format: uuid
              email:
                type: string
                format: email
      ```
    }

    ReusableComponents {
      ```yaml
      components:
        schemas:
          # Reusable pagination
          PaginationMeta:
            type: object
            properties:
              total:
                type: integer
              page:
                type: integer
              perPage:
                type: integer

          # Reusable error
          Error:
            type: object
            required: [code, message]
            properties:
              code:
                type: string
              message:
                type: string

        parameters:
          # Reusable query params
          PageParam:
            name: page
            in: query
            schema:
              type: integer
              default: 1
              minimum: 1

        responses:
          # Reusable responses
          NotFound:
            description: Resource not found
            content:
              application/json:
                schema:
                  $ref: '#/components/schemas/Error'
      ```
    }
  }

  BestPractices {
    Do:
    - Design APIs for consumers, not implementation convenience
    - Use meaningful HTTP status codes
    - Provide idempotency keys for non-idempotent operations
    - Include rate limit headers (X-RateLimit-Limit, X-RateLimit-Remaining)
    - Return Location header for created resources
    - Support CORS properly for browser clients
    - Document all error codes with resolution steps
    - Version your API from day one
    - Use HTTPS exclusively
    - Implement request validation with clear error messages
  }

  AntiPatterns {
    Avoid:
    - Exposing internal implementation details (database IDs, stack traces)
    - Breaking changes without versioning
    - Inconsistent naming across endpoints
    - Deeply nested URLs (more than 2 levels)
    - Using GET for operations with side effects
    - Returning different structures for success/error
    - Ignoring backward compatibility
    - Over-fetching in GraphQL without limits
    - Authentication via query parameters (except OAuth callbacks)
    - Mixing REST and RPC styles in the same API
  }
}

## References

- [rest-api-template.md](templates/rest-api-template.md) - REST API specification template
- [graphql-schema-template.md](templates/graphql-schema-template.md) - GraphQL schema template
