---
title: "Progressive Disclosure & Cognitive Load"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-12"
last_updated: "2025-12-12"
version: "1.0.0"
---

# Progressive Disclosure & Cognitive Load

> **Goal:** Apply cognitive science principles to documentation design, revealing information progressively to reduce reader overwhelm and improve comprehension.

---

## 1. The Principle

**Progressive Disclosure:** Show only essential information upfront; defer advanced or less-frequently-needed details until explicitly requested.

```
┌─────────────────────────────────────────────────────┐
│  LAYER 1: Essential (Always Visible)                │
│  ─────────────────────────────────────────────────  │
│  What 80% of users need immediately                 │
├─────────────────────────────────────────────────────┤
│  ▶ LAYER 2: Intermediate (Expandable)               │
│    Additional context for curious users             │
├─────────────────────────────────────────────────────┤
│  ▶ LAYER 3: Advanced (Deep Dive Links)              │
│    Edge cases, internals, troubleshooting           │
└─────────────────────────────────────────────────────┘
```

**Cognitive Load Theory:** Users have limited working memory. Overloading with information reduces comprehension and retention.

---

## 2. Layered Information Architecture

### Layer Structure

| Layer | Content | Format | Example |
|-------|---------|--------|---------|
| **Essential** | Critical info to complete task | Always visible | Quick start, basic usage |
| **Intermediate** | Additional context | Expandable sections | Configuration options |
| **Advanced** | Deep technical details | Linked documents | Architecture, internals |

### Example: API Endpoint Documentation

```markdown
## Create User

Creates a new user account.

POST /api/v1/users

### Quick Start

\`\`\`bash
curl -X POST https://api.example.com/v1/users \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"email": "user@example.com", "name": "Jane"}'
\`\`\`

<details>
<summary>📋 Full Request/Response Schema</summary>

#### Request Body (Full)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | Yes | User email |
| name | string | Yes | Display name |
| role | string | No | Default: "user" |
| metadata | object | No | Custom fields |

</details>

<details>
<summary>⚙️ Advanced: Rate Limiting & Idempotency</summary>

- Rate limit: 100 requests/minute
- Use `Idempotency-Key` header for safe retries
- See Rate Limiting Guide for details

</details>
```

---

## 3. Implementation Patterns

### 3.1 Expandable Sections

Use HTML `<details>` for collapsible content:

```markdown
<details>
<summary>Click to expand</summary>

Hidden content appears here when expanded.

</details>
```

### 3.2 Tabs (for alternatives, not sequences)

Use tabs when showing equivalent alternatives:

- Language-specific code examples (Python/JS/Go)
- Platform-specific instructions (macOS/Linux/Windows)
- Role-specific configurations (Dev/Staging/Prod)

### 3.3 "Learn More" Links

Link to advanced topics rather than embedding them:

```markdown
For basic usage, see the Quick Start above.

**Going Deeper:**
- Authentication Deep Dive
- Error Handling Patterns
- Performance Tuning
```

### 3.4 Tiered Documentation Sets

| Tier | Audience | Content |
|------|----------|---------|
| **Getting Started** | New users | 5-minute quick start |
| **User Guide** | Regular users | Common tasks, workflows |
| **Reference** | Power users | Complete API, all options |
| **Internals** | Contributors | Architecture, design decisions |

---

## 4. Cognitive Load Reduction Techniques

### 4.1 Chunking

Break information into digestible chunks (3-5 items per group):

```markdown
<!-- ❌ BAD: Wall of options -->
Supports: JSON, YAML, TOML, XML, CSV, Protobuf, MessagePack, BSON, Avro

<!-- ✅ GOOD: Chunked by category -->
**Structured:**
- JSON, YAML, TOML

**Binary:**
- Protobuf, MessagePack, Avro

**Legacy:**
- XML, CSV, BSON
```

### 4.2 Visual Hierarchy

Use headings, whitespace, and formatting to guide scanning:

| Element | Purpose |
|---------|---------|
| **H2** | Major sections |
| **H3** | Sub-topics within sections |
| **Bold** | Key terms in flowing text |
| **Bullets** | Multiple discrete items |
| **Tables** | Structured comparisons |
| **Code blocks** | Executable examples |

### 4.3 Consistent Patterns

Readers build mental models. Keep patterns consistent:

| Pattern | Apply Consistently |
|---------|---------------------|
| Prerequisites | Always at the start |
| Examples | Always after explanation |
| Warnings | Always use `> ⚠️` format |
| Next steps | Always at the end |

---

## 5. Anti-Patterns to Avoid

### 5.1 Information Dumps

**❌ Problem:** Everything on one page

**✅ Fix:** Split into quick start + reference + concepts

### 5.2 Hidden Critical Info

**❌ Problem:** Essential info buried in expandable section

**✅ Fix:** Essential = always visible; only optional = expandable

### 5.3 Over-Expansion

**❌ Problem:** Every paragraph in a `<details>` tag

**✅ Fix:** Use sparingly; 2-4 expandable sections per page maximum

### 5.4 Forced Linear Reading

**❌ Problem:** "You must read sections 1-5 before this makes sense"

**✅ Fix:** Every page is page one (see [Philosophy](./01-PHILOSOPHY.md))

---

## 6. Measurement

| Metric | Target | Indicates |
|--------|--------|-----------|
| **Time on page** | < 3 min for quick tasks | Appropriate density |
| **Scroll depth** | > 60% | Content is engaging |
| **Section expansion rate** | 20-40% | Right amount hidden |
| **Task completion rate** | > 85% | Information is findable |
| **Page bounces** | < 40% | Content meets expectations |

---

## 7. Checklist

Before publishing, verify:

- [ ] Essential info visible without expanding/clicking
- [ ] Advanced details in expandable sections or linked pages
- [ ] Maximum 3-5 items per bullet list
- [ ] Clear visual hierarchy (H2 → H3 → content)
- [ ] Consistent patterns throughout document
- [ ] No walls of text (max 3 paragraphs without a break)

---

## 8. Related Documents

| Document | Purpose |
|----------|---------|
| [Philosophy](./01-PHILOSOPHY.md) | "Every Page Is Page One" principle |
| [Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md) | Targeting different experience levels |
| [Anti-Patterns](./20-ANTI_PATTERNS.md) | Mega-document, wall of text |
| [Feedback](./13-FEEDBACK.md) | Measuring documentation effectiveness |

---

**Previous:** [31 - Dependencies](./31-DEPENDENCIES.md)
**Next:** [33 - ADR](./33-ADR.md)
