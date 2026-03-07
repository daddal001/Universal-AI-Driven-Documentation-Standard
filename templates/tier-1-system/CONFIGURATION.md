---
title: "[Service Name] Configuration Reference"
type: "configuration"
status: "approved"
owner: "@team-name"
classification: "internal"
created: "YYYY-MM-DD"
last_updated: "YYYY-MM-DD"
version: "1.0.0"
---

# [Service Name] Configuration Reference

> All environment variables and feature flags for `[service-name]`.

---

## Environment Variables

### [Category 1 — e.g., Database]

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `SVC_DATABASE_URL` | `url` | REQUIRED | Database connection string | Must start with `postgresql://` | Yes |
| `SVC_DB_MAX_CONNECTIONS` | `integer` | `25` | Connection pool size | `1-500` | No |

### [Category 2 — e.g., Authentication]

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `SVC_AUTH_SECRET` | `string` | REQUIRED | Signing key | Min 32 chars | Yes |
| `SVC_AUTH_EXPIRY` | `duration` | `15m` | Token TTL | `1m-24h` | No |

### Observability

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `LOG_LEVEL` | `enum` | `info` | Log verbosity | `debug`, `info`, `warn`, `error` | No |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | `url` | `http://localhost:4317` | OpenTelemetry collector | Valid URL | No |

---

## `.env.example`

```bash
# === [Category 1] ===
SVC_DATABASE_URL=postgresql://user:CHANGE_ME@localhost:5432/mydb
SVC_DB_MAX_CONNECTIONS=25

# === [Category 2] ===
SVC_AUTH_SECRET=CHANGE_ME_TO_A_RANDOM_STRING
SVC_AUTH_EXPIRY=15m

# === Observability ===
LOG_LEVEL=info
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

---

## Feature Flags

| Flag | Type | Owner | Created | Target Removal | Description |
|------|------|-------|---------|----------------|-------------|
| `ENABLE_[FEATURE]` | Release | @team | YYYY-MM-DD | YYYY-MM-DD | [What this flag controls] |
| `ENABLE_LEGACY_[X]` | Ops | @team | YYYY-MM-DD | None (kill switch) | [Fallback description] |

<!--
Flag types:
- Release: Gates incomplete features (days to weeks)
- Experiment: A/B testing (weeks to months)
- Ops: Kill switches, circuit breakers (permanent)
- Permission: Entitlement-based access (permanent)
-->

---

## Startup Validation

The service validates all configuration at startup. Missing or invalid config produces:

```text
FATAL: Configuration errors:
  - SVC_DATABASE_URL is required but not set
  - SVC_AUTH_SECRET is required but not set
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Service README](./README.md) | Service overview |
| [Error Catalog](./errors.md) | Service error codes |
| [Deployment Guide](./deployment.md) | Per-environment config |
