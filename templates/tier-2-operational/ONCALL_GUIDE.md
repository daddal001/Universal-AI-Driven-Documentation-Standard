---
title: "On-Call Guide: [Team/Service]"
type: "oncall"
status: "approved"
owner: "@sre-team"
classification: "internal"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

# On-Call Guide: [Team/Service]

Everything engineers need to know for on-call rotation with [service/team]. Reference this guide before, during, and after your shift to respond effectively to incidents.

---

## On-Call Basics

| Property | Value |
|----------|-------|
| **Rotation Schedule** | [Link to PagerDuty/OpsGenie] |
| **Shift Duration** | [1 week / 24 hours] |
| **Handoff Time** | [Day/Time in timezone] |
| **Escalation** | @oncall-primary → @oncall-secondary → @manager |

---

## Before Your Shift

### Checklist

- [ ] VPN access working
- [ ] PagerDuty/OpsGenie app installed and logged in
- [ ] kubectl access to all clusters
- [ ] Access to [monitoring dashboard](https://grafana.example.com)
- [ ] Reviewed recent incidents in #incidents
- [ ] Know who your escalation contacts are

### Handoff Meeting

1. Attend handoff with outgoing on-call
2. Review any ongoing issues
3. Check error budget status
4. Confirm contact information

---

## During Your Shift

### Responding to Pages

1. **Acknowledge** within 5 minutes
2. **Assess** severity and impact
3. **Communicate** in #incidents channel
4. **Diagnose** using runbooks
5. **Resolve** or **escalate**
6. **Document** actions taken

### Severity Levels

| Severity | Definition | Response Time | Example |
|----------|------------|---------------|---------|
| **P1** | Critical / Revenue impact | Immediate | Full outage |
| **P2** | Major / Degraded service | 15 min | Partial outage |
| **P3** | Minor / No user impact | 1 hour | Internal tool down |

### Communication Templates

**Incident Start:**

```
🚨 INCIDENT: [Brief description]
Severity: P[X]
Impact: [What's affected]
Status: Investigating
Commander: @[your-name]
```

**Update:**

```
📍 UPDATE: [Brief description]
Status: [Investigating/Identified/Mitigating/Resolved]
Next update in: [X minutes]
```

**Resolution:**

```
✅ RESOLVED: [Brief description]
Duration: [X hours Y minutes]
Root cause: [One sentence]
Postmortem: [Link or "pending"]
```

---

## Key Runbooks

| Alert | Runbook | Priority |
|-------|---------|----------|
| [Service] High Error Rate | [Link](../runbooks/HIGH_ERRORS.md) | P1 |
| [Service] High Latency | [Link](../runbooks/HIGH_LATENCY.md) | P2 |
| Database Connection Failed | [Link](../runbooks/DB_CONNECTION.md) | P1 |
| Certificate Expiring | [Link](../runbooks/CERT_RENEWAL.md) | P3 |

---

## Key Dashboards

| Dashboard | Purpose | Link |
|-----------|---------|------|
| Service Overview | High-level health | [Grafana](https://grafana.example.com/d/overview) |
| Error Rates | Error debugging | [Grafana](https://grafana.example.com/d/errors) |
| Latency | Performance | [Grafana](https://grafana.example.com/d/latency) |
| Infrastructure | Resource usage | [Grafana](https://grafana.example.com/d/infra) |

---

## Escalation Contacts

| Role | Name | Contact | When to Escalate |
|------|------|---------|------------------|
| Secondary On-Call | @secondary | [Phone/Slack] | After 15 min |
| Team Lead | @lead | [Phone/Slack] | P1 unresolved 30 min |
| VP Engineering | @vp-eng | [Phone] | P1 > 1 hour, exec comms needed |

---

## After Your Shift

- [ ] Complete handoff with incoming on-call
- [ ] Write postmortems for any P1/P2 incidents
- [ ] File tickets for any recurring issues
- [ ] Update runbooks if they were incomplete
