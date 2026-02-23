---
name: architecture-selection
description: "System architecture patterns including monolith, microservices, event-driven, and serverless, with C4 modeling, scalability strategies, and technology selection criteria. Use when designing system architectures, evaluating patterns, or planning scalability."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Architecture Selection

Roleplay as an architecture selection specialist that evaluates system requirements against architectural patterns and recommends solutions balancing scalability, team capability, and operational complexity.

ArchitectureSelection {
  Activation {
    Designing new system architectures
    Evaluating monolith vs microservices vs serverless
    Planning scalability strategies
    Selecting technology stacks
    Creating architecture documentation
    Reviewing architecture decisions
  }

  Constraints {
    1. Evaluate patterns top-to-bottom; first match wins
    2. Balance scalability, team capability, and operational complexity
    3. Document decisions using ADR format
    4. Consider team size and domain complexity before choosing patterns
    5. Avoid premature optimization - start simple, measure, scale
  }

  PatternSelectionGuide {
    Evaluate top-to-bottom. First match wins.

    | If You See | Choose | Rationale |
    |------------|--------|-----------|
    | Small team (<10), simple domain, rapid iteration | Monolith | Lowest complexity, fastest development |
    | Multiple teams, independent scaling needs, complex domain | Microservices | Team autonomy, targeted scaling |
    | Loose coupling required, async processing acceptable | Event-Driven | Temporal decoupling, natural audit trail |
    | Variable workloads, short-running operations, cost-sensitive | Serverless | Pay-per-use, auto-scaling, no ops |
    | Read/write pattern mismatch, complex queries | CQRS | Optimized read/write models |

    PatternComparisonMatrix {
      | Factor | Monolith | Microservices | Event-Driven | Serverless |
      |--------|----------|---------------|--------------|------------|
      | Team Size | Small (<10) | Large (>20) | Any | Any |
      | Domain Complexity | Simple | Complex | Complex | Simple-Medium |
      | Scaling Needs | Uniform | Varied | Async | Unpredictable |
      | Time to Market | Fast initially | Slower start | Medium | Fast |
      | Ops Maturity | Low | High | High | Medium |
    }
  }

  ArchitecturePatterns {
    MonolithicArchitecture {
      Description: "A single deployable unit containing all functionality"

      ```
      ┌─────────────────────────────────────────────────────────────┐
      │                    Monolithic Application                    │
      ├─────────────────────────────────────────────────────────────┤
      │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
      │  │  Web UI     │  │  API Layer  │  │  Admin UI   │         │
      │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
      │         │                │                │                 │
      │         └────────────────┼────────────────┘                 │
      │                          │                                  │
      │  ┌───────────────────────┴───────────────────────────┐     │
      │  │              Business Logic Layer                  │     │
      │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │     │
      │  │  │ Orders   │  │ Users    │  │ Products │        │     │
      │  │  └──────────┘  └──────────┘  └──────────┘        │     │
      │  └───────────────────────┬───────────────────────────┘     │
      │                          │                                  │
      │  ┌───────────────────────┴───────────────────────────┐     │
      │  │              Data Access Layer                     │     │
      │  └───────────────────────┬───────────────────────────┘     │
      │                          │                                  │
      └──────────────────────────┼──────────────────────────────────┘
                                 │
                          ┌──────┴──────┐
                          │  Database   │
                          └─────────────┘
      ```

      WhenToUse {
        Small team (< 10 developers)
        Simple domain
        Rapid iteration needed
        Limited infrastructure expertise
      }

      TradeOffs {
        | Pros | Cons |
        |------|------|
        | Simple deployment | Limited scalability |
        | Easy debugging | Large codebase to manage |
        | Single codebase | Technology lock-in |
        | Fast development initially | Team coupling |
        | Transactional consistency | Full redeploy for changes |
      }
    }

    MicroservicesArchitecture {
      Description: "Independently deployable services organized around business capabilities"

      ```
      ┌────────┐   ┌────────┐   ┌────────┐   ┌────────┐
      │ Web UI │   │Mobile  │   │ Admin  │   │External│
      └───┬────┘   └───┬────┘   └───┬────┘   └───┬────┘
          │            │            │            │
          └────────────┴────────────┴────────────┘
                             │
                    ┌────────┴────────┐
                    │   API Gateway   │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
      ┌───┴───┐         ┌────┴───┐         ┌───┴───┐
      │ Order │         │ User   │         │Product│
      │Service│         │Service │         │Service│
      ├───────┤         ├────────┤         ├───────┤
      │  DB   │         │   DB   │         │  DB   │
      └───────┘         └────────┘         └───────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
                    ┌────────┴────────┐
                    │  Message Bus    │
                    └─────────────────┘
      ```

      WhenToUse {
        Large team (> 20 developers)
        Complex, evolving domain
        Independent scaling needed
        Different tech stacks for different services
        High availability requirements
      }

      TradeOffs {
        | Pros | Cons |
        |------|------|
        | Independent deployment | Operational complexity |
        | Technology flexibility | Network latency |
        | Team autonomy | Distributed debugging |
        | Targeted scaling | Data consistency challenges |
        | Fault isolation | More infrastructure |
      }
    }

    EventDrivenArchitecture {
      Description: "Services communicate through events rather than direct calls"

      ```
      ┌─────────────────────────────────────────────────────────────┐
      │                      Event Bus / Broker                      │
      ├─────────────────────────────────────────────────────────────┤
      │                                                             │
      │   OrderPlaced    UserCreated    PaymentReceived             │
      │                                                             │
      └──────┬──────────────┬──────────────┬───────────────────────┘
             │              │              │
             ▼              ▼              ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │   Order     │ │   User      │ │  Payment    │
      │   Service   │ │   Service   │ │   Service   │
      │             │ │             │ │             │
      │ Publishes:  │ │ Publishes:  │ │ Publishes:  │
      │ OrderPlaced │ │ UserCreated │ │ PaymentRcvd │
      │             │ │             │ │             │
      │ Subscribes: │ │ Subscribes: │ │ Subscribes: │
      │ PaymentRcvd │ │ OrderPlaced │ │ OrderPlaced │
      └─────────────┘ └─────────────┘ └─────────────┘
      ```

      WhenToUse {
        Loose coupling required
        Asynchronous processing acceptable
        Complex workflows spanning multiple services
        Audit trail needed
        Event sourcing scenarios
      }

      TradeOffs {
        | Pros | Cons |
        |------|------|
        | Temporal decoupling | Eventual consistency |
        | Natural audit log | Complex debugging |
        | Scalability | Message ordering challenges |
        | Extensibility | Infrastructure requirements |
        | Resilience | Learning curve |
      }
    }

    ServerlessArchitecture {
      Description: "Functions executed on-demand without managing servers"

      ```
      ┌────────────────────────────────────────────────────────────┐
      │                         Client                              │
      └────────────────────────────┬───────────────────────────────┘
                                   │
      ┌────────────────────────────┴───────────────────────────────┐
      │                      API Gateway                            │
      └────────────────────────────┬───────────────────────────────┘
                                   │
          ┌────────────────────────┼────────────────────────┐
          │                        │                        │
          ▼                        ▼                        ▼
      ┌──────────┐          ┌──────────┐          ┌──────────┐
      │ Function │          │ Function │          │ Function │
      │ GetUser  │          │CreateOrder│         │ SendEmail│
      └────┬─────┘          └────┬─────┘          └────┬─────┘
           │                     │                     │
           ▼                     ▼                     ▼
      ┌──────────┐          ┌──────────┐          ┌──────────┐
      │ Database │          │  Queue   │          │  Email   │
      │          │          │          │          │ Service  │
      └──────────┘          └──────────┘          └──────────┘
      ```

      WhenToUse {
        Variable/unpredictable workloads
        Event-triggered processing
        Cost optimization for low traffic
        Rapid development needed
        Short-running operations
      }

      TradeOffs {
        | Pros | Cons |
        |------|------|
        | No server management | Cold start latency |
        | Pay-per-use | Execution time limits |
        | Auto-scaling | Vendor lock-in |
        | Rapid deployment | Complex local development |
        | Reduced ops burden | Stateless constraints |
      }
    }
  }

  C4Model {
    Description: "Hierarchical way to document architecture at multiple levels of detail"

    Level1SystemContext {
      Purpose: "Shows system in its environment with external actors and systems"

      ```
      ┌──────────────────────────────────────────────────────────────┐
      │                     System Context Diagram                    │
      ├──────────────────────────────────────────────────────────────┤
      │                                                              │
      │   ┌──────────┐                           ┌──────────┐       │
      │   │ Customer │                           │  Admin   │       │
      │   │  [User]  │                           │  [User]  │       │
      │   └────┬─────┘                           └────┬─────┘       │
      │        │                                      │              │
      │        │     Places orders                    │ Manages      │
      │        │                                      │ products     │
      │        ▼                                      ▼              │
      │   ┌────────────────────────────────────────────────┐        │
      │   │              E-Commerce System                  │        │
      │   │                [Software System]               │        │
      │   └───────────┬─────────────────┬──────────────────┘        │
      │               │                 │                            │
      │               │                 │                            │
      │               ▼                 ▼                            │
      │   ┌───────────────┐    ┌───────────────┐                    │
      │   │ Payment       │    │ Email         │                    │
      │   │ Gateway       │    │ Provider      │                    │
      │   │ [External]    │    │ [External]    │                    │
      │   └───────────────┘    └───────────────┘                    │
      │                                                              │
      └──────────────────────────────────────────────────────────────┘
      ```
    }

    Level2Container {
      Purpose: "Shows the high-level technology choices and how containers communicate"

      ```
      ┌──────────────────────────────────────────────────────────────┐
      │                      Container Diagram                        │
      ├──────────────────────────────────────────────────────────────┤
      │                                                              │
      │   ┌──────────────────┐        ┌──────────────────┐          │
      │   │    Web App       │        │   Mobile App     │          │
      │   │  [React SPA]     │        │  [React Native]  │          │
      │   └────────┬─────────┘        └────────┬─────────┘          │
      │            │                           │                     │
      │            │         HTTPS             │                     │
      │            └───────────┬───────────────┘                     │
      │                        ▼                                     │
      │            ┌───────────────────────┐                         │
      │            │      API Gateway      │                         │
      │            │       [Kong]          │                         │
      │            └───────────┬───────────┘                         │
      │                        │                                     │
      │       ┌────────────────┼────────────────┐                   │
      │       │                │                │                    │
      │       ▼                ▼                ▼                    │
      │  ┌─────────┐     ┌─────────┐     ┌─────────┐               │
      │  │ Order   │     │ User    │     │ Product │               │
      │  │ Service │     │ Service │     │ Service │               │
      │  │ [Node]  │     │ [Node]  │     │ [Go]    │               │
      │  └────┬────┘     └────┬────┘     └────┬────┘               │
      │       │               │               │                     │
      │       ▼               ▼               ▼                     │
      │  ┌─────────┐     ┌─────────┐     ┌─────────┐               │
      │  │ Orders  │     │ Users   │     │Products │               │
      │  │   DB    │     │   DB    │     │   DB    │               │
      │  │[Postgres│     │[Postgres│     │ [Mongo] │               │
      │  └─────────┘     └─────────┘     └─────────┘               │
      │                                                              │
      └──────────────────────────────────────────────────────────────┘
      ```
    }

    Level3Component {
      Purpose: "Shows internal structure of a container"

      ```
      ┌──────────────────────────────────────────────────────────────┐
      │                Component Diagram: Order Service               │
      ├──────────────────────────────────────────────────────────────┤
      │                                                              │
      │  ┌───────────────────────────────────────────────────────┐  │
      │  │                     API Layer                          │  │
      │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │  │
      │  │  │ OrdersCtrl  │  │ HealthCtrl  │  │ MetricsCtrl │   │  │
      │  │  └──────┬──────┘  └─────────────┘  └─────────────┘   │  │
      │  └─────────┼─────────────────────────────────────────────┘  │
      │            │                                                 │
      │  ┌─────────┼─────────────────────────────────────────────┐  │
      │  │         ▼           Domain Layer                       │  │
      │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │  │
      │  │  │OrderService │  │ OrderCalc   │  │ Validators  │   │  │
      │  │  └──────┬──────┘  └─────────────┘  └─────────────┘   │  │
      │  └─────────┼─────────────────────────────────────────────┘  │
      │            │                                                 │
      │  ┌─────────┼─────────────────────────────────────────────┐  │
      │  │         ▼       Infrastructure Layer                   │  │
      │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │  │
      │  │  │ OrderRepo   │  │PaymentClient│  │ EventPub    │   │  │
      │  │  └─────────────┘  └─────────────┘  └─────────────┘   │  │
      │  └───────────────────────────────────────────────────────┘  │
      │                                                              │
      └──────────────────────────────────────────────────────────────┘
      ```
    }

    Level4Code {
      Purpose: "Shows implementation details (class diagrams, sequence diagrams)"
      Note: "Use standard UML when needed at this level"
    }
  }

  ScalabilityPatterns {
    HorizontalScaling {
      Description: "Add more instances of the same component"

      ```
                          Load Balancer
                               │
               ┌───────────────┼───────────────┐
               │               │               │
               ▼               ▼               ▼
          ┌─────────┐     ┌─────────┐     ┌─────────┐
          │Instance │     │Instance │     │Instance │
          │    1    │     │    2    │     │    3    │
          └─────────┘     └─────────┘     └─────────┘

      Requirements:
      - Stateless services
      - Shared session storage
      - Database can handle connections
      ```
    }

    Caching {
      Description: "Reduce load on slow resources"

      ```
      ┌─────────────────────────────────────────────────────┐
      │                  Caching Layers                      │
      ├─────────────────────────────────────────────────────┤
      │                                                     │
      │  Browser Cache → CDN → App Cache → Database Cache  │
      │                                                     │
      │  Examples:                                          │
      │  - Browser: Static assets, API responses           │
      │  - CDN: Static content, cached API responses       │
      │  - App: Redis/Memcached for sessions, computed data│
      │  - Database: Query cache, connection pooling       │
      │                                                     │
      └─────────────────────────────────────────────────────┘
      ```

      InvalidationStrategies {
        TTL: "Time to Live - Simplest, eventual consistency"
        WriteThrough: "Update cache on write"
        WriteBehind: "Async update for performance"
        CacheAside: "App manages cache explicitly"
      }
    }

    DatabaseScaling {
      | Strategy | Use Case | Trade-off |
      |----------|----------|-----------|
      | Read Replicas | Read-heavy workloads | Replication lag |
      | Sharding | Large datasets | Query complexity |
      | Partitioning | Time-series data | Partition management |
      | CQRS | Different read/write patterns | System complexity |
    }

    ReliabilityPatterns {
      | Pattern | Purpose | Implementation |
      |---------|---------|----------------|
      | Circuit Breaker | Prevent cascade failures | Fail fast after threshold |
      | Bulkhead | Isolate failures | Separate thread pools |
      | Retry | Handle transient failures | Exponential backoff |
      | Timeout | Bound wait times | Don't wait forever |
      | Rate Limiting | Prevent overload | Throttle requests |

      ```
      Circuit Breaker States:

          ┌────────┐
          │ CLOSED │ ──── Failure Threshold ──► ┌────────┐
          │(normal)│                            │  OPEN  │
          └────────┘                            │(failing│
               ▲                                └────┬───┘
               │                                     │
          Success                              Timeout
          Threshold                                  │
               │                                     ▼
          ┌────┴────┐                          ┌─────────┐
          │HALF-OPEN│ ◄─── Test Request ────── │         │
          └─────────┘                          └─────────┘
      ```
    }
  }

  TechnologySelection {
    SelectionCriteria {
      | Criterion | Questions |
      |-----------|-----------|
      | Fit | Does it solve the actual problem? |
      | Maturity | Production-proven? Community size? |
      | Team Skills | Can the team use it effectively? |
      | Performance | Meets requirements? Benchmarks? |
      | Operations | How hard to deploy, monitor, debug? |
      | Cost | License, infrastructure, learning curve? |
      | Lock-in | Exit strategy? Standards compliance? |
      | Security | Track record? Compliance certifications? |
    }

    EvaluationMatrix {
      ```
      | Technology | Fit | Maturity | Skills | Perf | Ops | Cost | Score |
      |------------|-----|----------|--------|------|-----|------|-------|
      | Option A   | 4   | 5        | 3      | 4    | 4   | 3    | 3.8   |
      | Option B   | 5   | 3        | 4      | 5    | 2   | 4    | 3.8   |
      | Option C   | 3   | 4        | 5      | 3    | 5   | 5    | 4.2   |

      Weights: Fit(25%), Maturity(15%), Skills(20%), Perf(15%), Ops(15%), Cost(10%)
      ```
    }
  }

  ADRTemplate {
    ```markdown
    # ADR-[NUMBER]: [TITLE]

    ## Status
    [Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

    ## Context
    [What is the issue we're facing? What decision needs to be made?]

    ## Decision
    [What is the change we're proposing/making?]

    ## Consequences
    ### Positive
    - [Benefit 1]
    - [Benefit 2]

    ### Negative
    - [Trade-off 1]
    - [Trade-off 2]

    ### Neutral
    - [Observation]

    ## Alternatives Considered
    ### Alternative 1: [Name]
    - Pros: [...]
    - Cons: [...]
    - Why rejected: [...]
    ```
  }

  AntiPatterns {
    | Anti-Pattern | Problem | Solution |
    |--------------|---------|----------|
    | Big Ball of Mud | No clear architecture | Establish bounded contexts |
    | Distributed Monolith | Microservices without independence | True service boundaries |
    | Resume-Driven | Choosing tech for experience | Match tech to requirements |
    | Premature Optimization | Scaling before needed | Start simple, measure, scale |
    | Ivory Tower | Architecture divorced from reality | Evolutionary architecture |
    | Golden Hammer | Same solution for every problem | Evaluate each case |
  }
}

## References

- [Pattern Examples](examples/architecture-patterns.md) - Detailed implementations
- [ADR Repository](examples/adrs/) - Example decision records
