---
title: "Feedback & Analytics Standard"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-12"
version: "1.0.0"
---



> **Goal:** Move beyond "freshness" to measure the actual *efficacy* of documentation. Treat documentation as a product with measurable outcomes.

---

## 1. Core Metrics (Docs as Product)

We track three key metrics to determine if documentation is solving user problems:

### A. Search Success Rate (SSR)

**Definition:** The percentage of search sessions where a user clicks a result.

- **Target:** > 80%
- **Anti-Metric:** "Zero Result Searches" (Terms users search for that yield no pages).
- **Action:** Review top 10 "Zero Result" terms weekly and create aliases or new docs.

### B. Finding Rate (Drift)

**Definition:** How quickly does a user find the *correct* page?

- **Metric:** Time to first meaningful interaction.
- **Action:** If > 60 seconds, investigate information architecture (IA) and navigation path.

### C. Helpfulness Ratio

**Definition:** Binary "Did this page help you?" (Yes/No) at the bottom of every page.

- **Target:** > 85% Positive
- **Action:** Any page with < 70% helpfulness triggers a mandatory **Audience Review**.

### D. Time-to-Hello-World (TTHW)

**Definition:** Time from first documentation visit to first working code execution.

- **Target:** < 10 minutes for Quick Start guides
- **Measurement:** Track from docs page load to first successful API call
- **Action:** If > 15 minutes, simplify prerequisites and examples

### E. Code Example Copy Rate

**Definition:** Percentage of code blocks that users copy (via click or Ctrl+C).

- **Target:** > 40% for tutorial code
- **Insight:** Low copy rate indicates examples may be unclear or irrelevant

### F. Content Completion Rate

**Definition:** Percentage of users who complete multi-step tutorials.

- **Target:** > 60% completion
- **Action:** High drop-off at specific step indicates that step needs improvement

### G. Support Deflection Rate

**Definition:** Percentage of issues resolved via documentation without support ticket.

- **Target:** > 70%
- **Measurement:** Compare doc views → support tickets by topic

### H. Documentation Net Promoter Score (NPS)

**Definition:** "How likely are you to recommend this documentation to a colleague?" (0-10 scale)

- **Target:** > +30
- **Promoters (9-10):** Enthusiastic documentation advocates
- **Detractors (0-6):** Users with poor documentation experience
- **Calculation:** % Promoters - % Detractors
- **Survey Frequency:** Quarterly or after major updates

### I. Task Completion Rate (TCR)

**Definition:** Percentage of users who successfully complete a documented task.

- **Target:** > 85%
- **Measurement:** Track task start → task success events
- **Action:** High drop-off indicates content gaps or usability issues

### J. First Contact Resolution (Documentation)

**Definition:** Percentage of user queries resolved via documentation without escalation.

- **Target:** > 70%
- **Measurement:** User starts in docs → completes task OR leaves without support ticket

### K. Documentation CSAT (Customer Satisfaction Score)

**Definition:** "How satisfied are you with this documentation?" (1-5 scale)

- **Target:** > 80% satisfied (rating 4-5)
- **In-context Survey:** Show on docs pages with low helpfulness ratio
- **Action:** < 60% CSAT triggers immediate content review

---

## 2. Error Documentation Standard

### The RefLink Pattern

**Rule:** Every user-facing error message **must** include a documentation reference.

**Bad:**
> `Error 503: Service Unavailable`

**Good:**
> `Error 503: Service Unavailable. (Ref: [OPS-503](https://docs.internal/errors/503))`

### Error Code Registry

Maintain `docs/errors/INDEX.md`:

| Code | HTTP | Category | Resolution Doc |
|------|------|----------|----------------|
| `AUTH-001` | 401 | Authentication | [AUTH-001.md](./errors/AUTH-001.md) |
| `RATE-001` | 429 | Rate Limiting | [RATE-001.md](./errors/RATE-001.md) |
| `OPS-503` | 503 | Operations | Link to runbook |

