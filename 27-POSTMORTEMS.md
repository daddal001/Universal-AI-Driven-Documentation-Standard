---
title: "Incident Postmortem Documentation"
type: "standard"
status: "approved"
owner: "@sre-team"
classification: "public"
created: "2025-12-09"
last_updated: "2026-03-04"
version: "2.0.0"
---

# Incident Postmortem Documentation

> **Goal:** Learn from incidents through blameless retrospectives. Focus on systems and processes, not individuals.

---

## 1. Blameless Culture

### Core Principles

| Principle | Practice |
|-----------|----------|
| **No Blame** | Focus on systems, not people |
| **Assume Good Intent** | Everyone acted with best available info |
| **Psychological Safety** | Safe to share mistakes |
| **System Thinking** | Fix the system, not the symptom |
| **Continuous Learning** | Every incident is a learning opportunity |

> **"Human error is a symptom of a deeper system problem, not a cause."**
> — Sidney Dekker

---

## 2. Postmortem Template

### Required Document

After any P0/P1 incident, create `docs/incidents/YYYY-MM-DD-incident-title.md`:

```markdown
# Incident: [Brief Title]

**Date:** 2025-12-09
**Duration:** 2 hours 15 minutes (14:30 - 16:45 UTC)
**Severity:** P1
**Author:** @incident-commander
**Status:** Complete

---

## Summary

One paragraph executive summary:

> On December 9, 2025, users experienced intermittent 503 errors for
> approximately 2 hours due to database connection pool exhaustion.
> The issue was caused by a query regression in the v2.3.1 release
> that increased connection hold time by 10x. Impact: ~15% of API
> requests failed during the incident window.

---

## Impact

| Metric | Value |
|--------|-------|
| Duration | 2h 15m |
| Users Affected | ~12,000 |
| Requests Failed | ~45,000 (15% error rate) |
| Revenue Impact | ~$8,000 estimated |
| SLA Status | Breached (target: 99.9%, actual: 99.2%) |

---

## Timeline

| Time (UTC) | Event |
|------------|-------|
| 14:30 | PagerDuty alert: Error rate > 5% |
| 14:32 | On-call engineer acknowledges |
| 14:35 | Initial investigation: DB connections at 100% |
| 14:45 | Rolled back to v2.3.0 |
| 14:50 | Error rate unchanged - rollback didn't help |
| 15:00 | Escalation to database team |
| 15:15 | Identified: Connection pool exhausted |
| 15:30 | Increased pool size from 20 → 50 |
| 15:35 | Error rate dropping |
| 16:00 | All metrics back to normal |
| 16:45 | Incident declared resolved |

---

## Root Cause Analysis

### What Happened

The v2.3.1 release included a new ORM query that held database
connections for the duration of request processing instead of
releasing them after the query completed.

### Contributing Factors

1. **Query Pattern Change** — New eager loading pattern kept
   connections open longer
2. **Insufficient Pool Size** — Pool sized for old query patterns
3. **Missing Monitoring** — No alert on connection wait time
4. **Load Spike** — Traffic 20% higher than normal during incident

### Five Whys

1. **Why** did users see 503 errors?
   - Database connections exhausted
2. **Why** were connections exhausted?
   - New queries held connections 10x longer
3. **Why** did the new queries hold connections longer?
   - ORM eager loading pattern change in v2.3.1
4. **Why** wasn't this caught in testing?
   - Load tests don't run against production-like data volume
5. **Why** don't load tests use production-like data?
   - No automated data sampling from production

---

## What Went Well

- Alert fired within 5 minutes of issue start
- Clear escalation path followed
- Team collaborated effectively
- Customer communication was timely

## What Could Be Improved

- Rollback didn't help — should have checked if it was recent code
- Took 45 minutes to identify root cause
- No runbook for connection pool issues
- Load tests don't catch connection holding issues

---

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Add connection wait time alert | @sre-team | 2025-12-16 | 🔲 TODO |
| Create connection pool runbook | @sre-team | 2025-12-20 | 🔲 TODO |
| Add load test with prod-like data | @platform | 2025-12-30 | 🔲 TODO |
| Review all ORM eager loading | @backend | 2026-01-10 | 🔲 TODO |
| Increase default pool size | @platform | 2025-12-12 | ✅ DONE |

---

## Lessons Learned

1. Connection pool sizing needs to account for query patterns
2. Load tests must simulate realistic data volumes
3. Need better visibility into connection lifecycle

---

## Appendix

- [Grafana Dashboard](https://grafana.example.com/d/incident-2025-12-09)
- [Slack Thread](https://slack.com/archives/incidents/p1234567890)
- [Related PR](https://github.com/org/repo/pull/1234)
```

