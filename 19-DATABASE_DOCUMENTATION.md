---
title: "Database Documentation Standard"
type: "standard"
status: "approved"
owner: "@data-platform-team"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-09"
version: "1.0.0"
---

# Database Documentation Standard

> **Goal:** Ensure every database schema, table, and relationship is documented clearly enough for developers and AI agents to understand data flow without reverse-engineering.

---

## 1. Schema Documentation Requirements

### Entity-Relationship Diagrams (ERD)

Every database **must** have an ERD in Mermaid format:

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    USER {
        uuid id PK
        string email UK
        string name
        timestamp created_at
    }
    ORDER ||--|{ ORDER_ITEM : contains
    ORDER {
        uuid id PK
        uuid user_id FK
        decimal total
        enum status
        timestamp created_at
    }
    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
        decimal price
    }
    PRODUCT ||--o{ ORDER_ITEM : "ordered in"
    PRODUCT {
        uuid id PK
        string name
        decimal price
        boolean active
    }
```

### ERD Placement

| Database Scope | Location | Owner |
|----------------|----------|-------|
| **Service-level** | `services/<name>/docs/DATABASE.md` | Service owner |
| **Cross-service** | `docs/architecture/DATA_MODEL.md` | Data platform |

---

## 2. Table Documentation

### Required Table Metadata

Every table **must** be documented with:

```markdown
## Table: `orders`

**Purpose:** Stores customer order headers with status tracking.

**Owner:** @backend-team
**Created:** 2024-01-15
**Last Modified:** 2025-12-01

### Columns

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `id` | `uuid` | NO | `gen_random_uuid()` | Primary key |
| `user_id` | `uuid` | NO | - | FK → `users.id` |
| `status` | `enum` | NO | `'pending'` | Order state: `pending`, `confirmed`, `shipped`, `delivered`, `cancelled` |
| `total` | `decimal(10,2)` | NO | - | Order total in USD |
| `created_at` | `timestamptz` | NO | `now()` | Creation timestamp |
| `updated_at` | `timestamptz` | NO | `now()` | Last update (trigger-maintained) |

### Indexes

| Name | Columns | Type | Purpose |
|------|---------|------|---------|
| `orders_pkey` | `id` | PRIMARY | Primary key |
| `orders_user_id_idx` | `user_id` | BTREE | User order lookup |
| `orders_status_created_idx` | `status, created_at` | BTREE | Status filtering with time |

### Constraints

| Name | Type | Definition | Reason |
|------|------|------------|--------|
| `orders_user_fk` | FOREIGN KEY | `user_id → users.id` | Referential integrity |
| `orders_total_positive` | CHECK | `total >= 0` | No negative totals |

### Triggers

| Name | Event | Description |
|------|-------|-------------|
| `orders_updated_at` | BEFORE UPDATE | Sets `updated_at` to current timestamp |
```

---

## 3. Relationship Documentation

### Cardinality Notation

Use standard cardinality in documentation:

| Notation | Meaning | Example |
|----------|---------|---------|
| `1:1` | One-to-One | User → Profile |
| `1:N` | One-to-Many | User → Orders |
| `N:M` | Many-to-Many | Products ↔ Categories |

### Relationship Table Template

```markdown
## Relationships

| From | To | Cardinality | FK Column | On Delete | Notes |
|------|----|-------------|-----------|-----------|-------|
| `orders` | `users` | N:1 | `user_id` | CASCADE | Order belongs to user |
| `order_items` | `orders` | N:1 | `order_id` | CASCADE | Delete items with order |
| `order_items` | `products` | N:1 | `product_id` | RESTRICT | Prevent product deletion if ordered |
```

---

## 4. Migration Documentation

### Migration File Standard

Every migration **must** include:

```sql
-- Migration: 20251209_add_orders_shipping_address
-- Author: @developer
-- Ticket: PROJ-1234
-- Reversible: Yes
--
-- Description:
-- Adds shipping_address_id to orders table to support
-- separate shipping destinations per order.
--
-- Impact:
-- - Adds nullable FK column (no data migration needed)
-- - Existing orders will have NULL shipping_address
--
-- Rollback:
-- ALTER TABLE orders DROP COLUMN shipping_address_id;

ALTER TABLE orders
ADD COLUMN shipping_address_id uuid
REFERENCES addresses(id);

CREATE INDEX orders_shipping_address_idx
ON orders(shipping_address_id);
```

### Migration Registry

Maintain `docs/database/MIGRATIONS.md`:

| Version | Date | Author | Description | Reversible |
|---------|------|--------|-------------|------------|
| `20251209_001` | 2025-12-09 | @dev | Add shipping address to orders | ✅ Yes |
| `20251208_001` | 2025-12-08 | @dev | Create addresses table | ✅ Yes |

---

## 5. Data Dictionary

### Central Data Dictionary

Maintain `docs/database/DATA_DICTIONARY.md`:

```markdown
# Data Dictionary

## Core Entities

| Entity | Table | Description | PII | Retention |
|--------|-------|-------------|-----|-----------|
| User | `users` | Registered users | ✅ Yes | 7 years |
| Order | `orders` | Customer orders | ❌ No | 5 years |
| Product | `products` | Catalog items | ❌ No | Forever |

## Common Data Types

| Logical Type | Physical Type | Example | Notes |
|--------------|---------------|---------|-------|
| **Identifier** | `uuid` | `550e8400-e29b-41d4-a716-446655440000` | Always UUID v4 |
| **Money** | `decimal(10,2)` | `99.99` | Never use float |
| **Timestamp** | `timestamptz` | `2025-12-09T12:00:00Z` | Always with timezone |
| **Status** | `enum` or `varchar(50)` | `'active'` | Prefer enum for fixed values |

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Tables | `snake_case`, plural | `order_items` |
| Columns | `snake_case` | `created_at` |
| Primary Keys | `id` | `orders.id` |
| Foreign Keys | `<table>_id` | `user_id` |
| Indexes | `<table>_<columns>_idx` | `orders_user_id_idx` |
| Constraints | `<table>_<type>` | `orders_pkey`, `orders_user_fk` |
```

---

## 6. Query Documentation

### Documenting Complex Queries

For queries used in application code, document in code comments:

```python
def get_user_order_summary(user_id: UUID) -> OrderSummary:
    """
    Get aggregated order statistics for a user.

    Query Explanation:
    - Joins orders → order_items → products
    - Filters to last 90 days
    - Groups by order status
    - Uses orders_user_id_idx for initial filter

    Performance:
    - Typical execution: < 50ms
    - Tested with 10M orders: < 200ms

    Returns:
        OrderSummary with counts and totals by status
    """
```

### Documenting Views and Materialized Views

```markdown
## View: `v_order_summary`

**Purpose:** Pre-aggregated order statistics for dashboard queries.

**Materialized:** Yes
**Refresh:** Every 15 minutes (cron)
**Owner:** @analytics-team

### Definition
\`\`\`sql
SELECT
    user_id,
    COUNT(*) as total_orders,
    SUM(total) as lifetime_value,
    MAX(created_at) as last_order_at
FROM orders
WHERE status != 'cancelled'
GROUP BY user_id
\`\`\`

### Usage
\`\`\`python
# Fast lookup for user dashboards
summary = db.query(VOrderSummary).filter_by(user_id=user_id).first()
\`\`\`
```

---

## 7. Database-as-Code

### Schema Files Location

```
services/<service>/
├── src/
│   └── db/
│       ├── schema.sql          # Full schema DDL
│       ├── migrations/         # Migration files
│       │   ├── 001_initial.sql
│       │   └── 002_add_addresses.sql
│       └── seeds/              # Test data
│           └── dev_data.sql
└── docs/
    └── DATABASE.md             # This documentation
```

### Auto-Generation

Use tools to keep docs in sync with schema:

| Tool | Language | What It Generates |
|------|----------|-------------------|
| `tbls` | Any | Markdown docs from live DB |
| `SchemaSpy` | Java | HTML ERD + docs |
| `pg_dump -s` | PostgreSQL | DDL export |
| `prisma generate` | Node.js | ERD from Prisma schema |

---

## 8. Database Visualization Tools (Interactive UIs)

For complex databases, static ERDs aren't enough. Use these **interactive exploration tools**:

### Free / Open Source

| Tool | Database Support | Key Features |
|------|------------------|--------------|
| **[DBeaver](https://dbeaver.io/)** | PostgreSQL, MySQL, SQLite, 80+ | ERD viewer, relationship explorer, query builder |
| **[pgAdmin](https://www.pgadmin.org/)** | PostgreSQL | Native PG tool, ER diagrams, dependency viewer |
| **[MySQL Workbench](https://www.mysql.com/products/workbench/)** | MySQL, MariaDB | Visual schema designer, forward/reverse engineering |
| **[SchemaSpy](https://schemaspy.org/)** | Any JDBC | Generates HTML site with clickable ERD |
| **[dbdiagram.io](https://dbdiagram.io/)** | Any (DSL input) | Web-based, shareable, embeddable diagrams |
| **[DrawDB](https://drawdb.vercel.app/)** | Any | Browser-based ERD editor, exports SQL |

### Commercial / SaaS

| Tool | Database Support | Key Features |
|------|------------------|--------------|
| **[DataGrip](https://www.jetbrains.com/datagrip/)** | 20+ databases | JetBrains IDE, diagram generation, smart navigation |
| **[Navicat](https://www.navicat.com/)** | MySQL, PostgreSQL, SQLite, etc. | Visual query builder, data modeling |
| **[DbVisualizer](https://www.dbvis.com/)** | Universal | References graph, object search |
| **[Metabase](https://www.metabase.com/)** | Any | BI tool with schema browser, x-ray feature |
| **[Retool Database](https://retool.com/products/database)** | PostgreSQL | Built-in relationship viewer |

### Recommended Workflows

**For PostgreSQL:**

```bash
# Generate SchemaSpy HTML documentation
docker run -v "$PWD:/output" schemaspy/schemaspy:latest \
  -t pgsql11 \
  -host localhost \
  -db mydb \
  -u postgres \
  -p password \
  -o /output/schema-docs
```

**For any database (tbls):**

```bash
# Generate Markdown docs
tbls doc postgres://user:pass@localhost:5432/mydb ./docs/database

# Output includes:
# - README.md with table list
# - Per-table markdown with relationships
# - Mermaid ERD diagram
```

### What to Look For

When exploring, these views help understand relationships:

| View | What It Shows |
|------|---------------|
| **Foreign Key Graph** | Visual connections between tables |
| **Dependency Tree** | What depends on this table |
| **Reverse Dependencies** | What this table depends on |
| **Index Usage** | Which indexes are actually used |
| **Table Size** | Row counts and storage |

---

## 9. Security Documentation

### Sensitive Data Classification

| Classification | Examples | Handling |
|----------------|----------|----------|
| **PII** | email, name, address | Encryption, access logging |
| **PCI** | card numbers, CVV | Tokenization, never store CVV |
| **PHI** | health records | Encryption, audit trail |
| **Sensitive** | salaries, reviews | Role-based access |

### Access Documentation

```markdown
## Access Control

| Role | Tables | Permissions | Purpose |
|------|--------|-------------|---------|
| `app_readonly` | All | SELECT | Application reads |
| `app_readwrite` | `orders`, `users` | SELECT, INSERT, UPDATE | Application writes |
| `admin` | All | ALL | Migrations, maintenance |
| `analytics` | Views only | SELECT | Reporting |
```

---

## 10. Related Documents

| Document | Purpose |
|----------|---------|
| [API Documentation](./18-API_DOCUMENTATION.md) | API-to-database mapping |
| [Visuals](./14-VISUALS.md) | ERD diagram standards |
| [Governance](./07-GOVERNANCE.md) | Data ownership |

---

**Previous:** [18 - API Documentation](./18-API_DOCUMENTATION.md)
**Next:** [20 - Anti-Patterns](./20-ANTI_PATTERNS.md)