### Implementation Requirements

1. **API responses** must include `docRef` field in error objects
2. **CLI tools** must output error reference on failure
3. **UI** must render error reference as clickable link

---

## 3. Feedback Instruments

### The Standard Widget

Every documentation site must include a feedback widget at the footer of **every** page.

**Required Elements:**

1. **Binary Vote:** "Was this page helpful? [Yes] [No]"
2. **Edit Link:** "Edit this page on GitHub" (Low friction fix)
3. **Issue Link:** "Report a problem with this page"

**Example Component (React/Next.js):**

```tsx
export const DocsFeedback = ({ pageId }) => {
  return (
    <footer className="docs-feedback">
      <div className="vote">
        <p>Was this page helpful?</p>
        <button onClick={() => track(pageId, 'vote_up')}>👍 Yes</button>
        <button onClick={() => track(pageId, 'vote_down')}>👎 No</button>
      </div>
      <div className="actions">
        <a href={`github.com/org/repo/edit/main/docs/${pageId}`}>Edit this page</a>
        <a href={`github.com/org/repo/issues/new?template=doc_issue&page=${pageId}`}>Report Issue</a>
      </div>
    </footer>
  );
};
```

---

### Just-in-Time Documentation

Documentation should appear where the user experiences friction, not just in the portal.

### Error Messages

**Rule:** Every user-facing error message must include a `RefLink` to a specific runbook or explanation.

**Bad:**
> "Error 503: Service Unavailable"

**Good:**
> "Error 503: Service Unavailable. (Ref: [OPS-001](https://docs.internal/ops/001-503-errors))"

### CLI Output

**Rule:** Long-running CLI commands must output a link to logs or troubleshooting guides on failure.

---

## 4. Reviewing Analytics (The Loop)

**The "Bottom 10" Ritual:**

1. **Frequency:** Monthly
2. **Process:** Identify the 10 least helpful pages (by vote or high bounce rate on long docs).
3. **Choice:**
    - **Refactor:** Rewrite for clarity.
    - **Deprecate:** If traffic is low, delete or merge.
    - **redirect:** If users bounce to another specific page, set up a redirect.

---

## 5. Analytics Dashboard Implementation

### Required Events

Track these events for documentation analytics:

| Event | Properties | Tool |
|-------|------------|------|
| `page_view` | `page_id`, `referrer`, `time_on_page` | GA4 / Plausible |
| `search_query` | `query`, `results_count`, `clicked_result` | Algolia / Typesense |
| `feedback_vote` | `page_id`, `vote` (up/down), `comment` | Custom |
| `code_copy` | `page_id`, `code_block_id`, `language` | Custom |
| `external_link_click` | `page_id`, `destination_url` | Custom |

### Dashboard Panels

```yaml
panels:
  - title: Search Success Rate
    query: (search_events WITH clicked_result) / total_search_events
    threshold: 80%

  - title: Bottom 10 Pages (Helpfulness)
    query: GROUP BY page_id ORDER BY helpfulness_ratio ASC LIMIT 10

  - title: Time-to-Hello-World
    query: PERCENTILE(95, first_api_call_time - docs_page_load_time)
    threshold: 600000  # 10 minutes in ms

  - title: Zero-Result Searches
    query: search_events WHERE results_count = 0 GROUP BY query
```

### Monthly Report Template

```markdown
# Documentation Health Report - [Month Year]

## Key Metrics
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Search Success Rate | X% | 80% | ✅/❌ |
| Helpfulness Ratio | X% | 85% | ✅/❌ |
| Time-to-Hello-World | Xm | <10m | ✅/❌ |

## Bottom 10 Pages
1. [Page] - X% helpfulness - Action: [Refactor/Deprecate]

## Top Zero-Result Searches
1. "[query]" - X searches - Action: [Create alias/doc]
```

---

## 6. Analytics Tooling Setup

### Recommended Stack

