---
title: "AUTH-001: Authentication Token Expired"
type: "error-reference"
status: "approved"
classification: "public"
owner: "@platform-team"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
error_code: "AUTH-001"
severity: "warning"
---

# AUTH-001: Authentication Token Expired

## Error Message

```
Error 401: Authentication token expired or invalid.
(Ref: AUTH-001)
```

## What This Means

Your API request was rejected because the authentication token has expired or is malformed.

## Common Causes

1. **Token expiration** — Access tokens expire after 1 hour by default
2. **Clock skew** — Your system clock is out of sync
3. **Token revoked** — The token was manually revoked
4. **Wrong environment** — Using a staging token in production (or vice versa)

## How to Fix

### 1. Refresh the Token

```bash
# Using the CLI
myapp auth refresh

# Using the API
curl -X POST https://api.example.com/oauth/token \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$REFRESH_TOKEN"
```

### 2. Check Token Expiration

```python
import jwt

token = "your_access_token"
decoded = jwt.decode(token, options={"verify_signature": False})
print(f"Expires at: {decoded['exp']}")
```

### 3. Verify Clock Sync

```bash
# Check system time
date

# Sync with NTP (Linux)
sudo ntpdate pool.ntp.org
```

## Prevention

- Implement automatic token refresh before expiration
- Set up monitoring for auth failures
- Use shorter-lived tokens with refresh tokens

## Related Errors

| Code | Description |
|------|-------------|
| [AUTH-002](./AUTH-002.md) | Invalid credentials |
| [AUTH-003](./AUTH-003.md) | Missing authorization header |
| [RATE-001](./RATE-001.md) | Rate limit exceeded |

## Need Help?

- Check the [Authentication Guide](../guides/authentication.md)
- Contact: #platform-support on Slack
