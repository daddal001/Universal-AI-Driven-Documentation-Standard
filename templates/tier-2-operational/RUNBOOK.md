---
title: "[Service] Runbook"
type: "runbook"
status: "approved"
owner: "@team-name"
classification: "internal"
created: "[YYYY-MM-DD]"
last_updated: "2025-12-14"
last_tested: "[YYYY-MM-DD]"
version: "1.0.0"
---

# Runbook: [SERVICE/SYSTEM NAME]

Step-by-step procedures for on-call engineers responding to [service/alert] incidents. Use this when [alert name] fires or [symptoms occur] in [production/staging/all] environments. Following these tested steps reduces mean time to resolution.

---

## Overview

| Property | Value |
|----------|-------|
| **Service** | [Service name] |
| **Owner** | @team-name |
| **Criticality** | P0 / P1 / P2 |
| **Escalation** | #channel-name |

## Prerequisites

- [ ] Access to [system/dashboard]
- [ ] VPN connected
- [ ] kubectl configured for [cluster]

---

## Alert: [ALERT NAME]

### Symptoms

- [What the user/system experiences]

### Diagnosis

```bash
# Step 1: Check service status
kubectl get pods -n [namespace]

# Step 2: Check logs
kubectl logs -f deployment/[service] -n [namespace] --tail=100
```

### Resolution

1. **If [condition A]:**

   ```bash
   # Command to fix
   kubectl rollout restart deployment/[service] -n [namespace]
   ```

2. **If [condition B]:**
   - [Manual step]
   - [Verification step]

### Verification

```bash
# Confirm service is healthy
curl -s https://[service]/health | jq .
# Expected: {"status": "healthy"}
```

### Escalation

If unresolved after 15 minutes:

1. Page @oncall-secondary
2. Create incident in #incidents

---

## Common Procedures

### Restart Service

```bash
kubectl rollout restart deployment/[service] -n [namespace]
kubectl rollout status deployment/[service] -n [namespace]
```

### Scale Up

```bash
kubectl scale deployment/[service] --replicas=5 -n [namespace]
```

### Check Database Connection

```bash
kubectl exec -it deployment/[service] -n [namespace] -- \
  psql $DATABASE_URL -c "SELECT 1"
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Architecture](./ARCHITECTURE.md) | System design |
| [Alerts](./ALERTS.md) | Alert definitions |
| [Postmortem Template](./POSTMORTEM.md) | If incident occurs |