| Layer | Tool | Purpose | Cost |
|-------|------|---------|------|
| **Page Analytics** | [Plausible](https://plausible.io) | Privacy-first page views, referrers | ~$9/mo |
| **Page Analytics** | [GA4](https://analytics.google.com) | Full-featured, free | Free |
| **Search Analytics** | [Algolia](https://algolia.com) | Search queries, click-through | Free tier |
| **Search Analytics** | [Typesense](https://typesense.org) | Self-hosted alternative | Free (OSS) |
| **Dashboard** | [Grafana](https://grafana.com) | Unified metrics visualization | Free (OSS) |
| **Feedback** | Custom + Supabase | Binary votes, comments | Free tier |

### GA4 Configuration for Docs

```javascript
// docs-analytics.js
gtag('config', 'G-XXXXXXXXXX', {
  // Custom dimensions for docs
  custom_map: {
    dimension1: 'doc_type',
    dimension2: 'doc_version',
    dimension3: 'doc_owner'
  }
});

// Track code copy events
document.querySelectorAll('pre code').forEach((block, index) => {
  block.addEventListener('copy', () => {
    gtag('event', 'code_copy', {
      page_id: window.location.pathname,
      code_block_id: index,
      language: block.className.replace('language-', '')
    });
  });
});

// Track feedback votes
function trackVote(pageId, vote) {
  gtag('event', 'feedback_vote', {
    page_id: pageId,
    vote: vote  // 'up' or 'down'
  });
}
```

### Plausible Configuration

```html
<!-- Privacy-first alternative to GA4 -->
<script defer
  data-domain="docs.yourcompany.com"
  data-api="/api/event"
  src="/js/script.js">
</script>

<!-- Custom events -->
<script>
  // Track outbound links
  plausible('Outbound Link', { props: { url: href }});

  // Track search
  plausible('Search', { props: { query: searchTerm, results: count }});
</script>
```

### Grafana Dashboard Template

```json
{
  "dashboard": {
    "title": "Documentation Health",
    "panels": [
      {
        "title": "Search Success Rate",
        "type": "gauge",
        "targets": [{"expr": "docs_search_success_rate"}],
        "thresholds": {"steps": [{"value": 0.8, "color": "green"}]}
      },
      {
        "title": "Helpfulness Ratio",
        "type": "stat",
        "targets": [{"expr": "sum(docs_votes_up) / sum(docs_votes_total)"}]
      },
      {
        "title": "Bottom 10 Pages",
        "type": "table",
        "targets": [{"expr": "bottomk(10, docs_page_helpfulness)"}]
      },
      {
        "title": "Zero-Result Searches",
        "type": "logs",
        "targets": [{"expr": "{job=\"docs-search\"} |= \"results=0\""}]
      }
    ]
  }
}
```

### Implementation Checklist

```markdown
## Analytics Implementation Checklist

- [ ] **Page Tracking**
  - [ ] Install GA4 or Plausible
  - [ ] Configure custom dimensions (doc_type, doc_owner)
  - [ ] Test page view tracking

- [ ] **Search Tracking**
  - [ ] Track search queries
  - [ ] Track zero-result searches
  - [ ] Track clicked results

- [ ] **Engagement Tracking**
  - [ ] Code copy events
  - [ ] External link clicks
  - [ ] Time on page

- [ ] **Feedback System**
  - [ ] Binary vote widget on all pages
  - [ ] Optional comment field
  - [ ] Store in database (Supabase/PostgreSQL)

- [ ] **Dashboard**
  - [ ] Grafana or Looker Studio
  - [ ] Weekly automated report
  - [ ] Alerts for metrics below threshold
```

---

## 7. Related Documents

| Document | Purpose |
|----------|---------|
| [Quality](./05-QUALITY.md) | Quality gates and static checks |
| [Governance](./07-GOVERNANCE.md) | Who is responsible for fixing low-score docs |

---

**Previous:** [12 - Reviews](./12-REVIEWS.md)
**Next:** [14 - Visuals](./14-VISUALS.md)
