---
title: "Dependency & Versioning Documentation"
type: "standard"
status: "approved"
owner: "@platform-team"
classification: "public"
created: "2025-12-10"
last_updated: "2025-12-10"
version: "1.0.0"
---

# Dependency & Versioning Documentation

> **Goal:** Document dependencies, versioning strategies, and upgrade paths so teams understand what's in use, why, and how to safely update.

---

## 1. Semantic Versioning

### Version Format

All projects MUST use [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]

Examples:
- 1.0.0       — First stable release
- 1.2.3       — Stable release with patches
- 2.0.0-beta  — Major version beta
- 2.1.0-rc.1  — Release candidate
```

### Version Increment Rules

| Change Type | Increment | Example |
|-------------|-----------|---------|
| Breaking API change | MAJOR | 1.x.x → 2.0.0 |
| New feature (backward compatible) | MINOR | 1.2.x → 1.3.0 |
| Bug fix (backward compatible) | PATCH | 1.2.3 → 1.2.4 |

### Breaking Change Documentation

When incrementing MAJOR version:

```markdown
# Breaking Changes in v2.0.0

## Summary

This release contains breaking changes. Please read carefully.

## Breaking Changes

### 1. API Response Format Changed

**Before (v1.x):**
```json
{ "data": [...], "error": null }
```

**After (v2.x):**

```json
{ "items": [...], "meta": { "total": 100 } }
```

**Migration:**

```diff
- const items = response.data;
+ const items = response.items;
```

### 2. Removed Deprecated Methods

| Removed | Replacement |
|---------|-------------|
| `getUserById()` | `getUser({ id })` |
| `createOrder()` | `orders.create()` |

```

---

## 2. Dependency Documentation

### Dependencies README

Every project MUST document key dependencies:

```markdown
# Dependencies

## Core Dependencies

| Package | Version | Purpose | Why Chosen |
|---------|---------|---------|------------|
| react | 18.2.0 | UI framework | Industry standard |
| typescript | 5.3.0 | Type safety | Maintainability |
| axios | 1.6.0 | HTTP client | Interceptors, cancel tokens |
| zod | 3.22.0 | Validation | Type inference |

## Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| vitest | 1.0.0 | Unit testing |
| playwright | 1.40.0 | E2E testing |
| eslint | 8.56.0 | Linting |
| prettier | 3.1.0 | Formatting |

## Infrastructure Dependencies

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | 20.x LTS | Runtime |
| PostgreSQL | 15.x | Database |
| Redis | 7.x | Caching |
| Docker | 24.x | Containerization |
```

---

## 3. Lock File Documentation

### Why Lock Files Matter

```markdown
# Lock File Policy

## Required Lock Files

| Package Manager | Lock File |
|-----------------|-----------|
| npm | `package-lock.json` |
| yarn | `yarn.lock` |
| pnpm | `pnpm-lock.yaml` |
| pip | `requirements.lock` or `Pipfile.lock` |
| poetry | `poetry.lock` |
| go | `go.sum` |

## Rules

1. **ALWAYS commit lock files** to version control
2. **NEVER manually edit** lock files
3. **Review lock file changes** in PRs
4. **Regenerate** if conflicts occur

## Updating Dependencies

```bash
# Update single dependency
npm update axios

# Update all (minor + patch)
npm update

# Update all (including major)
npx npm-check-updates -u

# Regenerate lock file
rm package-lock.json && npm install
```

```

---

## 4. Security Vulnerability Tracking

### Vulnerability Documentation

```markdown
# Security Vulnerabilities

## Active Vulnerabilities

| ID | Package | Severity | Status | Ticket |
|----|---------|----------|--------|--------|
| CVE-2024-1234 | lodash | High | Patching | SEC-101 |
| CVE-2024-5678 | express | Medium | Monitoring | SEC-102 |

## Scanning Tools

| Tool | Purpose | Frequency |
|------|---------|-----------|
| `npm audit` | Node.js deps | Every build |
| `snyk` | All ecosystems | Daily |
| `dependabot` | GitHub alerts | Continuous |
| `trivy` | Container images | Every build |

