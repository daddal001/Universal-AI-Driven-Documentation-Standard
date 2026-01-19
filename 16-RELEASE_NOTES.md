---
title: "Release Notes & Changelog Standard"
type: "standard"
status: "approved"
owner: "@release-engineering"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-09"
version: "1.0.0"
---



> **Goal:** Communicate changes clearly to humans, not just machines. Adhere to "Keep a Changelog" principles and Semantic Versioning.

---

## 1. Principles

1. **Changelogs are for humans.** Do not just dump `git log` output.
2. **One entry per change.** Group by type, not by commit.
3. **Link to issues/PRs.** Always provide traceability.
4. **Date your releases.** ISO 8601 (`YYYY-MM-DD`).

---

## 2. Enforcement

To ensure the changelog stays up-to-date, all CI pipelines **MUST** enforce the following rule:

> **"Every Pull Request that affects code MUST include an update to `CHANGELOG.md`."**

### CI Check Implementation

Use the standard script `docs/standards/scripts/check-changelog.sh` in your pipeline.

**Bypassing:**
If a change is trivial (e.g., fixing a typo, updating CI config), add the label `skip-changelog` to the PR to bypass this check.

---

## 3. Standard Structure (`CHANGELOG.md`)

Use this exact Markdown structure for the `CHANGELOG.md` at the root of the repository.

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New authentication provider: Auth0.

## [1.0.0] - 2025-12-09

### Added
- Initial release of the Documentation Standard.
- Added `validate-frontmatter.sh` script.

### Changed
- **BREAKING**: Renamed `docs/spec` to `docs/standards`.
- Updated CI pipeline to run linting on every commit.

### Fixed
- Fixed typo in dashboard URL (#123).

### Security
- Upgraded `request` library to v2.88.2 to fix CVE-2025-1001.
```

---

## 3. Change Types

Group changes under these standard headers:

| Header | Meaning |
|--------|---------|
| **Added** | New features. |
| **Changed** | Changes in existing functionality. |
| **Deprecated** | Features soon to be removed. |
| **Removed** | Features now removed. |
| **Fixed** | Bug fixes. |
| **Security** | Vulnerability fixes. |

---

## 4. Release Notes vs. Changelogs

| Feature | Changelog (`CHANGELOG.md`) | Release Notes (GitHub Release / Email) |
|---------|----------------------------|----------------------------------------|
| **Audience** | Developers, Maintainers | End Users, Stakeholders |
| **Granularity** | Every notable change | High-level summary of value |
| **Tone** | Technical, terse | Marketing-friendly, explanatory |
| **Format** | Bullet points | Paragraphs + Bullet points |

### Release Note Example

> **v1.0 is here! 🚀**
>
> We are thrilled to announce the first major release of the Documentation Standard. This release brings a modular architecture that scales to thousands of repositories.
>
> **Highlights:**
>
> * **Modular Design:** 16 separate standards files for easier maintenance.
> * **Automation:** New scripts to validate quality automatically.
>
> *For the full list of changes, see the [Changelog](./CHANGELOG.md).*

---

## 5. Versioning Strategy (SemVer)

We strictly follow **Semantic Versioning 2.0.0**: `MAJOR.MINOR.PATCH`

* **MAJOR**: Incompatible API changes (Breaking).
* **MINOR**: Backwards-compatible functionality (Features).
* **PATCH**: Backwards-compatible bug fixes.

**Note:** Documentation changes that do not affect code logic are usually **PATCH** level, unless they fundamentally change the specification/governance (then **MINOR** or **MAJOR**).

---

## 6. Related Documents

| Document | Purpose |
|----------|---------|
| [Governance](./07-GOVERNANCE.md) | Release approval process |
| [CLI Tools](./15-CLI_TOOLS.md) | Version flag standards |

---

**Previous:** [15 - CLI Tools](./15-CLI_TOOLS.md)
**Next:** [17 - Maturity Model](./17-MATURITY_MODEL.md)
