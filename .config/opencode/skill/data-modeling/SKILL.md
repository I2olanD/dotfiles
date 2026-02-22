---
name: data-modeling
description: Schema design, entity relationships, normalization, and database patterns. Use when designing database schemas, modeling domain entities, deciding between normalized and denormalized structures, choosing between relational and NoSQL approaches, or planning schema migrations. Covers ER modeling, normal forms, and data evolution strategies.
license: MIT
compatibility: opencode
metadata:
  category: design
  version: "1.0"
---

# Data Modeling

## When to Use

- Designing new database schemas from domain requirements
- Analyzing existing schemas for optimization opportunities
- Deciding between normalized and denormalized structures
- Choosing appropriate data stores (relational vs NoSQL)
- Planning schema evolution and migration strategies
- Modeling complex entity relationships

## Philosophy

Data models outlive applications. A well-designed schema encodes business rules, enforces integrity, and enables performance optimization. The goal is to create models that are correct first, then optimize for access patterns while maintaining data integrity.

## Entity-Relationship Modeling

### Identifying Entities

Entities represent distinct business concepts that have identity and lifecycle.

```sudolang
EntityIdentification {
  require Has unique identity across the system.
  require Has attributes that describe it.
  require Participates in relationships with other entities.
  require Has meaningful lifecycle (created, modified, archived).
  require Would be stored and retrieved independently.
}
```

**Common Entity Patterns:**
- Core domain objects (User, Product, Order)
- Reference/lookup data (Country, Status, Category)
- Transactional records (Payment, LogEntry, Event)
- Associative entities (OrderItem, Enrollment, Permission)

### Relationship Types

```sudolang
determineRelationshipImplementation(relationship) {
  match relationship.type {
    "1:1" => {
      implementation: "FK with unique constraint or same table",
      example: "User - Profile"
    }
    "1:N" => {
      implementation: "FK on the 'many' side",
      example: "Customer - Orders"
    }
    "M:N" => {
      implementation: "Junction/bridge table",
      example: "Students - Courses"
    }
  }
}

RelationshipAnalysis {
  considerations: [
    "Cardinality: minimum and maximum on each side",
    "Optionality: required vs optional participation",
    "Direction: unidirectional vs bidirectional navigation",
    "Cascade behavior: what happens on delete/update"
  ]
}
```

### Attribute Analysis

```sudolang
Attribute {
  name
  type   "simple" | "composite" | "derived" | "multi-valued"
  nullable
  description
}

categorizeAttribute(attribute) {
  match attribute {
    { atomic: true, single: true } => "simple"        name, price
    { structured: true } => "composite"                address = street + city + postal
    { calculatedFrom: _ } => "derived"                 age from birthdate
    { repeating: true } => "multi-valued"              phone numbers, tags
  }
}

Key {
  type   "natural" | "surrogate" | "composite" | "candidate"
  columns
}

categorizeKey(key) {
  match key {
    { businessMeaningful: true } => "natural"          SSN, ISBN
    { systemGenerated: true } => "surrogate"           UUID, auto-increment
    { columns: c } if c has more than 1 => "composite" Multiple columns
    { couldServePrimary: true } => "candidate"         Any viable primary key option
  }
}

KeyDesign {
  Constraints {
    Prefer surrogate keys for primary keys.
    Use natural keys as unique constraints.
  }
}
```

## Normalization

### Normal Forms Progression

Each normal form builds on the previous. Normalize until requirements dictate otherwise.

```sudolang
NormalFormValidation {
  validate1NF(table) {
    require No repeating groups.
    require Each cell contains atomic values.

    Violation: Order(id, customer, items: "widget,gadget,thing")
    Resolution: Separate Order and OrderItem tables
  }

  validate2NF(table) {
    require Satisfies 1NF.
    require No partial dependencies on composite keys.

    Violation: OrderItem(order_id, product_id, product_name, quantity)
               where product_name depends only on product_id
    Resolution: Extract Product(product_id, product_name)
  }

  validate3NF(table) {
    require Satisfies 2NF.
    require No transitive dependencies.
    require Non-key columns depend only on the key.

    Violation: Employee(id, department_id, department_name)
               where department_name depends on department_id
    Resolution: Extract Department(id, name)
  }

  validateBCNF(table) {
    require Satisfies 3NF.
    require Every determinant is a candidate key.

    Violation: CourseOffering(student, course, instructor)
               with constraint: instructor -> course
    Resolution: InstructorCourse(instructor, course) + Enrollment(student, instructor)
  }
}
```

### When to Stop Normalizing

```sudolang
determineNormalizationLevel(context) {
  match context {
    { systemType: "OLTP" } => "3NF"
    { updateAnomalies: true } => "BCNF"
    { dataIntegrity: "paramount" } => "BCNF"
    { writeFrequency: "high" } => "BCNF"
    _ => "3NF"
  }
}
```

## Denormalization Strategies

Denormalize intentionally for read performance, not out of laziness.

### Calculated Columns

Store derived values to avoid repeated computation.

```
Order
  - subtotal (calculated once on item changes)
  - tax_amount (calculated once)
  - total (calculated once)
```

**Trade-off:** Faster reads, more complex writes, potential consistency issues.

### Materialized Relationships

Embed frequently-accessed related data.

```
Post
  - author_id
  - author_name (copied from User.name)
  - author_avatar_url (copied from User.avatar_url)
```

**Trade-off:** Eliminates joins, requires synchronization on source changes.

