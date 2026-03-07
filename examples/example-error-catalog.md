---
title: "Error Catalog — Order Platform"
type: "example"
status: "approved"
classification: "public"
owner: "@platform-team"
created: "2026-03-07"
last_updated: "2026-03-07"
version: "1.0.0"
---

# Error Catalog — Order Platform

> Error code reference for the Order Platform. See [44-ERROR_CATALOG.md](../44-ERROR_CATALOG.md) for the standard.

**Error code format:** `SERVICE-CATEGORY-NNN`

---

## AUTH — Authentication Service

### AUTH-TOKEN — Token Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| AUTH-TOKEN-001 | 401 | Expired access token | warning | No | Refresh token via `POST /auth/refresh`. If refresh token also expired, re-authenticate via `POST /auth/login`. |
| AUTH-TOKEN-002 | 401 | Invalid token signature | error | No | Token was tampered with or signed with wrong key. Re-authenticate. If persistent, check signing key rotation. |
| AUTH-TOKEN-003 | 401 | Revoked token | warning | No | Token was explicitly revoked (logout, password change). Re-authenticate. |
| AUTH-TOKEN-004 | 401 | Token not yet valid | warning | Yes (with delay) | Token `nbf` (not-before) claim is in the future. Check server clock synchronization (NTP). |

### AUTH-CRED — Credential Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| AUTH-CRED-001 | 401 | Invalid credentials | warning | No | Username or password is incorrect. Check credentials and try again. |
| AUTH-CRED-002 | 429 | Too many login attempts | warning | Yes (after lockout) | Account locked for 15 minutes after 5 failed attempts. Wait and retry, or contact support for immediate unlock. |
| AUTH-CRED-003 | 403 | Account disabled | error | No | Account has been deactivated by an administrator. Contact your admin. |

### AUTH-MFA — Multi-Factor Authentication Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| AUTH-MFA-001 | 401 | Invalid MFA code | warning | Yes | OTP code is incorrect or expired. Request a new code and try again. |
| AUTH-MFA-002 | 403 | MFA required | info | No | This action requires MFA. Complete MFA challenge before proceeding. |

---

## ORD — Order Service

### ORD-VALID — Validation Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| ORD-VALID-001 | 400 | Empty cart | warning | No | Cart has no items. Add at least one item before placing an order. |
| ORD-VALID-002 | 400 | Invalid shipping address | warning | No | Address validation failed. Check required fields: street, city, postal code, country. |
| ORD-VALID-003 | 400 | Item quantity exceeds stock | warning | Yes | Requested quantity exceeds available stock. Reduce quantity or wait for restock. |

### ORD-STATE — State Machine Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| ORD-STATE-001 | 409 | Invalid state transition | error | No | Order cannot move from current state to requested state. Valid transitions: `pending→confirmed→shipped→delivered`, `pending→cancelled`, `confirmed→cancelled`. |
| ORD-STATE-002 | 409 | Order already cancelled | warning | No | Cannot modify a cancelled order. Create a new order instead. |

### ORD-RSRC — Resource Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| ORD-RSRC-001 | 404 | Order not found | warning | No | No order exists with the given ID. Verify the order ID and check you have access. |

---

## PAY — Payment Service

### PAY-CHARGE — Charge Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| PAY-CHARGE-001 | 402 | Payment declined | warning | Yes | Card was declined by the issuer. Try a different payment method. |
| PAY-CHARGE-002 | 402 | Insufficient funds | warning | Yes | Card has insufficient funds. Use a different card or add funds. |
| PAY-CHARGE-003 | 400 | Invalid card number | warning | No | Card number failed Luhn check. Verify the card number. |
| PAY-CHARGE-004 | 400 | Card expired | warning | No | Card expiration date is in the past. Use a valid card. |

### PAY-REFUND — Refund Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| PAY-REFUND-001 | 400 | Refund exceeds charge | error | No | Refund amount exceeds the original charge. Check the refund amount. |
| PAY-REFUND-002 | 409 | Already refunded | warning | No | This charge has already been fully refunded. |

### PAY-EXT — External Service Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| PAY-EXT-001 | 502 | Payment provider unavailable | critical | Yes (with backoff) | Stripe is not responding. The system will retry automatically. If persistent, check [Stripe Status](https://status.stripe.com). |
| PAY-EXT-002 | 504 | Payment provider timeout | error | Yes (with backoff) | Stripe request timed out. Will retry automatically. Payment may have been processed — check idempotency key before manual retry. |

---

## API — API Gateway

### API-RATE — Rate Limiting Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| API-RATE-001 | 429 | Rate limit exceeded | warning | Yes (after delay) | Too many requests. Check `Retry-After` header for wait duration. Implement exponential backoff. |
| API-RATE-002 | 429 | Concurrent request limit | warning | Yes (after delay) | Too many concurrent requests from this client. Reduce parallelism. |

### API-AUTH — Gateway Auth Errors

| Code | HTTP | Title | Severity | Retry | Resolution |
|------|------|-------|----------|-------|------------|
| API-AUTH-001 | 401 | Missing authorization header | warning | No | Request has no `Authorization` header. Include `Bearer <token>`. |
| API-AUTH-002 | 403 | Insufficient scope | warning | No | Token does not have the required scope for this endpoint. Request a token with the needed scopes. |

---

## Error Response Format

All services return errors in this format:

```json
{
  "error": {
    "code": "AUTH-TOKEN-001",
    "title": "Expired Access Token",
    "message": "Your session has expired. Please sign in again.",
    "details": {
      "expired_at": "2026-03-07T10:30:00Z"
    },
    "retry": false,
    "docs_url": "https://docs.example.com/errors/AUTH-TOKEN-001"
  }
}
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [API Documentation](./example-api-documentation.md) | API endpoint reference |
| [Configuration Reference](./example-configuration.md) | Service configuration |
| [Architecture](./example-architecture.md) | System architecture |
