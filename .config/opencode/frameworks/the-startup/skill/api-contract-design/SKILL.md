---
name: api-contract-design
description: REST and GraphQL API design patterns, OpenAPI/Swagger specifications, versioning strategies, and authentication patterns. Use when designing APIs, reviewing API contracts, evaluating API technologies, or implementing API endpoints. Covers contract-first design, resource modeling, error handling, pagination, and security.
license: MIT
compatibility: opencode
metadata:
  category: design
  version: "1.0"
---

# API Design Patterns

A comprehensive skill for designing, documenting, and implementing APIs that developers love to use. Covers REST, GraphQL, and hybrid approaches with emphasis on consistency, discoverability, and maintainability.

## When to Use

- Designing new REST or GraphQL APIs from scratch
- Reviewing existing API contracts for consistency and best practices
- Evaluating API technologies and frameworks
- Implementing API versioning strategies
- Designing authentication and authorization flows
- Creating OpenAPI/Swagger specifications
- Building developer-friendly API documentation

## Core Principles

### 1. Contract-First Design

Define the API contract before implementation. This enables parallel development, clearer communication, and better documentation.

```sudolang
ContractFirstDesign {
  sequence: [
    "IDENTIFY use cases and consumer needs",
    "MODEL resources and their relationships",
    "DEFINE operations (CRUD + custom actions)",
    "SPECIFY request/response schemas",
    "DOCUMENT error scenarios",
    "VALIDATE with consumers before implementing"
  ]
  
  constraints {
    Contract must be defined before implementation begins
    Consumer needs drive API design, not implementation convenience
    All stakeholders must review before coding starts
  }
}
```

### 2. Consistency Over Cleverness

APIs should be predictable. Developers should be able to guess how an endpoint works based on patterns established elsewhere in the API.

```sudolang
APIConsistency {
  require {
    Naming conventions follow plural nouns, kebab-case
    Response envelope structure is uniform
    Error format is identical across all endpoints
    Pagination approach is consistent
    Query parameter patterns are standardized
    Date/time uses ISO 8601 format
  }
  
  /validate api:APISpec => {
    violations = []
    for endpoint in api.endpoints {
      if !endpoint.name.isPluralNoun() => violations.push("Non-plural resource name")
      if !endpoint.name.isKebabCase() => violations.push("Non-kebab-case naming")
      if endpoint.errorFormat != api.standardErrorFormat => violations.push("Inconsistent error format")
    }
    return violations
  }
}
```

### 3. Design for Evolution

APIs must evolve without breaking existing consumers. Plan for change from day one.

```sudolang
APIEvolution {
  strategies: [
    "Additive changes only (new fields, endpoints)",
    "Deprecation with sunset periods",
    "Version negotiation (headers, URL paths)",
    "Backward compatibility testing"
  ]
  
  constraints {
    Never remove fields without deprecation period
    Never change field types without versioning
    New required fields must have defaults
    Breaking changes require major version bump
  }
  
  warn {
    Removing optional fields should have 6-month sunset
    Changing semantics requires documentation update
  }
}
```

## REST API Patterns

### Resource Modeling

Resources represent business entities. URLs should reflect the resource hierarchy.

```sudolang
ResourceModeling {
  require {
    URLs use plural nouns for collections
    Resource IDs appear in path, not query
    Sub-resources reflect ownership relationship
    Maximum 2 levels of nesting
  }
  
  examples {
    good: [
      "GET    /users                    # List users",
      "POST   /users                    # Create user",
      "GET    /users/{id}               # Get user",
      "PATCH  /users/{id}               # Partial update",
      "DELETE /users/{id}               # Delete user",
      "GET    /users/{id}/orders        # User's orders (sub-resource)"
    ]
    avoid: [
      "GET    /getUsers                 # Verbs in URLs",
      "POST   /createNewUser            # Redundant verbs",
      "GET    /user-list                # Inconsistent naming",
      "POST   /users/{id}/delete        # Wrong HTTP method"
    ]
  }
}
```

### HTTP Method Semantics