### Aggregation Tables

Pre-compute summaries for reporting.

```
DailySales
  - date
  - product_id
  - units_sold (sum)
  - revenue (sum)
```

**Trade-off:** Fast analytics, storage overhead, stale until refreshed.

### Denormalization Decision

```sudolang
shouldDenormalize(context) {
  match context {
    { writeFrequency: "high" } => false                 Keep normalized
    { readFrequency: "high", writeFrequency: "low" } => true
    { consistency: "critical" } => false                 Keep normalized
    { consistency: "eventual_ok" } => true
    { queryComplexity: "complex_joins" } => true
    { queryComplexity: "simple" } => false
    { dataSize: "large" } => true
    { dataSize: "small" } => false
    _ => false  Safe default: keep normalized
  }
}
```

## NoSQL Data Modeling Patterns

### Document Stores (MongoDB, DynamoDB)

```sudolang
determineDocumentPattern(relationship) {
  match relationship {
    { readTogether: true, cardinality: "1:few" } => {
      pattern: "embedding",
      example: """
        {
          "order_id": "123",
          "customer": { "id": "456", "name": "Jane Doe", "email": "jane@example.com" },
          "items": [{ "product_id": "A1", "name": "Widget", "quantity": 2 }]
        }
      """
    }
    { changesIndependently: true } | { shared: true } => {
      pattern: "referencing",
      example: """
        {
          "order_id": "123",
          "customer_id": "456",
          "item_ids": ["A1", "B2"]
        }
      """
    }
    _ => {
      pattern: "hybrid",
      description: "Embed summary data, reference for full details",
      example: """
        {
          "order_id": "123",
          "customer_summary": { "id": "456", "name": "Jane Doe" },
          "items": [{ "product_id": "A1", "name": "Widget", "quantity": 2 }]
        }
      """
    }
  }
}
```

### Key-Value Stores

**Access Pattern Design:** Design keys around query patterns.

```
USER:{user_id} -> user data
USER:{user_id}:ORDERS -> list of order ids
ORDER:{order_id} -> order data
```

**Composite Keys:** Combine entity type with identifiers for namespacing.

### Wide-Column Stores (Cassandra, HBase)

**Partition Key Design:** Choose partition keys for even distribution and access locality.

```
Primary Key: (user_id, order_date)
             ^-- partition key (distribution)
                       ^-- clustering column (ordering)
```

```sudolang
WideColumnDesign {
  warn High-cardinality partition keys causing hot spots.
  warn Large partitions exceeding recommended sizes.
  warn Scatter-gather queries across partitions.
}
```

### Graph Databases

**Node and Relationship Design:**
- Nodes: entities with properties
- Relationships: named, directed, with properties
- Labels: categorize nodes for efficient traversal

```
(User)-[:PURCHASED {date, amount}]->(Product)
(User)-[:FOLLOWS]->(User)
(Product)-[:BELONGS_TO]->(Category)
```

## Schema Evolution Strategies

### Change Classification

```sudolang
classifySchemaChange(change) {
  match change.type {
    "add_nullable_column" => { safe: true, migration: "additive" }
    "add_table" => { safe: true, migration: "additive" }
    "add_index" => { safe: true, migration: "additive" }
    "add_optional_field" => { safe: true, migration: "additive" }  NoSQL

    "remove_column" | "remove_table" => {
      safe: false,
      migration: "breaking",
      action: "Requires data migration"
    }
    "rename_column" | "rename_table" => {
      safe: false,
      migration: "breaking",
      action: "Requires application updates"
    }
    "change_data_type" => {
      safe: false,
      migration: "breaking",
      action: "Requires data conversion"
    }
    "add_non_nullable_column" if !change.hasDefault => {
      safe: false,
      migration: "breaking",
      action: "Requires default value or backfill"
    }
  }
}
```

### Migration Patterns

**Expand-Contract Pattern:**
1. Add new column alongside old
2. Backfill new column from old
3. Update application to use new column
4. Remove old column

**Blue-Green Schema:**
1. Create new version of schema
2. Dual-write to both versions
3. Migrate reads to new version
4. Drop old version

**Versioned Documents (NoSQL):**
```json
{
  "_schema_version": 2,
  "name": "Jane",
  "email": "jane@example.com"
}
```

Handle multiple versions in application code during transition.

## Best Practices

```sudolang
DataModelingBestPractices {
  Constraints {
    Model the domain first, then optimize for access patterns.
    Use surrogate keys for primary keys.
    Use natural keys as unique constraints.
    Normalize to 3NF for OLTP.
    Denormalize deliberately for read-heavy loads.
    Document all foreign key relationships and cascade behaviors.
    Version control all schema changes as migration scripts.
    Test migrations on production-like data volumes.
    Consider query patterns when designing NoSQL schemas.
    Plan for schema evolution from day one.
  }
}
```

## Anti-Patterns

```sudolang
DataModelingAntiPatterns {
  warn Designing schemas around UI forms instead of domain concepts.
  warn Using generic columns (field1, field2, field3).
  warn Entity-Attribute-Value (EAV) for structured data.
  warn Storing comma-separated values in single columns.
  warn Circular foreign key dependencies.
  warn Missing indexes on foreign key columns.
  warn Hard-deleting data without soft-delete consideration.
  warn Ignoring temporal aspects (effective dates, audit trails).
}
```

## References

- [templates/schema-design-template.md](templates/schema-design-template.md) - Structured template for schema documentation
