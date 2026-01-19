---
title: "Data Classification Guide"
type: "standard"
status: "draft"
classification: "internal"
owner: "@security-team"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
---

# Data Classification Guide

**Purpose:** Define data classification levels and handling requirements for documentation.

---

## Classification Levels

| Level | Description | Handling Requirements | Examples |
|-------|-------------|----------------------|----------|
| **Public** | Can be shared externally | No restrictions | Marketing materials, public APIs |
| **Internal** | Company-wide access | Internal use only | Architecture docs, team processes |
| **Confidential** | Need-to-know basis | Restricted access, encryption | Customer data, financial info |
| **Restricted** | Highly sensitive | Approval required, audit logging | PII, payment data, security keys |

---

## Classification in Documentation

### Frontmatter

All documents must include classification in frontmatter:

```yaml
---
classification: "confidential"
data_sensitivity:
  - "PII"
  - "financial"
access_control: "finance-team, security-team"
---
```

### Handling Requirements

| Classification | Storage | Sharing | Encryption | Retention |
|----------------|---------|---------|------------|-----------|
| **Public** | Any | Anyone | Not required | As needed |
| **Internal** | Company systems | Employees only | In transit | 7 years |
| **Confidential** | Encrypted storage | Authorized only | At rest + transit | Per policy |
| **Restricted** | Secure systems | Approval required | Full encryption | Per policy |

---

## Data Sensitivity Tags

Use `data_sensitivity` field in frontmatter:

- `PII` — Personally Identifiable Information
- `financial` — Financial data
- `health` — Health information (HIPAA)
- `payment` — Payment card data (PCI-DSS)
- `intellectual-property` — Trade secrets, IP

---

**Note:** Customize classification levels and requirements for your organization.
