---
title: "Configuration Reference — Auth Service"
type: "example"
status: "approved"
classification: "internal"
owner: "@identity-team"
created: "2026-03-07"
last_updated: "2026-03-07"
version: "1.0.0"
---

# Configuration Reference — Auth Service

> All environment variables for `auth-service`. See [43-CONFIGURATION_FLAGS.md](../43-CONFIGURATION_FLAGS.md) for the standard.

---

## Environment Variables

### Database

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `AUTH_DATABASE_URL` | `url` | REQUIRED | PostgreSQL connection string | Must start with `postgresql://` | Yes |
| `AUTH_DB_MAX_CONNECTIONS` | `integer` | `25` | Connection pool size | `1-500` | No |
| `AUTH_DB_IDLE_TIMEOUT` | `duration` | `5m` | Idle connection timeout | `30s-1h` | No |

### JWT

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `AUTH_JWT_SECRET` | `string` | REQUIRED | HMAC signing key for JWT tokens | Min 32 chars | Yes |
| `AUTH_JWT_ISSUER` | `url` | `https://auth.example.com` | JWT `iss` claim value | Valid URL | No |
| `AUTH_JWT_EXPIRY` | `duration` | `15m` | Access token TTL | `1m-24h` | No |
| `AUTH_REFRESH_TOKEN_EXPIRY` | `duration` | `7d` | Refresh token TTL | `1h-90d` | No |

### OIDC / SSO

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `AUTH_OIDC_PROVIDER_URL` | `url` | REQUIRED | OIDC discovery endpoint | Must serve `.well-known/openid-configuration` | No |
| `AUTH_OIDC_CLIENT_ID` | `string` | REQUIRED | OIDC client identifier | N/A | No |
| `AUTH_OIDC_CLIENT_SECRET` | `string` | REQUIRED | OIDC client secret | N/A | Yes |
| `AUTH_OIDC_REDIRECT_URI` | `url` | REQUIRED | OAuth callback URL | Must match provider config | No |

### Rate Limiting

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `AUTH_LOGIN_RATE_LIMIT` | `integer` | `5` | Max login attempts per IP per 15min window | `1-100` | No |
| `AUTH_LOGIN_LOCKOUT_DURATION` | `duration` | `15m` | Account lockout duration after rate limit hit | `1m-24h` | No |

### Observability

| Name | Type | Default | Description | Constraints | Sensitive |
|------|------|---------|-------------|-------------|-----------|
| `LOG_LEVEL` | `enum` | `info` | Log verbosity | `debug`, `info`, `warn`, `error` | No |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | `url` | `http://localhost:4317` | OpenTelemetry collector endpoint | Valid URL | No |
| `OTEL_SERVICE_NAME` | `string` | `auth-service` | Service name in traces | N/A | No |

---

## `.env.example`

```bash
# === Database ===
AUTH_DATABASE_URL=postgresql://auth_user:CHANGE_ME@localhost:5432/auth_db
AUTH_DB_MAX_CONNECTIONS=25
AUTH_DB_IDLE_TIMEOUT=5m

# === JWT ===
AUTH_JWT_SECRET=CHANGE_ME_TO_A_RANDOM_STRING_AT_LEAST_32_CHARS
AUTH_JWT_ISSUER=https://auth.example.com
AUTH_JWT_EXPIRY=15m
AUTH_REFRESH_TOKEN_EXPIRY=7d

# === OIDC / SSO ===
AUTH_OIDC_PROVIDER_URL=https://accounts.google.com
AUTH_OIDC_CLIENT_ID=your-client-id
AUTH_OIDC_CLIENT_SECRET=CHANGE_ME
AUTH_OIDC_REDIRECT_URI=https://app.example.com/auth/callback

# === Rate Limiting ===
AUTH_LOGIN_RATE_LIMIT=5
AUTH_LOGIN_LOCKOUT_DURATION=15m

# === Observability ===
LOG_LEVEL=info
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_SERVICE_NAME=auth-service
```

---

## Feature Flags

| Flag | Type | Owner | Created | Target Removal | Description |
|------|------|-------|---------|----------------|-------------|
| `ENABLE_PASSKEY_AUTH` | Release | @identity-team | 2026-02-01 | 2026-04-15 | WebAuthn/Passkey authentication flow |
| `ENABLE_SESSION_V2` | Release | @identity-team | 2026-01-15 | 2026-03-30 | New session management with sliding expiry |
| `ENABLE_LEGACY_OAUTH` | Ops | @identity-team | 2025-06-01 | None (kill switch) | Fallback to legacy OAuth if OIDC provider is down |
| `ENABLE_MFA_ENFORCEMENT` | Permission | @security-team | 2026-03-01 | None (permanent) | Require MFA for admin roles |

---

## Startup Validation

The auth service validates all configuration at startup and fails fast:

```text
$ AUTH_JWT_SECRET="" AUTH_DATABASE_URL="" ./auth-service

FATAL: Configuration errors:
  - AUTH_DATABASE_URL is required but not set
  - AUTH_JWT_SECRET is required but not set
  - AUTH_OIDC_PROVIDER_URL is required but not set
  - AUTH_OIDC_CLIENT_ID is required but not set
  - AUTH_OIDC_CLIENT_SECRET is required but not set
  - AUTH_OIDC_REDIRECT_URI is required but not set
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Auth Service README](../services/auth/README.md) | Service overview |
| [ADR-0007: Authentication](../adr/0007-authentication.md) | Why OIDC via Auth0 |
| [Error Catalog: AUTH-*](./example-error-catalog.md) | Auth error codes |
