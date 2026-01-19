---
title: "Open Source Documentation Standards"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
---

# Open Source Documentation Standards

> **Goal:** Documentation standards specifically tailored for open source projects, focusing on community engagement, contributor onboarding, and public-facing clarity.

---

## Table of Contents

1. [Open Source Documentation Principles](#open-source-documentation-principles)
2. [Essential Documentation](#essential-documentation)
3. [Contributor Onboarding](#contributor-onboarding)
4. [Public-Facing Considerations](#public-facing-considerations)
5. [Community Guidelines](#community-guidelines)
6. [Translation and Localization](#translation-and-localization)
7. [Security Disclosure](#security-disclosure)
8. [Release Process](#release-process)
9. [Maintainer Handoff](#maintainer-handoff)

---

## Open Source Documentation Principles

### 1. Assume Zero Prior Knowledge

Open source projects have diverse audiences:

- **First-time contributors** who may not know your tech stack
- **Users from different industries** with varying technical backgrounds
- **International community members** where English is a second language
- **Future maintainers** who may inherit the project years later

**Implication:** Document prerequisites explicitly, avoid internal jargon, provide context for decisions.

### 2. Public Accountability

Unlike internal documentation, OSS docs are:

- **Permanently visible** - mistakes are public and archived
- **Searchable by employers** - poor docs reflect on maintainers
- **Referenced in tutorials** - errors propagate across the ecosystem

**Implication:** Maintain higher quality bar, update docs proactively when code changes.

### 3. Community-Driven Evolution

OSS documentation must:

- **Welcome contributions** - make it easy to suggest improvements
- **Accept imperfection** - incremental improvements beat perfection paralysis
- **Acknowledge contributors** - recognition motivates volunteer work

**Implication:** Use templates, provide clear contribution guidelines, celebrate doc PRs.

### 4. Long-Term Maintainability

Projects may outlive original creators:

- **Bus factor awareness** - document tribal knowledge before it's lost
- **Onboarding efficiency** - new maintainers should get productive in < 1 week
- **Architecture rationale** - explain *why* decisions were made

**Implication:** Write docs for your future replacement, not yourself.

---

## Essential Documentation

All open source projects MUST include these files:

### README.md (Required)

**Template:** [`docs/standards/templates/tier-oss/README.md`](./templates/tier-oss/README.md)

**Required Sections:**

1. **Project Title + One-Line Description**

   ```markdown
   # Project Name
   > A brief, compelling one-line description of what this does
   ```

2. **Badges** (build status, coverage, license, version)

   ```markdown
   ![Build](https://img.shields.io/github/actions/workflow/status/...)
   ![Coverage](https://img.shields.io/codecov/c/github/...)
   ![License](https://img.shields.io/github/license/...)
   ```

3. **Features** (3-5 bullet points)
4. **Quick Start** (< 10 minutes to "Hello World")
5. **Installation** (all platforms, with prerequisites)
6. **Usage Examples** (realistic, working code)
7. **Documentation Links** (full docs, API reference)
8. **Contributing** (link to CONTRIBUTING.md)
9. **License** (SPDX identifier + link to LICENSE file)

**Quality Test:**
> Can a developer who's never seen this project get it running in < 10 minutes by following the README alone?

### CONTRIBUTING.md (Required)

**Template:** [`docs/standards/templates/tier-oss/CONTRIBUTING.md`](./templates/tier-oss/CONTRIBUTING.md)

**Required Sections:**

1. **Welcome Message** - Make contributors feel valued
2. **Ways to Contribute** - Code, docs, bug reports, design, translations
3. **Development Setup** - Complete environment setup instructions
4. **Coding Standards** - Linters, formatters, style guide
5. **Commit Message Format** - Conventional commits or project standard
6. **Pull Request Process** - How to submit, what happens next
7. **Code Review Expectations** - Timeline, feedback style
8. **Community Guidelines** - Link to CODE_OF_CONDUCT.md

**Example:**

```markdown
## Development Setup

1. **Prerequisites:**
   - Node.js 18.18+
   - Docker Desktop
   - Git

2. **Clone and Install:**
   ```bash
   git clone https://github.com/yourorg/project.git
   cd project
   npm install
   ```

1. **Run Tests:**

   ```bash
   npm test
   ```

2. **Start Dev Server:**

   ```bash
   npm run dev
   ```

Expected output: Server running at <http://localhost:3000>

```

### LICENSE (Required)

**Common Choices:**

| License | Use Case | Restrictions |
|---------|----------|--------------|
| **MIT** | Maximum permissiveness | None - do whatever you want |
| **Apache 2.0** | Patent protection needed | Requires license/copyright notice |
| **GPL v3** | Ensure derivatives stay open | Derivatives must use GPL |
| **AGPL v3** | Network service copyleft | SaaS must share source |

**Template:** Use GitHub's license picker or [`docs/standards/templates/tier-oss/LICENSE.md`](./templates/tier-oss/LICENSE.md)

### CODE_OF_CONDUCT.md (Required)

**Template:** [`docs/standards/templates/tier-oss/CODE_OF_CONDUCT.md`](./templates/tier-oss/CODE_OF_CONDUCT.md)

**Standard:** Use [Contributor Covenant v2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/)

**Why Required:**
- GitHub requires it for "Community" badge
- Establishes behavioral expectations
- Provides enforcement mechanism
- Protects marginalized contributors

### SECURITY.md (Required)

**Template:** [`docs/standards/templates/tier-oss/SECURITY.md`](./templates/tier-oss/SECURITY.md)

**Required Sections:**

1. **Supported Versions** - Which versions receive security updates
2. **Reporting Vulnerabilities** - Email, security advisory, bug bounty
3. **Response Timeline** - When to expect acknowledgment
4. **Disclosure Policy** - Coordinated vs full disclosure
5. **CVE Process** - How vulnerabilities are documented

**Example:**
```markdown
## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x     | :white_check_mark: |
| 1.x     | :x:                |

## Reporting a Vulnerability

**DO NOT** open a public issue for security vulnerabilities.

Instead, email security@example.com with:
- Description of vulnerability
- Steps to reproduce
- Potential impact

**Expected Response:** Acknowledgment within 48 hours.
```

### CHANGELOG.md (Required)

**Template:** [`docs/standards/templates/tier-oss/CHANGELOG.md`](./templates/tier-oss/CHANGELOG.md)

**Standard:** Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

**Format:**

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
### Added
- Feature X for use case Y

## [2.1.0] - 2025-12-15
### Added
- New API endpoint `/v1/export`
### Fixed
- Bug #123: Rate limiting edge case

## [2.0.0] - 2025-11-01
### Breaking Changes
- Removed deprecated `legacy_api()` function
```

**Link to:** [16-RELEASE_NOTES.md](./16-RELEASE_NOTES.md) for detailed release note standards.

---

## Contributor Onboarding

### First-Time Contributor Experience

**Goal:** Enable a complete novice to submit their first PR in < 1 hour.

**Checklist:**

1. **Environment Setup** (< 10 minutes)
   - Single command setup if possible: `npm run setup` or `make init`
   - Docker-based dev environment for consistency
   - Automated dependency installation

2. **Verification Steps** (< 5 minutes)
   - Health check command: `npm run check` or `make verify`
   - Sample output showing success
   - Clear error messages with solutions

3. **First Contribution Ideas** (Clearly Labeled)
   - GitHub issues labeled `good-first-issue` or `beginner-friendly`
   - Documentation improvements (always accessible)
   - Test coverage gaps (good for learning codebase)

**Example Setup Script:**

```bash
#!/bin/bash
# scripts/setup-dev.sh

echo "🚀 Setting up development environment..."

# Check prerequisites
command -v docker >/dev/null 2>&1 || { echo "❌ Docker required"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "❌ Node.js 18+ required"; exit 1; }

# Install dependencies
npm install

# Setup pre-commit hooks
npm run prepare

# Start services
docker-compose up -d

# Run health check
npm run test:health

echo "✅ Setup complete! Run 'npm run dev' to start developing."
```

### Contribution Workflow

Document the exact steps:

**In CONTRIBUTING.md:**

```markdown
## Step-by-Step Contribution Guide

1. **Fork the repository** on GitHub
2. **Clone your fork:**

   ```bash
   git clone https://github.com/YOUR_USERNAME/project.git
   ```

1. **Create a feature branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** and test locally
3. **Commit with conventional format:**

   ```bash
   git commit -m "feat: add feature X"
   ```

4. **Push to your fork:**

   ```bash
   git push origin feature/your-feature-name
   ```

5. **Open a Pull Request** on the original repository
6. **Respond to feedback** from maintainers

### Code Review Expectations

**Set Clear Expectations:**

| Aspect | Expectation |
|--------|-------------|
| **Initial Response** | Within 48 hours (weekdays) |
| **Review Turnaround** | 3-5 business days for first review |
| **Feedback Style** | Constructive, educational, respectful |
| **Approval Criteria** | Tests pass, docs updated, no regressions |

**Communicate Unavailability:**

```markdown
## Maintainer Availability

- **Active maintenance:** Weekdays 9am-5pm UTC
- **Response time:** 2-3 business days
- **Holidays:** Responses may be delayed during December/January
```

### Recognition and Attribution

**Contributors.md:**

Automatically generate from Git history:

```bash
# Generate contributors list
git log --format='%aN' | sort -u > CONTRIBUTORS.md
```

**Release Notes Attribution:**

```markdown
## [2.1.0] - 2025-12-15

### Added
- Feature X by @contributor123

### Fixed
- Bug #45 by @newcontributor

**New Contributors:**
- @newcontributor made their first contribution! 🎉
```

---

## Public-Facing Considerations

### Writing for a Global Audience

**Language Guidelines:**

1. **Use Simple English** (Grade 8-10 reading level)
   - Short sentences (< 25 words)
   - Active voice preferred
   - Avoid idioms ("piece of cake", "low-hanging fruit")

2. **Define Technical Terms**
   - First use: "API (Application Programming Interface)"
   - Link to glossary for complex concepts

3. **Cultural Sensitivity**
   - Avoid region-specific examples (US holidays, sports references)
   - Use ISO date format (YYYY-MM-DD)
   - Avoid slang or colloquialisms

**Example:**

❌ **Bad:**

```markdown
Setting up the database is a piece of cake! Just hit the endpoint and you're golden.
```

✅ **Good:**

```markdown
Setting up the database is straightforward. Send a POST request to `/api/setup`
to initialize the database schema.
```

### Avoiding Internal Jargon

**Jargon Audit Checklist:**

- [ ] Replace internal project names with descriptive terms
- [ ] Explain acronyms on first use
- [ ] Avoid company-specific tools ("our internal Jenkins" → "CI/CD pipeline")
- [ ] Define domain-specific terminology

**Example:**

❌ **Bad:**

```markdown
Deploy using our Acme Deployer. Contact the SRE team via Slack #oncall.
```

✅ **Good:**

```markdown
Deploy using standard Docker commands:
```

docker build -t myapp .
docker run -p 8080:8080 myapp

```
For deployment issues, open a GitHub issue with the "deployment" label.
```

### Brand Consistency

**Style Guide Elements:**

- **Product Name Capitalization:** "MyProject" (not "myproject" or "my-project")
- **Logo Usage:** Provide brand assets in `docs/brand/` folder
- **Color Palette:** Document primary/secondary colors for custom docs sites
- **Tone:** Professional but approachable, helpful but not condescending

### SEO Optimization

**Documentation Site Best Practices:**

1. **Descriptive Titles:** Use keyword-rich, specific titles
   - ❌ "Setup" → ✅ "Setup MyProject on Ubuntu Linux"

2. **Meta Descriptions:** Add frontmatter for static site generators

   ```yaml
   ---
   title: "Authentication Guide"
   description: "Complete guide to implementing OAuth2 authentication with MyProject"
   ---
   ```

3. **Header Hierarchy:** Proper H1 → H2 → H3 structure for crawlers

4. **Alt Text:** All images/diagrams must have descriptive alt text

5. **Internal Linking:** Link related documentation pages

---

## Community Guidelines

### Communication Channels

**Recommended Structure:**

| Channel | Purpose | Response SLA |
|---------|---------|--------------|
| **GitHub Issues** | Bug reports, feature requests | 3-5 business days |
| **GitHub Discussions** | Q&A, general discussion | Best effort |
| **Discord/Slack** | Real-time community chat | Community-driven |
| **Email** | Security issues, private matters | 48 hours |

**Document in README.md:**

```markdown
## Community

- **Questions?** Open a [GitHub Discussion](https://github.com/org/project/discussions)
- **Bug Reports:** Use [GitHub Issues](https://github.com/org/project/issues)
- **Chat:** Join our [Discord](https://discord.gg/...)
- **Security:** Email security@example.com
```

### Issue Triage Process

**Workflow:**

```
New Issue → Label (bug/feature/question) → Priority → Assign/Comment → Close
```

**Labels:**

| Label | Meaning | Who Adds |
|-------|---------|----------|
| `bug` | Something broken | Reporter |
| `feature` | Enhancement request | Reporter |
| `good-first-issue` | Beginner-friendly | Maintainer |
| `help-wanted` | Looking for contributor | Maintainer |
| `duplicate` | Already reported | Maintainer |
| `wontfix` | Not planned | Maintainer |

**Template (.github/ISSUE_TEMPLATE/bug_report.yml):**

```yaml
name: Bug Report
description: Report a bug
body:
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: Clear description of the bug
    validations:
      required: true
  - type: textarea
    id: reproduce
    attributes:
      label: Steps to Reproduce
      placeholder: |
        1. Run command X
        2. Click button Y
        3. See error
    validations:
      required: true
  - type: input
    id: version
    attributes:
      label: Version
      description: Which version are you using?
    validations:
      required: true
```

### Pull Request Expectations

**PR Template (.github/pull_request_template.md):**

```markdown
## Description
<!-- Brief description of what this PR does -->

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
<!-- How did you test this? -->

## Checklist
- [ ] Code follows project style guidelines
- [ ] Tests added/updated and passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (if applicable)
```

### Release Cadence

**Communicate Expectations:**

```markdown
## Release Schedule

- **Patch releases** (bug fixes): As needed
- **Minor releases** (new features): Monthly
- **Major releases** (breaking changes): Quarterly

**Next planned release:** v2.1.0 on 2025-01-15

See [CHANGELOG.md](./CHANGELOG.md) for full version history.
```

### Governance Model

**For mature projects, document:**

- **Decision-making process** (consensus, voting, BDFL)
- **Maintainer roles** (core, committer, contributor)
- **How to become a maintainer**
- **Conflict resolution**

**Example (GOVERNANCE.md):**

```markdown
## Governance

**Model:** Benevolent Dictator For Life (BDFL)

**Roles:**
- **BDFL:** @founder (final decision authority)
- **Core Maintainers:** @alice, @bob (merge rights, release management)
- **Contributors:** All community members

**Becoming a Maintainer:**
1. Consistent high-quality contributions over 6+ months
2. Demonstration of project values
3. Nomination by existing maintainer
4. Consensus approval from core team
```

---

## Translation and Localization

### i18n Documentation Strategy

**Prioritization:**

1. **Start with README.md** - highest visibility
2. **Critical docs next** - installation, quick start
3. **Full docs** - API reference, guides

**Directory Structure:**

```
docs/
├── en/               # English (source)
│   ├── README.md
│   └── guides/
├── es/               # Spanish
│   ├── README.md
│   └── guides/
└── zh/               # Chinese
    ├── README.md
    └── guides/
```

### Translation Workflow

**Recommended Tools:**

| Tool | Use Case | Cost |
|------|----------|------|
| **Crowdin** | Community translation platform | Free for OSS |
| **Weblate** | Self-hosted alternative | Free |
| **GitHub** | Manual PRs | Free |

**Process:**

1. **Tag strings for translation** in source docs
2. **Export to translation platform**
3. **Community translates**
4. **Review + merge** translations
5. **Automate sync** via GitHub Actions

**Example GitHub Action (.github/workflows/crowdin-sync.yml):**

```yaml
name: Crowdin Sync
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: crowdin/github-action@v1
        with:
          upload_sources: true
          download_translations: true
```

### Language Priority

**Decision Matrix:**

| Factor | Weight | Notes |
|--------|--------|-------|
| **GitHub contributor locations** | High | Check GitHub Insights |
| **Issue languages** | Medium | What languages are questions in? |
| **Web analytics** | Low | If you have a docs site |

**Common Priorities:**

1. English (source)
2. Spanish (2nd most common on GitHub)
3. Chinese (large developer community)
4. Portuguese, German, French (regional demand)

### Translation Quality

**Guidelines for Translators:**

- **Preserve Markdown formatting** - don't break links/syntax
- **Keep code examples in English** - only translate comments
- **Maintain technical accuracy** - don't simplify incorrectly
- **Use native idioms** - not literal translations

**Example:**

```markdown
<!-- English -->
## Quick Start
Run the following command to install...

<!-- Spanish -->
## Inicio Rápido
Ejecuta el siguiente comando para instalar...

<!-- Chinese -->
## 快速开始
运行以下命令进行安装...
```

### Community Translation Programs

**Encourage Contributions:**

```markdown
## Translation Contributors

We welcome documentation translations! Current languages:

- 🇬🇧 English (maintained by core team)
- 🇪🇸 Spanish (maintained by @translator1)
- 🇨🇳 Chinese (maintained by @translator2)

**Want to add a language?** See TRANSLATING.md
```

---

## Security Disclosure

### Responsible Disclosure Policy

**SECURITY.md Template:**

```markdown
# Security Policy

## Reporting Security Vulnerabilities

**Please DO NOT report security vulnerabilities through public GitHub issues.**

Instead, report them via:
- **Email:** security@example.com (PGP key: [link])
- **GitHub Security Advisories:** [Use this form](https://github.com/org/repo/security/advisories/new)

## What to Include

- **Description** of the vulnerability
- **Steps to reproduce** (proof of concept)
- **Potential impact** and attack scenarios
- **Suggested fix** (if you have one)

## Response Timeline

- **Acknowledgment:** Within 48 hours
- **Initial assessment:** Within 5 business days
- **Fix timeline:** Depends on severity
  - Critical: 7-14 days
  - High: 30 days
  - Medium: 60 days

## Disclosure Process

1. You report the vulnerability privately
2. We confirm receipt and assess severity
3. We develop and test a fix
4. We coordinate public disclosure with you
5. We release the fix and publish advisory
6. You receive public credit (unless you prefer anonymity)

## Bug Bounty

Currently, we do not offer a bug bounty program.
```

### CVE Documentation Requirements

**When to Request a CVE:**

- Vulnerability affects released versions
- Vulnerability is remotely exploitable or has significant impact
- Patch is available or disclosure is coordinated

**CVE Information to Provide:**

```markdown
## CVE-YYYY-XXXXX: [Vulnerability Name]

**Severity:** Critical / High / Medium / Low
**CVSS Score:** X.X (Vector: CVSS:3.1/AV:N/AC:L/...)
**Affected Versions:** v1.0.0 - v1.5.2
**Patched Versions:** v1.5.3+

### Description
[Clear description of vulnerability]

### Impact
[What can an attacker do?]

### Mitigation
[Workarounds if patch not yet applied]

### Credit
Discovered by [researcher name/org]
```

### Embargo Periods

**Standard Practices:**

- **Embargo Duration:** 90 days from initial report (Google Project Zero standard)
- **Early Disclosure:** If actively exploited in the wild
- **Coordinated Disclosure:** Notify major users before public announcement

**Communication:**

```markdown
## Security Advisory: Coordinated Disclosure

**Embargo Until:** 2025-12-30 09:00 UTC

This vulnerability will be publicly disclosed on the above date.
Patches will be released simultaneously.

**For Enterprise Users:** Email enterprise@example.com for early patch access.
```

### Public Communication Templates

**GitHub Security Advisory Template:**

```markdown
### Summary
Brief 1-2 sentence description of vulnerability.

### Severity
**CVSS Score:** 8.5 (High)

### Affected Versions
- Versions 1.x: Vulnerable
- Version 2.0.0+: Not affected

### Patches
- Version 1.6.0 contains the fix
- Users should upgrade immediately

### Workarounds
If upgrading is not possible, apply this configuration change: [details]

### References
- Fix commit: [link]
- Discussion: [link to private disclosure]

### Credit
Discovered by [@researcher](https://github.com/researcher)
```

---

## Release Process

### Semantic Versioning

**Standard:** [SemVer 2.0.0](https://semver.org/)

**Format:** `MAJOR.MINOR.PATCH`

- **MAJOR:** Breaking changes (v1 → v2)
- **MINOR:** New features, backward compatible (v2.0 → v2.1)
- **PATCH:** Bug fixes, backward compatible (v2.1.0 → v2.1.1)

**Pre-release Identifiers:**

- `v2.1.0-alpha.1` - Early testing, unstable
- `v2.1.0-beta.2` - Feature complete, testing
- `v2.1.0-rc.1` - Release candidate, final testing

### Release Notes Format

**Template:** See [16-RELEASE_NOTES.md](./16-RELEASE_NOTES.md) for comprehensive guidance.

**Structure:**

```markdown
## [2.1.0] - 2025-12-15

### 🎉 Highlights
- Major feature X now available
- Performance improved by 40%

### ✨ Added
- New `/api/export` endpoint for data export (#234)
- Support for Postgres 16 (#245)

### 🔧 Changed
- Updated dependencies to latest versions (#250)
- Improved error messages for validation failures (#251)

### 🐛 Fixed
- Fixed race condition in session management (#240)
- Corrected timezone handling in reports (#242)

### ⚠️ Breaking Changes
- Removed deprecated `legacy_mode` configuration option
  **Migration:** Use `compatibility_mode: false` instead

### 📝 Documentation
- Added tutorial for Docker deployment (#255)
- Updated API reference with new endpoints (#256)

### 🙏 Contributors
@alice, @bob, @charlie (10 new contributors this release!)

**Full Changelog:** https://github.com/org/repo/compare/v2.0.0...v2.1.0
```

### Migration Guides for Breaking Changes

**When to Provide:**

- Any MAJOR version bump
- Changes to public APIs
- Configuration format changes
- Database schema changes

**Format:**

```markdown
## Migrating from v1.x to v2.0

### Breaking Changes Overview

| Change | v1.x | v2.0 | Action Required |
|--------|------|------|-----------------|
| Config format | YAML | TOML | Convert config files |
| API auth | API keys | OAuth2 | Update client code |
| Database | MySQL 5.7 | PostgreSQL 14+ | Migrate data |

### Step-by-Step Migration

#### 1. Update Dependencies

```bash
npm install myproject@2.0.0
```

#### 2. Convert Configuration

**Old (v1.x):**

```yaml
server:
  port: 8080
```

**New (v2.0):**

```toml
[server]
port = 8080
```

**Automated Conversion:**

```bash
npx myproject-migrate-config config.yml > config.toml
```

#### 3. Update API Calls

**Old:**

```javascript
fetch('/api/data', { headers: { 'X-API-Key': 'abc123' } })
```

**New:**

```javascript
fetch('/api/data', { headers: { 'Authorization': 'Bearer ' + accessToken } })
```

### Testing Your Migration

Run this command to verify:

```bash
npm run check-migration
```

Expected output: `✅ Migration successful`

### Rollback Plan

If you encounter issues:

```bash
npm install myproject@1.9.0
git checkout v1.x-branch
```

### Support

- Migration issues: GitHub Discussions
- Critical bugs: <security@example.com>

```

### Deprecation Notices

**Deprecation Timeline:**

1. **Announce deprecation** in MINOR release (v2.1.0)
2. **Issue warnings** in code/logs during deprecation period (6+ months)
3. **Remove feature** in next MAJOR release (v3.0.0)

**Example Notice:**

```markdown
## Deprecation Warning: `legacy_api()` function

**Deprecated in:** v2.1.0 (2025-12-15)
**Removed in:** v3.0.0 (planned 2026-06-01)

**Reason:** Replaced by more secure `modern_api()` with OAuth2 support.

**Migration:**
```javascript
// Old (deprecated)
legacy_api(apiKey, data)

// New
modern_api(oauthToken, data)
```

**Documentation:** [Migration Guide](./docs/migrate-to-v3.md)

```

### Upgrade Paths

**Document Supported Paths:**

```markdown
## Upgrade Paths

✅ **Supported Direct Upgrades:**
- v1.9.x → v2.0.0 (follow migration guide)
- v2.0.x → v2.1.x (no breaking changes)

⚠️ **Requires Intermediate Upgrade:**
- v1.5.x → v1.9.x first, then → v2.0.0
- Reason: Database schema changes in v1.6-1.9

❌ **Not Supported:**
- v1.0-1.4 → v2.0 (too many breaking changes)
- Recommendation: Fresh installation + data migration script
```

---

## Maintainer Handoff

### Succession Planning

**Why It Matters:**

- Original maintainers move on (new jobs, life changes)
- Prevents project abandonment
- Ensures community continuity

**Preparation Checklist:**

- [ ] Document all maintainer processes
- [ ] Cross-train at least 2 additional maintainers
- [ ] Document access credentials and accounts
- [ ] Create maintainer runbook
- [ ] Establish communication channels for emergencies

### Maintainer Runbook

**Create MAINTAINERS.md:**

```markdown
# Maintainer Guide

## Current Maintainers

- @alice (Lead, release management)
- @bob (Security, infrastructure)
- @charlie (Code review, triage)

## Maintainer Responsibilities

### Weekly
- [ ] Triage new issues (label, prioritize, assign)
- [ ] Review open pull requests
- [ ] Respond to security@example.com emails

### Monthly
- [ ] Cut new release (see Release Process below)
- [ ] Review and update dependencies
- [ ] Check analytics and community health metrics

### Quarterly
- [ ] Review and update roadmap
- [ ] Security audit
- [ ] Documentation freshness check

## Release Process

1. **Create release branch:**
   ```bash
   git checkout -b release/v2.1.0
   ```

1. **Update version numbers:**
   - `package.json` (or equivalent)
   - `CHANGELOG.md`
   - Documentation version references

2. **Run release checklist:**

   ```bash
   npm run release-check
   ```

3. **Create GitHub release:**
   - Tag: `v2.1.0`
   - Title: `Version 2.1.0`
   - Body: Copy from CHANGELOG.md

4. **Publish to registries:**

   ```bash
   npm publish  # or PyPI, Docker Hub, etc.
   ```

5. **Announce release:**
   - GitHub Discussions
   - Twitter/social media
   - Community Discord/Slack

## Emergency Procedures

### Critical Security Vulnerability

1. Acknowledge report within 48 hours
2. Create private fork for patch development
3. Coordinate disclosure date
4. Prepare hotfix release
5. Publish security advisory

### Maintainer Unavailability

If primary maintainer is unavailable:

- @bob has access to publish releases
- @charlie can manage community communications
- Credentials stored in 1Password (ask @alice for access)

## Access & Credentials

| Service | Who Has Access | Location |
|---------|----------------|----------|
| npm publish | @alice, @bob | 2FA required |
| GitHub Admin | @alice, @bob | GitHub org settings |
| DNS / Domain | @alice | Namecheap account |
| Email forwarding | @alice | security@, admin@ |

## Knowledge Transfer

**When onboarding new maintainers:**

1. Add to GitHub team with write access
2. Walk through this maintainer guide
3. Shadow 1-2 releases
4. Give access to credentials (staged)
5. Announce in community channels

```

### Ownership Transfer

**If transferring project to new organization:**

```markdown
## Ownership Transfer Notice

**Effective Date:** 2026-01-01

**Previous Owner:** @originalowner
**New Owner:** @neworganization

### What Changes

- **GitHub URL:** `github.com/old/repo` → `github.com/new/repo`
- **npm package:** No change (redirects handled)
- **Support Email:** old@example.com → new@example.com

### What Stays the Same

- Open source license (MIT)
- Project direction and roadmap
- Existing maintainers remain

### Action Required

None. GitHub handles redirects automatically. Update bookmarks if desired.

### Questions?

Contact @neworganization via GitHub Discussions.
```

### Archiving vs. Deprecating

**When to Archive:**

- Project no longer actively maintained
- No security updates planned
- Better alternatives exist

**Archival Process:**

1. **Update README.md:**

   ```markdown
   # ⚠️ PROJECT ARCHIVED

   This project is no longer actively maintained as of 2026-01-01.

   **Recommended Alternatives:**
   - [Project X](https://github.com/...) - Actively maintained fork
   - [Project Y](https://github.com/...) - Modern replacement

   **For Existing Users:**
   - Version 2.1.0 remains available on npm
   - Security: No further patches will be issued
   - Support: Community-driven only (GitHub Discussions remain open)
   ```

2. **GitHub Settings:**
   - Mark repository as archived
   - Disable Issues (keep Discussions for community)
   - Add archive notice to repository description

3. **Package Registries:**
   - Add deprecation notice: `npm deprecate package "Project archived, see README"`
   - Keep packages available (don't unpublish)

4. **Communicate:**
   - Blog post or announcement
   - Social media
   - Email major users if known

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [36-CONTEXT_GUIDANCE.md](./36-CONTEXT_GUIDANCE.md) | When to use OSS standards |
| [16-RELEASE_NOTES.md](./16-RELEASE_NOTES.md) | Detailed release note format |
| [26-ONBOARDING.md](./26-ONBOARDING.md) | Internal onboarding (complement to contributor onboarding) |
| [05-QUALITY.md](./05-QUALITY.md) | Quality criteria for all documentation |

---

**Previous:** [37 - Migration Guide](./37-MIGRATION_GUIDE.md)
**Next:** [39 - Integrations](./39-INTEGRATIONS.md)
