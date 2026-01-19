---
title: "[API Name] Reference"
type: "reference"
status: "approved"
owner: "@api-owner"
classification: "public"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

## [API Name] Reference

Comprehensive reference for the [API Name] API. This documentation covers authentication, endpoints, error handling, and usage examples. Use this when integrating with our platform.

---

## Authentication

All API requests require an API Key in the header:

```http
Authorization: Bearer <YOUR_API_KEY>
```

To obtain an API Key, go to [Developer Portal Link].

---

## Base URL

```text
https://api.example.com/v1
```

---

## Endpoints

### `GET /resources`

List all resources.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `limit` | integer | No | Max number of results (default 10) |
| `offset` | integer | No | Pagination offset |

**Response:**

```json
{
  "data": [
    {
      "id": "123",
      "name": "Resource Name"
    }
  ],
  "meta": {
    "total": 100
  }
}
```

### `POST /resources`

Create a new resource.

**Body:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | string | Yes | Name of the resource |

**Response:**

```json
{
  "id": "124",
  "name": "New Resource"
}
```

---

## Errors

| Code | Description |
|------|-------------|
| `400` | Bad Request - Invalid input |
| `401` | Unauthorized - Invalid API Key |
| `429` | Too Many Requests - Rate limit exceeded |
| `500` | Internal Server Error |

---

## Rate Limits

- **Standard:** 100 requests / minute
- **Enterprise:** 1000 requests / minute

See [Rate Limits Guide](../guides/RATE_LIMITS.md) for more details.
