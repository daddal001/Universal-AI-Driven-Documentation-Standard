---
title: "API Documentation Standards"
type: "standard"
status: "approved"
owner: "@api-platform-team"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-09"
version: "1.0.0"
---

# API Documentation Standards

> **Goal:** Standardize documentation for REST, Event-Driven, and GraphQL APIs to ensure developer success and tooling interoperability.

---

## 1. REST APIs (OpenAPI 3.1)

### Specification Requirements

All REST APIs **must** have an OpenAPI 3.1 specification file.

| Requirement | Minimum | Best Practice |
|-------------|---------|---------------|
| **Location** | `docs/api/openapi.yaml` | Versioned: `docs/api/v1/openapi.yaml` |
| **Format** | YAML or JSON | YAML (more readable) |
| **Version** | OpenAPI 3.0+ | OpenAPI 3.1 (JSON Schema alignment) |

### Required Sections

```yaml
openapi: "3.1.0"
info:
  title: "Service Name API"
  version: "1.0.0"
  description: |
    Brief description of the API.

    ## Authentication
    All endpoints require Bearer token.
  contact:
    name: API Support
    email: api-support@example.com

servers:
  - url: https://api.example.com/v1
    description: Production

paths:
  /resource:
    get:
      summary: List resources
      description: Detailed description with usage notes
      operationId: listResources  # Required for SDK generation
      tags: [Resources]
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ResourceList'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '429':
          $ref: '#/components/responses/RateLimited'

components:
  schemas:
    Resource:
      type: object
      required: [id, name]
      properties:
        id:
          type: string
          format: uuid
          description: Unique identifier
        name:
          type: string
          maxLength: 255
          description: Human-readable name
```

### OpenAPI 3.1 Specific Features

| Feature | Usage |
|---------|-------|
| **JSON Schema Draft 2020-12** | Full alignment—use `$schema`, `const`, `prefixItems` |
| **Webhooks** | Top-level `webhooks` field for callbacks |
| **`null` type** | Use `type: ["string", "null"]` for nullable |

---

## 2. Event-Driven APIs (AsyncAPI)

### When to Use

Use AsyncAPI for:

- WebSocket connections
- Server-Sent Events (SSE)
- Message queues (Kafka, RabbitMQ, SQS)
- Pub/Sub patterns

### Specification Requirements

| Requirement | Standard |
|-------------|----------|
| **Location** | `docs/api/asyncapi.yaml` |
| **Version** | AsyncAPI 3.0.0 |

### Template

```yaml
asyncapi: '3.0.0'
info:
  title: Chat Events API
  version: '1.0.0'
  description: Real-time chat message streaming

servers:
  production:
    host: wss://api.example.com
    protocol: wss
    description: Production WebSocket server

channels:
  messages:
    address: /v1/messages
    messages:
      ChatMessage:
        $ref: '#/components/messages/ChatMessage'

operations:
  receiveMessage:
    action: receive
    channel:
      $ref: '#/channels/messages'
    summary: Receive chat messages in real-time

components:
  messages:
    ChatMessage:
      name: ChatMessage
      contentType: application/json
      payload:
        type: object
        properties:
          id:
            type: string
            format: uuid
          content:
            type: string
          timestamp:
            type: string
            format: date-time
```

---

## 3. GraphQL APIs

### Documentation Requirements

GraphQL APIs are self-documenting via introspection, but **must** include:

| Element | Requirement |
|---------|-------------|
| **Schema descriptions** | Every type, field, and argument |
| **Deprecation notices** | `@deprecated(reason: "...")` directive |
| **Examples** | In companion Markdown docs |

### SDL Documentation Pattern

```graphql
"""
A user in the system.

Users are the primary actors who can create and own resources.
"""
type User {
  """Unique identifier (UUID v4)"""
  id: ID!

  """
  User's email address.
  Must be verified before account activation.
  """
  email: String!

  """Display name shown in UI (max 50 chars)"""
  name: String!

  """When the user was created"""
  createdAt: DateTime!

  """@deprecated Use `createdAt` instead"""
  created: String @deprecated(reason: "Use createdAt instead")
}

type Query {
  """
  Fetch a user by ID.

  Returns null if user not found.
  Requires authentication.
  """
  user(
    """The user's unique ID"""
    id: ID!
  ): User
}
```

### Companion Documentation

Create `docs/api/graphql/README.md`:

```markdown
# GraphQL API

## Quick Start
\`\`\`graphql
query {
  user(id: "123") {
    name
    email
  }
}
\`\`\`

## Authentication
Include `Authorization: Bearer <token>` header.

## Rate Limiting
- 100 queries/minute per user
- 1000 queries/minute per API key

## Error Handling
Errors follow GraphQL spec with extensions:
\`\`\`json
{
  "errors": [{
    "message": "User not found",
    "extensions": {
      "code": "NOT_FOUND",
      "docRef": "API-404"
    }
  }]
}
\`\`\`
```

