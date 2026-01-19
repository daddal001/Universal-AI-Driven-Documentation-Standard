---
title: "Migration Guide: [From Version] to [To Version]"
type: "guide"
status: "approved"
owner: "@author"
classification: "internal"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Migration Guide: [From Version] to [To Version]

Step-by-step instructions for engineers upgrading [component/library] from [old version] to [new version]. This guide covers breaking changes, deprecations, and a tested migration path. Use when upgrading services that depend on [component].

---

## Overview

| Property | Value |
|----------|-------|
| **From Version** | [X.X.X] |
| **To Version** | [Y.Y.Y] |
| **Estimated Effort** | [X hours/days] |
| **Risk Level** | Low / Medium / High |
| **Rollback Possible** | Yes / No |

---

## Breaking Changes

### 1. [Breaking Change Title]

**What changed:**

```diff
- old_function(arg1, arg2)
+ new_function(arg1, options={arg2: value})
```

**Migration:**

```python
# Before
old_function("value", True)

# After
new_function("value", options={"feature": True})
```

### 2. [Breaking Change Title]

**What changed:** [Description]

**Migration:** [Steps]

---

## Deprecations

| Deprecated | Replacement | Removal Version |
|------------|-------------|-----------------|
| `old_method()` | `new_method()` | v3.0.0 |
| `legacy_config` | `config.legacy` | v3.0.0 |

---

## Migration Steps

### Pre-Migration Checklist

- [ ] Read this entire guide
- [ ] Backup database / state
- [ ] Notify stakeholders of planned downtime
- [ ] Test migration in staging first

### Step 1: Update Dependencies

```bash
npm install [package]@[version]
# or
pip install [package]==[version]
```

### Step 2: Update Configuration

```diff
# config.yaml
- old_setting: value
+ new_setting:
+   option: value
```

### Step 3: Update Code

[Describe code changes needed]

### Step 4: Run Migrations

```bash
# Database migrations
./migrate.sh

# Verify
./verify-migration.sh
```

### Step 5: Deploy

```bash
# Deploy to staging first
make deploy-staging

# Verify staging
make test-staging

# Deploy to production
make deploy-production
```

---

## Verification

After migration, verify:

```bash
# Check version
[command] --version
# Expected: [new version]

# Run tests
make test
# Expected: All passing

# Check functionality
curl http://localhost:8080/health
# Expected: {"status": "healthy", "version": "[new version]"}
```

---

## Rollback Plan

If issues occur:

```bash
# Rollback to previous version
npm install [package]@[old-version]
# or
git revert [commit-hash]

# Restore database if needed
./restore-backup.sh [backup-file]
```

---

## Known Issues

| Issue | Workaround | Fixed In |
|-------|------------|----------|
| [Issue description] | [Workaround] | [Version] |

---

## Related

| Document | Purpose |
|----------|---------|
| [CHANGELOG](./CHANGELOG.md) | Full change history |
| [Breaking Changes Policy](./BREAKING_CHANGES.md) | Version policy |
