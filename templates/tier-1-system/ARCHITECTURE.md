---
title: "[System/Component] Architecture"
type: "architecture"
status: "approved"
owner: "@tech-lead"
classification: "internal"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

# [System/Component] Architecture

High-level architecture documentation for engineers working with [system/component]. This document covers system design, component relationships, and key technology decisions. Review before making major changes or during onboarding.

---

## Overview

[1-2 paragraph high-level description of the system]

## System Context

```mermaid
C4Context
    title System Context Diagram

    Person(user, "User", "End user of the system")
    System(system, "This System", "What it does")
    System_Ext(external, "External System", "Integration point")

    Rel(user, system, "Uses")
    Rel(system, external, "Calls")
```

## Container Diagram

```mermaid
C4Container
    title Container Diagram

    Container(web, "Web App", "React", "User interface")
    Container(api, "API Gateway", "Node.js", "API routing")
    Container(service, "Core Service", "Python", "Business logic")
    ContainerDb(db, "Database", "PostgreSQL", "Data storage")

    Rel(web, api, "HTTPS")
    Rel(api, service, "gRPC")
    Rel(service, db, "SQL")
```

## Data Flow

```mermaid
flowchart LR
    A[Client] --> B[Load Balancer]
    B --> C[API Gateway]
    C --> D[Service A]
    C --> E[Service B]
    D --> F[(Database)]
    E --> G[(Cache)]
```

## Key Components

| Component | Technology | Purpose | Owner |
|-----------|------------|---------|-------|
| [Component 1] | [Tech stack] | [What it does] | @team |
| [Component 2] | [Tech stack] | [What it does] | @team |

## Technology Decisions

| Decision | Choice | Rationale | ADR |
|----------|--------|-----------|-----|
| [Decision 1] | [Choice] | [Why] | [ADR-XXX](../adr/ADR-XXX.md) |
| [Decision 2] | [Choice] | [Why] | [ADR-XXX](../adr/ADR-XXX.md) |

## Non-Functional Requirements

| Requirement | Target | Current |
|-------------|--------|---------|
| Availability | 99.9% | [XX%] |
| Latency (p99) | < 200ms | [XXms] |
| Throughput | 1000 RPS | [XXX RPS] |

## Security

- **Authentication:** [Method]
- **Authorization:** [Method]
- **Data Encryption:** [At rest / In transit]
- **Secrets Management:** [Tool/method]

## Deployment

- **Infrastructure:** [Cloud provider / On-prem]
- **Orchestration:** [Kubernetes / ECS / etc.]
- **Regions:** [List of regions]

## Related Documents

| Document | Purpose |
|----------|---------|
| [ADRs](../adr/) | Architecture decisions |
| [Runbooks](../operations/runbooks/) | Operational procedures |
| [API Reference](../api/) | API documentation |
