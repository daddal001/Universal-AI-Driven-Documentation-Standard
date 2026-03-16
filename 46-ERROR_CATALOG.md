---
title: "Error Catalog"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2026-03-07"
last_updated: "2026-03-07"
version: "1.0.0"
---

# Error Catalog

> **Goal:** Define a standard for cataloging, formatting, and documenting error codes so that users, operators, and AI agents can quickly diagnose and resolve issues.

---

## 1. Why an Error Catalog?

Every system produces errors. Without a catalog:

* Users see cryptic codes (`ERR_4012`) with no explanation.
* Support teams reinvent troubleshooting steps for the same error repeatedly.
* AI agents cannot map errors to remediation actions.
* Developers add new error codes without checking for duplicates or conflicts.

An error catalog is a single source of truth that maps every error code to its meaning, cause, and resolution.

---

## 2. Error Code Format

### 2.1 Structure

Use a namespaced, hierarchical error code format:

```text
<SERVICE>-<CATEGORY>-<NUMBER>

Examples:
  AUTH-TOKEN-001    → Authentication service, token category, first error
  PAY-CHARGE-003   → Payment service, charge category, third error
  API-RATE-001     → API gateway, rate limiting, first error
```

### 2.2 Naming Rules

| Rule | Example | Anti-pattern |
|------|---------|-------------|
| 3-4 letter service prefix | `AUTH`, `PAY`, `API` | `AUTHENTICATION`, `A` |
| Category groups related errors | `TOKEN`, `CHARGE`, `RATE` | Flat numbering (`AUTH-001`) |
| Sequential numbering within category | `001`, `002`, `003` | Gaps (`001`, `005`, `042`) |
| Zero-padded to 3 digits | `001` | `1` |

### 2.3 Reserved Ranges

Reserve error number ranges for common categories across all services:

| Range | Category | Description |
|-------|----------|-------------|
| `000-099` | Validation | Input validation errors |
| `100-199` | Authentication | Auth and identity errors |
| `200-299` | Authorization | Permission and access errors |
| `300-399` | Resource | Not found, conflict, gone |
| `400-499` | External | Third-party service failures |
| `500-599` | Internal | Unexpected internal errors |

---

## 3. Error Catalog Entry

Each error code MUST have a catalog entry with the following fields:

### 3.1 Required Fields

| Field | Description |
|-------|-------------|
| `code` | The error code (e.g., `AUTH-TOKEN-001`) |
| `http_status` | HTTP status code if applicable (e.g., `401`) |
| `title` | Short human-readable title |
| `description` | What happened (1-2 sentences) |
| `cause` | Why this error occurs |
| `resolution` | Steps the user/operator can take to fix it |
| `severity` | `info`, `warning`, `error`, `critical` |

### 3.2 Optional Fields

| Field | Description |
|-------|-------------|
| `retry` | Whether the request is safe to retry (`true`, `false`, `with-backoff`) |
| `user_message` | Safe message to show end-users (no internal details) |
| `internal_details` | Technical details for operators (not shown to users) |
| `related_errors` | Other error codes that commonly occur together |
| `since` | Version when this error was introduced |
| `log_level` | Recommended log level when this error occurs |

### 3.3 Example Entry

```yaml
# errors/AUTH-TOKEN-001.yaml
code: AUTH-TOKEN-001
http_status: 401
title: "Expired Access Token"
description: "The provided access token has expired and is no longer valid."
cause: >
  Access tokens have a configurable TTL (default: 15 minutes).
  This error occurs when a request is made with a token past its expiration.
resolution:
  - "Refresh the token using the refresh token endpoint: POST /auth/refresh"
  - "If the refresh token is also expired, re-authenticate: POST /auth/login"
  - "Check that the client clock is synchronized (NTP drift can cause premature expiration)"
severity: warning
retry: false
user_message: "Your session has expired. Please sign in again."
related_errors:
  - AUTH-TOKEN-002  # Invalid token signature
  - AUTH-TOKEN-003  # Revoked token
```

---

## 4. Catalog Formats

### 4.1 Markdown Table (Simple)

For smaller projects, a single markdown file works well:

