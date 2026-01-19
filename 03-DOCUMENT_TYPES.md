---
title: "Document Types"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-14"
version: "1.1.0"
---

> **"A document should have ONE purpose. Don't mix types."** — Google SWE Book

This section defines all supported document types, their purposes, and when to use each.

---

## Table of Contents

1. [Core Frameworks](#core-frameworks)
2. [Document Format Classes](#document-format-classes)
3. [Document Type Decision Tree](#document-type-decision-tree)
4. [Landing Pages: The Traffic Cop](#landing-pages-the-traffic-cop)
5. [Tutorial vs How-To Guide](#tutorial-vs-how-to-guide)

---

## Core Frameworks

### Google's Five Document Types

| Type | Purpose | Audience | Location |
|------|---------|----------|----------|
| **Reference** | Document usage of code (API docs, comments) | Seekers looking up facts | Inline, `/docs/api/` |
| **Design Documents** | Record design decisions before implementation | Providers, reviewers | `/docs/adr/` |
| **Tutorials** | Learning-oriented, step-by-step for skills | Newcomers | `/docs/getting-started/` |
| **Conceptual** | Deep explanations, the "why" | Seekers wanting understanding | `/docs/architecture/` |
| **Landing Pages** | Navigation ONLY, be a "traffic cop" | Everyone | `INDEX.md` files and how to |

### Diátaxis Framework

| Type | Mode | User Need | Maps To |
|------|------|-----------|---------|
| **Tutorials** | Learning | "Help me learn" | Getting Started guides |
| **How-To Guides** | Problem-solving | "Help me complete this task" | Runbooks, guides |
| **Reference** | Information | "Help me find this fact" | API docs |
| **Explanation** | Understanding | "Help me understand" | Architecture, ADRs |

---

## Document Format Classes

| Format Class | Purpose | Audience | Location |
|----------|---------|----------|----------|
| **Reference** | Document usage of code (API docs, comments) | Seekers looking up facts | Inline, `/docs/api/` |
| **Design Documents** | Record design decisions before implementation | Providers, reviewers | `/docs/adr/` |
| **Tutorials** | Learning-oriented, step-by-step for skills | Newcomers | `/docs/getting-started/` |
| **Conceptual** | Deep explanations, the "why" | Seekers wanting understanding | `/docs/architecture/` |
| **Landing Pages** | Navigation ONLY, be a "traffic cop" | Everyone | `INDEX.md` files and how to |
| **How-to Guides** | Problem-solving | "Help me complete this task" | Runbooks, guides |

---

## Subject Domain Categories

The `category` frontmatter field indicates the subject domain or area a document covers. This allows you to tag documents across different formats.

### Valid Categories

| Category | Description | Example Documents |
|----------|-------------|-------------------|
| **security** | Security, authentication, authorization, compliance | Security playbooks, auth tutorials, compliance reports |
| **infrastructure** | Infrastructure, deployment, networking, cloud | Infrastructure docs, deployment guides, terraform runbooks |
| **api** | API design, endpoints, specifications | API references, API tutorials, OpenAPI specs |
| **data** | Databases, data pipelines, ML, analytics | Schema docs, pipeline guides, model cards |
| **operations** | Monitoring, SRE, incident response, on-call | Runbooks, SLO docs, postmortems, disaster recovery |
| **development** | Code, libraries, SDKs, development practices | Getting started guides, code references, testing docs |
| **architecture** | System design, decisions, technical strategy | Architecture docs, ADRs, design docs |
| **process** | Team processes, workflows, policies | Migration guides, changelogs, standards |

### Multi-Category Documents

Some documents may span multiple domains. In such cases:

1. **Primary category first** - Use the most important category
2. **Consider splitting** - If a document covers too many domains, split it
3. **Cross-reference** - Link to related documents in other categories

```yaml
---
category: "api"  # Primary
tags: ["security", "authentication"]  # Secondary concerns
---
```

---

## Document Type Decision Tree

Use this flowchart to select the appropriate document type:

```mermaid
flowchart TD
    START[What are you documenting?] --> Q1{Is it a folder<br/>or directory?}

    Q1 -->|Yes| README[Generate: README.md]
    Q1 -->|No| Q2{What is the user's goal?}

    Q2 -->|Learn a skill| TUTORIAL[Generate: Tutorial]
    Q2 -->|Complete a task| HOWTO[Generate: How-To Guide]
    Q2 -->|Look up a fact| REFERENCE[Generate: Reference]
    Q2 -->|Understand why| CONCEPTUAL[Generate: Conceptual/ADR]

    TUTORIAL --> T1[Learning-oriented<br/>Step-by-step<br/>Builds understanding]
    HOWTO --> H1[Task-oriented<br/>Assumes knowledge<br/>Gets to the point]
    REFERENCE --> R1[Information-oriented<br/>Accurate, complete<br/>Structured data]
    CONCEPTUAL --> C1[Understanding-oriented<br/>Explains context<br/>Covers the "why"]
```

### Quick Decision Table

| Question | If Yes → | If No → |
|----------|----------|---------|
| Is this a new feature being designed? | Design Document / ADR | ↓ |
| Is this describing how to respond to an incident? | Runbook or Playbook | ↓ |
| Is this describing an API? | API Documentation (OpenAPI) | ↓ |
| Is this describing system architecture? | Architecture Document | ↓ |
| Is the reader trying to learn something? | Tutorial | How-To Guide |

---

## Landing Pages: The Traffic Cop

Landing pages (`INDEX.md`) serve ONE purpose: **navigation**. They should NOT contain substantive content.

### What Landing Pages Should Do

| Do ✅ | Don't ❌ |
|-------|---------|
| Link to other documents | Contain explanations |
| Provide brief descriptions | Duplicate content |
| Organize by category | Include tutorials |
| Show document hierarchy | Have long paragraphs |

### Landing Page Template

```markdown
# [Section Name]

> Brief one-line description of what this section covers.

## Quick Links

| Document | Purpose |
|----------|---------|
| [Getting Started](./getting-started.md) | New user onboarding |
| [API Reference](./api/README.md) | Complete API docs |
| [Troubleshooting](./troubleshooting.md) | Common issues |

## By Category

### For New Users
- [Installation](./install.md)
- [First Steps](./first-steps.md)

### For Developers
- [Architecture](./architecture.md)
- [Contributing](./CONTRIBUTING.md)
```

---

## Tutorial vs How-To Guide

These are often confused. Here's the key distinction:

| Aspect | Tutorial | How-To Guide |
|--------|----------|--------------|
| **Purpose** | Learning | Accomplishing |
| **Audience** | Beginner | Someone with context |
| **Assumes** | Nothing | Prior knowledge |
| **Length** | Longer, explanatory | Shorter, direct |
| **Structure** | Sequential steps | Numbered steps |
| **Language** | "We will..." | "To do X, do Y" |
| **Examples** | Walks through | Provides templates |

### Tutorial Example ✅

```markdown
## Creating Your First API Key

In this tutorial, you'll learn how to create an API key
and understand how our authentication system works.

**What you'll learn:**
- How API keys are structured
- Where keys are stored
- Best practices for key management

### Step 1: Navigate to Settings

First, open the dashboard. Notice the navigation bar
at the top—this is where you'll find all account settings.

Click on "Settings" → "API Keys".

You should see:
```

### How-To Guide Example ✅

```markdown
## Create an API Key

1. Go to **Settings → API Keys**
2. Click **Create New Key**
3. Set permissions (read/write)
4. Copy the key immediately (shown only once)
5. Store in your `.env` file:

   ```bash
   API_KEY=sk_live_xxxxxxxxxxxx
   ```

> ⚠️ Never commit API keys to version control.

```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md) | Target your readers |
| [AI Agents](./04-AI_AGENTS.md) | AI-optimized docs |
| [Quality](./05-QUALITY.md) | Quality standards |

---

**Previous:** [02 - Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md)
**Next:** [04 - AI Agents](./04-AI_AGENTS.md)
