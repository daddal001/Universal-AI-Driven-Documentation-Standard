---
title: "Runbook: Payment Gateway High Error Rate"
type: "runbook"
status: "approved"
classification: "public"
owner: "@payments-oncall"
created: "2025-08-20"
last_updated: "2025-12-10"
version: "1.2.0"
severity: "P1"
service: "payment-gateway"
alert_name: "PaymentHighErrorRate"
---

# Runbook: Payment Gateway High Error Rate

> **Severity:** P1 (Critical)
> **Time to Mitigate:** Target < 15 minutes
> **Escalation:** @platform-oncall after 30 minutes

## Alert Details

**Trigger Condition:**

```promql
sum(rate(payment_requests_total{status="error"}[5m]))
  / sum(rate(payment_requests_total[5m])) > 0.05
```

This alert fires when **more than 5% of payment requests fail** over a 5-minute window.

**Impact:**

# Check PostgreSQL replication lag

kubectl exec -n payments postgresql-0 -- psql -c "SELECT pg_last_wal_replay_lsn();"

# Check active connections

kubectl exec -n payments postgresql-0 -- psql -c \
  "SELECT count(*) FROM pg_stat_activity WHERE state = 'active';"

```

**If connection pool exhausted:**

```bash
# Restart the service to reset connections
kubectl rollout restart deployment/payment-gateway -n payments

# Watch for recovery
kubectl get pods -n payments -w
```

**If database is unreachable:**

1. **Page @database-oncall**
2. Check if failover is in progress
3. Do NOT restart database pods manually

---

## Rate Limit Issues

### Step 4: Check Rate Limits (2 min)

```bash
# Check current rate limit usage
curl -s http://payment-gateway:8080/metrics | grep rate_limit

# Check if a specific client is hammering us
kubectl logs -n payments -l app=payment-gateway --since=5m | \
  jq -r 'select(.status == 429) | .client_id' | sort | uniq -c | sort -rn
```

**If single client causing issues:**

```bash
# Temporarily block the client (requires API gateway access)
kubectl exec -n gateway deployment/api-gateway -- \
  curl -X POST http://localhost:8080/admin/block-client -d '{"client_id": "xxx"}'

# Notify the client's account manager
```

**If legitimate traffic spike:**

```bash
# Scale up payment-gateway
kubectl scale deployment/payment-gateway -n payments --replicas=10

# Increase rate limits temporarily
kubectl set env deployment/payment-gateway -n payments RATE_LIMIT_MULTIPLIER=2
```

---

## Kafka Issues

### Step 5: Check Kafka Health (3 min)

```bash
# Check consumer lag
kubectl exec -n kafka kafka-0 -- kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --describe --group payment-gateway

# Check broker health
kubectl exec -n kafka kafka-0 -- kafka-broker-api-versions.sh \
  --bootstrap-server localhost:9092
```

**If consumer lag is high:**

```bash
# Scale up consumers
kubectl scale deployment/payment-gateway -n payments --replicas=8

# Check if messages are being produced
kubectl exec -n kafka kafka-0 -- kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic payments --from-beginning --max-messages 5
```

---

## Recovery Verification

### Step 6: Verify Resolution (5 min)

```bash
# Check error rate is decreasing
watch -n 10 'curl -s http://payment-gateway:8080/metrics | grep payment_success_rate'

# Target: error rate < 2% for 5 consecutive minutes
```

**Recovery Checklist:**

- [ ] Error rate below 2%
- [ ] No new alerts firing
- [ ] Customer-facing status updated
- [ ] Incident channel notified

---

## Not an Incident

High `INVALID_CARD` errors are **normal customer behavior**, not a system issue.

**However, investigate if:**

- Rate suddenly doubled (possible card testing attack)
- Single merchant has 90%+ errors (integration issue)

## Post-Incident

1. **Update incident timeline** in #incidents Slack channel
   - Customer impact confirmed
2. **Review this runbook** — update if steps were unclear or missing

Use: [POSTMORTEM.md](../templates/tier-4-process/POSTMORTEM.md)

## Escalation Contacts

| Primary On-Call | @payments-oncall | First responder |
| Database On-Call | @database-oncall | Database issues |
| Engineering Manager | @payments-em | Customer-facing outage > 1 hour |
---

| Date | Change | Author |
|------|--------|--------|
| 2025-08-20 | Initial version | @payments-oncall |

---
