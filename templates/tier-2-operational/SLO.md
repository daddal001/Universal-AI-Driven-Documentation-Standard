---
title: "[Service] SLO Document"
type: "slo"
status: "approved"
owner: "@service-owner"
classification: "internal"
created: "2025-12-14"
last_updated: "2025-01-12"
version: "2.0.0"
next_review: "2025-04-12"
---

# [Service] Service Level Objectives

Reliability targets and error budgets for [service]. This document defines the availability, latency, and throughput commitments for service owners, SREs, and stakeholders. Review quarterly to ensure targets remain appropriate.

**Based on:** [Google SRE Workbook - Implementing SLOs](https://sre.google/workbook/implementing-slos/)

---

## Service Overview

| Property | Value |
|----------|-------|
| **Service** | [Service Name] |
| **Owner** | @team-name |
| **Tier** | Tier 1 / Tier 2 / Tier 3 |
| **Dependencies** | [List critical dependencies] |

---

## SLI Definitions

Service Level Indicators (SLIs) are the quantitative measurements of service level.

**Source:** [Google SRE Workbook - Implementing SLOs](https://sre.google/workbook/implementing-slos/)

### Availability SLI

```
Availability = (Good Events / Total Events) × 100%

Where:
  Good Events = Requests returning non-5xx status
  Total Events = All requests

PromQL:
1 - (
  sum(rate(http_server_request_duration_seconds_count{http_status_code=~"5.."}[5m]))
  /
  sum(rate(http_server_request_duration_seconds_count[5m]))
)
```

### Latency SLI

```
Latency = Time from request received to response sent

PromQL (P95):
histogram_quantile(0.95,
  sum(rate(http_server_request_duration_seconds_bucket[5m])) by (le)
)
```

---

## SLOs

### Availability

| Metric | Target | Window | Current |
|--------|--------|--------|---------|
| Successful requests | ≥ 99.9% | 30 days | [XX.XX%] |

**Definition:** `(total_requests - 5xx_errors) / total_requests`

**Dashboard:** [Grafana Link](https://grafana.example.com/d/availability)

### Latency

| Percentile | Target | Window | Current |
|------------|--------|--------|---------|
| p50 | ≤ 50ms | 30 days | [XXms] |
| p95 | ≤ 150ms | 30 days | [XXms] |
| p99 | ≤ 200ms | 30 days | [XXms] |

**Definition:** Time from request received to response sent

**Dashboard:** [Grafana Link](https://grafana.example.com/d/latency)

### Throughput

| Metric | Target | Window | Current |
|--------|--------|--------|---------|
| Requests per second | Handle ≥ 1000 RPS | Peak | [XXX RPS] |

---

## Error Budget

Error budgets quantify acceptable unreliability and balance feature velocity with reliability work.

**Source:** [Nobl9 - Complete Guide to Error Budgets](https://www.nobl9.com/resources/a-complete-guide-to-error-budgets-setting-up-slos-slis-and-slas-to-maintain-reliability)

### Error Budget Calculation

```
Error Budget = (1 - SLO Target) × Measurement Window

Example for 99.9% SLO over 30 days:
Error Budget = (1 - 0.999) × 30 × 24 × 60 minutes
             = 0.001 × 43,200 minutes
             = 43.2 minutes
```

### Error Budget Table

| SLO Target | Monthly Budget | Weekly Budget | Daily Budget |
|------------|----------------|---------------|--------------|
| 99.99% | 4.32 min | 1 min | 8.6 sec |
| 99.9% | 43.2 min | 10 min | 1.4 min |
| 99.5% | 3.6 hours | 50 min | 7.2 min |
| 99.0% | 7.2 hours | 1.7 hrs | 14.4 min |

### Current Error Budget Status

| SLO | Budget (30d) | Consumed | Remaining |
|-----|--------------|----------|-----------|
| Availability 99.9% | 43.2 min | [XX min] | [XX min] |
| Latency p99 < 200ms | 0.1% of requests | [X.XX%] | [X.XX%] |

### Error Budget Policy

**Source:** [Google SRE Workbook - Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)

| Budget Remaining | Status | Action |
|------------------|--------|--------|
| > 50% | **Green** | Normal development velocity |
| 25-50% | **Yellow** | Prioritize reliability work |
| 10-25% | **Orange** | Freeze non-critical changes |
| < 10% | **Red** | All hands on reliability |
| Exhausted | **Critical** | Roll back, postmortem required |

---

## Alerting Strategy

### Multi-Burn-Rate Alerting

Multi-burn-rate alerting balances alert sensitivity with noise reduction. Faster burn rates trigger faster alerts for acute issues; slower burn rates catch gradual degradation.

**Source:** [Google SRE Workbook - Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)

```
Burn Rate = Actual Error Rate / Tolerated Error Rate

Where:
  Tolerated Error Rate = (1 - SLO) / Window

Example:
  SLO = 99.9% over 30 days
  Tolerated Error Rate = 0.001 / 30 days = 0.000033/day
  If actual errors = 0.1%, Burn Rate = 0.001 / 0.000033 = 30x
```

### Multi-Burn-Rate Windows

| Burn Rate | Budget Consumed | Alert Window | Response Time | Severity |
|-----------|-----------------|--------------|---------------|----------|
| 14.4x | 2% in 1 hour | 5m short / 1h long | 5 minutes | P0 Critical |
| 6x | 5% in 6 hours | 30m short / 6h long | 30 minutes | P1 High |
| 3x | 10% in 3 days | 6h short / 3d long | Next day | P2 Medium |

### Alert Configuration

| Alert | Condition | Severity | Runbook |
|-------|-----------|----------|---------|
| High Error Rate Critical | 5xx > 5% for 2m | P0 | [Link](../runbooks/HIGH_ERRORS.md) |
| High Error Rate Warning | 5xx > 1% for 5m | P1 | [Link](../runbooks/HIGH_ERRORS.md) |
| High Latency | p95 > target for 5m | P1 | [Link](../runbooks/HIGH_LATENCY.md) |
| SLO Fast Burn | 14.4x burn rate | P0 | [Link](../runbooks/SLO_BURN.md) |
| SLO Slow Burn | 3x burn rate | P2 | [Link](../runbooks/SLO_BURN.md) |

---

## Dependencies

| Dependency | Their SLO | Our Budget Impact | If Down |
|------------|-----------|-------------------|---------|
| [Database] | 99.99% | Blocks us at 99.99% | Service unavailable |
| [Cache] | 99.9% | Degrades performance | High latency |
| [External API] | 99.5% | Feature unavailable | Graceful degradation |

### Dependency SLO Calculation

Your service cannot be more reliable than your dependencies:

```
Max Service SLO ≤ min(Dependency SLOs)

Example:
  Database: 99.99%
  Cache: 99.9%
  External API: 99.5%

  Max realistic SLO = 99.5% (limited by weakest dependency)
```

---

## Monitoring Methodologies

### RED Method (Services)

**Source:** [Grafana - The RED Method](https://grafana.com/blog/the-red-method-how-to-instrument-your-services/)

| Signal | Definition | Why It Matters |
|--------|------------|----------------|
| **R**ate | Requests per second | Traffic volume, capacity planning |
| **E**rrors | Failed requests per second | User impact, SLO compliance |
| **D**uration | Request latency distribution | User experience, performance |

### USE Method (Infrastructure)

**Source:** [Brendan Gregg - USE Method](https://www.brendangregg.com/usemethod.html)

| Signal | Definition | Why It Matters |
|--------|------------|----------------|
| **U**tilization | % time resource busy | Capacity limits |
| **S**aturation | Work queued/waiting | Bottleneck identification |
| **E**rrors | Error count | Hardware/resource failures |

### Four Golden Signals (SRE)

**Source:** [Google SRE Workbook - Monitoring](https://sre.google/workbook/monitoring/)

| Signal | Mapped To | Dashboard |
|--------|-----------|-----------|
| Latency | RED Duration | Latency percentiles panel |
| Traffic | RED Rate | Request rate panel |
| Errors | RED Errors | Error rate panel |
| Saturation | USE Utilization | Infrastructure dashboard |

---

## Review History

| Date | Reviewer | Changes |
|------|----------|---------|
| [YYYY-MM-DD] | @reviewer | Initial SLOs defined |
| [YYYY-MM-DD] | @reviewer | Adjusted latency target |

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