```sudolang
fn selectHTTPMethod(operation) {
  match (operation) {
    case "retrieve" => {
      method: "GET",
      idempotent: true,
      safe: true
    }
    case "create" | "trigger_action" => {
      method: "POST",
      idempotent: false,
      safe: false
    }
    case "replace_entire" => {
      method: "PUT",
      idempotent: true,
      safe: false
    }
    case "partial_update" => {
      method: "PATCH",
      idempotent: true,
      safe: false
    }
    case "remove" => {
      method: "DELETE",
      idempotent: true,
      safe: false
    }
    case "preflight" | "capability_discovery" => {
      method: "OPTIONS",
      idempotent: true,
      safe: true
    }
  }
}
```

### Status Code Selection

```sudolang
fn selectStatusCode(result) {
  match (result) {
    // Success codes
    case { type: "success", method: "GET" | "PUT" | "PATCH" | "DELETE" } => 200  // OK
    case { type: "success", method: "POST", created: true } => 201  // Created (include Location header)
    case { type: "success", async: true } => 202  // Accepted
    case { type: "success", body: null } => 204  // No Content
    
    // Client errors
    case { type: "error", reason: "malformed" | "validation" } => 400  // Bad Request
    case { type: "error", reason: "unauthenticated" } => 401  // Unauthorized
    case { type: "error", reason: "forbidden" } => 403  // Forbidden
    case { type: "error", reason: "not_found" } => 404  // Not Found
    case { type: "error", reason: "conflict" | "duplicate" | "version_mismatch" } => 409  // Conflict
    case { type: "error", reason: "business_rule" } => 422  // Unprocessable Entity
    case { type: "error", reason: "rate_limit" } => 429  // Too Many Requests
    
    // Server errors
    case { type: "error", reason: "internal" } => 500  // Internal Server Error
    case { type: "error", reason: "upstream_failure" } => 502  // Bad Gateway
    case { type: "error", reason: "maintenance" | "overload" } => 503  // Service Unavailable
    case { type: "error", reason: "upstream_timeout" } => 504  // Gateway Timeout
  }
}
```

### Error Response Format

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

```sudolang
interface ErrorResponse {
  error: {
    code: String           // Machine-readable error code
    message: String        // Human-readable message
    details: ErrorDetail[] // Field-level errors
    requestId: String      // Correlation ID for debugging
    timestamp: ISO8601     // When error occurred
    documentation: URL?    // Link to error docs
  }
}

interface ErrorDetail {
  field: String
  code: String
  message: String
}
```

### Pagination Patterns

```sudolang
PaginationStrategy {
  fn selectStrategy(dataset) {
    match (dataset) {
      case { size: "small", mutable: false } => "offset"
      case { size: "large" } => "cursor"
      case { realtime: true } => "cursor"
      default => "cursor"  // Recommended default
    }
  }
  
  OffsetBased {
    request: "GET /users?offset=20&limit=10"
    response: {
      data: [],
      pagination: {
        total: Number,
        offset: Number,
        limit: Number,
        hasMore: Boolean
      }
    }
    warn {
      Not suitable for large datasets (performance degrades)
      Inconsistent results if data changes between pages
    }
  }
  
  CursorBased {
    request: "GET /users?cursor=eyJpZCI6MTAwfQ&limit=10"
    response: {
      data: [],
      pagination: {
        nextCursor: String?,
        prevCursor: String?,
        hasMore: Boolean
      }
    }
    require {
      Cursors must be opaque to clients
      Cursors should encode sort position
      Cursors must be URL-safe (base64)
    }
  }
}
```

### Filtering and Sorting

```sudolang
QueryPatterns {
  filtering: {
    exact_match: "GET /users?status=active",
    date_range: "GET /users?created_after=2025-01-01",
    multiple_values: "GET /users?role=admin,moderator",
    full_text: "GET /users?search=john"
  }
  
  sorting: {
    ascending: "GET /users?sort=created_at",
    descending: "GET /users?sort=-created_at",
    multiple: "GET /users?sort=status,-created_at"
  }
  
  field_selection: {
    sparse: "GET /users?fields=id,name,email",
    expand: "GET /users?expand=organization"
  }
  
  require {
    Sort direction indicated by prefix (- for descending)
    Multiple sort fields comma-separated
    Field selection reduces payload size
    Expand includes related resources inline
  }
}
```

## GraphQL Patterns

### Schema Design Principles

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

### Query Design

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

