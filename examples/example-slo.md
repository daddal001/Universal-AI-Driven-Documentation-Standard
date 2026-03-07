---
title: "A Gateway SLO Document"
type: "slo"
status: "approved"
owner: "@platform-team"
classification: "internal"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.0.0"
next_review: "2025-04-12"
---

# A Gateway Service Level Objectives

Reliability targets and error budgets for the A Gateway service. This document defines the availability, latency, and throughput commitments for the API gateway that handles all incoming requests.

**Based on:** [Google SRE Workbook - Implementing SLOs](https://sre.google/workbook/implementing-slos/)

---

## Service Overview

| Property | Value |
|----------|-------|
| **Service** | Backend Gateway |
| **Owner** | @platform-team |
| **Tier** | Tier 1 (Critical) |
| **Port** | 8000 (internal), 80 (via Nginx) |
| **Dependencies** | Chat Service, AI Service, Document Service |

### Service Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         REQUEST FLOW                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   Users → Nginx → Gateway → [Chat | AI | Document | Metadata]       │
│                    :8000      :8001  :8002  :8003    :8005          │
│                                                                      │
│   Gateway Responsibilities:                                         │
│   • Rate limiting (20 req/min per IP)                              │
│   • CORS handling                                                   │
│   • Request routing                                                 │
│   • Health aggregation                                              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## SLI Definitions

### Availability SLI

The Gateway service availability is measured as the ratio of successful requests to total requests.

```
Availability = (Successful Requests / Total Requests) × 100%

Where:
  Successful = HTTP status codes 2xx, 3xx, 4xx (client errors are not service failures)
  Total = All requests received

PromQL:
1 - (
  sum(rate(otel_http_server_request_duration_seconds_count{
    service_name="backend-gateway",
    http_status_code=~"5.."
  }[5m]))
  /
  sum(rate(otel_http_server_request_duration_seconds_count{
    service_name="backend-gateway"
  }[5m]))
)
```

### Latency SLI

The Gateway latency is measured from request receipt to response sent, excluding time spent in downstream services.

```
Latency = Time from request received to response sent

PromQL (P95):
histogram_quantile(0.95,
  sum(rate(otel_http_server_request_duration_seconds_bucket{
    service_name="backend-gateway"
  }[5m])) by (le)
)
```

---

## SLOs

### Availability

| Metric | Target | Window | Current | Status |
|--------|--------|--------|---------|--------|
| Successful requests | ≥ 99.5% | 30 days | 99.7% | **Met** |

**Rationale:** 99.5% allows 3.6 hours of downtime per month, providing buffer for:

- Deployment windows
- Dependency failures (AI service has external Gemini API)
- Infrastructure maintenance

**Dashboard:** [Grafana - SRE Golden Signals](http://localhost/admin/grafana/d/A-sre-golden-signals)

### Latency

| Percentile | Target | Window | Current | Status |
|------------|--------|--------|---------|--------|
| p50 | ≤ 50ms | 30 days | 32ms | **Met** |
| p95 | ≤ 500ms | 30 days | 245ms | **Met** |
| p99 | ≤ 1s | 30 days | 680ms | **Met** |

**Rationale:** P95 target of 500ms accounts for:

- Downstream service calls (Chat, AI)
- Database operations (session lookup)
- Network latency

**Dashboard:** [Grafana - OTEL Metrics](http://localhost/admin/grafana/d/A-otel-metrics)

### Throughput

| Metric | Target | Window | Current | Status |
|--------|--------|--------|---------|--------|
| Requests per second | Handle ≥ 100 RPS | Peak | 85 RPS | **Adequate** |

**Rationale:** 100 RPS target based on:

- Expected concurrent users: 50
- Average requests per user: 2/second
- Headroom: 2x

---

## Error Budget

### Error Budget Calculation

```
Error Budget for 99.5% SLO over 30 days:

Error Budget = (1 - 0.995) × 30 × 24 × 60 minutes
             = 0.005 × 43,200 minutes
             = 216 minutes (3.6 hours)

Weekly Budget = 216 / 4.3 ≈ 50 minutes
Daily Budget = 216 / 30 ≈ 7.2 minutes
```

### Current Error Budget Status

| SLO | Budget (30d) | Consumed | Remaining | Status |
|-----|--------------|----------|-----------|--------|
| Availability 99.5% | 3.6 hours | 0.3 hours | 3.3 hours | **92% remaining** |
| Latency p95 < 500ms | 0.5% of requests | 0.1% | 0.4% | **80% remaining** |

### Error Budget Tracking (PromQL)

```promql
# Error budget consumed (as percentage) - 30 day window
(
  1 - (
    sum(increase(otel_http_server_request_duration_seconds_count{
      service_name="backend-gateway",
      http_status_code!~"5.."
    }[30d]))
    /
    sum(increase(otel_http_server_request_duration_seconds_count{
      service_name="backend-gateway"
    }[30d]))
  )
) / 0.005 * 100
```

### Error Budget Policy

**Source:** [Google SRE Workbook - Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)

| Budget Remaining | Status | Current Action |
|------------------|--------|----------------|
| > 50% (Current: 92%) | **Green** | Normal development, shipping features |
| 25-50% | **Yellow** | Increase reliability focus |
| 10-25% | **Orange** | Freeze non-critical changes |
| < 10% | **Red** | All hands on reliability |
| Exhausted | **Critical** | Roll back, postmortem required |

---

## Alerting Configuration

### Multi-Burn-Rate Alerts

**Source:** [Google SRE Workbook - Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)

| Alert | Burn Rate | Budget Impact | Window | Severity |
|-------|-----------|---------------|--------|----------|
| `GatewayHighErrorRateCritical` | 14.4x | 2% in 1 hour | 5m | P0 Critical |
| `GatewayHighErrorRateWarning` | 6x | 5% in 6 hours | 30m | P1 High |
| `GatewayHighLatencyCritical` | - | P95 > 2s | 5m | P0 Critical |

### Alert Definitions (Prometheus)

```yaml
# From infra/prometheus/alert-rules.yml
groups:
  - name: gateway-slo-alerts
    rules:
      - alert: GatewayHighErrorRateCritical
        expr: |
          sum(rate(otel_http_server_request_duration_seconds_count{
            service_name="backend-gateway",
            http_status_code=~"5.."
          }[5m]))
          /
          sum(rate(otel_http_server_request_duration_seconds_count{
            service_name="backend-gateway"
          }[5m])) > 0.05
        for: 2m
        labels:
          severity: critical
          service: gateway
        annotations:
          summary: "Gateway error rate above 5% (SLO violation)"
          description: "Error rate is {{ $value | humanizePercentage }}"
          runbook: "docs/SRE_GUIDE.md#higherrorcritical"
          dashboard: "http://localhost/admin/grafana/d/A-sre-golden-signals"
```

---

## Dependencies

### Dependency SLO Impact

| Dependency | Their SLO | Protocol | Our Budget Impact | Failure Mode |
|------------|-----------|----------|-------------------|--------------|
| Chat Service | 99.9% | HTTP | Direct cascade | 503 to user |
| AI Service | 99.0% | HTTP | Partial (Gemini) | Degraded chat |
| Document Service | 99.5% | HTTP | Feature unavailable | Upload fails |
| MinIO | 99.9% | S3 | Storage unavailable | Document fails |
| Nginx | 99.99% | HTTP | Total outage | No traffic |

### Dependency SLO Math

```
Gateway max realistic SLO ≤ min(required dependencies)

Required for core functionality:
  Chat: 99.9%
  AI: 99.0%  ← Weakest link (Gemini external API)

Max Gateway SLO = 99.0% (limited by AI service)
Target Gateway SLO = 99.5% (buffer for our own issues)

Note: We target higher than AI service allows because:
1. Not all requests go to AI
2. Circuit breaker provides degraded mode
```

---

## Grafana Dashboards

### Available Dashboards

| Dashboard | UID | Purpose | Key Panels |
|-----------|-----|---------|------------|
| OTEL Metrics | `A-otel-metrics` | RED Method | Request rate, Error rate, P95 latency |
| SRE Golden Signals | `A-sre-golden-signals` | SLO tracking | Availability gauge, Error budget, Latency |
| Infrastructure USE | `A-infrastructure-use` | Container health | CPU, Memory, Network |

### Dashboard URLs

- **SRE Golden Signals:** `/admin/grafana/d/A-sre-golden-signals`
- **OTEL Metrics:** `/admin/grafana/d/A-otel-metrics`
- **Infrastructure USE:** `/admin/grafana/d/A-infrastructure-use`

---

## Runbook Links

| Scenario | Runbook | Response Time |
|----------|---------|---------------|
| High Error Rate | [SRE_GUIDE.md#higherrorcritical](../../SRE_GUIDE.md#higherrorcritical) | 5 minutes |
| High Latency | [SRE_GUIDE.md#highlatencycritical](../../SRE_GUIDE.md#highlatencycritical) | 30 minutes |
| Service Down | [SRE_GUIDE.md#servicedown](../../SRE_GUIDE.md#servicedown) | 5 minutes |
| CPU/Memory Issues | [SRE_GUIDE.md#highcpuutilization](../../SRE_GUIDE.md#highcpuutilization) | 30 minutes |

---

## Review History

| Date | Reviewer | Changes |
|------|----------|---------|
| 2025-01-12 | @platform-team | Initial SLOs defined based on baseline metrics |

---

## References

### SRE Foundations

- [Google SRE Workbook - Implementing SLOs](https://sre.google/workbook/implementing-slos/)
- [Google SRE Workbook - Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)
- [Google SRE Workbook - Monitoring](https://sre.google/workbook/monitoring/)

### Error Budgets

- [Nobl9 - Complete Guide to Error Budgets](https://www.nobl9.com/resources/a-complete-guide-to-error-budgets-setting-up-slos-slis-and-slas-to-maintain-reliability)
- [Google Cloud - Defining SLOs](https://cloud.google.com/architecture/defining-SLOs)

### Monitoring Methods

- [Grafana - The RED Method](https://grafana.com/blog/the-red-method-how-to-instrument-your-services/)
- [Brendan Gregg - USE Method](https://www.brendangregg.com/usemethod.html)
- [Better Stack - SRE Golden Signals](https://betterstack.com/community/guides/monitoring/sre-golden-signals/)

### OpenTelemetry

- [OpenTelemetry HTTP Metrics](https://opentelemetry.io/docs/specs/semconv/http/http-metrics/)
- [OpenTelemetry Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/)

---

**Related Documents:**

- [Admin Portal Documentation](../../ADMIN_PORTAL.md) - Tool URLs and debugging workflows
- [SRE Guide](../../SRE_GUIDE.md) - Full SRE practices and runbooks
- [Architecture](../../ARCHITECTURE.md) - System architecture overview
