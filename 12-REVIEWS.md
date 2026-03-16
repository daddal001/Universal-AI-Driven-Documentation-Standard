---
title: "Documentation Reviews"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2026-03-07"
version: "1.1.0"
---

# Documentation Reviews

> **Goal:** Ensure every document undergoes rigorous checks for accuracy, clarity, and consistency, formalized through **three distinct review types**.

---

## 1. The Three Review Types

Docs are code. Just as code needs unit tests and peer reviews, docs need:

### Type A: Technical Review (Accuracy)

* **Reviewer:** Subject Matter Expert (SME), Senior Engineer, or Code Owner.
* **Focus:**
  * Is the code sample correct and runnable?
  * Are the technical facts accurate?
  * Are edge cases covered?
  * Is the architecture accurately represented?
* **Label:** `doc-review-technical`

### Type B: Audience Review (Clarity)

* **Reviewer:** A new team member, a user of the API, or a "fresh pair of eyes" unfamiliar with the feature.
* **Focus:**
  * Does the "Getting Started" flow actually work for a beginner?
  * Are prerequisites clearly stated?
  * Is the "Why" (context) clear before the "How"?
  * Are there confusing jargon terms?
* **Label:** `doc-review-audience`

### Type C: Writing Review (Consistency)

* **Reviewer:** Technical Writer or "Style Guardian" (or automated via `vale`).
* **Focus:**
  * Grammar, spelling, and punctuation.
  * Adherence to [Style Guide](./11-STYLE_GUIDE.md).
  * Formatting and structure stability.
  * Voice and Tone.
* **Label:** `doc-review-writing`

## 2. Review Checklist

Use this checklist in PR descriptions for documentation changes:

### Technical Accuracy

* [ ] Code samples compile/run without errors
* [ ] API endpoints, parameters, and responses match current implementation
* [ ] Version numbers and dependency versions are correct
* [ ] Links to external resources are valid and point to stable URLs
* [ ] Architecture diagrams reflect current system state

### Audience Clarity

* [ ] Prerequisites are explicitly listed
* [ ] Steps are numbered and follow logical order
* [ ] Acronyms are defined on first use
* [ ] Expected output is shown for commands and code samples
* [ ] "Why" context is provided before "How" instructions

### Writing Consistency

* [ ] Active voice, present tense, second person ("you")
* [ ] Heading hierarchy is correct (no skipped levels)
* [ ] Frontmatter fields are complete and `last_updated` is current
* [ ] Formatting matches [Style Guide](./11-STYLE_GUIDE.md)
* [ ] Vale and markdownlint pass

## 3. Review Workflow

```text
Author opens PR
    │
    ├── CI runs automatically:
    │   ├── markdownlint (formatting)
    │   ├── Vale (prose style)
    │   ├── Frontmatter validation
    │   ├── Link checking
    │   └── Doc-enforcement (code changes need docs)
    │
    ├── Request reviewers:
    │   ├── Technical: @code-owner or SME
    │   ├── Audience: @new-team-member (optional)
    │   └── Writing: @tech-writer or CI (Vale)
    │
    ├── Address feedback
    │
    └── Merge (requires 1 Code Owner + passing CI)
```

## 4. Automated vs Human Review

Not everything needs a human reviewer. Use automation where possible, humans where judgment matters.

| Check | Automated | Human |
|-------|-----------|-------|
| Spelling and grammar | Vale | Edge cases, domain terms |
| Heading structure | markdownlint | Logical flow |
| Link validity | markdown-link-check | Link relevance |
| Code syntax | Language linters | Code correctness and completeness |
| Frontmatter fields | validate-frontmatter.sh | N/A |
| Technical accuracy | N/A | SME required |
| Audience clarity | N/A | Fresh-eyes reviewer |
| Tone appropriateness | Vale (partial) | Editorial judgment |

## 5. SLAs (Service Level Agreements)

Set expectations for review turnaround to prevent documentation PRs from going stale.

| Review Type | Target SLA | Escalation |
|-------------|------------|------------|
| Writing (automated) | Immediate (CI) | N/A |
| Writing (human) | 2 business days | Ping in team channel |
| Technical | 3 business days | Escalate to engineering lead |
| Audience | 5 business days | Merge without if CI passes |

### Stale PR Policy

* PRs with no review activity for **7 days** get a bot reminder.
* PRs stale for **14 days** are flagged to the documentation maintainer.
* PRs stale for **30 days** are closed with a comment explaining why.

## 6. Escalation Path

When reviewers disagree or a decision affects multiple teams:

1. **Style disagreements:** Defer to the [Style Guide](./11-STYLE_GUIDE.md). If the style guide is silent, the tech writer decides.
2. **Technical disagreements:** The Code Owner for the affected component has final say.
3. **Scope disagreements:** ("This PR is too big / too small") — the documentation maintainer arbitrates.
4. **Cross-team impact:** If a doc change affects multiple teams, require approval from each team's Code Owner.

## 7. Review Labels and CODEOWNERS

### GitHub Labels

```yaml
# .github/labels.yml (or create manually)
- name: doc-review-technical
  color: "d93f0b"
  description: "Needs technical accuracy review"
- name: doc-review-audience
  color: "0e8a16"
  description: "Needs audience/clarity review"
- name: doc-review-writing
  color: "1d76db"
  description: "Needs writing/style review"
```

### CODEOWNERS for Documentation

```text
# CODEOWNERS
docs/               @documentation-team
docs/api/           @api-team @documentation-team
docs/architecture/  @architecture-team @documentation-team
*.md                @documentation-team
```

## 8. Review Anti-patterns

| Anti-pattern | Why It's Harmful | Fix |
|--------------|------------------|-----|
| "LGTM" with no comments | Rubber-stamp review adds no value | Use the checklist; comment on at least one item |
| Blocking on style preferences | Stalls progress on subjective points | Defer to Style Guide; if silent, approve and file a Style Guide PR |
| Reviewing only the diff | Misses broken context around changes | Read the full section, not just changed lines |
| Requesting re-review on typo fixes | Wastes reviewer time on trivial changes | Author can merge typo-only fixes after CI passes |
| Combining code + doc PRs | Doc review gets skipped in large code PRs | Separate PRs for code and docs (or use doc-enforcement to ensure docs are included) |

---

## 9. Related Documents

| Document | Purpose |
|----------|---------|
| [Style Guide](./11-STYLE_GUIDE.md) | What to check in writing reviews |
| [Quality](./05-QUALITY.md) | Quality gates |
| [Governance](./07-GOVERNANCE.md) | Approval matrix |

---

**Previous:** [11 - Style Guide](./11-STYLE_GUIDE.md)
**Next:** [13 - Feedback](./13-FEEDBACK.md)