### Mutation Design

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

### N+1 Query Prevention

```sudolang
N1Prevention {
  strategies: [
    "DataLoader pattern for batching",
    "Query complexity analysis and limits",
    "Depth limiting",
    "Field-level cost calculation",
    "Persisted queries for production"
  ]
  
  require {
    DataLoader used for all relationship resolvers
    Maximum query depth enforced (typically 5-10)
    Query complexity scoring implemented
  }
  
  warn {
    Deeply nested queries indicate schema design issues
    High complexity queries should be persisted
  }
}
```

## API Versioning Strategies

```sudolang
fn selectVersioningStrategy(requirements) {
  match (requirements) {
    case { visibility: "high", infrastructure: "flexible" } => {
      strategy: "url_path",
      example: "GET /v1/users",
      pros: ["Explicit and visible", "Easy to route", "Clear in logs"],
      cons: ["URL pollution", "Harder to deprecate"]
    }
    case { urls: "clean", content_negotiation: true } => {
      strategy: "header",
      example: "Accept: application/vnd.api+json; version=2",
      pros: ["Clean URLs", "Content negotiation friendly", "Easier partial versioning"],
      cons: ["Less visible", "Harder to test in browser"]
    }
    case { testing: "easy", date_based: true } => {
      strategy: "query_param",
      example: "GET /users?api-version=2025-01-15",
      pros: ["Easy to test", "Visible", "Date-based versions intuitive"],
      cons: ["Clutters query strings", "Easy to forget"]
    }
    default => {
      strategy: "dual",
      description: "Recommended approach combining multiple strategies",
      rules: [
        "Major versions in URL path: /v1/, /v2/",
        "Minor versions via header: API-Version: 2025-01-15",
        "Default to latest minor within major",
        "Sunset headers for deprecation warnings"
      ]
    }
  }
}
```

## Authentication Patterns

```sudolang
AuthenticationPatterns {
  APIKeys {
    usage: ["Server-to-server", "Rate limiting", "Analytics"]
    transport: "Header (Authorization: ApiKey xxx) or query param"
    
    require {
      Rotate keys regularly
      Different keys for each environment
      Scope keys to specific operations
      Never expose in client-side code
    }
  }
  
  OAuth2 {
    fn selectFlow(client_type) {
      match (client_type) {
        case "web_app" | "mobile_app" => "Authorization Code + PKCE"
        case "server" => "Client Credentials"
        case "cli" | "smart_tv" => "Device Code"
      }
    }
    
    require {
      Access tokens short-lived (15-60 min)
      Refresh tokens for session extension
      Token introspection endpoint available
      Token revocation endpoint available
    }
  }
  
  JWT {
    claims: {
      iss: "https://auth.example.com",
      sub: "user_123",
      aud: "api.example.com",
      exp: 1705320000,
      iat: 1705316400,
      scope: "read:users write:users"
    }
    
    require {
      Use asymmetric keys (RS256, ES256)
      Validate all claims
      Check token expiration
      Verify audience matches
      Keep tokens stateless when possible
    }
  }
}
```

## OpenAPI/Swagger Patterns

### Specification Structure

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

### Reusable Components

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

## Best Practices

```sudolang
APIBestPractices {
  require {
    Design APIs for consumers, not implementation convenience
    Use meaningful HTTP status codes
    Provide idempotency keys for non-idempotent operations
    Include rate limit headers (X-RateLimit-Limit, X-RateLimit-Remaining)
    Return Location header for created resources
    Support CORS properly for browser clients
    Document all error codes with resolution steps
    Version your API from day one
    Use HTTPS exclusively
    Implement request validation with clear error messages
  }
  
  avoid {
    Exposing internal implementation details (database IDs, stack traces)
    Breaking changes without versioning
    Inconsistent naming across endpoints
    Deeply nested URLs (more than 2 levels)
    Using GET for operations with side effects
    Returning different structures for success/error
    Ignoring backward compatibility
    Over-fetching in GraphQL without limits
    Authentication via query parameters (except OAuth callbacks)
    Mixing REST and RPC styles in the same API
  }
}
```

## References

- `templates/rest-api-template.md` - REST API specification template
- `templates/graphql-schema-template.md` - GraphQL schema template
