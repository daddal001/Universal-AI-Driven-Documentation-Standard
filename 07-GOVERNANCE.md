---
title: "Governance"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-12"
version: "1.1.0"
---



> Documentation ownership, review processes, and multi-contributor workflows.

---

## Table of Contents

1. [Ownership](#ownership)
2. [Review Process](#review-process)
3. [Approval Matrix](#approval-matrix)
4. [Multi-Contributor Workflow](#multi-contributor-workflow)
5. [Enforcement](#enforcement)

---

## Ownership

### CODEOWNERS Integration

Every folder **must** have an owner defined in `.github/CODEOWNERS`:

```text
# Documentation ownership
docs/                           @doc-team
apps/frontend/                  @frontend-team
services/backend-gateway/       @backend-team
services/backend-ai/            @ai-team
infra/                          @platform-team
```

### Ownership Levels

| Level | Scope | Responsibilities |
|-------|-------|------------------|
| **Service Owner** | Service README + guides | Full accuracy, quarterly review |
| **Team Lead** | Team's services | Delegate, verify quality |
| **Doc Guild** | Cross-cutting docs | Standards, consistency |
| **Maintainer** | Repository-wide | Standard, templates, automation |

### Ownership Headers

Every README must include:

```markdown
**Owner:** @username
**Team:** #team-channel
**Last Reviewed:** December 2025
**Next Review:** March 2026
```

---

## Review Process

### Three Review Types

| Type | Focus | Reviewer |
|------|-------|----------|
| **Technical** | Is it accurate? | Team engineer |
| **Audience** | Is it clear? | Non-team member |
| **Writing** | Is it consistent? | Tech writer |

### Review Cadence by Type

| Document Type | Frequency | Reviewer |
|---------------|-----------|----------|
| P0 Runbooks | Monthly | SRE Lead |
| P1 Runbooks | Quarterly | SRE Team |
| Security Playbooks | Quarterly | Security Lead |
| Architecture | Quarterly | Tech Lead |
| API Documentation | Per Release | API Owner |
| Service README | Quarterly | Service Owner |

---

## Approval Matrix

| Document Type | Author | Reviewer | Approver |
|---------------|--------|----------|----------|
| README | Any engineer | Peer | Service owner |
| API Documentation | API developer | API lead | API owner |
| Architecture | Tech lead | Architect | Engineering director |
| Security Playbook | Security engineer | Security lead | CISO delegate |
| Runbook (P0) | SRE | SRE lead | Ops manager |
| ADR | Any engineer | Tech lead | Architect |

### Conflict Resolution

| Scenario | Resolution |
|----------|------------|
| Technical disputes | Escalate to Architect |
| Terminology disputes | Refer to Glossary |
| Security disputes | Security team decides |
| Compliance disputes | Legal/Compliance decides |

---

## Multi-Contributor Workflow

### Permission Matrix

| Actor | Can Do | Cannot Do |
|-------|--------|-----------|
| Any Engineer | Update own docs, fix typos | Change other team's structure |
| Team Member | Update team docs | Change folder hierarchy |
| Team Lead | Approve team changes | Modify this standard |
| Doc Maintainer | Change standard | Override CODEOWNERS |

### Contribution Rules

1. **Check existing patterns first** — Read 2-3 similar docs
2. **Use cross-references** — Never duplicate content
3. **Keep changes atomic** — One logical change per PR
4. **Update metadata** — Version, `last_updated`, owner

### Contribution Incentives

**Documentation contributions should be recognized.** (Based on Stripe/Meta practices)

| Recognition | Description |
|-------------|-------------|
| **Performance Reviews** | Doc contributions count toward impact |
| **Docs Champion Award** | Quarterly recognition for top contributors |
| **CHANGELOG Credit** | Contributors named in release notes |
| **Leaderboard** | Optional: Track doc PRs in team dashboard |

**Why This Matters:**
> "Engineers who improve documentation are recognized in performance reviews." — Meta Engineering

---

## Enforcement

### Git Hooks

```bash
# Installation (Required)
bash scripts/git-hooks/install.sh
```

**What It Does:**

- Prevents commits without doc updates
- Applies to all folders
- Config files exempt

### CI/CD Validation

```yaml
# .github/workflows/docs-ci.yml
- name: Validate documentation
  run: |
    bash scripts/docs/validate-frontmatter.sh
    bash scripts/docs/check-links.sh
    bash scripts/docs/check-freshness.sh
```

### Failure Behaviors

| Check | Failure Behavior |
|-------|------------------|
| Missing frontmatter | ❌ Block PR |
| Broken links | ❌ Block PR |
| Stale docs (>90 days) | ❌ Block deployment |
| Missing README | ❌ Block PR |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Operations](./06-OPERATIONS.md) | Freshness SLAs |
| [Language Specific](./08-LANGUAGE_SPECIFIC.md) | Per-language tooling |

---

**Previous:** [06 - Operations](./06-OPERATIONS.md)
**Next:** [08 - Language Specific](./08-LANGUAGE_SPECIFIC.md)
