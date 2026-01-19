---
title: "Documentation Maturity Model"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-09"
version: "1.0.0"
---

# Documentation Maturity Model

> **Goal:** Provide a self-assessment framework to measure and improve your organization's documentation maturity level.

---

## 1. The Five Maturity Levels

```
Level 5: OPTIMIZED     ████████████████████  Strategic asset, AI-augmented, continuous improvement
Level 4: MANAGED       ████████████████░░░░  Metrics-driven, integrated with product
Level 3: DEFINED       ████████████░░░░░░░░  Standardized processes, consistent quality
Level 2: DEVELOPING    ████████░░░░░░░░░░░░  Centralized, some automation
Level 1: INITIAL       ████░░░░░░░░░░░░░░░░  Ad hoc, tribal knowledge
```

---

## 2. Level Definitions

### Level 1: Initial (Ad Hoc)

| Characteristic | Description |
|----------------|-------------|
| **Process** | No formal documentation process |
| **Storage** | Scattered across wikis, emails, Slack |
| **Ownership** | Unclear or non-existent |
| **Updates** | Reactive, when someone complains |
| **Quality** | Inconsistent, often outdated |

**Symptoms:**

- "Where is the doc for X?" is a common question
- Same questions asked repeatedly
- New hires struggle for weeks
- Tribal knowledge dominates

---

### Level 2: Developing (Emerging)

| Characteristic | Description |
|----------------|-------------|
| **Process** | Basic README requirements |
| **Storage** | Centralized in Git repos |
| **Ownership** | Some CODEOWNERS entries |
| **Updates** | Manual, periodic reviews |
| **Quality** | Basic checks (link validation) |

**Symptoms:**

- READMEs exist but vary in quality
- Some documentation is current, most is stale
- Style varies between teams
- Search works but results are inconsistent

---

### Level 3: Defined (Standardized)

| Characteristic | Description |
|----------------|-------------|
| **Process** | Formal standards like this one |
| **Storage** | Structured hierarchy, templates |
| **Ownership** | 100% CODEOWNERS coverage |
| **Updates** | Quarterly review cadence |
| **Quality** | Automated linting, freshness checks |

**Symptoms:**

- New engineers onboard in < 1 week
- Style is consistent across teams
- Stale docs trigger CI warnings
- Templates exist for all document types

---

### Level 4: Managed (Metrics-Driven)

| Characteristic | Description |
|----------------|-------------|
| **Process** | Docs integrated into Definition of Done |
| **Storage** | Searchable portal with navigation |
| **Ownership** | Teams own docs like code |
| **Updates** | Metrics-triggered reviews |
| **Quality** | Coverage, freshness, helpfulness metrics |

**Symptoms:**

- Documentation dashboards exist
- Low helpfulness triggers reviews
- Docs are part of feature PRs
- Search Success Rate > 80%

---

### Level 5: Optimized (Strategic)

| Characteristic | Description |
|----------------|-------------|
| **Process** | Documentation is a competitive advantage |
| **Storage** | Multi-format output (web, PDF, IDE) |
| **Ownership** | Dedicated technical writers |
| **Updates** | User feedback drives priorities |
| **Quality** | SLAs for documentation response |

**Symptoms:**

- External praise for documentation
- Docs reduce support costs measurably
- AI agents can reliably use docs
- Time-to-Hello-World < 10 minutes

---

## 3. Self-Assessment Rubric

Rate your organization on each dimension (1-5):

| Dimension | Score (1-5) | Evidence |
|-----------|-------------|----------|
| **Coverage** | __ | % of services with complete READMEs |
| **Freshness** | __ | Average days since last update |
| **Consistency** | __ | % passing style checks |
| **Discoverability** | __ | Search Success Rate |
| **Usability** | __ | Time-to-Hello-World |
| **Ownership** | __ | % with CODEOWNERS |
| **Automation** | __ | CI checks in place |
| **Metrics** | __ | Dashboards tracking docs |

**Scoring:**

- **1-2:** Level 1 (Initial)
- **2-3:** Level 2 (Developing)
- **3-4:** Level 3 (Defined)
- **4-4.5:** Level 4 (Managed)
- **4.5-5:** Level 5 (Optimized)

### Continuous Representation (CMMI V3.0)

Alternatively, assess capability per domain rather than a single global level:

| Domain | Capability Level |
|--------|------------------|
| **Content Quality** | Level 3 |
| **Automation** | Level 2 |
| **Governance** | Level 4 |
| **AI Readiness** | Level 1 |

---

## 4. Progression Roadmap

### Level 1 → Level 2

| Action | Priority |
|--------|----------|
| Require README.md in every folder | P0 |
| Move docs to Git repositories | P0 |
| Add basic link checking to CI | P1 |
| Create CODEOWNERS file | P1 |

### Level 2 → Level 3

| Action | Priority |
|--------|----------|
| Adopt this documentation standard | P0 |
| Implement frontmatter validation | P0 |
| Create templates for all doc types | P1 |
| Add Vale linting for style | P1 |
| Establish quarterly review cadence | P1 |

### Level 3 → Level 4

| Action | Priority |
|--------|----------|
| Add docs to Definition of Done | P0 |
| Build documentation dashboard | P0 |
| Track Search Success Rate | P1 |
| Track Helpfulness Ratio | P1 |
| Implement feedback widgets | P1 |

### Level 4 → Level 5

| Action | Priority |
|--------|----------|
| Hire dedicated technical writers | P0 |
| Define documentation SLAs | P0 |
| Optimize for AI agent consumption | P1 |
| Multi-format output pipeline | P1 |
| Measure support cost reduction | P2 |

---

## 5. Quarterly Assessment Template

```markdown
# Documentation Maturity Assessment - Q[X] [YEAR]

## Current Level: [X]
## Target Level: [X]

### Dimension Scores
| Dimension | Q-1 | Q | Δ |
|-----------|-----|---|---|
| Coverage | | | |
| Freshness | | | |
| Consistency | | | |
| Discoverability | | | |
| Usability | | | |

### Actions This Quarter
- [ ] Action 1
- [ ] Action 2

### Blockers
- Blocker 1

### Next Quarter Goals
- Goal 1
```

---

## 6. Related Documents

| Document | Purpose |
|----------|---------|
| [Quality](./05-QUALITY.md) | Quality gates aligned to Level 3+ |
| [Governance](./07-GOVERNANCE.md) | Ownership model for Level 2+ |
| [Feedback](./13-FEEDBACK.md) | Metrics for Level 4+ |

---

**Previous:** [16 - Release Notes](./16-RELEASE_NOTES.md)
**Next:** [18 - API Documentation](./18-API_DOCUMENTATION.md)
