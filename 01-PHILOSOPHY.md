---
title: "Documentation Philosophy"
type: "guide"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-13"
version: "1.1.0"
---

> **"High-quality internal documentation leads to 25% higher team performance."** — DORA 2023 Research

This section establishes the foundational principles for documentation excellence, drawing from industry best practices across the world's leading engineering organizations.

---

## Table of Contents

1. [Why Documentation Matters](#why-documentation-matters)
2. [AI-First Documentation](#ai-first-documentation)
3. [Industry Best Practices](#industry-best-practices)
4. [Core Principles](#core-principles)
5. [Case Studies](#case-studies)
6. [TL;DRs (Key Takeaways)](#tldrs-key-takeaways)

---

## Why Documentation Matters

### The Business Case (DORA 2023)

The **DevOps Research and Assessment (DORA)** 2023 State of DevOps report found:

| Finding | Impact |
|---------|--------|
| **25% higher team performance** | Teams with high-quality documentation outperform |
| **Amplifies technical capabilities** | Docs enhance CI/CD, SRE, and code review effectiveness |
| **Organizational performance** | Directly linked to profitability goals |

> Documentation is NOT a nice-to-have. It directly impacts organizational performance.

### AI-First Documentation

> **This documentation standard is designed to be executed by AI agents, not written manually by humans.**

| Principle | Description |
|-----------|-------------|
| **AI Agents Handle All Documentation** | AI agents create, update, and maintain all documentation following these standards |
| **Detailed Standards Enable AI Precision** | Comprehensive guidelines allow AI to produce consistent, high-quality output |
| **Humans Read, AI Writes** | Engineers and stakeholders consume documentation; AI agents produce it |
| **Full Compliance in Days** | AI can achieve 100% compliance across all repositories within one week |
| **Multi-Purpose Output** | Documentation serves onboarding, triage, compliance, audits, and improvement planning |

**Why This Matters:**

- AI can process and follow complex, detailed guidelines in a single pass
- Consistent application of standards across hundreds of repositories
- Documentation stays fresh because AI updates it continuously
- Reduces burden on engineers while increasing documentation quality
- Documentation becomes a competitive advantage, not a chore

### Benefits to the Writer

| Benefit | Explanation |
|---------|-------------|
| **Formulates API** | Writing docs is the surest way to figure out if your API makes sense |
| **Historical record** | Good comments help when staring at code YOU wrote two years ago |
| **Professional appearance** | Well-documented API = better-designed API |
| **Fewer questions** | If you explain something more than once, document it |

### Benefits to the Reader

- Code and APIs become more comprehensible, reducing mistakes
- Project teams are more focused when goals are clearly stated
- Manual processes are easier to follow
- Onboarding takes much less effort

### Why Engineers Skip Documentation (And How We Fix It)

> *"They benefit from documentation, realise how important it is... but they just don't do it."*
> — [r/devops community](https://www.reddit.com/r/devops/comments/1neyjf1/)

Let's be honest about the real reasons and address each one:

| The Honest Reason | The Fix |
|-------------------|---------|
| **"It's not my job"** | CODEOWNERS assigns accountability ([07-GOVERNANCE](./07-GOVERNANCE.md)) |
| **"I don't have time"** | Templates reduce writing time by 70% ([templates/](./templates/)) |
| **"No one reads it anyway"** | Search analytics prove readership ([13-FEEDBACK](./13-FEEDBACK.md)) |
| **"It gets stale immediately"** | CI blocks PRs if docs don't match code ([scripts/](./scripts/)) |
| **"I'll remember this"** | Freshness SLAs force review in 90 days ([06-OPERATIONS](./06-OPERATIONS.md)) |
| **"Writing is hard"** | AI agents draft, humans review ([04-AI_AGENTS](./04-AI_AGENTS.md)) |
| **"There's no standard"** | You're reading it. 35 standards, one source. |
| **"Management doesn't care"** | Maturity metrics make it visible ([17-MATURITY_MODEL](./17-MATURITY_MODEL.md)) |

**The Core Insight:**

Documentation fails when it's *optional* and *effortful*. This standard makes it:

- **Non-optional** — CI enforcement, ownership rules
- **Low-effort** — Templates, AI assistance, validation scripts
- **Visible** — Analytics, maturity scores, freshness dashboards

---

## Industry Best Practices

### Google (Software Engineering at Google, Chapter 10)

Google's internal research on documentation established fundamental principles:

| Principle | Description |
|-----------|-------------|
| **Optimize for the reader** | You write once, they read thousands of times |
| **Documentation = Code** | Same rigor: version control, reviews, ownership |
| **Five document types** | Reference, Design, Tutorial, Conceptual, Landing |
| **One purpose per document** | Don't mix types—like APIs, do one thing well |
| **Know your audience** | Seekers vs Stumblers, Customers vs Providers |

**Monorepo Architecture:**

- Google uses a single monorepo ("google3") for ~95% of their codebase
- Docs live alongside code in g3doc format (Markdown in source control)
- Unified Code Search indexes all documentation
- Code Wiki auto-generates and maintains wikis from codebase

**go/ Links for Discovery:**

- Short URLs like `go/auth-guide` redirect to internal docs
- Engineers claim `go/` links before writing documentation
- Creates canonical sources for every document

**Key Quote:**
> "Every software engineer is also a writer."

**Learnings from the Google Wiki Failure:**

- Without owners, 90% of wiki documents became obsolete
- Without process, duplicates appeared everywhere
- Solution: Move docs to source control with ownership

### Amazon

| Practice | Description |
|----------|-------------|
| **6-Pager Design Docs** | Prose over bullet points, max 6-8 pages |
| **Data-driven** | Include numbers, percentages, dates |
| **Business value focus** | Start with customer outcome, not technology |
| **No PowerPoints** | Written narrative forces clear thinking |

**Key Quote:**
> "If you can't write it clearly, you haven't thought it through."

### Meta (Facebook)

| Practice | Description |
|----------|-------------|
| **RFC Documents** | Request for Comments with trade-offs, risks, diagrams |
| **Better Engineering Initiative** | 20-30% time for docs, refactoring, tooling |
| **Code reviews for docs** | Same rigor as code reviews |

**Key Insight:** Engineers who improve documentation are recognized in performance reviews.

### Stripe

| Practice | Description |
|----------|-------------|
| **Interactive documentation** | API keys auto-inserted, copy-paste ready |
| **Three-column layout** | Navigate + Understand + Test simultaneously |
| **Career ladder integration** | Docs in performance reviews |
| **"Done" = code + docs** | Feature isn't complete without documentation |
| **Markdoc** | Open-source extended Markdown framework |

**Key Quote:**
> "Documentation is a product feature, not an afterthought."

### Netflix

| Practice | Description |
|----------|-------------|
| **Customer perspective** | Write from user's view, not platform provider's |
| **Information architecture** | Searchability, discoverability, consolidation |
| **Education partnership** | Tech writers partner with learning team |

**Key Insight:** Good docs are written from the customer's perspective, not the team's.

### Microsoft

**Engineering Fundamentals Playbook principles:**

| Practice | Description |
|----------|-------------|
| **Not an afterthought** | Create docs throughout the lifecycle |
| **Key doc types** | READMEs, commits, PRs, inline comments, API specs |
| **Observability docs** | Correlation IDs, health checks, logging |

### Deloitte

**Research Sources:**

- [DORA DevEx Quick Check](https://dora.dev/quickcheck/)
- [Gartner: Internal Developer Portals](https://www.gartner.com/en/documents/4022290) *(requires Gartner subscription)*
- Spotify Engineering Blog: "How Spotify Measures the Value of Backstage" (2023)

| Practice | Description |
|----------|-------------|
| **DevEx as Strategic Investment** | Developer experience directly impacts profitability and customer outcomes |
| **Internal Developer Portals** | Centralized hub for docs, tools, SDKs, onboarding |
| **Self-Service Platforms** | Reduce lead times for deploying new services |
| **Developer-First Mindset** | Improve every touchpoint engineers have with the organization |

**Key Statistic (Gartner, cited by Deloitte):**
> "By 2025, 75% of organizations with platform teams will implement self-service developer portals to enhance developer experience and accelerate innovation."

### Diátaxis Framework (Daniele Procida)

A systematic framework for organizing technical documentation:

```text
                      PRACTICAL                    THEORETICAL
                ┌──────────────────┬──────────────────┐
   LEARNING     │    TUTORIALS     │   EXPLANATION    │
   (Study)      │  "Help me learn" │ "Help me         │
                │                  │  understand"     │
                ├──────────────────┼──────────────────┤
   WORKING      │   HOW-TO GUIDES  │   REFERENCE      │
   (Apply)      │ "Help me do this"│ "Help me find    │
                │                  │  this fact"      │
                └──────────────────┴──────────────────┘
```

| Type | Mode | Purpose | Example |
|------|------|---------|---------|
| **Tutorials** | Learning | Guide through steps to build something | "Getting Started" |
| **How-To Guides** | Problem-solving | Steps to solve a specific problem | Runbooks |
| **Reference** | Information | Factual descriptions | API docs |
| **Explanation** | Understanding | Background, context, "why" | Architecture docs |

### Write the Docs Community (2024)

Global community practices:

| Practice | Description |
|----------|-------------|
| **Docs as Code** | Same tools as software development |
| **CI/CD for docs** | Automated build, test, publish |
| **Plain text formats** | Markdown, reStructuredText |
| **Version control** | Git for documentation |
| **Documentation testing** | Validate links, code samples |

### Red Hat (Modular Documentation)

| Practice | Description |
|----------|-------------|
| **Modules** | Self-contained units addressing one topic |
| **Assemblies** | Modules combined for user stories |
| **Reusability** | Same module, multiple contexts |
| **One concept per file** | Easier maintenance and updates |

### Angular

| Practice | Description |
|----------|-------------|
| **One concept per file** | Single component per file |
| **Split when too populated** | Create sub-directories |
| **Consistent naming** | Reflect content in filename |

### Twilio

**Source:** [Twilio Developer Hub](https://www.twilio.com/docs)

| Practice | Description |
|----------|-------------|
| **Developer Hub** | Central portal with API docs, SDKs, Code Exchange, tutorials |
| **Multi-Language SDKs** | Examples in 8 languages (Python, Java, Node.js, C#, Go, PHP, Ruby, Kotlin) |
| **Exponential Backoff** | Every API doc includes retry with `Retry-After` header guidance |
| **Sandbox Testing** | Every API has sandbox credentials for testing |

**Key Quote:**
> "Documentation should include retry logic with exponential backoff for every API endpoint."

### Shopify

**Source:** [Shopify Polaris](https://polaris.shopify.com), [Shopify Engineering](https://shopify.engineering)

| Practice | Description |
|----------|-------------|
| **Design System Docs** | Polaris integrates component docs with code |
| **Docs as Product** | Documentation treated as a product with UX research |
| **Minimize External Docs** | Clear UI text reduces need for external documentation |

**Key Quote:**
> "The best documentation is a UI that doesn't need documentation."

### GitHub

**Source:** [GitHub Docs Contributing Guide](https://github.com/github/docs)

| Practice | Description |
|----------|-------------|
| **Open Source Docs** | Public repo for all docs, community contributions |
| **Task-Based Content** | Focus on helping users accomplish specific goals |
| **Global Audience First** | Written for translation, avoids idioms |
| **Plain Language** | Active voice, brief sentences, avoid jargon |

**Key Quote:**
> "We advocate for users through documentation—from planning to publishing."

### Cloudflare

**Source:** [Cloudflare Developers](https://developers.cloudflare.com)

| Practice | Description |
|----------|-------------|
| **Docs on GitHub** | Open-source documentation, community PRs accepted |
| **Standards Integration** | Docs reference RFCs and IETF standards |
| **Progressive Disclosure** | Simple getting started → advanced topics |

### Atlassian

**Source:** [Atlassian Engineering Handbook](https://www.atlassian.com/engineering)

| Practice | Description |
|----------|-------------|
| **Confluence Gardeners** | Designated people to maintain documentation quality |
| **DACI Templates** | Driver, Approver, Contributor, Informed for decisions |
| **Space-per-Domain** | Separate Confluence spaces per team/domain |

---

## Core Principles

### 1. Optimize for the Reader

> **"Optimize for the reader."** — Google C++ Style Guide

You write a document once, but it will be read hundreds or thousands of times. Every decision should favor the reader over the writer.

### 2. Documentation Is Like Code

Documentation should have the same rigor as code:

| Code Practice | Documentation Equivalent |
|---------------|-------------------------|
| Version control (Git) | Docs in same repo as code |
| Code review | Doc review before merge |
| Ownership (CODEOWNERS) | Doc owners defined |
| Bug tracking | Doc issues in tracker |
| Testing | Link validation, example testing |
| Metrics | Freshness, accuracy, coverage |

### 3. README-Driven Development

> "Write the README **before** you write any code." — Tom Preston-Werner (GitHub co-founder)

| Principle | Description |
|-----------|-------------|
| **Write README first** | Before any code |
| **Define public interface** | Installation, usage, API |
| **Minimum viable documentation** | Enough to start, evolves with code |
| **Collaboration enabler** | Others can build against interface |

### 4. Single Source of Truth (SSOT)

- **Never duplicate content** — link to the authoritative source
- **One canonical location** — for each piece of information
- **Cross-reference** — instead of copying

### 5. Every Page Is Page One

Each document or section should:

- Be self-contained
- Make sense in isolation
- Minimize dependencies on other sections
- Include necessary context

### 6. ARID Principle (Accept Repetition In Documentation)

> **Balance to SSOT:** Unlike code, documentation can benefit from strategic repetition.

While SSOT prevents drift, the **ARID principle** (from Write the Docs) acknowledges that some repetition enhances usability:

| When to Repeat | Why |
|----------------|-----|
| **Prerequisites** | Every tutorial should list them, even if documented elsewhere |
| **Safety warnings** | Critical warnings in every runbook, not just one |
| **Quick reference** | Summary tables in component docs, linking to canonical source |
| **Context setting** | Brief background in each section for standalone reading |

**Rule:** Repeat context briefly, but always **link to the canonical source** for the full explanation.

---

## Case Studies

### The Google Wiki Failure

**What happened:**

- Early Google used a wiki (GooWiki) for documentation
- No true owners → documents became obsolete
- No process for adding → duplicates appeared
- 7-10 documents on setting up Borg, only a few maintained
- **90% of documents had no views or updates in months**

**The Solution:**

- Moved documentation under source control
- Documents got owners, canonical locations
- Errors reported via bug tracking
- Changes via code review process

**Result:** Documents became dramatically better.

### Stripe's Documentation Culture

**What they did:**

- Made documentation part of the career ladder
- Features considered "done" only when docs complete
- Built open-source tooling (Markdoc)
- Created interactive, personalized docs

**Result:** Industry-leading developer experience, often cited as gold standard.

### The Developer Guide Library at Google

**Problem:** Cross-API documentation didn't fit in any one team's repository.

**Solution:**

- Created standalone documentation sets
- Hired technical writers for cross-boundary docs
- Used `go/` short links for discoverability

**Result:** Unified documentation experience across products.

---

## TL;DRs (Key Takeaways)

1. **Documentation is hugely important** over time and scale
2. **Documentation changes should use the same tools as code** (version control, review)
3. **Different document types matter** — design docs are NOT the same as landing pages
4. **Who/What/When/Where/Why** — use this framework for every document

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [INDEX](./INDEX.md) | Landing page |
| [Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md) | Targeting readers |
| [Document Types](./03-DOCUMENT_TYPES.md) | All document types |

---

**Next:** [02 - Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md)
