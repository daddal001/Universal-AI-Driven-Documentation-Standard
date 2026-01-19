---
title: "Documentation Search Optimization"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-12"
last_updated: "2025-12-12"
version: "1.0.0"
---

# Documentation Search Optimization

> **Goal:** Ensure documentation is discoverable through internal search engines, AI retrieval systems, and developer portals.

---

## 1. Search-Friendly Structure

### Title Optimization

| Element | Best Practice | Example |
|---------|---------------|---------|
| **H1 Title** | Descriptive, unique, action-oriented | "Configuring Redis Cache for Session Storage" |
| **URL/Path** | Lowercase, hyphenated, meaningful | `/docs/guides/redis-session-cache.md` |
| **Frontmatter title** | Match H1 exactly | `title: "Configuring Redis Cache"` |

### Heading Hierarchy

```markdown
# Primary Topic (H1) — One per document
## Major Section (H2) — Scannable by search
### Subsection (H3) — Detailed breakdown
```

> **AI Search Tip:** LLMs and RAG systems parse headings as semantic boundaries. Clear headings improve retrieval accuracy.

---

## 2. Keyword Strategy

### Natural Keyword Placement

| Location | Priority | Example |
|----------|----------|---------|
| Title (H1) | Highest | Include primary action + technology |
| First paragraph | High | Summarize what the doc covers |
| Headings (H2/H3) | High | Use terms users search for |
| Code comments | Medium | Explain what code does |

### Synonym Mapping

Document common synonyms in your glossary:

```markdown
<!-- In GLOSSARY.md -->
| **Canonical Term** | **Synonyms (also search for)** |
|--------------------|-------------------------------|
| Authentication | auth, login, sign-in, SSO |
| Database | DB, data store, persistence |
| Configuration | config, settings, setup |
```

---

## 3. Metadata for Search

### Required Frontmatter

```yaml
---
title: "Descriptive Title for Search Results"
description: "1-2 sentence summary shown in search snippets"
keywords: ["redis", "cache", "session", "configuration"]
tags: ["infrastructure", "backend", "how-to"]
---
```

### Search-Specific Fields

| Field | Purpose | Search Impact |
|-------|---------|---------------|
| `description` | Search result snippet | High |
| `keywords` | Explicit search terms | Medium |
| `tags` | Category filtering | Medium |
| `aliases` | Alternative doc paths | Low |

---

## 4. Internal Linking

### Link Strategy

| Pattern | Benefit |
|---------|---------|
| **Related Docs sections** | Cross-discovery |
| **Inline contextual links** | Deeper exploration |
| **Breadcrumb paths** | Navigation context |
| **"See also" blocks** | Alternative resources |

### Anchor Links

Use descriptive anchor IDs:

```markdown
<!-- Good: Descriptive anchor -->
## Configuring Connection Pools {#connection-pool-config}

<!-- Avoid: Auto-generated anchors -->
## Configuring Connection Pools
<!-- Generates: #configuring-connection-pools -->
```

---

## 5. Search Analytics

### Metrics to Track

| Metric | Target | Action if Below Target |
|--------|--------|------------------------|
| **Search Success Rate** | > 80% | Improve titles, add synonyms |
| **Zero-Result Queries** | < 5% | Add missing content or redirects |
| **Click-Through Rate** | > 40% | Improve descriptions |
| **Time to First Click** | < 10s | Improve result ranking |

### Tracking Implementation

```javascript
// Search analytics event
analytics.track('docs_search', {
  query: searchQuery,
  results_count: results.length,
  clicked_result: clickedUrl,
  position: clickPosition,
  session_id: sessionId
});
```

---

## 6. AI/RAG Optimization

### Chunking-Friendly Structure

| Practice | Why It Helps RAG |
|----------|------------------|
| Self-contained sections | Each chunk makes sense alone |
| Context in every section | Don't rely on earlier content |
| Explicit relationships | "This relates to [X]" statements |
| Avoid pronouns at section start | "The service" not "It" |

### Embedding Optimization

```markdown
<!-- Good: Context-rich paragraph -->
## Redis Cache Configuration

Redis is used as the session cache for the authentication service.
To configure Redis connection pooling, set the following environment
variables in your deployment configuration.

<!-- Avoid: Context-poor paragraph -->
## Configuration

Set these environment variables to configure it.
```

---

## 7. Search Engine Configuration

### Algolia/MeiliSearch Setup

```javascript
// docs-search-config.js
module.exports = {
  indexName: 'docs_production',
  searchableAttributes: [
    'title',           // Highest priority
    'headings',        // H2, H3 text
    'description',     // Frontmatter
    'content'          // Body text
  ],
  attributesForFaceting: [
    'tags',
    'type',
    'owner'
  ],
  customRanking: [
    'desc(pageviews)',
    'desc(freshness)'
  ]
};
```

### Sitemap Generation

```yaml
# mkdocs.yml or docusaurus.config.js
plugins:
  - search:
      lang: en
  - sitemap:
      changefreq: weekly
      priority: 0.8
```

---

## 8. Common Search Problems

| Problem | Cause | Fix |
|---------|-------|-----|
| Doc not found | Missing keywords | Add synonyms, improve title |
| Wrong doc ranks first | Poor relevance signals | Add description, improve H1 |
| Outdated doc in results | Stale content | Update or deprecate |
| Duplicate results | Content duplication | Consolidate, use canonical |

---

## 9. Related Documents

| Document | Purpose |
|----------|---------|
| [AI Agents](./04-AI_AGENTS.md) | RAG optimization details |
| [Feedback](./13-FEEDBACK.md) | Search success metrics |
| [Glossary](./GLOSSARY.md) | Synonym mapping |

---

**Previous:** [33 - ADR](./33-ADR.md)
**Next:** [35 - Documentation Portal](./35-DOCUMENTATION_PORTAL.md)
