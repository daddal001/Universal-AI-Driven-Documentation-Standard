---
title: "Documentation Anti-Patterns"
type: "reference"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-15"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Documentation Anti-Patterns

> **Goal:** Identify common documentation mistakes to avoid, with practical solutions for recovery and prevention.

---

## Table of Contents

1. [How to Use This Guide](#how-to-use-this-guide)
2. [Content Anti-Patterns](#content-anti-patterns)
3. [Process Anti-Patterns](#process-anti-patterns)
4. [Technical Anti-Patterns](#technical-anti-patterns)
5. [Organizational Anti-Patterns](#organizational-anti-patterns)
6. [Recovery Guide](#recovery-guide)

---

## How to Use This Guide

**Purpose:** Learn from common mistakes without blame or judgment.

**Format for each anti-pattern:**

- **Description:** What the anti-pattern looks like
- **Why It's Bad:** The actual harm it causes
- **Example:** Real-world manifestation
- **How to Fix:** Concrete recovery steps
- **Prevention:** How to avoid it in the first place

> **Important:** Most teams exhibit multiple anti-patterns. This is normal. Focus on incremental improvement, not perfection.

---

## Content Anti-Patterns

### 1. Wall of Text

**Description:** Large blocks of unbroken prose with no formatting, headers, or visual breaks.

**Why It's Bad:** Readers can't scan, key information gets buried, cognitive overload.

**Example:**

```markdown
The authentication service handles user login and logout and session management
and token refresh and password reset and multi-factor authentication and OAuth
integration and SAML support and API key management and service accounts...
```

**How to Fix:**

- Add headers every 2-3 paragraphs
- Use bullet points for lists
- Break paragraphs at 3-4 sentences max
- Add code blocks, tables, diagrams

**Prevention:** Use the [Progressive Disclosure](./32-PROGRESSIVE_DISCLOSURE.md) patterns.

---

### 2. Outdated Documentation

**Description:** Documentation that no longer reflects the current state of the system.

**Why It's Bad:** Worse than no documentation—actively misleads and wastes time.

**Example:** API docs showing deprecated endpoints, README with wrong setup instructions.

**How to Fix:**

1. Add `last_updated` to frontmatter
2. Run quarterly freshness audits
3. Link docs to code via CI checks

**Prevention:** Use [Operations](./06-OPERATIONS.md) freshness requirements.

---

### 3. No Examples

**Description:** Explaining concepts without showing working code or real scenarios.

**Why It's Bad:** Readers must guess how to apply information; higher error rate.

**Example:**

```markdown
## Authentication

Use JWT tokens for authentication. Set the appropriate headers.
```

**How to Fix:** Add copy-paste-ready examples:

```markdown
## Authentication

```bash
curl -X POST https://api.example.com/auth \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "secret"}'
```

Response:

```json
{"token": "eyJhbG..."}
```

```

**Prevention:** Every concept needs at least one example.

---

### 4. Jargon Without Definition

**Description:** Using internal terminology, acronyms, or project-specific terms without explanation.

**Why It's Bad:** Excludes new team members and external contributors.

**Example:** "The BFF calls the Core via the hot path, avoiding the cold path queue."

**How to Fix:**
- Link to [Glossary](./GLOSSARY.md) on first use
- Define terms inline: "the BFF (Backend-for-Frontend)..."

**Prevention:** Maintain a project glossary.

---

### 5. Missing Prerequisites

**Description:** Jumping into instructions without stating what's needed first.

**Why It's Bad:** Users fail partway through, waste time debugging setup issues.

**Example:** "Run `make deploy`" (but doesn't mention Docker, AWS CLI, etc.)

**How to Fix:**
```markdown
## Prerequisites

Before you begin, ensure you have:
- [ ] Docker 24+ installed
- [ ] AWS CLI configured with credentials
- [ ] Access to the `staging` environment
```

**Prevention:** Always start with prerequisites section.

---

### 6. Documentation as Afterthought

**Description:** Writing docs only after code is complete and shipped.

**Why It's Bad:** Context is lost, details forgotten, docs never catch up.

**How to Fix:** Adopt README-Driven Development—write the README first.

**Prevention:** Include docs in Definition of Done.

---

### 7. Copy-Paste Without Adaptation

**Description:** Copying documentation templates without customizing for the specific context.

**Why It's Bad:** Generic docs don't help, placeholder text left in.

**Example:** "\[Describe your service here\]" still in production docs.

**How to Fix:** Search for brackets, placeholders, "TODO" markers.

**Prevention:** Review docs before merge, use validation scripts.

---

### 8. Documenting Everything

**Description:** Documenting obvious things, trivial functions, or implementation details.

**Why It's Bad:** Signal-to-noise ratio drops, important docs get buried.

**Example:** Documenting getters/setters, self-explanatory one-liners.

**How to Fix:** Focus on the "why", not the "what". Document decisions, not mechanics.

**Prevention:** Ask: "Would a competent engineer need this explained?"

---

## Process Anti-Patterns

### 9. No Ownership

**Description:** Documentation without a clear owner or maintainer.

**Why It's Bad:** Nobody updates it, nobody reviews it, it rots.

**How to Fix:**

- Add `owner` to frontmatter
- Set up CODEOWNERS for docs
- Assign docs to teams, not individuals

**Prevention:** See [Governance](./07-GOVERNANCE.md) ownership model.

---

### 10. Review-Free Documentation

**Description:** Docs merged without any review process.

**Why It's Bad:** Errors, inconsistencies, unclear content ships.

**How to Fix:**

- Require at least one reviewer for docs
- Add docs linting to CI
- Include docs in PR templates

**Prevention:** See [Reviews](./12-REVIEWS.md) requirements.

---

### 11. No Versioning

**Description:** Docs without version numbers or history.

**Why It's Bad:** Can't tell if docs match current code version.

**How to Fix:**

- Add `version` to frontmatter
- Maintain CHANGELOG
- Consider versioned docs sites

**Prevention:** See [Release Notes](./16-RELEASE_NOTES.md).

---

### 12. Write Once, Never Update

**Description:** Creating documentation but never maintaining it.

**Why It's Bad:** Docs become progressively less accurate over time.

**How to Fix:**

- Schedule quarterly doc reviews
- Add freshness checks to CI
- Set up stale doc alerts

**Prevention:** See [Operations](./06-OPERATIONS.md) lifecycle.

---

### 13. Documentation Debt Ignored

**Description:** Accumulating known documentation issues without addressing them.

**Why It's Bad:** Compounds over time, new engineers inherit confusion.

**How to Fix:**

- Track doc debt like tech debt
- Allocate time each sprint for docs
- Prioritize high-traffic pages

**Prevention:** Include docs in sprint planning.

---

## Technical Anti-Patterns

### 14. Broken Links

**Description:** Links to pages that no longer exist or have moved.

**Why It's Bad:** Dead ends frustrate users, harm trust.

**How to Fix:**

```bash
# Use link checker in CI
npx markdown-link-check docs/**/*.md
```

**Prevention:** Add link checking to pre-commit hooks.

---

### 15. No Search Optimization

**Description:** Documentation that's hard to find via search.

**Why It's Bad:** Users can't find what they need, ask repeated questions.

**How to Fix:**

- Use descriptive titles and headers
- Add frontmatter keywords
- Include common search terms

**Prevention:** See [Search Optimization](./34-SEARCH_OPTIMIZATION.md).

---

### 16. Binary Files as Documentation

**Description:** Using Word docs, PDFs, or other non-diffable formats.

**Why It's Bad:** Can't diff, can't search, can't version control properly.

**How to Fix:** Convert to Markdown, use diagrams-as-code.

**Prevention:** Standardize on Markdown + Mermaid.

---

### 17. Documentation Outside the Repo

**Description:** Keeping docs in Confluence, Notion, or other external tools.

**Why It's Bad:** Falls out of sync with code, different access controls.

**Example:** Wiki with 3-year-old architecture diagrams.

**How to Fix:** Migrate to docs-as-code in the repository.

**Prevention:** See [Philosophy](./01-PHILOSOPHY.md) on docs as code.

---

### 18. Inconsistent Structure

**Description:** Every document has different formatting, sections, tone.

**Why It's Bad:** Readers can't build mental models, harder to scan.

**How to Fix:**

- Create templates for each doc type
- Use linters (Vale, markdownlint)
- Standardize frontmatter

**Prevention:** See [Style Guide](./11-STYLE_GUIDE.md).

---

## Organizational Anti-Patterns

### 19. Tribal Knowledge

**Description:** Critical information exists only in people's heads.

**Why It's Bad:** Bus factor of 1, knowledge lost when people leave.

**Example:** Only Sarah knows how to deploy to production.

**How to Fix:**

- Identify single points of failure
- Schedule knowledge transfer sessions
- Require runbooks for all critical processes

**Prevention:** See [Operations](./06-OPERATIONS.md) runbook standards.

---

### 20. Documentation Not Valued

**Description:** Organization treats documentation as optional or low priority.

**Why It's Bad:** Chronic underinvestment, docs always deprioritized.

**How to Fix:**

- Include docs in OKRs
- Track documentation metrics
- Celebrate doc contributions

**Prevention:** See [Philosophy](./01-PHILOSOPHY.md) business case.

---

### 21. Siloed Documentation

**Description:** Each team maintains docs differently, no consistency.

**Why It's Bad:** Users must learn different navigation for each service.

**How to Fix:**

- Establish org-wide standards
- Create shared templates
- Centralize in documentation portal

**Prevention:** See [Documentation Portal](./35-DOCUMENTATION_PORTAL.md).

---

### 22. No Feedback Loop

**Description:** No way for users to report issues or suggest improvements.

**Why It's Bad:** Problems persist because maintainers don't know about them.

**How to Fix:**

- Add "Edit this page" links
- Include feedback widgets
- Track search failures

**Prevention:** See [Feedback](./13-FEEDBACK.md) mechanisms.

---

## Recovery Guide

If your documentation has accumulated multiple anti-patterns:

### Step 1: Assess Current State (Week 1)

1. Run automated checks (link validation, linting)
2. Count stale documents (> 6 months old)
3. Survey team: "What docs are missing or wrong?"

### Step 2: Triage (Week 2)

| Priority | Criteria | Action |
|----------|----------|--------|
| **P0** | Actively causing incidents | Fix immediately |
| **P1** | Blocking new team members | Fix this sprint |
| **P2** | Annoying but workarounds exist | Schedule for next month |
| **P3** | Nice to have | Add to backlog |

### Step 3: Quick Wins (Weeks 3-4)

- Fix broken links (automated)
- Add missing frontmatter (scripted)
- Delete obviously outdated docs
- Add ownership to orphaned docs

### Step 4: Systematic Improvement (Ongoing)

- Allocate 10% of sprint to docs
- Require docs for new features
- Add docs to PR review checklist
- Celebrate improvements publicly

### Step 5: Prevent Regression

- Add CI checks for all anti-patterns
- Schedule quarterly audits
- Track metrics in dashboard
- Include docs in retrospectives

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [00 - Adoption Playbook](./00-ADOPTION_PLAYBOOK.md) | How to adopt standards systematically |
| [05 - Quality](./05-QUALITY.md) | Quality criteria to aim for |
| [37 - Migration Guide](./37-MIGRATION_GUIDE.md) | Migrate from other standards |
| [40 - Metrics](./40-METRICS.md) | Measure documentation health |

---

**Previous:** [19 - Database Documentation](./19-DATABASE_DOCUMENTATION.md)
**Next:** [21 - Service Catalog](./21-SERVICE_CATALOG.md)
