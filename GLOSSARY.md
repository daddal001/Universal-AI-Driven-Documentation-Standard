---
title: "Glossary"
type: "glossary"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-13"
version: "1.1.0"
---

# Glossary

> **Purpose:** Canonical definitions for terminology used across documentation. All documents **must** use these exact terms to ensure consistency and searchability.

---

## Documentation Terms

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **ADR** | Architecture Decision Record—document capturing a significant architectural decision | "Design doc" (ambiguous) |
| **ARID** | Accept (some) Repetition In Documentation—principle allowing strategic repetition | — |
| **Diátaxis** | Documentation framework with 4 types: Tutorial, How-To, Reference, Explanation | — |
| **Frontmatter** | YAML metadata block at the top of Markdown files | "Header", "metadata block" |
| **Landing Page** | Navigation-only document that directs readers to other docs | "Index page", "hub" |
| **Runbook** | Step-by-step operational procedure for incident response | "Playbook" (reserved for security) |
| **SSOT** | Single Source of Truth—one canonical location for each piece of information | "Golden source" |
| **Vale** | Prose linting tool used for style enforcement | — |

---

## Documentation Infrastructure Terms

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **go/ link** | Short, memorable URL that redirects to internal docs (e.g., `go/standards`) | "short link", "redirect" |
| **Monorepo** | Single repository containing all code and docs for multiple services | "mono-repo" |
| **Federated Repo** | Multiple repositories managed by a unified build system (Amazon model) | "multi-repo" (ambiguous) |
| **TechDocs** | Backstage plugin for aggregating docs from multiple sources | — |
| **Algolia** | External search-as-a-service for documentation | — |
| **Meilisearch** | Self-hosted, open-source search engine | — |
| **DocSearch** | Algolia's free documentation search program | — |
| **MkDocs** | Python-based static site generator for documentation | — |
| **Material for MkDocs** | Premium theme for MkDocs with advanced features | "MkDocs Material" |
| **Docusaurus** | React-based documentation framework by Meta | — |
| **Backstage** | Spotify's open-source developer portal platform | — |
| **Code Wiki** | Google's AI-generated, auto-updated documentation system | — |
| **Amazon Kendra** | AWS AI-powered enterprise search service | — |

---

## Audience Terms

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **Customer** | External user of an API or service | "Consumer" |
| **Provider** | Internal team maintaining a service | "Producer" |
| **Seeker** | Reader who knows exactly what they want | — |
| **Stumbler** | Reader exploring with a vague idea | — |

---

## Quality Terms

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **Accuracy** | Every fact matches the actual codebase | "Correctness" |
| **Completeness** | All required information is documented | "Coverage" (reserved for metrics) |
| **Freshness** | Time since last verified update | "Staleness" (inverse) |
| **Helpfulness Ratio** | % of positive "Was this helpful?" responses | "Satisfaction rate" |

---

## Operational Terms

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **P0** | Critical severity—requires immediate response | "Sev1", "Critical" |
| **P1** | High severity—requires response within hours | "Sev2", "High" |
| **P2** | Medium severity—next business day | "Sev3", "Medium" |
| **P3** | Low severity—no SLA | "Sev4", "Low" |
| **SLA** | Service Level Agreement—formal commitment | — |
| **SLO** | Service Level Objective—target metric | — |

---

## Technical Terms

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **API** | Application Programming Interface | "Endpoint" (part of API) |
| **AsyncAPI** | Specification for event-driven API documentation | — |
| **GraphQL** | Query language for APIs | — |
| **MCP** | Model Context Protocol for AI tool integration | — |
| **OpenAPI** | Specification for REST API documentation | "Swagger" (legacy name) |
| **RAG** | Retrieval-Augmented Generation for AI systems | — |
| **SSE** | Server-Sent Events—one-way streaming | — |

---

## Project-Specific Terms

> Add your organization's specific terminology here.

| Term | Definition | Do NOT Use |
|------|------------|------------|
| **[Your Project]** | Add your project name and definition here | — |

---

## Acronyms

| Acronym | Expansion |
|---------|-----------|
| **ALCOA-C** | Attributable, Legible, Contemporaneous, Original, Accurate, Complete |
| **CI/CD** | Continuous Integration / Continuous Deployment |
| **DX** | Developer Experience |
| **i18n** | Internationalization |
| **l10n** | Localization |
| **LLM** | Large Language Model |
| **WCAG** | Web Content Accessibility Guidelines |

---

## Vale Vocabulary

These terms are configured in `.vale/styles/Vocab/` to prevent false positives:

```
AsyncAPI
CODEOWNERS
Diátaxis
FastAPI
GraphQL
Kubernetes
Markdoc
Mermaid
OpenAPI
PostgreSQL
PromQL
Redis
TypeScript
```

---

## Adding New Terms

1. **Check existing terms** in this glossary first
2. **Propose new terms** via PR with:
   - Definition
   - Terms to avoid (aliases)
   - Category
3. **Update Vale vocabulary** if term triggers false positives
4. **Update all docs** using the deprecated term

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Style Guide](./11-STYLE_GUIDE.md) | Terminology enforcement via Vale |
| [Quality](./05-QUALITY.md) | Consistency criterion |