## Vulnerability Response SLAs

| Severity | Response Time | Resolution Time |
|----------|---------------|-----------------|
| Critical | 1 hour | 24 hours |
| High | 4 hours | 72 hours |
| Medium | 1 week | 2 weeks |
| Low | 2 weeks | Next release |

## Running Security Scans

```bash
# npm audit
npm audit

# With fix
npm audit fix

# Snyk
snyk test

# Generate SBOM
syft . -o spdx-json > sbom.json
```

```

---

## 5. Upgrade Guides

### Upgrade Guide Template

```markdown
# Upgrade Guide: v1.x → v2.x

## Overview

| From | To | Difficulty | Time |
|------|----|------------|------|
| 1.x | 2.0 | Medium | 2-4 hours |

## Prerequisites

- [ ] Node.js 20+ installed
- [ ] Backup your database
- [ ] Run tests on current version

## Step-by-Step Upgrade

### 1. Update Dependencies

```bash
npm install package-name@2.0.0
```

### 2. Run Codemods

```bash
npx @package/codemod --transform v2-migration
```

### 3. Manual Changes

#### 3.1 Update Imports

```diff
- import { oldFunction } from 'package';
+ import { newFunction } from 'package';
```

#### 3.2 Update Configuration

```diff
// config.js
- option: 'old-value',
+ option: 'new-value',
```

### 4. Test

```bash
npm test
npm run test:e2e
```

### 5. Deploy

Follow standard deployment process.

## Rollback

If issues occur:

```bash
npm install package-name@1.9.0
```

## FAQ

**Q: Is v1.x still supported?**
A: Security patches only until Dec 2025.

**Q: Can I skip v1.9 and go directly to v2?**
A: Yes, this guide covers the full migration.

```

---

## 6. Changelog Documentation

### Changelog Format (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- New feature description

## [2.1.0] - 2025-12-10

### Added
- Guest checkout flow (#234)
- Apple Pay integration (#245)

### Changed
- Improved checkout performance by 40% (#256)

### Fixed
- Cart total calculation bug (#267)

### Deprecated
- `legacyCheckout()` function, use `checkout()` instead

### Removed
- Support for Node.js 16

### Security
- Updated axios to fix CVE-2024-1234

## [2.0.0] - 2025-11-01

### Changed
- **BREAKING:** API response format changed

[Unreleased]: https://github.com/org/repo/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/org/repo/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/org/repo/releases/tag/v2.0.0
```

---

## 7. Dependency Decision Records

### When to Document

Create a dependency decision record for:

- New major dependencies
- Replacing existing dependencies
- Upgrading with breaking changes

```markdown
# DDR-001: Adopting Zod for Validation

## Status

Accepted

## Context

We need runtime validation for API inputs. Currently using:
- `joi` — Large bundle, slow types
- `yup` — Good, but TypeScript inference limited

## Decision

Adopt `zod` for all validation.

## Reasons

1. **TypeScript Integration** — Types inferred from schemas
2. **Bundle Size** — 12KB vs 52KB (joi)
3. **Performance** — 2x faster validation
4. **Ecosystem** — Works with tRPC, React Hook Form

## Consequences

- Need to migrate existing joi schemas
- Team training on zod API
- Update documentation

## Migration Plan

1. Add zod to dependencies
2. Create new schemas in zod
3. Migrate existing schemas (2 weeks)
4. Remove joi

## Decision Date

2025-12-10

## Decision Makers

@tech-lead, @backend-team
```

---

## 8. Related Documents

| Document | Purpose |
|----------|---------|
| [Release Notes](./16-RELEASE_NOTES.md) | Changelog format |
| [Security & Compliance](./24-SECURITY_COMPLIANCE.md) | Vulnerability handling |
| [CI/CD Pipelines](./22-CICD_PIPELINES.md) | Dependency scanning |

---

**Previous:** [30 - Testing](./30-TESTING.md)
**Next:** [32 - Progressive Disclosure](./32-PROGRESSIVE_DISCLOSURE.md)