---

## 4. Interactive Documentation

### Requirements

| API Type | Tool | Requirement |
|----------|------|-------------|
| REST | Swagger UI, Redoc | Deployed at `/docs` |
| GraphQL | GraphiQL, Apollo Sandbox | Deployed at `/graphql` |
| AsyncAPI | AsyncAPI Studio | Link in README |

### Try-It-Out Configuration

Interactive docs **must** support:

- [ ] Real API calls (sandbox environment)
- [ ] Pre-populated examples
- [ ] Copy-paste curl commands
- [ ] Authentication helper

---

## 5. Error Documentation

### RFC 9457: Problem Details for HTTP APIs

All APIs **should** follow [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html) (Problem Details) format:

```json
{
  "type": "https://api.example.com/errors/validation-failed",
  "title": "Validation Failed",
  "status": 400,
  "detail": "The 'email' field has an invalid format",
  "instance": "/api/v1/users/register"
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | URI identifying the error type |
| `title` | Yes | Human-readable error title |
| `status` | Yes | HTTP status code |
| `detail` | No | Specific error details |
| `instance` | No | URI of the specific occurrence |

### Error Response Standard

All APIs **must** document errors with:

```yaml
components:
  responses:
    BadRequest:
      description: Invalid request parameters
      content:
        application/problem+json:  # RFC 9457 media type
          schema:
            $ref: '#/components/schemas/Problem'
          example:
            type: "https://api.example.com/errors/validation-failed"
            title: "Validation Failed"
            status: 400
            detail: "The 'email' field has an invalid format"
            instance: "/api/v1/users/register"

  schemas:
    Problem:
      type: object
      required: [type, title, status]
      properties:
        type:
          type: string
          format: uri
          description: URI identifying the error type
        title:
          type: string
          description: Human-readable error title
        status:
          type: integer
          description: HTTP status code
        detail:
          type: string
          description: Specific error details
        instance:
          type: string
          format: uri
          description: URI of the specific occurrence

    # Legacy Error schema (for backward compatibility)
    Error:
      type: object
      required: [error, code]
      properties:
        error:
          type: string
          description: Human-readable error message
        code:
          type: integer
          description: HTTP status code
        docRef:
          type: string
          description: Reference to error documentation
```

### Error Code Registry

Maintain `docs/api/ERROR_CODES.md`:

| Code | HTTP | Message | Resolution |
|------|------|---------|------------|
| API-400 | 400 | Validation failed | Check request body format |
| API-401 | 401 | Unauthorized | Include valid Bearer token |
| API-429 | 429 | Rate limited | Retry after `Retry-After` header |

---

## 6. Versioning Documentation

### Version Strategy

| Strategy | When to Use | Documentation Requirement |
|----------|-------------|---------------------------|
| **URL path** (`/v1/`) | Breaking changes | Separate OpenAPI per version |
| **Header** (`API-Version: 2`) | Minor versions | Document in single spec |
| **Query** (`?version=2`) | Avoid | Not recommended |

### Deprecation Timeline

1. **Announce:** 6 months before deprecation
2. **Sunset Header:** Add `Sunset: <date>` header
3. **Document:** Migration guide required
4. **Remove:** After sunset date

---

## 7. Single Source of Truth Tooling

> **The Problem:** Maintaining types, validation, and API documentation separately leads to drift.
> **The Solution:** Use tools where your code IS your documentation.

### Recommended SSOT Tools by Language

| Language | Tool | What It Eliminates |
|----------|------|--------------------|
| **TypeScript** | [TypeSpec](https://typespec.io/) | Define API once → OpenAPI + SDKs |
| **TypeScript** | [Zod](https://zod.dev/) + [zod-to-openapi](https://github.com/asteasolutions/zod-to-openapi) | Schema = Validation = Docs |
| **TypeScript** | [tRPC](https://trpc.io/) | Full-stack type safety, auto-docs |
| **Python** | [FastAPI](https://fastapi.tiangolo.com/) | Type hints = Validation = OpenAPI |
| **Python** | [Pydantic](https://docs.pydantic.dev/) | Models → JSON Schema → OpenAPI |
| **Go** | [ogen](https://github.com/ogen-go/ogen) | OpenAPI → Type-safe handlers |
| **Java/Kotlin** | [SpringDoc](https://springdoc.org/) | Annotations → OpenAPI |
| **Multi-language** | [Buf](https://buf.build/) | Protobuf → Docs + SDKs |

### TypeSpec Example (Microsoft)

Define once, generate everything:

```typespec
// main.tsp - Single source of truth
import "@typespec/http";
import "@typespec/openapi3";

