---
title: "Frontmatter Reference"
type: "reference"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Frontmatter Reference

> **Goal:** Define the required YAML frontmatter metadata for all documentation files.

---

## Required Fields

Every markdown file in this repository **MUST** include these fields:

```yaml
---
title: "Document Title"           # Human-readable title
type: "standard"                  # Document type (see valid types below)
status: "approved"                # Lifecycle status
classification: "public"          # Access level
owner: "@team-name"               # Responsible team/person
created: "YYYY-MM-DD"             # Creation date (ISO 8601)
last_updated: "YYYY-MM-DD"        # Last modification date
version: "X.Y.Z"                  # Semantic version
---
```

---

## Field Definitions

### title (required)

- **Type:** String (quoted)
- **Purpose:** Human-readable document title
- **Example:** `title: "API Authentication Guide"`

### type (required)

- **Type:** String (quoted)
- **Purpose:** Categorizes the document for indexing and validation
- **Valid Values:**
  - `readme` - Project/service overview
  - `architecture` - System design documents
  - `adr` - Architecture Decision Records
  - `api` - API documentation
  - `changelog` - Version history
  - `runbook` - Operational procedures
  - `oncall` - On-call guides
  - `slo` - Service Level Objectives
  - `getting-started` - Setup guides
  - `guide` - General guides
  - `tutorial` - Step-by-step tutorials
  - `reference` - Reference documentation
  - `standard` - Standards documents
  - `landing` - Index/landing pages
  - `glossary` - Terminology definitions
  - `postmortem` - Incident reports
  - `migration` - Migration guides
  - `troubleshooting` - Problem-solving guides
  - `faq` - Frequently asked questions
  - `how-to` - Task-focused guides
  - `example` - Example documents
  - `policy` - Policy documents
  - `template` - Document templates

### status (required)

- **Type:** String (quoted)
- **Purpose:** Document lifecycle stage
- **Valid Values:**
  - `draft` - Work in progress, not for production use
  - `review` - Under review, pending approval
  - `approved` - Approved for use
  - `stale` - Needs update (>90 days old)
  - `deprecated` - No longer recommended

### classification (required)

- **Type:** String (quoted)
- **Purpose:** Access control level
- **Valid Values:**
  - `public` - Open to everyone
  - `internal` - Organization members only
  - `confidential` - Limited distribution
  - `restricted` - Need-to-know basis

### owner (required)

- **Type:** String (quoted)
- **Purpose:** Team or person responsible for maintenance
- **Format:** Use `@` prefix for teams or individuals
- **Examples:** `@documentation-maintainer`, `@platform-team`, `@jane-doe`

### created (required)

- **Type:** String (quoted, ISO 8601 date)
- **Purpose:** Document creation date
- **Format:** `YYYY-MM-DD`
- **Example:** `created: "2025-01-12"`

### last_updated (required)

- **Type:** String (quoted, ISO 8601 date)
- **Purpose:** Last modification date
- **Format:** `YYYY-MM-DD`
- **Example:** `last_updated: "2025-01-12"`

### version (required)

- **Type:** String (quoted, semantic version)
- **Purpose:** Document version for tracking changes
- **Format:** `MAJOR.MINOR.PATCH`
- **Example:** `version: "1.1.0"`

---

## Optional Fields

These fields enhance discoverability but are not required:

```yaml
---
# ... required fields ...
tags: ["api", "authentication", "security"]  # Searchable keywords
related:                                       # Related documents
  - "./AUTH_GUIDE.md"
  - "./API_REFERENCE.md"
audience: "developers"                         # Target audience
freshness:                                     # Review schedule
  reviewed: "2025-01-12"
  next_review: "2025-04-12"
---
```

---

## Complete Example

```yaml
---
title: "User Authentication API"
type: "api"
status: "approved"
classification: "internal"
owner: "@security-team"
created: "2024-06-15"
last_updated: "2025-01-12"
version: "2.3.0"
tags: ["api", "authentication", "oauth", "jwt"]
related:
  - "./AUTH_FLOWS.md"
  - "./TOKEN_MANAGEMENT.md"
audience: "backend-developers"
freshness:
  reviewed: "2025-01-12"
  next_review: "2025-04-12"
---
```

---

## Validation

Use the validation script to check frontmatter:

```bash
bash docs/standards/scripts/validate-frontmatter.sh docs/
```

This checks:

- All required fields are present
- Field values are valid (type, status, classification)
- Dates are in ISO 8601 format
- Strings are properly quoted

---

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| `title: My Title` | Unquoted string | `title: "My Title"` |
| `type: readme` | Unquoted value | `type: "readme"` |
| `owner: team-name` | Missing @ prefix | `owner: "@team-name"` |
| `created: 01/12/2025` | Wrong date format | `created: "2025-01-12"` |
| `version: 1.0` | Incomplete semver | `version: "1.0.0"` |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [05-QUALITY.md](../../05-QUALITY.md) | Quality criteria including frontmatter |
| [07-GOVERNANCE.md](../../07-GOVERNANCE.md) | Ownership and review requirements |
| [validate-frontmatter.sh](../../scripts/validate-frontmatter.sh) | Validation script |

---

**Previous:** [ADR Template](./ADR.md)
**Next:** [Tier 2 - Operational Templates](../tier-2-operational/)
