---
title: "Error Catalog — [System/Service Name]"
type: "error-catalog"
status: "approved"
owner: "@team-name"
classification: "public"
created: "YYYY-MM-DD"
last_updated: "YYYY-MM-DD"
version: "1.0.0"
---

# Error Catalog — [System/Service Name]

> Error code reference. Format: `SERVICE-CATEGORY-NNN`

---

## [SVC] — [Service Name]

### SVC-VALID — Validation Errors (000-099)

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| SVC-VALID-001 | 400 | [Title] | warning | No | [How to fix] |
| SVC-VALID-002 | 400 | [Title] | warning | No | [How to fix] |

### SVC-AUTH — Authentication Errors (100-199)

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| SVC-AUTH-001 | 401 | [Title] | warning | No | [How to fix] |
| SVC-AUTH-002 | 403 | [Title] | warning | No | [How to fix] |

### SVC-RSRC — Resource Errors (300-399)

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| SVC-RSRC-001 | 404 | [Title] | warning | No | [How to fix] |
| SVC-RSRC-002 | 409 | [Title] | error | No | [How to fix] |

### SVC-EXT — External Service Errors (400-499)

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| SVC-EXT-001 | 502 | [Title] | critical | Yes (with backoff) | [How to fix] |
| SVC-EXT-002 | 504 | [Title] | error | Yes (with backoff) | [How to fix] |

### SVC-INT — Internal Errors (500-599)

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| SVC-INT-001 | 500 | [Title] | critical | No | [How to fix — typically "Contact engineering"] |

<!--
Reserved ranges:
  000-099: Validation errors
  100-199: Authentication errors
  200-299: Authorization errors
  300-399: Resource errors (not found, conflict)
  400-499: External service errors
  500-599: Internal errors

Severity levels: info, warning, error, critical
Retry values: true, false, "with backoff", "after delay"
-->

---

## Error Response Format

All errors return this JSON structure:

```json
{
  "error": {
    "code": "SVC-VALID-001",
    "title": "Short Error Title",
    "message": "User-safe error message with no internal details.",
    "details": {},
    "retry": false,
    "docs_url": "https://docs.example.com/errors/SVC-VALID-001"
  }
}
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [API Documentation](./api.md) | API endpoint reference |
| [Configuration](./configuration.md) | Service configuration |
| [Troubleshooting](./troubleshooting.md) | Troubleshooting guides |
