---
title: "RATE-001: Rate Limit Exceeded"
type: "error-reference"
status: "approved"
classification: "public"
owner: "@platform-team"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
error_code: "RATE-001"
severity: "warning"
---

# RATE-001: Rate Limit Exceeded

## Error Message

```
Error 429: Too Many Requests. Rate limit exceeded.
(Ref: RATE-001)
```

## What This Means

Your API requests have exceeded the allowed rate limit for your tier.

## Rate Limits by Tier

| Tier | Requests/Minute | Requests/Day |
|------|-----------------|--------------|
| Free | 60 | 1,000 |
| Pro | 600 | 50,000 |
| Enterprise | 6,000 | Unlimited |

## Response Headers

Check these headers to understand your rate limit status:

```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1702576800
Retry-After: 45
```

## How to Fix

### 1. Wait and Retry

```python
import time
import requests

def api_call_with_retry(url, max_retries=3):
    for attempt in range(max_retries):
        response = requests.get(url)
        if response.status_code == 429:
            retry_after = int(response.headers.get('Retry-After', 60))
            print(f"Rate limited. Waiting {retry_after}s...")
            time.sleep(retry_after)
        else:
            return response
    raise Exception("Max retries exceeded")
```

### 2. Implement Exponential Backoff

```python
import time
import random

def exponential_backoff(attempt, base=1, max_delay=60):
    delay = min(base * (2 ** attempt) + random.uniform(0, 1), max_delay)
    time.sleep(delay)
```

### 3. Use Bulk Endpoints

Instead of:
