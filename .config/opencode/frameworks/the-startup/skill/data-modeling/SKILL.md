---
name: data-modeling
description: "Schema design, entity relationships, normalization, and database patterns. Use when designing database schemas, modeling domain entities, deciding between normalized and denormalized structures, choosing between relational and NoSQL approaches, or planning schema migrations."
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Data Modeling

Roleplay as a data modeling specialist designing schemas that encode business rules, enforce integrity, and enable performance optimization.

DataModeling {
  Activation {
    When designing new database schemas from domain requirements
    When analyzing existing schemas for optimization opportunities
    When deciding between normalized and denormalized structures
    When choosing appropriate data stores (relational vs NoSQL)
    When planning schema evolution and migration strategies
    When modeling complex entity relationships
  }

  Constraints {
    Data models outlive applications
    A well-designed schema encodes business rules and enforces integrity
    Correct first, then optimize for access patterns
    Maintain data integrity during optimization
    Model the domain first, then optimize for access patterns
    Use surrogate keys for primary keys; natural keys as unique constraints
    Normalize to 3NF for OLTP; denormalize deliberately for read-heavy loads
    Version control all schema changes as migration scripts
  }

  EntityRelationshipModeling {
    IdentifyingEntities {
      Entities represent distinct business concepts that have identity and lifecycle

      IdentificationChecklist:
      - Has unique identity across the system
      - Has attributes that describe it
      - Participates in relationships with other entities
      - Has a meaningful lifecycle (created, modified, archived)
      - Would be stored and retrieved independently

      CommonEntityPatterns:
      - Core domain objects (User, Product, Order)
      - Reference/lookup data (Country, Status, Category)
      - Transactional records (Payment, LogEntry, Event)
      - Associative entities (OrderItem, Enrollment, Permission)
    }

    RelationshipTypes {
      | Type | Notation | Example | Implementation |
      |------|----------|---------|----------------|
      | One-to-One | 1:1 | User - Profile | FK with unique constraint or same table |
      | One-to-Many | 1:N | Customer - Orders | FK on the "many" side |
      | Many-to-Many | M:N | Students - Courses | Junction/bridge table |

      Considerations:
      - Cardinality: minimum and maximum on each side
      - Optionality: required vs optional participation
      - Direction: unidirectional vs bidirectional navigation
      - Cascade behavior: what happens on delete/update
    }

    AttributeAnalysis {
      AttributeTypes:
      - Simple: single atomic value (name, price)
      - Composite: structured value (address = street + city + postal)
      - Derived: calculated from other attributes (age from birthdate)
      - Multi-valued: repeating values (phone numbers, tags)

      KeyTypes:
      - Natural key: business-meaningful identifier (SSN, ISBN)
      - Surrogate key: system-generated identifier (UUID, auto-increment)
      - Composite key: multiple columns forming identity
      - Candidate key: any attribute(s) that could serve as primary key

      BestPractice: Prefer surrogate keys for primary keys; use natural keys as unique constraints
    }
  }

  Normalization {
    NormalFormsProgression {
      Each normal form builds on the previous
      Normalize until requirements dictate otherwise
    }

    FirstNormalForm {
      Rule: Eliminate repeating groups; each cell contains atomic values

      ViolationExample:
      ```
      Order(id, customer, items: "widget,gadget,thing")
      ```

      Resolution:
      ```
      Order(id, customer)
      OrderItem(order_id, item_name)
      ```
    }

    SecondNormalForm {
      Rule: Remove partial dependencies on composite keys

      ViolationExample:
      ```
      OrderItem(order_id, product_id, product_name, quantity)
                                       ^-- depends only on product_id
      ```

      Resolution:
      ```
      OrderItem(order_id, product_id, quantity)
      Product(product_id, product_name)
      ```
    }

    ThirdNormalForm {
      Rule: Remove transitive dependencies; non-key columns depend only on the key

      ViolationExample:
      ```
      Employee(id, department_id, department_name)
                                  ^-- depends on department_id, not employee id
      ```

      Resolution:
      ```
      Employee(id, department_id)
      Department(id, name)
      ```
    }

    BoyceCoodNormalForm {
      Rule: Every determinant is a candidate key

      ViolationExample:
      ```
      CourseOffering(student, course, instructor)
      -- Constraint: each instructor teaches only one course
      -- instructor -> course (but instructor is not a candidate key)
      ```

      Resolution:
      ```
      InstructorCourse(instructor, course) -- instructor is key
      Enrollment(student, instructor) -- references instructor
      ```
    }

    WhenToStopNormalizing {
      Stop at 3NF for most OLTP systems
      Consider BCNF when:
      - Update anomalies cause data corruption
      - Data integrity is paramount
      - Write frequency is high
    }
  }

  DenormalizationStrategies {
    Principle: Denormalize intentionally for read performance, not out of laziness

    CalculatedColumns {
      Store derived values to avoid repeated computation

      ```
      Order
        - subtotal (calculated once on item changes)
        - tax_amount (calculated once)
        - total (calculated once)
      ```

      TradeOff: Faster reads, more complex writes, potential consistency issues
    }

    MaterializedRelationships {
      Embed frequently-accessed related data

      ```
      Post
        - author_id
        - author_name (copied from User.name)
        - author_avatar_url (copied from User.avatar_url)
      ```

      TradeOff: Eliminates joins, requires synchronization on source changes
    }

    AggregationTables {
      Pre-compute summaries for reporting

      ```
      DailySales
        - date
        - product_id
        - units_sold (sum)
        - revenue (sum)
      ```

      TradeOff: Fast analytics, storage overhead, stale until refreshed
    }

    DecisionMatrix {
      | Factor | Normalize | Denormalize |
      |--------|-----------|-------------|
      | Write frequency | High | Low |
      | Read frequency | Low | High |
      | Data consistency | Critical | Eventual OK |
      | Query complexity | Simple | Complex joins |
      | Data size | Small | Large |
    }
  }

  NoSQLPatterns {
    DocumentStores {
      Target: MongoDB, DynamoDB

      EmbeddingPattern {
        Embed related data that is read together and has 1:few relationship

        ```json
        {
          "order_id": "123",
          "customer": {
            "id": "456",
            "name": "Jane Doe",
            "email": "jane@example.com"
          },
          "items": [
            {"product_id": "A1", "name": "Widget", "quantity": 2}
          ]
        }
        ```
      }

      ReferencingPattern {
        Reference related data when it changes independently or is shared

        ```json
        {
          "order_id": "123",
          "customer_id": "456",
          "item_ids": ["A1", "B2"]
        }
        ```
      }

      HybridPattern {
        Embed summary data, reference for full details

        ```json
        {
          "order_id": "123",
          "customer_summary": {
            "id": "456",
            "name": "Jane Doe"
          },
          "items": [
            {"product_id": "A1", "name": "Widget", "quantity": 2}
          ]
        }
        ```
      }
    }

    KeyValueStores {
      AccessPatternDesign: Design keys around query patterns

      ```
      USER:{user_id} -> user data
      USER:{user_id}:ORDERS -> list of order ids
      ORDER:{order_id} -> order data
      ```

      CompositeKeys: Combine entity type with identifiers for namespacing
    }

    WideColumnStores {
      Target: Cassandra, HBase

      PartitionKeyDesign: Choose partition keys for even distribution and access locality

      ```
      Primary Key: (user_id, order_date)
                   ^-- partition key (distribution)
                             ^-- clustering column (ordering)
      ```

      Avoid:
      - High-cardinality partition keys causing hot spots
      - Large partitions exceeding recommended sizes
      - Scatter-gather queries across partitions
    }

    GraphDatabases {
      NodeAndRelationshipDesign:
      - Nodes: entities with properties
      - Relationships: named, directed, with properties
      - Labels: categorize nodes for efficient traversal

      ```
      (User)-[:PURCHASED {date, amount}]->(Product)
      (User)-[:FOLLOWS]->(User)
      (Product)-[:BELONGS_TO]->(Category)
      ```
    }
  }

  SchemaEvolutionStrategies {
    AdditiveChanges {
      Safe changes:
      - Add new nullable columns
      - Add new tables
      - Add new indexes
      - Add new optional fields (NoSQL)
    }

    BreakingChanges {
      Require migration:
      - Remove columns/tables
      - Rename columns/tables
      - Change data types
      - Add non-nullable columns without defaults
    }

    MigrationPatterns {
      ExpandContractPattern {
        1. Add new column alongside old
        2. Backfill new column from old
        3. Update application to use new column
        4. Remove old column
      }

      BlueGreenSchema {
        1. Create new version of schema
        2. Dual-write to both versions
        3. Migrate reads to new version
        4. Drop old version
      }

      VersionedDocuments {
        For NoSQL:
        ```json
        {
          "_schema_version": 2,
          "name": "Jane",
          "email": "jane@example.com"
        }
        ```

        Handle multiple versions in application code during transition
      }
    }
  }

  BestPractices {
    - Model the domain first, then optimize for access patterns
    - Use surrogate keys for primary keys; natural keys as unique constraints
    - Normalize to 3NF for OLTP; denormalize deliberately for read-heavy loads
    - Document all foreign key relationships and cascade behaviors
    - Version control all schema changes as migration scripts
    - Test migrations on production-like data volumes
    - Consider query patterns when designing NoSQL schemas
    - Plan for schema evolution from day one
  }

  AntiPatterns {
    - Designing schemas around UI forms instead of domain concepts
    - Using generic columns (field1, field2, field3)
    - Entity-Attribute-Value (EAV) for structured data
    - Storing comma-separated values in single columns
    - Circular foreign key dependencies
    - Missing indexes on foreign key columns
    - Hard-deleting data without soft-delete consideration
    - Ignoring temporal aspects (effective dates, audit trails)
  }
}

## References

- [templates/schema-design-template.md](templates/schema-design-template.md) - Structured template for schema documentation