@service({
  title: "User Service",
  version: "1.0.0"
})
namespace UserService;

@route("/users")
interface Users {
  @get list(): User[];
  @post create(@body user: UserCreate): User;
  @get @route("{id}") get(@path id: string): User | NotFound;
}

model User {
  id: string;
  email: string;
  name: string;
  createdAt: utcDateTime;
}

model UserCreate {
  email: string;
  name: string;
}

@error model NotFound {
  code: "NOT_FOUND";
  message: string;
}
```

Generate OpenAPI + TypeScript client:

```bash
npx tsp compile . --emit @typespec/openapi3
npx tsp compile . --emit @typespec/typescript
```

### Zod + OpenAPI Example (TypeScript)

```typescript
import { z } from 'zod';
import { extendZodWithOpenApi, OpenAPIRegistry } from '@asteasolutions/zod-to-openapi';

extendZodWithOpenApi(z);

// Define ONCE - used for validation AND documentation
export const UserSchema = z.object({
  id: z.string().uuid().openapi({ example: '550e8400-e29b-41d4-a716-446655440000' }),
  email: z.string().email().openapi({ example: 'user@example.com' }),
  name: z.string().min(1).max(100).openapi({ example: 'Jane Doe' }),
  createdAt: z.date().openapi({ example: '2025-12-13T00:00:00Z' }),
}).openapi('User');

// Register for OpenAPI generation
const registry = new OpenAPIRegistry();
registry.register('User', UserSchema);

// Use in your API handler - same schema validates AND documents
app.post('/users', (req, res) => {
  const parsed = UserSchema.parse(req.body); // Validates
  // ...
});
```

### FastAPI Example (Python)

```python
from fastapi import FastAPI
from pydantic import BaseModel, EmailStr
from datetime import datetime
from uuid import UUID

app = FastAPI(title="User Service", version="1.0.0")

# Define ONCE - Pydantic model IS the documentation
class User(BaseModel):
    id: UUID
    email: EmailStr
    name: str
    created_at: datetime

    class Config:
        json_schema_extra = {
            "example": {
                "id": "550e8400-e29b-41d4-a716-446655440000",
                "email": "user@example.com",
                "name": "Jane Doe",
                "created_at": "2025-12-13T00:00:00Z"
            }
        }

# Type hint = Validation = OpenAPI docs (auto-generated at /docs)
@app.post("/users", response_model=User)
async def create_user(user: User) -> User:
    """Create a new user account."""
    return user
```

### tRPC Example (Full-Stack TypeScript)

```typescript
import { initTRPC } from '@trpc/server';
import { z } from 'zod';

const t = initTRPC.create();

// Define API with full type safety - client inherits types automatically
export const appRouter = t.router({
  users: t.router({
    list: t.procedure.query(async () => {
      return await db.users.findMany();
    }),

    create: t.procedure
      .input(z.object({
        email: z.string().email(),
        name: z.string(),
      }))
      .mutation(async ({ input }) => {
        return await db.users.create({ data: input });
      }),
  }),
});

// Client gets full type inference - no OpenAPI needed!
// const user = await trpc.users.create.mutate({ email: '...', name: '...' });
```

### When to Use What

| Scenario | Recommended Tool |
|----------|-----------------|
| Public REST API with external consumers | TypeSpec → OpenAPI |
| Internal TypeScript monorepo | tRPC (no OpenAPI needed) |
| Python backend | FastAPI (built-in OpenAPI) |
| Existing OpenAPI-first workflow | Keep OpenAPI, add SDK generation |
| gRPC / Protocol Buffers | Buf for docs generation |

### Benefits of SSOT Approach

| Benefit | Impact |
|---------|--------|
| **Zero drift** | Types, validation, and docs cannot diverge |
| **Less maintenance** | Update one place, not three |
| **Better DX** | IDE autocomplete from actual API |
| **Faster onboarding** | Docs are always accurate |
| **CI-ready** | Generate docs in pipeline |

---

## 8. Related Documents

| Document | Purpose |
|----------|---------|
| [Language Specific](./08-LANGUAGE_SPECIFIC.md) | Inline API documentation |
| [Release Notes](./16-RELEASE_NOTES.md) | API changelog format |
| [Quality](./05-QUALITY.md) | API doc validation |

---

**Previous:** [17 - Maturity Model](./17-MATURITY_MODEL.md)
**Next:** [19 - Database Documentation](./19-DATABASE_DOCUMENTATION.md)
