---
title: "Example: Complete API Documentation"
type: "example"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
context: "api"
---

# Example: Complete API Documentation

> **Context:** This example shows comprehensive API documentation with OpenAPI specification, following our API documentation standards. It demonstrates both human-readable docs and machine-readable specs.

---

## API Overview

The TaskFlow API provides programmatic access to task management functionality. All endpoints require authentication via JWT tokens.

**Base URL:** `https://api.taskflow.app/v1`
**API Version:** 1.0.0
**Authentication:** Bearer Token (JWT)
**Rate Limit:** 100 requests per minute per API key

---

## Authentication

All API requests require a JWT token in the Authorization header:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Getting an API Token

1. Sign up or log in at <https://taskflow.app>p>p>p>p>p>p>p>
2. Navigate to Settings → API Keys
3. Create a new API key
4. Copy the token (shown only once)

**Token Format:** JWT with 30-day expiration

---

## Rate Limiting

| Tier | Requests/Minute | Requests/Hour |
|------|-----------------|---------------|
| **Free** | 100 | 5,000 |
| **Pro** | 1,000 | 50,000 |
| **Enterprise** | 10,000 | 500,000 |

Rate limit headers are included in all responses:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

When rate limit is exceeded, API returns `429 Too Many Requests`.

---

## Error Handling

All errors follow a consistent format:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid email address",
    "details": {
      "field": "email",
      "reason": "Must be a valid email format"
    }
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Request validation failed |
| `UNAUTHORIZED` | 401 | Missing or invalid token |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource conflict |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |

---

## Endpoints

### Tasks

#### List Tasks

```http
GET /tasks
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `status` | string | No | Filter by status (todo, in_progress, done) |
| `project_id` | UUID | No | Filter by project |
| `limit` | integer | No | Number of results (default: 20, max: 100) |
| `offset` | integer | No | Pagination offset |

**Response:**

```json
{
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Complete API documentation",
      "description": "Write comprehensive API docs",
      "status": "in_progress",
      "project_id": "660e8400-e29b-41d4-a716-446655440001",
      "created_at": "2025-12-15T10:00:00Z",
      "updated_at": "2025-12-15T14:30:00Z"
    }
  ],
  "pagination": {
    "total": 42,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

**Example Request:**

```bash
curl -X GET "https://api.taskflow.app/v1/tasks?status=in_progress&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### Create Task

```http
POST /tasks
```

**Request Body:**

```json
{
  "title": "New task",
  "description": "Task description (optional)",
  "status": "todo",
  "project_id": "660e8400-e29b-41d4-a716-446655440001"
}
```

**Validation Rules:**

- `title`: Required, string, 1-200 characters
- `description`: Optional, string, max 5000 characters
- `status`: Optional, enum (todo, in_progress, done), default: todo
- `project_id`: Optional, UUID, must exist

**Response:**

```json
{
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "New task",
    "description": "Task description",
    "status": "todo",
    "project_id": "660e8400-e29b-41d4-a716-446655440001",
    "created_at": "2025-12-15T15:00:00Z",
    "updated_at": "2025-12-15T15:00:00Z"
  }
}
```

**Example Request:**

```bash
curl -X POST "https://api.taskflow.app/v1/tasks" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New task",
    "description": "Task description",
    "status": "todo"
  }'
```

#### Get Task

```http
GET /tasks/{id}
```

**Path Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Task ID |

**Response:** Same as task object in list response

**Example Request:**

```bash
curl -X GET "https://api.taskflow.app/v1/tasks/550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### Update Task

```http
PATCH /tasks/{id}
```

**Request Body:** Partial task object (only include fields to update)

**Response:** Updated task object

**Example Request:**

```bash
curl -X PATCH "https://api.taskflow.app/v1/tasks/550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "done"
  }'
```

#### Delete Task

```http
DELETE /tasks/{id}
```

**Response:**

```json
{
  "message": "Task deleted successfully"
}
```

**Example Request:**

```bash
curl -X DELETE "https://api.taskflow.app/v1/tasks/550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Projects

#### List Projects

```http
GET /projects
```

Similar structure to tasks endpoint.

#### Create Project

```http
POST /projects
```

**Request Body:**

```json
{
  "name": "Project Name",
  "description": "Project description (optional)"
}
```

---

## OpenAPI Specification

Full OpenAPI 3.1 specification available at:

- **JSON:** <https://api.taskflow.app/v1/openapi.json>n>n>n>n>n>n>n>
- **YAML:** <https://api.taskflow.app/v1/openapi.yaml>l>l>l>l>l>l>l>
- **Interactive Docs:** <https://api.taskflow.app/docs>s>s>s>s>s>s>s>

### Example OpenAPI Snippet

```yaml
openapi: 3.1.0
info:
  title: TaskFlow API
  version: 1.0.0
  description: Task management API
servers:
  - url: https://api.taskflow.app/v1
paths:
  /tasks:
    get:
      summary: List tasks
      operationId: listTasks
      security:
        - bearerAuth: []
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [todo, in_progress, done]
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TaskList'
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  schemas:
    Task:
      type: object
      properties:
        id:
          type: string
          format: uuid
        title:
          type: string
        status:
          type: string
          enum: [todo, in_progress, done]
```

---

## SDKs and Libraries

Official SDKs available:

- **JavaScript/TypeScript:** `npm install @taskflow/api-client`
- **Python:** `pip install taskflow-api`
- **Ruby:** `gem install taskflow-api`
- **Go:** `go get github.com/taskflow/api-go`

See [SDK Documentation](./docs/SDK.md) for usage examples.

---

## Webhooks

TaskFlow supports webhooks for real-time event notifications.

### Events

- `task.created` — New task created
- `task.updated` — Task updated
- `task.deleted` — Task deleted
- `project.created` — New project created

### Webhook Payload

```json
{
  "event": "task.created",
  "timestamp": "2025-12-15T15:00:00Z",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "New task",
    "status": "todo"
  }
}
```

See [Webhooks Guide](./docs/WEBHOOKS.md) for setup instructions.

---

## Changelog

### v1.2.0 (2025-12-10)

**Added:**

<https://docs.taskflow.app>

<api-support@taskflow.app>

<https://docs.taskflow.app>
**Deprecated:**<https://status.taskflow.app>

<https://discord.gg/taskflow>

### v1.1.0 (2025-11-15)

<https://docs.taskflow.app>

**Added:**<https://status.taskflow.app>
<api-support@taskflow.app>

<https://discord.gg/taskflow>

- Projects endpoint
- Task filtering by s<https://docs.taskflow.app>
<https://status.taskflow.app>
**Fixed:**<api-support@taskflow.app>

<https://discord.gg/taskflow>

- Pagination offset calculation
<https://docs.taskflow.app>
---<https://status.taskflow.app>
<api-support@taskflow.app>

## Support<https://discord.gg/taskflow>

- **Documentation:** <https://docs.taskflow.app>
- **API Status:** <https://status.taskflow.app>
- **Support Email:** <api-support@taskflow.app>

- **Discord:** <https://discord.gg/taskflow>

---

**Note:** This example demonstrates comprehensive API documentation that:

- Includes authentication and rate limiting
- Provides clear endpoint documentation with examples
- Shows request/response formats
- Includes OpenAPI specification
- Documents error handling
- Provides SDK information
- Includes changelog for versioning