---

## 3. Severity Classification

### 3.1 Operational Incidents

| Severity | Criteria | Postmortem Required |
|----------|----------|---------------------|
| **P0** | Complete service outage | ✅ Mandatory within 48h |
| **P1** | Major feature unavailable or degraded | ✅ Mandatory within 1 week |
| **P2** | Minor feature affected, workaround exists | 📝 Recommended |
| **P3** | Minimal impact | ❌ Optional |

### 3.2 Security / CVE Incidents

Security vulnerabilities use a parallel classification based on CVSS score and exploitation context. All CVE remediations that required code or infrastructure changes require a postmortem — even if no exploit occurred — to satisfy ISO 27001 A.5.27 (Learning from incidents) and SOC 2 CC7.4 evidence requirements.

| Severity | CVSS Range | Criteria | Postmortem Required | Remediation SLA |
|----------|-----------|----------|---------------------|-----------------|
| **P0** | 9.0–10.0 (Critical) | Active exploitation or CISA KEV listed | ✅ Mandatory within 48h | 14 days |
| **P1** | 7.0–8.9 (High) | Affects production, no known exploitation | ✅ Mandatory within 1 week | 30 days |
| **P2** | 4.0–6.9 (Medium) | Requires specific conditions to exploit | 📝 Recommended | 60 days |
| **P3** | 0.1–3.9 (Low) | Minimal exploitability | ❌ Optional | 90 days |

> **Note:** If a CVE has an EPSS score ≥ 10% (high exploit probability), escalate one severity level regardless of CVSS score.

---

## 4. CVE / Security Vulnerability Section

When the incident involves a CVE or security vulnerability, the postmortem **MUST** include the following additional section between "Summary" and "Impact". This section is required by ISO 27001 A.5.26 (Response to information security incidents) and provides evidence for SOC 2 CC7.3-CC7.5.

### 4.1 Required Fields

```markdown
## Vulnerability Details

| Field | Value |
|-------|-------|
| **CVE ID** | CVE-YYYY-NNNNN |
| **CVSS Score** | X.X (Critical / High / Medium / Low) |
| **CVSS Vector** | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N |
| **EPSS Score** | X.XX% (as of YYYY-MM-DD) |
| **CISA KEV** | Yes / No (date added if applicable) |
| **CWE** | CWE-XXX: [Name] |
| **Affected Component** | [software name and version range] |
| **Fixed Version** | [version that resolves the vulnerability] |
| **Our Version (Before)** | [version we were running] |
| **Our Version (After)** | [version we upgraded to] |
| **MITRE ATT&CK** | [Tactic: Technique ID — Technique Name] |
| **Patch Available Date** | YYYY-MM-DD |
| **Remediation Deadline** | YYYY-MM-DD (per SLA from §3.2) |
| **Remediation Completed** | YYYY-MM-DD |
| **SLA Met** | ✅ Yes / ❌ No (X days under/over) |

### Attack Vector Analysis

[Describe how an attacker could exploit this vulnerability in the context of
our deployment. Include network path, required preconditions, and what data
or systems would be at risk.]

### GDPR Data Impact Assessment

| Question | Answer |
|----------|--------|
| Could personal data be accessed? | Yes / No |
| Data categories at risk | [e.g., email addresses, session tokens, documents] |
| Data subjects at risk | [e.g., all platform users, admin users only] |
| Breach notification required? | Yes (Art. 33) / No |
| Supervisory authority notified? | Yes (date) / N/A |
```

### 4.2 Backlog Check (Atlassian Pattern)

Every CVE postmortem must answer:

> **"Was this fix already known but deprioritized?"**

