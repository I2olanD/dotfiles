---
name: domain-driven-design
description: "Domain-Driven Design tactical and strategic patterns including entities, value objects, aggregates, bounded contexts, and consistency strategies. Use when modeling business domains, designing aggregate boundaries, implementing business rules, or planning data consistency."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Domain-Driven Design

Roleplay as a domain modeling specialist that applies DDD tactical and strategic patterns to design bounded contexts, aggregates, and consistency strategies for complex business domains.

DomainDrivenDesign {
  Activation {
    When modeling business domains and entities
    When designing aggregate boundaries
    When implementing complex business rules
    When planning data consistency strategies
    When establishing bounded contexts
    When designing domain events and integration
  }

  Constraints {
    Model business concepts explicitly using ubiquitous language
    Encapsulate business rules in domain layer
    Keep domain free of framework dependencies
    Reference other aggregates by identity only
    Update one aggregate per transaction
    Design small aggregates (prefer single entity)
    Protect invariants at aggregate boundary
  }

  StrategicPatterns {
    BoundedContext {
      A bounded context defines the boundary within which a domain model applies
      The same term can mean different things in different contexts

      ```
      Example: "Customer" in different contexts

      ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
      │    Sales        │  │    Support      │  │    Billing      │
      │    Context      │  │    Context      │  │    Context      │
      ├─────────────────┤  ├─────────────────┤  ├─────────────────┤
      │ Customer:       │  │ Customer:       │  │ Customer:       │
      │ - Leads         │  │ - Tickets       │  │ - Invoices      │
      │ - Opportunities │  │ - SLA           │  │ - Payment       │
      │ - Proposals     │  │ - Satisfaction  │  │ - Credit Limit  │
      └─────────────────┘  └─────────────────┘  └─────────────────┘
      ```

      ContextIdentification {
        Ask these questions to find context boundaries:
        - Where does the ubiquitous language change?
        - Which teams own which concepts?
        - Where do integration points naturally occur?
        - What could be deployed independently?
      }
    }

    ContextMapping {
      Define how bounded contexts integrate:

      | Pattern | Description | Use When |
      |---------|-------------|----------|
      | **Shared Kernel** | Shared code between contexts | Close collaboration, same team |
      | **Customer-Supplier** | Upstream/downstream relationship | Clear dependency direction |
      | **Conformist** | Downstream adopts upstream model | No negotiation power |
      | **Anti-Corruption Layer** | Translation layer between models | Protecting domain from external models |
      | **Open Host Service** | Published API for integration | Multiple consumers |
      | **Published Language** | Shared interchange format | Industry standards exist |
    }

    UbiquitousLanguage {
      The shared vocabulary between developers and domain experts

      ```
      Building Ubiquitous Language:

      1. EXTRACT terms from domain expert conversations
      2. DOCUMENT in a glossary with precise definitions
      3. ENFORCE in code - class names, method names, variables
      4. EVOLVE as understanding deepens

      Example Glossary Entry:
      ┌─────────────────────────────────────────────────────────────┐
      │ Term: Order                                                  │
      │ Definition: A confirmed request from a customer to purchase │
      │             one or more products at agreed prices.          │
      │ NOT: A shopping cart (which is an Intent, not an Order)     │
      │ Context: Sales                                              │
      └─────────────────────────────────────────────────────────────┘
      ```
    }
  }

  TacticalPatterns {
    Entities {
      Objects with identity that persists over time
      Equality is based on identity, not attributes

      Characteristics:
      - Has a unique identifier
      - Mutable state
      - Lifecycle (created, modified, archived)
      - Equality by ID

      ```
      Example:
      ┌─────────────────────────────────────────┐
      │ Entity: Order                           │
      ├─────────────────────────────────────────┤
      │ Identity: orderId (UUID)                │
      │ State: status, items, total             │
      │ Behavior: addItem(), submit(), cancel() │
      └─────────────────────────────────────────┘

      class Order {
        private readonly id: OrderId;      // Identity - immutable
        private status: OrderStatus;        // State - mutable
        private items: OrderItem[];         // State - mutable

        constructor(id: OrderId) {
          this.id = id;
          this.status = OrderStatus.Draft;
          this.items = [];
        }

        equals(other: Order): boolean {
          return this.id.equals(other.id);  // Equality by identity
        }
      }
      ```
    }

    ValueObjects {
      Objects without identity
      Equality is based on attributes
      Always immutable

      Characteristics:
      - No unique identifier
      - Immutable (all properties readonly)
      - Equality by attributes
      - Self-validating

      ```
      Example:
      ┌─────────────────────────────────────────┐
      │ Value Object: Money                     │
      ├─────────────────────────────────────────┤
      │ Attributes: amount, currency            │
      │ Behavior: add(), subtract(), format()   │
      │ Invariant: amount >= 0                  │
      └─────────────────────────────────────────┘

      class Money {
        constructor(
          public readonly amount: number,
          public readonly currency: Currency
        ) {
          if (amount < 0) throw new Error('Amount cannot be negative');
        }

        add(other: Money): Money {
          if (!this.currency.equals(other.currency)) {
            throw new Error('Cannot add different currencies');
          }
          return new Money(this.amount + other.amount, this.currency);
        }

        equals(other: Money): boolean {
          return this.amount === other.amount &&
                 this.currency.equals(other.currency);
        }
      }
      ```

      DecisionMatrix {
        | Use Value Object | Use Entity |
        |------------------|------------|
        | No need to track over time | Need to track lifecycle |
        | Interchangeable instances | Unique identity matters |
        | Defined by attributes | Defined by continuity |
        | Examples: Money, Address, DateRange | Examples: User, Order, Account |
      }
    }

    Aggregates {
      A cluster of entities and value objects with a defined boundary
      One entity is the aggregate root

      DesignRules {
        1. PROTECT invariants at aggregate boundary
        2. REFERENCE other aggregates by identity only
        3. UPDATE one aggregate per transaction
        4. DESIGN small aggregates (prefer single entity)
      }

      ```
      Example:
      ┌─────────────────────────────────────────────────────────────┐
      │ Aggregate: Order                                            │
      │ Root: Order (entity)                                        │
      ├─────────────────────────────────────────────────────────────┤
      │  ┌─────────────────┐                                        │
      │  │ Order (Root)    │◄── Aggregate Root                      │
      │  │ - orderId       │                                        │
      │  │ - customerId ───┼──► Reference by ID only                │
      │  │ - status        │                                        │
      │  └────────┬────────┘                                        │
      │           │                                                 │
      │  ┌────────▼────────┐                                        │
      │  │ OrderItem       │◄── Inside aggregate                    │
      │  │ - productId ────┼──► Reference by ID only                │
      │  │ - quantity      │                                        │
      │  │ - price (Money) │◄── Value Object                        │
      │  └─────────────────┘                                        │
      └─────────────────────────────────────────────────────────────┘
      ```

      Sizing {
        Start Small:
        - Begin with single-entity aggregates
        - Expand only when invariants require it

        SignsOfTooLarge:
        - Frequent optimistic lock conflicts
        - Loading too much data for simple operations
        - Multiple users editing simultaneously
        - Transactional failures across unrelated data

        SignsOfTooSmall:
        - Invariants not protected
        - Business rules scattered across services
        - Eventual consistency where immediate is required
      }
    }

    DomainEvents {
      Represent something that happened in the domain
      Immutable facts about the past

      ```
      Event Structure:
      ┌─────────────────────────────────────────┐
      │ Event: OrderPlaced                      │
      ├─────────────────────────────────────────┤
      │ eventId: UUID                           │
      │ occurredAt: DateTime                    │
      │ aggregateId: orderId                    │
      │ payload:                                │
      │   - customerId                          │
      │   - items                               │
      │   - totalAmount                         │
      └─────────────────────────────────────────┘

      Naming Convention:
      - Past tense (OrderPlaced, not PlaceOrder)
      - Domain language (not technical)
      - Include all relevant data (event is immutable)

      class OrderPlaced implements DomainEvent {
        readonly eventId = uuid();
        readonly occurredAt = new Date();

        constructor(
          readonly orderId: OrderId,
          readonly customerId: CustomerId,
          readonly items: OrderItemData[],
          readonly totalAmount: Money
        ) {}
      }
      ```

      EventPatterns {
        | Pattern | Description | Use Case |
        |---------|-------------|----------|
        | **Event Notification** | Minimal data, query for details | Loose coupling |
        | **Event-Carried State** | Full data in event | Performance, offline |
        | **Event Sourcing** | Events as source of truth | Audit, temporal queries |
      }
    }

    Repositories {
      Abstract persistence, providing collection-like access to aggregates

      Principles:
      - One repository per aggregate
      - Returns aggregate roots only
      - Hides persistence mechanism
      - Supports aggregate reconstitution

      ```typescript
      interface OrderRepository {
        findById(id: OrderId): Promise<Order | null>;
        findByCustomer(customerId: CustomerId): Promise<Order[]>;
        save(order: Order): Promise<void>;
        delete(order: Order): Promise<void>;
      }

      // Implementation hides persistence details
      class PostgresOrderRepository implements OrderRepository {
        async findById(id: OrderId): Promise<Order | null> {
          const row = await this.db.query('SELECT * FROM orders WHERE id = $1', [id]);
          return row ? this.reconstitute(row) : null;
        }

        private reconstitute(row: OrderRow): Order {
          // Rebuild aggregate from persistence
        }
      }
      ```
    }
  }

  ConsistencyStrategies {
    TransactionalConsistency {
      Use for invariants within an aggregate

      Rule: One aggregate per transaction

      ```typescript
      // Good: Single aggregate updated
      async function addItemToOrder(orderId: OrderId, item: OrderItem) {
        const order = await orderRepo.findById(orderId);
        order.addItem(item);  // Business rules enforced
        await orderRepo.save(order);
      }

      // Bad: Multiple aggregates in one transaction
      async function createOrderWithInventory() {
        await db.transaction(async (tx) => {
          await orderRepo.save(order, tx);
          await inventoryRepo.decrement(productId, quantity, tx);  // Don't do this
        });
      }
      ```
    }

    EventualConsistency {
      Use for consistency across aggregates

      ```typescript
      // Order aggregate publishes event
      class Order {
        submit(): void {
          this.status = OrderStatus.Placed;
          this.addEvent(new OrderPlaced(this.id, this.customerId, this.items));
        }
      }

      // Separate handler updates inventory (eventually)
      class InventoryHandler {
        async handle(event: OrderPlaced): Promise<void> {
          for (const item of event.items) {
            await this.inventoryService.reserve(item.productId, item.quantity);
          }
        }
      }
      ```
    }

    SagaPattern {
      Coordinate multiple aggregates with compensation

      ```
      Saga: Order Fulfillment

      ┌─────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────┐
      │ Create  │────►│ Reserve     │────►│ Charge      │────►│ Ship    │
      │ Order   │     │ Inventory   │     │ Payment     │     │ Order   │
      └────┬────┘     └──────┬──────┘     └──────┬──────┘     └─────────┘
           │                 │                   │
           │ Compensate:     │ Compensate:       │ Compensate:
           │ Cancel Order    │ Release Inventory │ Refund Payment
           ▼                 ▼                   ▼

      On failure at any step, execute compensation in reverse order.
      ```
    }

    ConsistencyDecisionMatrix {
      | Scenario | Strategy |
      |----------|----------|
      | Within single aggregate | Transactional (ACID) |
      | Across aggregates, same service | Eventual (domain events) |
      | Across services | Saga with compensation |
      | Read model updates | Eventual (projection) |
    }
  }

  AntiPatterns {
    AnemicDomainModel {
      ```typescript
      // Anti-pattern: Logic outside domain objects
      class Order {
        id: string;
        items: Item[];
        status: string;
      }

      class OrderService {
        calculateTotal(order: Order): number { ... }
        validate(order: Order): boolean { ... }
        submit(order: Order): void { ... }
      }

      // Better: Logic inside domain objects
      class Order {
        private items: OrderItem[];
        private status: OrderStatus;

        get total(): Money {
          return this.items.reduce((sum, item) => sum.add(item.subtotal), Money.zero());
        }

        submit(): void {
          this.validate();
          this.status = OrderStatus.Submitted;
        }
      }
      ```
    }

    LargeAggregates {
      ```typescript
      // Anti-pattern: Everything in one aggregate
      class Customer {
        orders: Order[];           // Could be thousands
        addresses: Address[];
        paymentMethods: PaymentMethod[];
        preferences: Preferences;
        activityLog: Activity[];   // Could be millions
      }

      // Better: Separate aggregates referenced by ID
      class Customer {
        id: CustomerId;
        defaultAddressId: AddressId;
        defaultPaymentMethodId: PaymentMethodId;
      }

      class Order {
        customerId: CustomerId;    // Reference by ID
      }
      ```
    }

    PrimitiveObsession {
      ```typescript
      // Anti-pattern: Primitive types for domain concepts
      function createOrder(
        customerId: string,
        productId: string,
        quantity: number,
        price: number,
        currency: string
      ) { ... }

      // Better: Value objects
      function createOrder(
        customerId: CustomerId,
        productId: ProductId,
        quantity: Quantity,
        price: Money
      ) { ... }
      ```
    }
  }

  ImplementationChecklists {
    AggregateDesign {
      - [ ] Single entity can be aggregate root
      - [ ] Invariants are protected at boundary
      - [ ] Other aggregates referenced by ID only
      - [ ] Fits in memory comfortably
      - [ ] One transaction per aggregate
    }

    EntityImplementation {
      - [ ] Has unique identifier
      - [ ] Equality based on ID
      - [ ] Encapsulates business rules
      - [ ] State changes through methods
    }

    ValueObjectImplementation {
      - [ ] All properties immutable
      - [ ] Equality based on attributes
      - [ ] Self-validating
      - [ ] Operations return new instances
    }

    RepositoryImplementation {
      - [ ] One per aggregate
      - [ ] Returns aggregate roots only
      - [ ] Hides persistence details
      - [ ] Supports queries needed by domain
    }
  }
}

## References

- [Pattern Implementation Examples](examples/ddd-patterns.md) - Code examples in multiple languages
- [Aggregate Design Guide](reference.md) - Detailed aggregate sizing heuristics
