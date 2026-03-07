---
title: "Monorepo Documentation Patterns"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2026-03-07"
last_updated: "2026-03-07"
version: "1.0.0"
---

# Monorepo Documentation Patterns

> **Goal:** Define documentation standards for monorepos — repositories containing multiple packages, services, or applications — ensuring each component is independently documented while maintaining a coherent whole.

---

## 1. The Monorepo Documentation Problem

Monorepos amplify documentation challenges:

* **Discoverability:** With 10+ packages, new developers cannot find the right docs.
* **Ownership:** Unclear who maintains docs for shared libraries vs. applications.
* **Scope:** A single `README.md` cannot cover everything. Per-package READMEs get out of sync.
* **Cross-references:** Packages depend on each other — docs must link without creating circular or broken references.
* **CI/CD:** Doc validation must run per-package, not just repo-wide.

This standard addresses each of these challenges.

---

## 2. Documentation Hierarchy

A monorepo uses a **three-tier documentation hierarchy**:

```text
repo-root/
├── README.md                    # Tier 1: Repo overview
├── docs/                        # Tier 1: Cross-cutting docs
│   ├── architecture.md
│   ├── contributing.md
│   ├── getting-started.md
│   └── adr/
├── packages/                    # Tier 2: Per-package docs
│   ├── auth/
│   │   ├── README.md            # Package overview
│   │   ├── docs/
│   │   │   ├── configuration.md
│   │   │   └── api.md
│   │   ├── CHANGELOG.md
│   │   └── src/
│   ├── payments/
│   │   ├── README.md
│   │   ├── docs/
│   │   └── src/
│   └── shared-utils/
│       ├── README.md
│       └── src/
└── tools/                       # Tier 3: Tooling docs
    ├── cli/
    │   └── README.md
    └── scripts/
        └── README.md
```

### Tier Responsibilities

| Tier | Location | Audience | Covers |
|------|----------|----------|--------|
| **1. Repo-level** | `README.md`, `docs/` | Everyone | Architecture, onboarding, ADRs, cross-cutting concerns |
| **2. Package-level** | `packages/*/README.md`, `packages/*/docs/` | Package consumers and contributors | API, config, changelog, package-specific guides |
| **3. Tooling** | `tools/*/README.md` | Contributors | Build tools, scripts, CI helpers |

---

## 3. Root README Requirements

The root `README.md` in a monorepo MUST include:

### 3.1 Package Directory

A table or list of all packages with one-line descriptions:

```markdown
## Packages

| Package | Description | Status |
|---------|-------------|--------|
| [`@acme/auth`](packages/auth/) | Authentication and authorization | Stable |
| [`@acme/payments`](packages/payments/) | Payment processing (Stripe) | Beta |
| [`@acme/shared-utils`](packages/shared-utils/) | Shared TypeScript utilities | Stable |
| [`@acme/cli`](tools/cli/) | Developer CLI tool | Alpha |
```

### 3.2 Getting Started

A clear path from clone to running locally:

```markdown
## Getting Started

1. Clone: `git clone <repo-url>`
2. Install: `pnpm install` (installs all packages)
3. Build: `pnpm build`
4. Test: `pnpm test`

### Working on a specific package

cd packages/auth
pnpm dev
```

### 3.3 Cross-Package Dependency Map

For repos with inter-package dependencies, include a visual or table:

```markdown
## Dependency Map

auth ──depends-on──> shared-utils
payments ──depends-on──> auth, shared-utils
cli ──depends-on──> auth, payments
```

---

## 4. Per-Package README Requirements

Every package MUST have its own `README.md` with:

| Section | Required | Description |
|---------|----------|-------------|
| Package name and description | Yes | What this package does |
| Installation | Yes | How to install/use as a dependency |
| Quick start | Yes | Minimal usage example |
| API reference (or link) | Yes | Public API surface |
| Configuration | Conditional | If the package has config options |
| Contributing | No | Link to root `CONTRIBUTING.md` or package-specific |
| Changelog | Yes | Inline or link to `CHANGELOG.md` |

### Template

```markdown
# @acme/auth

> Authentication and authorization library for Acme services.

## Installation

pnpm add @acme/auth

## Quick Start

import { createAuthClient } from '@acme/auth';
const client = createAuthClient({ issuer: 'https://auth.acme.com' });

## API Reference

See [API documentation](./docs/api.md).

## Configuration

See [Configuration guide](./docs/configuration.md).

## Changelog

See [CHANGELOG.md](./CHANGELOG.md).
```

---

## 5. Cross-Package References

### 5.1 Linking Rules

| Scenario | Link Format | Example |
|----------|-------------|---------|
| Same package | Relative path | `[Config](./docs/configuration.md)` |
| Sibling package | Relative from root | `[Auth API](../auth/docs/api.md)` |
| Root docs | Relative to root | `[Architecture](../../docs/architecture.md)` |
| External | Absolute URL | `[Stripe Docs](https://stripe.com/docs)` |

### 5.2 Avoiding Circular References

