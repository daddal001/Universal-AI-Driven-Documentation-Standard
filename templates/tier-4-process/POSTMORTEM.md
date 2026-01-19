---
title: "Incident: [BRIEF TITLE]"
type: "postmortem"
status: "draft"
owner: "@incident-commander"
classification: "internal"
created: "[YYYY-MM-DD]"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Incident: [BRIEF TITLE]

Post-incident analysis for engineers, stakeholders, and future on-call responders. [Brief description of what happened]. This incident affected [services/systems/regions] on [YYYY-MM-DD]. We document failures to prevent recurrence.

**Date:** [YYYY-MM-DD]
**Duration:** [X hours Y minutes]
**Severity:** P0 / P1 / P2
**Author:** @incident-commander
**Status:** Draft / Complete

---

## Summary

> [One paragraph executive summary: What happened, impact, resolution]

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
| HH:MM | [First alert / symptom] |
| HH:MM | [Detection / acknowledgment] |
| HH:MM | [Initial investigation] |
| HH:MM | [First mitigation attempt] |
| HH:MM | [Resolution] |
| HH:MM | [Incident declared resolved] |

---

## Root Cause Analysis

### What Happened

[Technical description of the failure]

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

## Appendix

- [Grafana Dashboard](https://grafana.example.com/d/incident-YYYY-MM-DD)
- [Slack Thread](https://slack.com/archives/...)
- [Related PR](https://github.com/org/repo/pull/XXX)
