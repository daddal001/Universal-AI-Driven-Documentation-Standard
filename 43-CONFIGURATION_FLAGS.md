---
title: "Configuration & Feature Flags"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2026-03-07"
last_updated: "2026-03-07"
version: "1.0.0"
---

# Configuration & Feature Flags

> **Goal:** Establish a standard for documenting application configuration, environment variables, and feature flags so that operators, developers, and AI agents can discover, validate, and reason about system behavior.

---

## 1. Why Document Configuration?

Misconfiguration is the leading cause of production incidents. Undocumented config means:

* Operators guess at valid values and acceptable ranges.
* AI agents cannot reason about system behavior or auto-remediate.
* Onboarding developers copy `.env.example` files without understanding constraints.
* Feature flags accumulate as permanent, undocumented forks in behavior.

This standard ensures every configurable knob is discoverable, typed, and constrained.

---

## 2. Configuration Schema

Every service or application MUST maintain a configuration reference document. Use a structured format that is both human-readable and machine-parseable.

### 2.1 Required Fields Per Config Item

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Environment variable or config key name |
| `type` | Yes | Data type: `string`, `integer`, `float`, `boolean`, `enum`, `duration`, `url`, `path`, `json` |
| `default` | Yes | Default value, or `REQUIRED` if no default |
| `description` | Yes | What this config controls |
| `constraints` | Conditional | Valid range, regex pattern, enum values, min/max |
| `example` | Yes | A realistic example value |
| `sensitive` | Yes | `true` if this is a secret (passwords, tokens, keys) |
| `since` | No | Version when this config was introduced |
| `deprecated` | No | Version when deprecated, with migration path |

### 2.2 Example: Configuration Reference Table

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `DATABASE_URL` | `url` | REQUIRED | PostgreSQL connection string | Must start with `postgresql://` | Yes |
| `LOG_LEVEL` | `enum` | `info` | Application log verbosity | `debug`, `info`, `warn`, `error` | No |
| `MAX_CONNECTIONS` | `integer` | `25` | Database connection pool size | `1-500` | No |
| `CACHE_TTL` | `duration` | `5m` | Cache time-to-live | `10s-24h` | No |
| `ENABLE_DARK_LAUNCH` | `boolean` | `false` | Enable dark launch for new API | N/A | No |
| `API_KEY` | `string` | REQUIRED | Third-party API authentication key | 32-64 chars, alphanumeric | Yes |

### 2.3 Machine-Readable Schema (Optional)

For AI-agent discoverability, provide a JSON Schema or YAML schema alongside the human-readable table:

```yaml
# config-schema.yaml
properties:
  DATABASE_URL:
    type: string
    format: uri
    pattern: "^postgresql://"
    description: "PostgreSQL connection string"
    sensitive: true
  LOG_LEVEL:
    type: string
    enum: [debug, info, warn, error]
    default: info
    description: "Application log verbosity"
  MAX_CONNECTIONS:
    type: integer
    minimum: 1
    maximum: 500
    default: 25
    description: "Database connection pool size"
```

---

## 3. Environment Variable Conventions

### 3.1 Naming

| Rule | Example | Anti-pattern |
|------|---------|-------------|
| UPPER_SNAKE_CASE | `DATABASE_URL` | `databaseUrl`, `database-url` |
| Prefix with service name | `AUTH_JWT_SECRET` | `JWT_SECRET` (ambiguous in multi-service) |
| Boolean uses affirmative | `ENABLE_CACHE` | `DISABLE_CACHE`, `NO_CACHE` |
| Duration includes unit hint | `CACHE_TTL` (document unit) | `CACHE_TIME` (seconds? minutes?) |

### 3.2 `.env.example` Files

Every service MUST include a `.env.example` file that:

* Lists ALL environment variables (no hidden config)
* Uses placeholder values for secrets: `DATABASE_URL=postgresql://user:CHANGE_ME@localhost:5432/mydb`
* Groups related variables with comments
* Never contains real credentials

```bash
# .env.example

# === Database ===
DATABASE_URL=postgresql://user:CHANGE_ME@localhost:5432/mydb
MAX_CONNECTIONS=25

# === Authentication ===
AUTH_JWT_SECRET=CHANGE_ME_TO_A_RANDOM_STRING
AUTH_TOKEN_EXPIRY=15m

# === Feature Flags ===
ENABLE_DARK_LAUNCH=false
ENABLE_NEW_CHECKOUT=false
```

### 3.3 Validation at Startup

Applications SHOULD validate configuration at startup and fail fast with clear error messages:

