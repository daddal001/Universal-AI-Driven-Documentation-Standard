---
title: "Know Your Audience"
type: "guide"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-14"
version: "1.1.0"
---

> **"The single most important mistake is writing only for yourself."** — Google SWE Book

Before writing ANY document, identify your audience(s). This section provides frameworks for understanding and targeting your readers.

---

## Table of Contents

1. [Audience Types by Criteria](#audience-types-by-criteria)
2. [Seekers vs Stumblers](#seekers-vs-stumblers)
3. [Customers vs Providers](#customers-vs-providers)
4. [TL;DR Guidelines](#tldr-guidelines)
5. [The 5 Ws Framework](#the-5-ws-framework-whowhatwhenwherewhy)
6. [Audience-Specific Documentation Patterns](#audience-specific-documentation-patterns)

---

## Audience Types by Criteria

| Criteria | Example Audiences |
|----------|-------------------|
| **Experience level** | Expert programmers vs junior engineers who might not know the language |
| **Domain knowledge** | Team members vs engineers who only know API endpoints |
| **Purpose** | End users needing to do a specific task vs maintainers of complex implementation |

### Questions to Ask

Before writing:

1. Who will read this document?
2. What do they already know?
3. What do they need to accomplish?
4. How will they find this document?

---

## Seekers vs Stumblers

From Google's internal research, there are two fundamental types of documentation users:

| Type | Description | What They Need |
|------|-------------|----------------|
| **Seekers** | Know exactly what they want, scanning to find it quickly | **Consistency** — same format throughout, quickly scannable headings, predictable structure |
| **Stumblers** | Don't know exactly what they want, have a vague idea | **Clarity** — overviews, introductions, purpose statements, context-setting |

### Design Implications

**For Seekers:**

- Use consistent heading structure
- Include table of contents
- Use descriptive headers (not clever ones)
- Enable Ctrl+F friendly content
- Use tables for quick lookup

**For Stumblers:**

- Start with "Overview" or "Purpose" sections
- Explain the "why" before the "how"
- Provide context and background
- Link to related concepts
- Use TL;DR summaries

---

## Customers vs Providers

| Type | Who They Are | What They Need | What They DON'T Need |
|------|--------------|----------------|----------------------|
| **Customers** | API users, external developers | Usage information, examples, getting started | Implementation details, design decisions, internal workings |
| **Providers** | Team members, maintainers | Architecture, design decisions, internal details | Basic usage tutorials |

### Critical Rule

> **Keep documents for customers separate from documents for providers.**

**Bad Example:**

```markdown
# API Service

This service uses a sophisticated caching layer with Redis...
[3 paragraphs of implementation details]

## Usage
Call the `/api/messages` endpoint...
```

**Good Example:**

```markdown
# API Service (for users)
See: [API Reference](./api/)

# API Service (internal)
See: [Architecture](./ARCHITECTURE.md)
```

---

## TL;DR Guidelines

Many documents should begin with a quick summary that helps readers decide if the document is relevant.

### When to Use TL;DR

| Document Type | TL;DR Needed? |
|---------------|---------------|
| Tutorial | ✅ Yes — help user decide if right level |
| Architecture | ✅ Yes — summarize key decisions |
| API Reference | ⚠️ Sometimes — for complex APIs |
| Runbook | ❌ No — action-focused, read in emergencies |

### Examples

**Good TL;DR:**
> "TL;DR: This document explains our authentication flow. If you're looking for how to make authenticated API calls, see [Quick Start](./quickstart.md) instead."

**Good TL;DR (scope filtering):**
> "TL;DR: If you are not interested in C++ compilers at Google, you can stop reading now."

---

## The 5 Ws Framework (WHO/WHAT/WHEN/WHERE/WHY)

Every document introduction should **answer** these questions — but not by explicitly labeling them. The reader should naturally understand WHO, WHAT, WHEN, WHERE, and WHY from reading the introduction.

| Question | What to Include |
|----------|-----------------|
| **WHO** | Who is this document for? |
| **WHAT** | What does this document cover? |
| **WHEN** | When was it last updated? When should you use it? |
| **WHERE** | Where does this fit in the system/documentation? |
| **WHY** | Why does this document exist? Why should readers care? |

### ❌ Bad: Explicit Labels

```markdown
# Database Connection Pooling

> **WHO:** Backend engineers
> **WHAT:** Database connection pooling configuration
> **WHEN:** Last updated Dec 2025, review quarterly
> **WHERE:** Part of infrastructure documentation
> **WHY:** Proper pooling prevents connection exhaustion under load
```

This is mechanical and doesn't read naturally.

### ✅ Good: Natural Prose That Answers the 5 Ws

```markdown
# Database Connection Pooling

This guide helps backend engineers configure connection pooling for PostgreSQL databases. Proper pooling prevents connection exhaustion under load — a common cause of production outages.

Use this when setting up a new service or troubleshooting
connection errors. Last reviewed December 2025.
```

This answers all 5 Ws naturally:

- **WHO:** "backend engineers"
- **WHAT:** "configure connection pooling for PostgreSQL"
- **WHEN:** "when setting up a new service or troubleshooting", "December 2025"
- **WHERE:** implied by context (infrastructure/database)
- **WHY:** "prevents connection exhaustion under load"

---

## Audience-Specific Documentation Patterns

### For New Engineers

- Start with prerequisites
- Assume nothing
- Provide complete, copy-paste examples
- Include expected output
- Link to glossary for terms

### For Senior Engineers

- Be concise
- Jump to technical details
- Show code patterns
- Highlight gotchas and edge cases

### For Non-Technical Stakeholders

- Lead with business value
- Use diagrams over text
- Avoid jargon
- Summarize in bullet points

### For AI Agents

- Use clear, consistent headers
- Make sections self-contained
- Include structured data (tables)
- Avoid "see above" references

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Philosophy](./01-PHILOSOPHY.md) | Why documentation matters |
| [Document Types](./03-DOCUMENT_TYPES.md) | What types to write |

---

**Previous:** [01 - Philosophy](./01-PHILOSOPHY.md)
**Next:** [03 - Document Types](./03-DOCUMENT_TYPES.md)