```markdown
# Error Catalog

## AUTH — Authentication Service

| Code | HTTP | Title | Resolution |
|------|------|-------|------------|
| AUTH-TOKEN-001 | 401 | Expired access token | Refresh or re-authenticate |
| AUTH-TOKEN-002 | 401 | Invalid token signature | Check signing key rotation |
| AUTH-TOKEN-003 | 401 | Revoked token | Re-authenticate |
| AUTH-CRED-001 | 401 | Invalid credentials | Check username/password |
| AUTH-CRED-002 | 429 | Too many login attempts | Wait 15 minutes |
```

### 4.2 Structured Files (Scalable)

For larger systems, use individual YAML/JSON files per error:

```text
errors/
├── AUTH/
│   ├── TOKEN/
│   │   ├── 001.yaml    # Expired access token
│   │   ├── 002.yaml    # Invalid token signature
│   │   └── 003.yaml    # Revoked token
│   └── CRED/
│       ├── 001.yaml    # Invalid credentials
│       └── 002.yaml    # Too many login attempts
├── PAY/
│   └── CHARGE/
│       ├── 001.yaml    # Payment declined
│       └── 002.yaml    # Insufficient funds
└── index.yaml          # Auto-generated index of all errors
```

### 4.3 Generated Documentation

Error catalogs stored as structured data can be rendered into:

* **API documentation** — error codes in endpoint response schemas
* **Searchable error reference** — static site with search
* **CLI help** — `myapp errors AUTH-TOKEN-001` prints resolution steps
* **AI agent context** — agents load the catalog to auto-diagnose

---

## 5. Error Messages in Code

### 5.1 Error Response Format

Standardize the error response body across all services:

```json
{
  "error": {
    "code": "AUTH-TOKEN-001",
    "title": "Expired Access Token",
    "message": "Your session has expired. Please sign in again.",
    "details": {
      "expired_at": "2026-03-07T10:30:00Z",
      "token_id": "tok_abc123"
    },
    "docs_url": "https://docs.example.com/errors/AUTH-TOKEN-001"
  }
}
```

### 5.2 Rules for Error Messages

| Rule | Example | Anti-pattern |
|------|---------|-------------|
| Include the error code | `AUTH-TOKEN-001: Token expired` | `Token expired` |
| User messages hide internals | `Please sign in again` | `JWT validation failed at jwt.go:142` |
| Link to documentation | `docs_url` field in response | No reference to docs |
| Include actionable resolution | `Refresh using POST /auth/refresh` | `Contact support` |
| Use consistent structure | Same JSON shape for all errors | Different shapes per service |

---

## 6. Error Documentation Workflow

### 6.1 Adding a New Error

1. Check reserved ranges (Section 2.3) for the correct category
2. Pick the next sequential number in that category
3. Create the catalog entry with all required fields (Section 3.1)
4. Add the error code constant to the codebase
5. Include the `docs_url` in the error response
6. Update the generated error reference

### 6.2 Deprecating an Error

* Mark the error as `deprecated` in the catalog with a replacement code
* Keep the entry for at least 2 major versions
* Log a warning when the deprecated error is triggered
* Update documentation to point to the replacement

---

## 7. AI-Agent Integration

For AI agents to auto-diagnose errors:

* **Structured catalog** (YAML/JSON) allows agents to look up error codes programmatically.
* **Resolution steps** give agents a decision tree for remediation.
* **Retry guidance** tells agents whether to retry or escalate.
* **Related errors** help agents identify cascading failures.
* **Severity levels** help agents prioritize which errors to address first.

---

## 8. Validation Checklist

* [ ] Error code format follows `SERVICE-CATEGORY-NUMBER` convention
* [ ] Every error code has a catalog entry with required fields
* [ ] User-facing messages contain no internal implementation details
* [ ] Error responses include `code`, `title`, `message`, and `docs_url`
* [ ] No duplicate error codes across services
* [ ] Deprecated errors have replacement codes documented
* [ ] Error catalog is versioned alongside the codebase

---

## 9. Related Documents

| Document | Purpose |
|----------|---------|
| [API Documentation](./06-API_DOCUMENTATION.md) | Error codes in API responses |
| [Troubleshooting](./36-TROUBLESHOOTING.md) | Troubleshooting guides per error |
| [Observability](./43-OBSERVABILITY.md) | Error logging and alerting |
| [Configuration & Flags](./45-CONFIGURATION_FLAGS.md) | Config-related errors |

---

**Previous:** [45 - Configuration & Feature Flags](./45-CONFIGURATION_FLAGS.md)
**Next:** [47 - Monorepo Patterns](./47-MONOREPO_PATTERNS.md)
