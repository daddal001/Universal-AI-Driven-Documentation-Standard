---
title: "Universal Documentation Standard"
type: "landing"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-01-12"
version: "1.1.0"
status: "approved"
---

# Universal Documentation Standard

> **Documentation that makes AI coding assistants understand your codebase.**

This modular standard helps you write docs that work for humans AND AI assistants like Claude, Copilot, and Cursor.

---

## Which Docs Do You Need?

**Answer these questions to find your path:**

```
┌─────────────────────────────────────────────────────────────┐
│                    START HERE                                │
│                                                              │
│  Are you working solo on a side project?                    │
│     YES → Use --solo mode (just README.md)                  │
│           See: QUICK_START_SOLO.md                          │
│     NO  ↓                                                   │
│                                                              │
│  Is this an open source project?                            │
│     YES → Use --oss mode (README + CONTRIBUTING + CHANGELOG)│
│           See: QUICK_START_OSS.md                           │
│     NO  ↓                                                   │
│                                                              │
│  Do you have compliance requirements (SOC2, GDPR, etc.)?    │
│     YES → Use Enterprise mode                               │
│           See: QUICK_START_ENTERPRISE.md                    │
│     NO  ↓                                                   │
│                                                              │
│  You're a team/startup                                       │
│     → Use Standard mode                                     │
│        See: QUICK_START_TEAM.md                             │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start by Audience

| You Are | Time | Command | Guide |
|---------|------|---------|-------|
| Solo developer | 30 sec | `bash init.sh --solo` | [QUICK_START_SOLO.md](./QUICK_START_SOLO.md) |
| OSS maintainer | 2 min | `bash init.sh --oss` | [QUICK_START_OSS.md](./QUICK_START_OSS.md) |
| Startup/Team | 5-15 min | `bash init.sh` | [QUICK_START_TEAM.md](./QUICK_START_TEAM.md) |
| Enterprise | 1-2 hours | `bash init.sh` (Enterprise) | [QUICK_START_ENTERPRISE.md](./QUICK_START_ENTERPRISE.md) |

---

## Standards Reference

### Core Standards (Start Here)

| # | Standard | Purpose | Read If... |
|---|----------|---------|------------|
| 01 | [Philosophy](./01-PHILOSOPHY.md) | Why documentation matters | You want to understand the "why" |
| 02 | [Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md) | Writing for readers | You're writing for multiple audiences |
| 03 | [Document Types](./03-DOCUMENT_TYPES.md) | When to use what format | You're not sure what type of doc to write |
| 04 | [AI Agents](./04-AI_AGENTS.md) | llms.txt, AGENTS.md, RAG | You want AI assistants to understand your code |
| 05 | [Quality](./05-QUALITY.md) | 6 quality criteria | You want to measure doc quality |

### Operational Standards

| # | Standard | Purpose | Read If... |
|---|----------|---------|------------|
| 06 | [Operations](./06-OPERATIONS.md) | Runbooks, SLOs | You're on-call or writing runbooks |
| 07 | [Governance](./07-GOVERNANCE.md) | Ownership, reviews | You need CODEOWNERS or review process |
| 16 | [Release Notes](./16-RELEASE_NOTES.md) | Changelogs | You're writing release notes |
| 27 | [Postmortems](./27-POSTMORTEMS.md) | Incident write-ups | You had an incident |

### Technical Standards

| # | Standard | Purpose | Read If... |
|---|----------|---------|------------|
| 08 | [Language-Specific](./08-LANGUAGE_SPECIFIC.md) | Python, JS/TS, Go docs | You need language-specific guidance |
| 14 | [Visuals](./14-VISUALS.md) | Diagrams, Mermaid | You're adding diagrams |
| 15 | [CLI Tools](./15-CLI_TOOLS.md) | Command-line docs | You're documenting a CLI |
| 18 | [API Documentation](./18-API_DOCUMENTATION.md) | REST, GraphQL, OpenAPI | You're documenting APIs |
| 19 | [Database Documentation](./19-DATABASE_DOCUMENTATION.md) | Schemas, ERDs | You're documenting databases |

### Process Standards

| # | Standard | Purpose | Read If... |
|---|----------|---------|------------|
| 00 | [Adoption Playbook](./00-ADOPTION_PLAYBOOK.md) | 12-week rollout | You're rolling this out to a team |
| 12 | [Reviews](./12-REVIEWS.md) | Doc review process | You need review guidelines |
| 26 | [Onboarding](./26-ONBOARDING.md) | New developer docs | You're writing onboarding guides |
| 33 | [ADRs](./33-ADR.md) | Decision records | You need to document architecture decisions |

### Specialized Standards

| # | Standard | Purpose | Read If... |
|---|----------|---------|------------|
| 20 | [Anti-Patterns](./20-ANTI_PATTERNS.md) | What NOT to do | You want to avoid common mistakes |
| 24 | [Security & Compliance](./24-SECURITY_COMPLIANCE.md) | SOC2, GDPR, ISO27001 | You have compliance requirements |
| 28 | [Mobile Apps](./28-MOBILE_APPS.md) | iOS/Android docs | You're documenting mobile apps |
| 29 | [ML Model Cards](./29-ML_MODEL_CARDS.md) | ML documentation | You're documenting ML models |
| 38 | [Open Source](./38-OPEN_SOURCE.md) | OSS-specific guidance | You're maintaining OSS |

---

## Templates

Pre-built templates ready to copy and customize:

| Tier | Templates | Best For |
|------|-----------|----------|
| [tier-oss](./templates/tier-oss/) | CONTRIBUTING, CODE_OF_CONDUCT, SECURITY | Open source projects |
| [tier-1-system](./templates/tier-1-system/) | README, ARCHITECTURE, ADR, API | All projects |
| [tier-2-operational](./templates/tier-2-operational/) | RUNBOOK, ONCALL_GUIDE, SLO | Production services |
| [tier-3-developer](./templates/tier-3-developer/) | GETTING_STARTED, HOW_TO | Developer onboarding |
| [tier-4-process](./templates/tier-4-process/) | POSTMORTEM, MIGRATION | Process documentation |
| [tier-5-troubleshooting](./templates/tier-5-troubleshooting/) | FAQ, TROUBLESHOOTING | Support docs |
| [tier-enterprise](./templates/tier-enterprise/) | COMPLIANCE_MATRIX, AUDIT_TRAIL | Compliance needs |

---

## Examples

Real-world examples showing what good docs look like:

- [Copy-Paste README](./examples/COPY_PASTE_README.md) - Just copy and edit
- [Example Service README](./examples/example-service-readme.md)
- [Example API Documentation](./examples/example-api-documentation.md)
- [Example Postmortem](./examples/example-postmortem.md)
- [Example ADR](./examples/example-adr.md)

---

## Validation & Automation

Scripts to automate quality checks:

| Script | Purpose | Usage |
|--------|---------|-------|
| `validate-frontmatter.sh` | Check YAML metadata | `bash scripts/validate-frontmatter.sh docs/` |
| `check-freshness.sh` | Find stale docs | `bash scripts/check-freshness.sh docs/ --days 90` |
| `validate-structure.sh` | Check required sections | `bash scripts/validate-structure.sh docs/` |

---

## Full Standard List

<details>
<summary>Click to expand all 40 standards</summary>

| # | Standard | Category |
|---|----------|----------|
| 00 | [Adoption Playbook](./00-ADOPTION_PLAYBOOK.md) | Process |
| 01 | [Philosophy](./01-PHILOSOPHY.md) | Core |
| 02 | [Know Your Audience](./02-KNOW_YOUR_AUDIENCE.md) | Core |
| 03 | [Document Types](./03-DOCUMENT_TYPES.md) | Core |
| 04 | [AI Agents](./04-AI_AGENTS.md) | Core |
| 05 | [Quality](./05-QUALITY.md) | Core |
| 06 | [Operations](./06-OPERATIONS.md) | Operational |
| 07 | [Governance](./07-GOVERNANCE.md) | Operational |
| 08 | [Language-Specific](./08-LANGUAGE_SPECIFIC.md) | Technical |
| 09 | [Localization](./09-LOCALIZATION.md) | Specialized |
| 10 | [Accessibility](./10-ACCESSIBILITY.md) | Specialized |
| 11 | [Style Guide](./11-STYLE_GUIDE.md) | Core |
| 12 | [Reviews](./12-REVIEWS.md) | Process |
| 13 | [Feedback](./13-FEEDBACK.md) | Process |
| 14 | [Visuals](./14-VISUALS.md) | Technical |
| 15 | [CLI Tools](./15-CLI_TOOLS.md) | Technical |
| 16 | [Release Notes](./16-RELEASE_NOTES.md) | Operational |
| 17 | [Maturity Model](./17-MATURITY_MODEL.md) | Process |
| 18 | [API Documentation](./18-API_DOCUMENTATION.md) | Technical |
| 19 | [Database Documentation](./19-DATABASE_DOCUMENTATION.md) | Technical |
| 20 | [Anti-Patterns](./20-ANTI_PATTERNS.md) | Core |
| 21 | [Service Catalog](./21-SERVICE_CATALOG.md) | Technical |
| 22 | [CI/CD Pipelines](./22-CICD_PIPELINES.md) | Technical |
| 23 | [Data Pipelines](./23-DATA_PIPELINES.md) | Technical |
| 24 | [Security & Compliance](./24-SECURITY_COMPLIANCE.md) | Specialized |
| 25 | [Infrastructure Code](./25-INFRASTRUCTURE_CODE.md) | Technical |
| 26 | [Onboarding](./26-ONBOARDING.md) | Process |
| 27 | [Postmortems](./27-POSTMORTEMS.md) | Operational |
| 28 | [Mobile Apps](./28-MOBILE_APPS.md) | Specialized |
| 29 | [ML Model Cards](./29-ML_MODEL_CARDS.md) | Specialized |
| 30 | [Testing](./30-TESTING.md) | Technical |
| 31 | [Dependencies](./31-DEPENDENCIES.md) | Technical |
| 32 | [Progressive Disclosure](./32-PROGRESSIVE_DISCLOSURE.md) | Core |
| 33 | [ADRs](./33-ADR.md) | Process |
| 34 | [Search Optimization](./34-SEARCH_OPTIMIZATION.md) | Specialized |
| 35 | [Documentation Portal](./35-DOCUMENTATION_PORTAL.md) | Specialized |
| 36 | [Context Guidance](./36-CONTEXT_GUIDANCE.md) | Core |
| 37 | [Migration Guide](./37-MIGRATION_GUIDE.md) | Process |
| 38 | [Open Source](./38-OPEN_SOURCE.md) | Specialized |
| 39 | [Integrations](./39-INTEGRATIONS.md) | Technical |
| 40 | [Metrics](./40-METRICS.md) | Process |

</details>

---

## Resources

- [README.md](./README.md) - Project overview and quick start
- [CONTRIBUTING.md](./CONTRIBUTING.md) - How to contribute
- [CHANGELOG.md](./CHANGELOG.md) - Version history
- [GLOSSARY.md](./GLOSSARY.md) - Terminology definitions

---

**License:** CC BY 4.0 - Use it, modify it, share it.
