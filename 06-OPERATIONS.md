---
title: "Operations Documentation"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-12"
version: "1.1.0"
---



> Documentation for operational excellence: runbooks, lifecycle, freshness, and incident response.

---

## Table of Contents

1. [Document Lifecycle](#document-lifecycle)
2. [Freshness Requirements](#freshness-requirements)
3. [Runbook Standards](#runbook-standards)
4. [Observability Linking](#observability-linking)

---

## Document Lifecycle

### Lifecycle States

| State | Description | Visual Indicator | Max Duration |
|-------|-------------|------------------|--------------|
| **DRAFT** | Initial creation | `[DRAFT]` prefix | Until review |
| **REVIEW** | Under peer review | Open PR | 5 business days |
| **APPROVED** | Production-ready | No prefix | Active |
| **STALE** | Exceeded freshness | CI warning | 90 days max |
| **DEPRECATED** | Being phased out | Deprecation banner | 90 days |
| **ARCHIVED** | No longer active | Moved to `archive/` | Permanent |

### State Transitions

```text
DRAFT → REVIEW → APPROVED → STALE → DEPRECATED → ARCHIVED
                    ↑           ↓
                    └── refresh ─┘
```

### Deprecation Format

```markdown
> ⚠️ **DEPRECATED** (December 2025)
>
> This document is deprecated. Use [New Document](./YOUR_NEW_DOC.md) instead.
>
> **Removal Date:** March 2026
```

---

## Freshness Requirements

### By Document Type

| Document Type | Maximum Age | Review Cadence |
|---------------|-------------|----------------|
| Service README | 90 days | Quarterly |
| API Documentation | 30 days | Monthly |
| Architecture Docs | 180 days | Semi-annually |
| Tutorials/Guides | 90 days | Quarterly |
| P0 Runbooks | 30 days | Monthly |
| P1 Runbooks | 90 days | Quarterly |

### Required Headers

Every README **must** include:

```markdown
**Last Updated:** December 2025
**Last Verified:** December 2025
**Next Review:** March 2026
```

### Staleness Enforcement

| Days Overdue | Action |
|--------------|--------|
| 1-7 days | Warning in CI |
| 8-14 days | Blocks PRs |
| 15+ days | Escalation to lead |

### Freshness Automation

Run automated freshness checks using the provided script:

```bash
# Check all docs with default 90-day threshold
./docs/standards/scripts/check-freshness.sh

# Check specific directory
./docs/standards/scripts/check-freshness.sh docs/api

# Custom threshold
THRESHOLD_DAYS=30 ./docs/standards/scripts/check-freshness.sh
```

### CI Workflow for SLA Monitoring

```yaml
# .github/workflows/docs-sla.yml
name: Documentation SLA Check
on:
  schedule:
    - cron: '0 9 * * 1'  # Weekly Monday 9 AM
  workflow_dispatch:

jobs:
  check-freshness:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Need git history for date checks
      - name: Check documentation freshness
        run: ./docs/standards/scripts/check-freshness.sh docs/
      - name: Notify on failure
        if: failure()
        uses: slackapi/slack-github-action@v1
        with:
          channel-id: ${{ secrets.DOCS_ALERT_CHANNEL }}
          payload: |
            {"text": "⚠️ Documentation SLA violation detected - stale docs found"}
```

## Runbook Standards

### Runbook Testing Frequency

| Severity | Test Frequency | Auto-Archive After |
|----------|----------------|-------------------|
| **P0 (Critical)** | Monthly | 60 days untested |
| **P1 (High)** | Quarterly | 90 days untested |
| **P2 (Medium)** | Semi-annually | 180 days untested |
| **P3 (Low)** | Annually | 365 days untested |

### Required Frontmatter

```yaml
---
title: "Database Failover Runbook"
type: "runbook"
severity_trigger: "P0"
last_tested: "2025-11-15"
tested_by: "@sre-lead"
test_outcome: "PASS"
next_test_due: "2025-12-15"
---
```

### Runbook Structure

1. **Trigger Conditions** — When to use
2. **Severity Assessment** — P0/P1/P2/P3
3. **Prerequisites** — What you need before starting
4. **Step-by-Step Actions** — Numbered, unambiguous
5. **Expected Outcomes** — What success looks like
6. **Rollback** — How to undo if needed
7. **Escalation Path** — Who to contact
8. **Post-Incident Actions** — Follow-up tasks

### Executable Runbooks

Transform static runbooks into executable automation for reliability and consistency.

#### Supported Formats

| Format | Use Case | Tool |
|--------|----------|------|
| **Ansible Playbook** | Infrastructure tasks | `ansible-playbook` |
| **Azure Runbook** | Cloud automation | Azure Automation |
| **Bash Script** | Simple commands | Native execution |
| **Python Script** | Complex logic | `python` |
| **Kubernetes Job** | Container tasks | `kubectl apply` |

#### Ansible Runbook Example

```yaml
# runbooks/database-failover.yml
---
- name: Database Failover Runbook
  hosts: database_servers
  become: yes
  vars:
    doc_ref: "https://docs.example.com/runbooks/db-failover"
    tested: "2025-12-01"

  pre_tasks:
    - name: Verify prerequisites
      assert:
        that:
          - replica_host is defined
          - backup_verified == true
        fail_msg: "Prerequisites not met. See {{ doc_ref }}"

  tasks:
    - name: Promote replica to primary
      postgresql_query:
        db: postgres
        query: "SELECT pg_promote()"
      register: promote_result

    - name: Update DNS records
      route53:
        zone: example.com
        record: db.example.com
        value: "{{ replica_ip }}"
```

#### Runbook Testing with Chaos Engineering

Integrate runbooks with chaos experiments:

```yaml
# chaos/test-database-failover.yml
---
experiment:
  name: "Test Database Failover Runbook"
  schedule: "monthly"

steady_state_hypothesis:
  - probe:
      name: "Application responds to /health"
      type: http
      url: "http://app/health"

method:
  - action:
      name: "Terminate primary database"
      type: process
      target: "postgres-primary"

  - action:
      name: "Execute failover runbook"
      type: ansible
      playbook: "runbooks/database-failover.yml"

rollback:
  - action:
      name: "Restore primary if needed"
      type: ansible
      playbook: "runbooks/database-restore.yml"
```

#### Pre-Flight Checks

Every executable runbook MUST include:

```bash
#!/bin/bash
# runbooks/pre-flight.sh

# Exit on any error
set -euo pipefail

# Check prerequisites
echo "Running pre-flight checks..."
kubectl auth can-i get pods || { echo "❌ No kubectl access"; exit 1; }
test -f ~/.kube/config || { echo "❌ No kubeconfig"; exit 1; }
curl -sf http://vault:8200/v1/sys/health || { echo "❌ Vault unavailable"; exit 1; }

echo "✅ All pre-flight checks passed"
```

---

## Observability Linking

### Observability Context

Every runbook **must** include the following "Observability Context" to speed up debugging:

* **Logs**: Example log lines to grep for (e.g., `grep "Connection refused" /var/log/app.log`).
* **Metrics**: The exact PromQL or Datadog query that triggered the alert.
* **Tracing**: The expected Trace ID format (e.g., `x-request-id`) and the entry point service.

### Alert-to-Runbook Chain

Every alert **must** link to a runbook:

```yaml
# alerting/rules/backend-gateway.yml
- alert: HighErrorRate
  annotations:
    runbook_url: "https://github.com/org/repo/docs/operations/runbooks/HIGH_ERRORS.md"
    dashboard_url: "https://grafana.example.com/d/gateway-errors"
    escalation: "@backend-team, then @sre-lead after 30min"
```

### Required Alert Annotations

| Annotation | Required | Purpose |
|------------|----------|---------|
| `runbook_url` | ✅ Yes | Link to resolution steps |
| `dashboard_url` | ✅ Yes | Link to metrics |
| `escalation` | ✅ Yes | Who and when to contact |
| `summary` | ✅ Yes | Human-readable description |

### Dashboard Documentation

Every dashboard must document:

| Element | Purpose |
|---------|---------|
| **Purpose** | What this dashboard shows |
| **Audience** | Who should use it |
| **Panels** | What each panel displays |
| **Normal Ranges** | Expected values |
| **Troubleshooting** | Links to runbooks |

### OpenTelemetry Semantic Conventions

Document observability using OpenTelemetry semantic conventions for consistency:

#### Required Trace Correlation

Every runbook and troubleshooting doc MUST include:

| Field | Convention | Example |
|-------|------------|---------|
| **Trace ID format** | W3C Trace Context | `traceparent: 00-{trace-id}-{span-id}-01` |
| **Log correlation** | `trace_id`, `span_id` fields | `grep "trace_id=abc123"` |
| **Metric labels** | `service.name`, `service.namespace` | `service_errors_total{service_name="gateway"}` |

#### Semantic Convention Queries Template

Include in runbooks:

```markdown
## Observability

### Logs
\`\`\`bash
# Find related logs by trace
grep "trace_id=<TRACE_ID>" /var/log/app/*.log
# Structured logging query
jq 'select(.trace_id == "<TRACE_ID>")' logs.json
\`\`\`

### Metrics (PromQL)
\`\`\`promql
# Error rate for this service
rate(http_server_request_duration_seconds_count{
  service_name="<SERVICE>",
  http_response_status_code=~"5.."
}[5m])
\`\`\`

### Traces
- Entry service: `<SERVICE_NAME>`
- Trace visualization: [Tempo/Jaeger](${TRACE_URL}/<TRACE_ID>)
```

---

## Emergency Documentation Protocol

### When Emergency Protocol Applies

| Severity | Bypass Review? | Required Actions |
|----------|----------------|------------------|
| **P0** | ✅ Yes | Update within 24 hours |
| **P1** | ⚠️ Limited | Self-review + async approval |
| **P2-P3** | ❌ No | Normal process |

### Emergency Update Process

1. Make necessary changes without review
2. Create PR with `emergency-docs` label within 24 hours
3. Get retrospective approval within 48 hours
4. Link documentation PR in incident report

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Quality](./05-QUALITY.md) | Quality standards |
| [Governance](./07-GOVERNANCE.md) | Ownership |

---

**Previous:** [05 - Quality](./05-QUALITY.md)
**Next:** [07 - Governance](./07-GOVERNANCE.md)