```text
FATAL: Configuration error:
  - DATABASE_URL is required but not set
  - MAX_CONNECTIONS=9999 exceeds maximum (500)
  - LOG_LEVEL=verbose is not valid (expected: debug, info, warn, error)
```

---

## 4. Feature Flags

Feature flags (toggles) control runtime behavior without code deployment. They require special documentation because they are invisible forks in system behavior.

### 4.1 Flag Lifecycle

Every feature flag MUST have a documented lifecycle:

```text
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Proposed │───>│  Active   │───>│ Released │───>│ Removed  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │                │                │               │
  ADR/RFC         In code,         Flag removed     Code path
  created        documented        from config,     for old
                                   default=true    behavior
                                                    deleted
```

### 4.2 Flag Registry

Maintain a feature flag registry — a single document or structured file listing all flags:

| Flag | Type | Owner | Created | Target Removal | Description |
|------|------|-------|---------|----------------|-------------|
| `ENABLE_NEW_CHECKOUT` | Release | @payments-team | 2026-01-15 | 2026-04-01 | New checkout flow with Stripe v3 |
| `ENABLE_DARK_LAUNCH` | Experiment | @platform-team | 2026-02-01 | 2026-03-15 | Shadow traffic to new recommendation engine |
| `ENABLE_LEGACY_AUTH` | Ops | @auth-team | 2025-06-01 | None (kill switch) | Fallback to legacy auth if SSO fails |

### 4.3 Flag Types

| Type | Purpose | Lifespan | Example |
|------|---------|----------|---------|
| **Release** | Gate incomplete features | Days to weeks | `ENABLE_NEW_CHECKOUT` |
| **Experiment** | A/B testing, canary | Weeks to months | `ENABLE_RECOMMENDATION_V2` |
| **Ops** | Kill switches, circuit breakers | Permanent | `ENABLE_LEGACY_AUTH` |
| **Permission** | Entitlement-based access | Permanent | `ENABLE_ENTERPRISE_SSO` |

### 4.4 Flag Hygiene

* **Expiration:** Release and experiment flags MUST have a `target_removal` date.
* **Stale flag audit:** CI or scheduled jobs should flag flags past their removal date.
* **Max active flags:** Set a team limit (e.g., 15 active release flags). Exceeding it triggers cleanup.
* **Dead code removal:** When a flag is removed, delete BOTH the flag check AND the old code path.

---

## 5. Configuration Documentation Location

| Scope | Location | Format |
|-------|----------|--------|
| Service-level config | `docs/configuration.md` or `README.md` section | Table (Section 2.2) |
| Machine-readable schema | `config-schema.yaml` or `config-schema.json` | JSON Schema / YAML |
| Environment template | `.env.example` | Bash comments + placeholders |
| Feature flag registry | `docs/feature-flags.md` | Table (Section 4.2) |
| Deployment overrides | `docs/deployment.md` or Helm `values.yaml` | Per-environment tables |

---

## 6. AI-Agent Discoverability

For AI agents to reason about configuration:

* **Structured schemas** (Section 2.3) allow agents to validate config changes before applying them.
* **Constraint documentation** prevents agents from setting out-of-range values.
* **Sensitivity markers** tell agents which values must not be logged or echoed.
* **Deprecation notices** help agents suggest migration paths.

### Example: Agent-Friendly Config Comment

```yaml
# @config DATABASE_URL
# @type url
# @required true
# @sensitive true
# @pattern ^postgresql://
# @description PostgreSQL connection string for the primary database
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
```

---

## 7. Validation Checklist

- [ ] Every config item has name, type, default, description, and sensitivity flag
- [ ] `.env.example` exists and lists all variables with placeholder values
- [ ] No real credentials in `.env.example` or documentation
- [ ] Feature flags have owner, creation date, and target removal date
- [ ] Deprecated config items include migration instructions
- [ ] Machine-readable schema exists for services with >10 config items
- [ ] Startup validation fails fast on invalid config

---

## 8. Related Documents

| Document | Purpose |
|----------|---------|
| [Security & Compliance](./24-SECURITY_COMPLIANCE.md) | Secrets management |
| [Deployment](./30-DEPLOYMENT.md) | Per-environment configuration |
| [ADR](./33-ADR.md) | Decisions behind config choices |
| [Observability](./41-OBSERVABILITY.md) | Config-driven logging levels |

---

**Previous:** [42 - Architecture](./42-ARCHITECTURE.md)
**Next:** [44 - Error Catalog](./44-ERROR_CATALOG.md)