* Document shared concepts in `docs/` (root level), not in any single package.
* Packages link UP to shared docs, never sideways for shared concepts.
* Use a "See Also" section at the bottom rather than inline cross-references.

---

## 6. Workspace-Aware Documentation

### 6.1 Workspace Tool Integration

| Tool | Config File | Doc Pattern |
|------|-------------|-------------|
| **pnpm** | `pnpm-workspace.yaml` | `packages/*/README.md` auto-discovered |
| **npm workspaces** | `package.json` `workspaces` | Same pattern |
| **Turborepo** | `turbo.json` | Add `docs` pipeline task |
| **Nx** | `nx.json`, `project.json` | Per-project `README.md`, Nx graph for deps |
| **Bazel** | `BUILD` files | `BUILD` + `README.md` per target |
| **Cargo** (Rust) | `Cargo.toml` workspace | `crates/*/README.md` |
| **Go modules** | `go.work` | `cmd/*/README.md`, `pkg/*/README.md` |

### 6.2 Automated Package Discovery

CI can validate that every workspace package has a README:

```bash
#!/bin/bash
# Verify every package has a README
missing=0
for pkg_dir in packages/*/; do
  if [ ! -f "$pkg_dir/README.md" ]; then
    echo "::error::Missing README.md in $pkg_dir"
    missing=$((missing + 1))
  fi
done
exit $missing
```

---

## 7. Changelogs in Monorepos

### 7.1 Per-Package Changelogs

Each publishable package maintains its own `CHANGELOG.md`. Use tools that automate this:

| Tool | Ecosystem | How It Works |
|------|-----------|-------------|
| **Changesets** | npm/pnpm | Developers add changeset files; CI generates changelogs |
| **Conventional Commits** | Any | Commit message format drives changelog generation |
| **Lerna** | npm | `lerna version` updates changelogs per package |
| **Release Please** | Any | GitHub Action parses commits, creates release PRs |

### 7.2 Root Changelog

The root `CHANGELOG.md` is a high-level summary that links to per-package changelogs:

```markdown
## 2026-03-07

### @acme/auth v2.1.0
- Add SSO support ([changelog](packages/auth/CHANGELOG.md))

### @acme/payments v1.3.0
- Add Stripe v3 integration ([changelog](packages/payments/CHANGELOG.md))
```

---

## 8. Doc-Enforcement in Monorepos

The [docs-enforcement hook](../scripts/git-hooks/README.md) uses **scope resolution** — it walks up the directory tree from each changed file to find the nearest `README.md`. This works naturally with monorepos:

| Changed File | Nearest README | Scope |
|-------------|----------------|-------|
| `packages/auth/src/login.ts` | `packages/auth/README.md` | `packages/auth/` |
| `packages/payments/src/charge.ts` | `packages/payments/README.md` | `packages/payments/` |
| `tools/cli/src/main.ts` | `tools/cli/README.md` | `tools/cli/` |

A code change in `packages/auth/` requires a doc update somewhere in `packages/auth/` — not in an unrelated package.

---

## 9. CI/CD Documentation Validation

### 9.1 Per-Package Validation

Run doc checks scoped to changed packages, not the entire repo:

```yaml
# .github/workflows/docs-validation.yml
- name: Detect changed packages
  id: changes
  run: |
    changed=$(git diff --name-only origin/main...HEAD | grep '^packages/' | cut -d/ -f2 | sort -u)
    echo "packages=$changed" >> $GITHUB_OUTPUT

- name: Validate docs for changed packages
  run: |
    for pkg in ${{ steps.changes.outputs.packages }}; do
      echo "Validating packages/$pkg/"
      bash scripts/validate-frontmatter.sh "packages/$pkg/"
      bash scripts/validate-structure.sh "packages/$pkg/"
    done
```

### 9.2 README Existence Check

```yaml
- name: Verify package READMEs exist
  run: |
    for dir in packages/*/; do
      if [ ! -f "$dir/README.md" ]; then
        echo "::error::$dir is missing README.md"
        exit 1
      fi
    done
```

---

## 10. Validation Checklist

- [ ] Root README includes package directory table
- [ ] Every package has its own README with required sections
- [ ] Cross-package links use correct relative paths
- [ ] Shared concepts are documented at root level, not duplicated per-package
- [ ] Per-package changelogs exist for publishable packages
- [ ] CI validates docs per changed package, not repo-wide
- [ ] Doc-enforcement hook correctly resolves scopes to package boundaries
- [ ] Workspace tool config and doc structure are aligned

---

## 11. Related Documents

| Document | Purpose |
|----------|---------|
| [Repository Structure](./02-REPOSITORY_STRUCTURE.md) | Base directory conventions |
| [Versioning](./04-VERSIONING.md) | Changelog and versioning standards |
| [Configuration & Flags](./43-CONFIGURATION_FLAGS.md) | Per-package config documentation |
| [Error Catalog](./44-ERROR_CATALOG.md) | Per-service error namespacing |

---

**Previous:** [44 - Error Catalog](./44-ERROR_CATALOG.md)
**Next:** [Index](./INDEX.md)
