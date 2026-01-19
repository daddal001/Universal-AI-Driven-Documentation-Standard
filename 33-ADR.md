---
title: "Architecture Decision Records"
type: "standard"
status: "approved"
owner: "@architecture-review-board"
classification: "public"
created: "2025-12-12"
last_updated: "2025-12-12"
version: "1.0.0"
---

# Architecture Decision Records (ADR)

> **Goal:** Capture the "Why" behind architectural decisions. An ADR is a short text file that describes a decision, its context, and its consequences.

---

## 1. When to write an ADR

Write an ADR when a decision involves a significant trade-off, including:

* Adding/Removing a core dependency (e.g., "Switching from REST to gRPC").
* Changing a database or storage strategy.
* Defining a structural pattern (e.g., "Standardizing on Hexagonal Architecture").
* Accepting strategic technical debt.

**Timeline:**

* **Draft:** During the design phase.
* **Approved:** Before merging the code implementing the decision.

---

## 2. Standard Format (MADR)

We follow the [Markdown Architectural Decision Records (MADR)](https://adr.github.io/madr/) format.

### Template

Save as `docs/architecture/decisions/YYYY-MM-DD-short-title.md`:

```markdown
# [Short Title, e.g., Use Postgres for Session Storage]

**Status:** [Proposed | Accepted | Deprecated | Superseded]
**Date:** YYYY-MM-DD
**Deciders:** [List names]
**Consulted:** [List names]

## Context and Problem Statement

[Describe the context and problem statement, e.g., "We need to store user sessions. Currently, we use in-memory storage, which doesn't persist across restarts."]

## Decision Drivers

*   [Driver 1, e.g., Persistence required]
*   [Driver 2, e.g., Low latency]
*   [Driver 3, e.g., Operational costs]

## Considered Options

*   [Option 1, e.g., Redis]
*   [Option 2, e.g., PostgreSQL]
*   [Option 3, e.g., DynamoDB]

## Decision Outcome

Chosen option: **[Option 2]**, because [Justification].

### Consequences

*   [Positive Consequence, e.g., Simplified stack as we already use Postgres]
*   [Negative Consequence, e.g., Slightly higher latency than Redis]

## Pros and Cons of the Options

### [Option 1: Redis]

*   Good, because [Argument]
*   Bad, because [Argument]

### [Option 2: PostgreSQL]

*   Good, because [Argument]
*   Bad, because [Argument]
```

---

## 3. Storage & Lifecycle

### Location

* **Global Architecture:** `docs/architecture/decisions/`
* **Service Specific:** `services/<name>/docs/adr/`

### File Naming

`NNNN-short-title-with-dashes.md`

* `NNNN`: Monotonically increasing number (0001, 0002...)
* Example: `0005-use-uuid-primary-keys.md`

### Superseding

When a decision is reversed:

1. Create a NEW ADR explaining the new decision.
2. Mark the OLD ADR as `Status: Superseded` and link to the new one.
3. Do **not** delete the old ADR. It is history.

---

## 4. Review Process

1. **Pull Request:** Create a PR with the ADR draft.
2. **Discussion:** Discuss in PR comments. Focus on the *Decision Drivers* and *Consequences*.
3. **Approval:** Requires approval from the relevant Tech Lead or Architect.
4. **Merge:** Once merged, the decision is "Accepted".

---

## 5. Related Documents

| Document | Purpose |
|----------|---------|
| [Philosophy](./01-PHILOSOPHY.md) | "Context, not Control" principle |
| [Document Types](./03-DOCUMENT_TYPES.md) | Where ADRs fit in |

---

**Previous:** [32 - Progressive Disclosure](./32-PROGRESSIVE_DISCLOSURE.md)
**Next:** [34 - Search Optimization](./34-SEARCH_OPTIMIZATION.md)
