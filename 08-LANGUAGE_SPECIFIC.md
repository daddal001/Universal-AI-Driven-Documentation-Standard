---
title: "Language-Specific Documentation"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-14"
version: "1.1.0"
---



> Per-language tooling, inline documentation standards, and API documentation generation.

---

## Table of Contents

1. [Inline Documentation by Language](#inline-documentation-by-language)
2. [API Documentation Generation](#api-documentation-generation)
3. [Test Documentation](#test-documentation)

---

## Inline Documentation by Language

### Language Reference Table

| Language | Standard | Tool | Format |
|----------|----------|------|--------|
| **Python** | PEP 257 | Sphinx, MkDocs | `"""Description."""` |
| **TypeScript** | JSDoc | TypeDoc | `/** @param name */` |
| **JavaScript** | JSDoc | JSDoc | `/** @param name */` |
| **Go** | GoDoc | godoc | `// FunctionName does...` |
| **Rust** | Doc comments | rustdoc | `/// Description` |
| **Java** | Javadoc | Javadoc | `/** @param name */` |
| **Kotlin** | KDoc | Dokka | `/** @param name */` |
| **C#** | XML comments | DocFX | `/// <summary>` |
| **C/C++** | Doxygen | Doxygen | `/** @brief */` |
| **Ruby** | YARD | YARD | `# @param name` |
| **PHP** | PHPDoc | phpDocumentor | `/** @param */` |

---

### TypeScript/JavaScript (JSDoc)

```typescript
/**
 * Send a message to the AI service.
 *
 * @param content - Message content (max 8000 chars)
 * @returns Message ID and response ID
 * @throws {ApiError} 429 if rate limited
 *
 * @example
 * ```typescript
 * const response = await sendMessage("Hello");
 * console.log(response.messageId);
 * ```
 */
export async function sendMessage(content: string): Promise<Response>
```

### Python (Docstrings)

```python
def send_message(content: str) -> Response:
    """Send a message to the AI service.

    Args:
        content: Message content (max 8000 chars)

    Returns:
        Response object with message_id and response_id

    Raises:
        ApiError: 429 if rate limited

    Example:
        >>> response = send_message("Hello")
        >>> print(response.message_id)
    """
```

### Go (GoDoc)

```go
// SendMessage sends a message to the AI service.
//
// It accepts content up to 8000 characters and returns
// a Response containing the message ID and response ID.
// Returns ApiError if rate limited.
func SendMessage(content string) (*Response, error)
```

---

## API Documentation Generation

### By Framework

| Framework | Spec | Tool | Auto-Generate? |
|-----------|------|------|----------------|
| FastAPI | OpenAPI 3.0 | Built-in | ✅ Automatic |
| NestJS | OpenAPI 3.0 | @nestjs/swagger | ✅ With decorators |
| Spring Boot | OpenAPI 3.0 | springdoc-openapi | ✅ Automatic |
| Express | OpenAPI 3.0 | swagger-jsdoc | Manual setup |
| Gin (Go) | OpenAPI 2.0 | swaggo/swag | ✅ With comments |

### OpenAPI Example

```yaml
paths:
  /api/messages:
    post:
      summary: Send a message
      description: Send a message to the AI service
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/MessageRequest'
      responses:
        '200':
          description: Message sent successfully
        '429':
          description: Rate limited
```

### AsyncAPI (for Event-Driven)

For WebSocket, SSE, Kafka, or other async APIs:

```yaml
asyncapi: '2.6.0'
info:
  title: Chat Events API
  version: '1.0.0'
channels:
  messages:
    subscribe:
      message:
        $ref: '#/components/messages/ChatMessage'
```

---

## Test Documentation

### Coverage Requirements

| Language | Test Command | Coverage Tool | Minimum |
|----------|--------------|---------------|---------|
| Python | `pytest` | coverage.py | 80% |
| TypeScript | `npm test` | c8/istanbul | 80% |
| Go | `go test` | go test -cover | 80% |
| Rust | `cargo test` | tarpaulin | 80% |
| Java | `mvn test` | JaCoCo | 80% |

### Test Documentation Pattern

```typescript
describe('MessageService', () => {
  /**
   * Tests the sendMessage function with valid input.
   * Expects: Success response with message ID
   */
  it('should send message successfully', async () => {
    // Arrange
    const content = 'Test message';

    // Act
    const result = await sendMessage(content);

    // Assert
    expect(result.messageId).toBeDefined();
  });
});
```

---

## Code Commenting Best Practices

### Prose Over Boilerplate (Google Recommendation)

**❌ Bad (Boilerplate):**

```python
def calculate_tip(total: float) -> float:
    """Calculate tip.

    Args:
        total: Total amount.

    Returns:
        Tip amount.
    """
```

**✅ Good (Prose):**

```python
def calculate_tip(total: float) -> float:
    """Calculates a 20% tip on the given total.

    Pass the bill total; returns the tip amount.
    Example: calculate_tip(100.0) returns 20.0
    """
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Governance](./07-GOVERNANCE.md) | Ownership |
| [Localization](./09-LOCALIZATION.md) | i18n |

---

**Previous:** [07 - Governance](./07-GOVERNANCE.md)
**Next:** [09 - Localization](./09-LOCALIZATION.md)
