---
title: "Incident: [BRIEF TITLE]"
type: "postmortem"
status: "draft"
owner: "@incident-commander"
classification: "internal"
created: "[YYYY-MM-DD]"
last_updated: "2026-03-04"
version: "2.0.0"
# For CVE/security incidents, add these frontmatter fields:
# cve_id: "CVE-YYYY-NNNNN"
# cvss_score: "X.X"
# cvss_severity: "critical|high|medium|low"
---

# Incident: [BRIEF TITLE]

Post-incident analysis for engineers, stakeholders, and future on-call responders. [Brief description of what happened]. This incident affected [services/systems/regions] on [YYYY-MM-DD]. We document failures to prevent recurrence.

**Date:** [YYYY-MM-DD]
**Duration:** [X hours Y minutes]
**Severity:** P0 / P1 / P2
**Author:** @incident-commander
**Status:** Draft / Complete
**Type:** Operational / Security-CVE / Security-Other

---

## Summary

> [One paragraph executive summary: What happened, impact, resolution]

---

<!-- ═══════════════════════════════════════════════════════════════
     CVE / SECURITY VULNERABILITY SECTION
     Include this section ONLY for security/CVE incidents.
     Delete this entire block for operational incidents.
     See: docs/standards/27-POSTMORTEMS.md §4 for field definitions.
     ═══════════════════════════════════════════════════════════════ -->

## Vulnerability Details

| Field | Value |
|-------|-------|
| **CVE ID** | CVE-YYYY-NNNNN |
| **CVSS Score** | X.X (Critical / High / Medium / Low) |
| **CVSS Vector** | CVSS:3.1/AV:_/AC:_/PR:_/UI:_/S:_/C:_/I:_/A:_ |
| **EPSS Score** | X.XX% (as of YYYY-MM-DD) |
| **CISA KEV** | Yes / No |
| **CWE** | CWE-XXX: [Name] |
| **Affected Component** | [software name and version range] |
| **Fixed Version** | [version that resolves the vulnerability] |
| **Our Version (Before)** | [version we were running] |
| **Our Version (After)** | [version we upgraded to] |
| **MITRE ATT&CK** | [Tactic: Technique ID — Name] |
| **Patch Available Date** | YYYY-MM-DD |
| **Remediation Deadline** | YYYY-MM-DD (per SLA: Critical=14d, High=30d, Medium=60d, Low=90d) |
| **Remediation Completed** | YYYY-MM-DD |
| **SLA Met** | ✅ Yes / ❌ No (X days under/over) |

### Attack Vector Analysis

[Describe how an attacker could exploit this in your deployment. Include
network path, required preconditions, and what data/systems would be at risk.]

### GDPR Data Impact Assessment

| Question | Answer |
|----------|--------|
| Could personal data be accessed? | Yes / No |
| Data categories at risk | [e.g., email addresses, session tokens] |
| Data subjects at risk | [e.g., all platform users, admin only] |
| Breach notification required? | Yes (Art. 33) / No |
| Supervisory authority notified? | Yes (date) / N/A |

### Backlog Check

> **"Was this fix already known but deprioritized?"**

| Question | Answer |
|----------|--------|
| Was a Dependabot/Renovate PR open for this update? | Yes / No |
| Was a security advisory previously triaged? | Yes / No |
| If yes, why was it deprioritized? | [Reason] |
| Process change to prevent future deprioritization | [Action] |

### Recurrence Analysis

| Previous Incident | Similarity | Action Items Completed? |
|-------------------|------------|------------------------|
| [INC-YYYY-MM-DD-XXX](link) | [Same component / Same CWE / Same vendor] | ✅ / ❌ |
| _None_ | — | — |

<!-- ═══════════════════════════════════════════════════════════════
     END CVE / SECURITY VULNERABILITY SECTION
     ═══════════════════════════════════════════════════════════════ -->

---

## Impact

| Metric | Value |
|--------|-------|
| Duration | [X hours Y minutes] |
| Users Affected | [Number] |
| Requests Failed | [Number or %] |
| Revenue Impact | [$X estimated] |
| SLA Status | Met / Breached |

---

## Timeline

| Time (UTC) | Event |
|------------|-------|
| HH:MM | [First alert / symptom / disclosure published] |
| HH:MM | [Detection / acknowledgment / triage] |
| HH:MM | [Initial investigation / version audit] |
| HH:MM | [First mitigation attempt / upgrade started] |
| HH:MM | [Resolution / patched version deployed] |
| HH:MM | [Incident declared resolved / verification complete] |

---

## Root Cause Analysis

### What Happened

[Technical description of the failure or vulnerability]

### Contributing Factors

1. [Factor 1]
2. [Factor 2]
3. [Factor 3]

### Five Whys

1. **Why** [symptom]? → [cause]
2. **Why** [cause]? → [deeper cause]
3. **Why** [deeper cause]? → [even deeper]
4. **Why** [even deeper]? → [systemic issue]
5. **Why** [systemic issue]? → [root cause]

---

## What Went Well

- [Positive 1]
- [Positive 2]

## Where We Got Lucky

<!-- Google SRE pattern: document near-misses and lucky breaks -->

- [Lucky break 1 — e.g., "No known exploitation in the wild before we patched"]

## What Could Be Improved

- [Improvement 1]
- [Improvement 2]

---

## Action Items

| Action | Owner | Due Date | Status | Ticket |
|--------|-------|----------|--------|--------|
| [Action 1] | @owner | YYYY-MM-DD | 🔲 TODO | [PROJ-XXX] |
| [Action 2] | @owner | YYYY-MM-DD | 🔲 TODO | [PROJ-XXX] |
| [Action 3] | @owner | YYYY-MM-DD | ✅ DONE | [PROJ-XXX] |

---

## Lessons Learned

1. [Lesson 1]
2. [Lesson 2]

---

<!-- For CVE incidents only: Compliance Evidence Checklist -->

## Compliance Evidence Checklist

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

## Appendix

- [Grafana Dashboard](https://grafana.example.com/d/incident-YYYY-MM-DD)
- [Slack Thread](https://slack.com/archives/...)
- [Related PR](https://github.com/org/repo/pull/XXX)
- [CVE Advisory](https://nvd.nist.gov/vuln/detail/CVE-YYYY-NNNNN)
- [Vendor Advisory](https://...)
