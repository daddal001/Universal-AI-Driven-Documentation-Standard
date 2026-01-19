---
title: "Troubleshooting: [System/Component]"
type: "troubleshooting"
status: "approved"
owner: "@sre-team"
classification: "internal"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Troubleshooting: [System/Component]

Symptom-based diagnosis guide for engineers debugging issues with [system]. Use this when [system] isn't working as expected in [production/staging/all environments]. Systematic diagnosis reduces mean time to resolution.

---

## Quick Diagnostics

```bash
# Check if service is running
curl -s http://[service]/health | jq .

# Check recent logs
kubectl logs -l app=[service] --tail=50 -n [namespace]

# Check resource usage
kubectl top pods -l app=[service] -n [namespace]
```

---

## Symptom: [Error/Behavior 1]

**Example:** "API returns 503 errors intermittently"

### Possible Causes

| Cause | Likelihood | Quick Check |
|-------|------------|-------------|
| [Cause 1] | High | [How to check] |
| [Cause 2] | Medium | [How to check] |
| [Cause 3] | Low | [How to check] |

### Diagnosis

```bash
# Step 1: Check [thing]
command-to-check

# Step 2: Check [other thing]
another-command
```

### Resolution

**If [Cause 1]:**

```bash
# Fix command
fix-command
```

**If [Cause 2]:**

1. [Manual step]
2. [Verification step]

### Verification

```bash
# Confirm the fix worked
verification-command
# Expected: [expected output]
```

---

## Symptom: [Error/Behavior 2]

**Example:** "High latency on /api/v1/users endpoint"

### Possible Causes

| Cause | Likelihood | Quick Check |
|-------|------------|-------------|
| Database slow queries | High | Check query logs |
| Cache miss rate high | Medium | Check Redis stats |
| Resource exhaustion | Low | Check CPU/memory |

### Diagnosis

```bash
# Check database query time
kubectl exec -it [db-pod] -- psql -c "SELECT * FROM pg_stat_activity"

# Check cache hit rate
redis-cli INFO stats | grep hit
```

### Resolution

[Steps to resolve]

---

## Symptom: [Error/Behavior 3]

[Repeat pattern...]

---

## Escalation

If none of the above resolves the issue:

1. Check the [Runbook](../operations/runbooks/[SERVICE].md)
2. Page on-call: `pd trigger [service]-critical`
3. Create incident in #incidents

---

## Related

| Document | Purpose |
|----------|---------|
| [Runbook](../operations/runbooks/) | Step-by-step procedures |
| [Architecture](../architecture/) | System design |
| [Monitoring](../operations/MONITORING.md) | Dashboards and alerts |