| Question | Answer |
|----------|--------|
| Was a Dependabot/Renovate PR open for this update? | Yes / No |
| Was a security advisory previously triaged? | Yes / No |
| If yes, why was it deprioritized? | [Reason] |
| Process change to prevent future deprioritization | [Action] |

### 4.3 Recurrence Linkage

If similar vulnerabilities have occurred before, link them:

```markdown
### Recurrence Analysis

| Previous Incident | Similarity | Action Items Completed? |
|-------------------|------------|------------------------|
| [INC-YYYY-MM-DD-XXX](link) | Same component / Same CWE / Same vendor | ✅ / ❌ |
```

### 4.4 Compliance Evidence Checklist

Every CVE postmortem serves as audit evidence. Before marking "Complete", verify:

| Requirement | Standard | Verified |
|-------------|----------|----------|
| Vulnerability identified and classified | ISO 27001 A.5.25 | ☐ |
| Response actions documented | ISO 27001 A.5.26 | ☐ |
| Root cause analyzed | ISO 27001 A.5.27 | ☐ |
| Evidence preserved (logs, screenshots) | ISO 27001 A.5.28 | ☐ |
| Remediation SLA tracked | SOC 2 CC7.4 | ☐ |
| GDPR data impact assessed | GDPR Art. 33-34 | ☐ |
| Action items have owners and due dates | SOC 2 CC7.5 | ☐ |
| Supply chain impact assessed | NIS2 Art. 23 | ☐ |

---

## 5. Postmortem Process

### Timeline

```mermaid
flowchart LR
    A[Incident<br/>Resolved] --> B[24-48h:<br/>Draft Postmortem]
    B --> C[3-5 days:<br/>Review Meeting]
    C --> D[1 week:<br/>Publish & Share]
    D --> E[Track<br/>Action Items]
```

### Postmortem Meeting

**Duration:** 30-60 minutes

**Attendees:**

- Incident Commander
- On-call responders
- Service owners
- Optional: Leadership (for P0)

**Agenda:**

1. **5 min** — Review timeline
2. **15 min** — Discuss what happened (facts, not opinions)
3. **15 min** — Identify contributing factors
4. **10 min** — Agree on action items
5. **5 min** — Assign owners and due dates

---

## 6. Action Item Tracking

### Required Fields

| Field | Purpose |
|-------|---------|
| **Action** | Specific, measurable task |
| **Owner** | Single person accountable |
| **Due Date** | Realistic deadline |
| **Status** | TODO, IN PROGRESS, DONE, WONTFIX |
| **Ticket** | Link to tracking issue |

### Status Tracking

```markdown
## Action Item Status

| ID | Action | Owner | Due | Status | Ticket |
|----|--------|-------|-----|--------|--------|
| 1 | Add connection alert | @sre | Dec 16 | ✅ DONE | SRE-123 |
| 2 | Create runbook | @sre | Dec 20 | 🔄 IN PROGRESS | SRE-124 |
| 3 | Load test update | @platform | Dec 30 | 🔲 TODO | PLAT-456 |
```

---

## 7. Sharing & Learning

### Distribution

| Audience | Format |
|----------|--------|
| Engineering Team | Full postmortem document |
| Company | Summary in #incidents Slack |
| Leadership | Brief for P0/P1 |
| External (if applicable) | Status page update |

### Monthly Review

- Review all postmortems from past month
- Track action item completion rate
- Identify recurring themes
- Update runbooks based on learnings

---

## 8. Related Documents

| Document | Purpose |
|----------|---------|
| [Operations](./06-OPERATIONS.md) | Runbooks, on-call |
| [CI/CD Pipelines](./22-CICD_PIPELINES.md) | Deployment incidents |
| [Service Catalog](./21-SERVICE_CATALOG.md) | Service ownership |
| [Incident Response Plan](../compliance/policies/INCIDENT_RESPONSE_PLAN.md) | ISO 27001 / GDPR response procedures |
| [Supply Chain Incident Runbook](../operations/SUPPLY_CHAIN_INCIDENT_RUNBOOK.md) | Third-party dependency CVE procedures |
| [Incident Index](../incidents/README.md) | All postmortem documents |

---

**Previous:** [26 - Onboarding](./26-ONBOARDING.md)
**Next:** [28 - Mobile Apps](./28-MOBILE_APPS.md)
