---
title: "Migration Guide"
type: "guide"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
---

# Migration Guide

> **Goal:** Step-by-step guide to migrating from ad-hoc documentation or other documentation approaches to this comprehensive standard.

---

## Table of Contents

1. [Migration Overview](#migration-overview)
2. [Migrating from Ad-Hoc Documentation](#migrating-from-ad-hoc-documentation)
3. [Migrating from Other Standards](#migrating-from-other-standards)
4. [Step-by-Step Migration Checklist](#step-by-step-migration-checklist)
5. [Common Pitfalls](#common-pitfalls)
6. [Post-Migration](#post-migration)

---

## Migration Overview

### Why Migrate?

| Current State | After Migration |
|---------------|-----------------|
| Inconsistent documentation | Standardized across all projects |
| Stale, outdated docs | Automated freshness checks |
| No quality standards | Quality gates in CI |
| Scattered information | Two-tier architecture |
| Manual review process | Automated validation |

### Migration Timeline

| Team Size | Estimated Time | Phases |
|-----------|----------------|--------|
| **1-5 engineers** | 2-4 weeks | Learn → Build → Enforce |
| **5-20 engineers** | 4-8 weeks | Learn → Build → Enforce → Scale |
| **20-50 engineers** | 8-12 weeks | Learn → Build → Enforce → Scale |
| **50+ engineers** | 12-16 weeks | Phased rollout by team |

See [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md) for detailed week-by-week plans.

---

## Migrating from Ad-Hoc Documentation

### Current State Assessment

#### Step 1: Audit Your Documentation

```bash
# Find all markdown files
find . -name "*.md" -type f > docs-inventory.txt

# Check for READMEs
find . -name "README.md" -type f > readme-list.txt

# Count documentation files
wc -l docs-inventory.txt
```

#### Step 2: Identify Documentation Gaps

| Check | Command | Target |
|-------|---------|--------|
| Services without READMEs | `find services/ -type d -exec test ! -f {}/README.md \; -print` | 0 missing |
| Docs without frontmatter | `grep -L "^---" $(find . -name "*.md")` | All have frontmatter |
| Stale documentation | `find . -name "*.md" -mtime +90` | Review all > 90 days |
| Broken links | `markdown-link-check **/*.md` | 0 broken |

#### Step 3: Prioritize Migration

1. **High Priority:** Critical runbooks, onboarding docs, API documentation
2. **Medium Priority:** Architecture docs, service READMEs, ADRs
3. **Low Priority:** Historical docs, archived content

### Migration Steps

#### Phase 1: Foundation (Week 1-2)

1. **Read Core Standards**
   - [01-PHILOSOPHY.md](./01-PHILOSOPHY.md) — Understand the "why"
   - [03-DOCUMENT_TYPES.md](./03-DOCUMENT_TYPES.md) — Two-tier architecture
   - [05-QUALITY.md](./05-QUALITY.md) — Quality criteria

2. **Set Up Validation**

   ```bash
   # Install validation scripts
   cp -r docs/standards/scripts/ ./scripts/

   # Test validation
   bash scripts/validate-frontmatter.sh .
   bash scripts/validate-structure.sh .
   ```

3. **Create Documentation Baseline**
   - Document current state (number of docs, coverage %)
   - Screenshot dashboard (if exists)
   - Record pain points from team survey

#### Phase 2: Implement Standards (Week 3-6)

1. **Add Frontmatter to Existing Docs**

   ```bash
   # For each .md file, add frontmatter if missing
   # Use the template from docs/standards/templates/
   ```

   Template frontmatter:

   ```yaml
   ---
   title: "Document Title"
   type: "guide|reference|runbook|tutorial"
   status: "approved"
   classification: "public|internal"
   owner: "@team-name"
   created: "YYYY-MM-DD"
   last_updated: "YYYY-MM-DD"
   version: "1.0.0"
   ---
   ```

2. **Restructure Documents**
   - Apply two-tier architecture ([03-DOCUMENT_TYPES.md](./03-DOCUMENT_TYPES.md))
   - Move system-level docs to `docs/` folder
   - Keep implementation details in service READMEs

3. **Apply Templates**
   - Use templates from `docs/standards/templates/`
   - For new docs: Copy template first, then customize
   - For existing docs: Gradually adopt template structure

4. **Fix Top 10 Issues**
   - Start with most-read documents
   - Fix broken links
   - Update stale content
   - Add missing sections

#### Phase 3: Enforce (Week 7-8)

1. **Enable CI/CD Validation**

   ```yaml
   # .github/workflows/docs-validation.yml
   name: Documentation Validation
   on: [pull_request]
   jobs:
     validate:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - name: Validate documentation
           run: bash scripts/validate-frontmatter.sh .
   ```

2. **Set Up Git Hooks** (optional but recommended)

   ```bash
   # Install pre-commit hook
   bash scripts/git-hooks/install.sh
   ```

3. **Gradual Rollout**
   - Week 7: Warning-only mode (CI passes even with issues)
   - Week 8: Blocking mode (CI fails on validation errors)
   - Communicate changes to team in advance

#### Phase 4: Optimize (Week 9+)

1. **Continuous Improvement**
   - Weekly freshness reviews
   - Monthly quality assessments
   - Quarterly template updates

2. **Team Training**
   - Workshop on new standards
   - Documentation champions program
   - Regular office hours for questions

---

## Migrating from Other Standards

### From Google Documentation Style Guide

| Google Concept | This Standard Equivalent | Notes |
|----------------|--------------------------|-------|
| Developer guides | `docs/` folder (Tier 1) | System-level documentation |
| Code comments | Service READMEs (Tier 2) | Implementation details |
| Style rules | [11-STYLE_GUIDE.md](./11-STYLE_GUIDE.md) | Extended with frontmatter |
| Reference docs | [18-API_DOCUMENTATION.md](./18-API_DOCUMENTATION.md) | OpenAPI + examples |

**Migration Steps:**

1. Keep Google style rules for prose
2. Add frontmatter to all documents
3. Implement two-tier architecture
4. Add validation automation

### From GitLab Documentation Standards

| GitLab Concept | This Standard Equivalent | Notes |
|----------------|--------------------------|-------|
| Product docs | `docs/` folder | User-facing documentation |
| Developer docs | Service READMEs | Technical implementation |
| `.gitlab-ci.yml` validation | CI/CD workflows | Extended validation suite |
| Documentation reviews | [12-REVIEWS.md](./12-REVIEWS.md) | Three review types |

**Migration Steps:**

1. GitLab's structure is already similar
2. Main change: Add comprehensive frontmatter
3. Implement quality gates from [05-QUALITY.md](./05-QUALITY.md)
4. Add AI agent integration ([04-AI_AGENTS.md](./04-AI_AGENTS.md))

### From Write the Docs Practices

| WtD Concept | This Standard Equivalent | Notes |
|-------------|--------------------------|-------|
| Documentation as code | Core philosophy | Extended with automation |
| Minimum viable docs | Templates | Start with 80% complete |
| Docs-driven development | [01-PHILOSOPHY.md](./01-PHILOSOPHY.md) | Codified in standards |

**Migration Steps:**

1. WtD is philosophy-compatible
2. Add structured standards and templates
3. Implement validation automation
4. Add metrics tracking ([40-METRICS.md](./40-METRICS.md))

### From Divio Documentation System

| Divio Concept | This Standard Equivalent | Notes |
|---------------|--------------------------|-------|
| Tutorials | `docs/` → Getting Started | How-to for first-time users |
| How-To Guides | `docs/` → Operations | Task-oriented guides |
| Explanation | `docs/` → Architecture | Conceptual understanding |
| Reference | Service READMEs + API docs | Technical specifications |

**Migration Steps:**

1. Map Divio quadrants to document types ([03-DOCUMENT_TYPES.md](./03-DOCUMENT_TYPES.md))
2. Add frontmatter with `type` field
3. Use Divio's audience-first approach
4. Extend with quality automation

### From Microsoft Style Guide

| Microsoft Concept | This Standard Equivalent | Notes |
|-------------------|--------------------------|-------|
| Writing style | [11-STYLE_GUIDE.md](./11-STYLE_GUIDE.md) | Simplified technical writing |
| Accessibility | [10-ACCESSIBILITY.md](./10-ACCESSIBILITY.md) | WCAG 2.2 AA compliance |
| Localization | [09-LOCALIZATION.md](./09-LOCALIZATION.md) | Multi-language support |

**Migration Steps:**

1. Keep Microsoft's prose style recommendations
2. Add frontmatter metadata
3. Implement automated validation
4. Add two-tier architecture

**Universal Migration Principle:**
> These standards are designed to **complement, not replace** existing style guides. Keep your current prose style (Google, Microsoft, etc.) and add the structure, automation, and quality gates from this standard.

---

## Step-by-Step Migration Checklist

### Pre-Migration (Do First)

- [ ] **Read the adoption playbook** - [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md)
- [ ] **Get leadership buy-in** - Present value proposition
- [ ] **Identify documentation champion** - Allocate 20-30% time
- [ ] **Audit current documentation** - Run commands from "Current State Assessment"
- [ ] **Create backup** - `git tag pre-migration-backup`
- [ ] **Set migration timeline** - Use table from "Migration Timeline" section

### During Migration - Phase 1: Learn (Week 1-2)

- [ ] **Read core standards**
  - [ ] [01-PHILOSOPHY.md](./01-PHILOSOPHY.md)
  - [ ] [03-DOCUMENT_TYPES.md](./03-DOCUMENT_TYPES.md)
  - [ ] [05-QUALITY.md](./05-QUALITY.md)
- [ ] **Install validation scripts** - `cp -r docs/standards/scripts/ ./scripts/`
- [ ] **Test validation on sample doc** - `bash scripts/validate-frontmatter.sh docs/sample.md`
- [ ] **Identify top 10 priority docs** - Use team survey + analytics
- [ ] **Document current metrics** - Coverage %, freshness %, link health

### During Migration - Phase 2: Build (Week 3-6)

- [ ] **Add frontmatter to top 10 docs**
  - [ ] Use template from `docs/standards/templates/`
  - [ ] Verify with `bash scripts/validate-frontmatter.sh .`
- [ ] **Create missing critical docs**
  - [ ] README.md for each service
  - [ ] CONTRIBUTING.md (if OSS or >5 engineers)
  - [ ] API documentation (if applicable)
- [ ] **Fix broken links** - `npx markdown-link-check **/*.md`
- [ ] **Update stale docs** - Address all docs > 90 days old
- [ ] **Apply two-tier architecture**
  - [ ] System docs → `docs/` folder
  - [ ] Implementation docs → service READMEs
- [ ] **Run full validation** - All scripts pass on migrated docs

### During Migration - Phase 3: Enforce (Week 7-8)

- [ ] **Create CI/CD workflow**
  - [ ] Copy template from `docs/standards/templates/ci-cd/docs-validation.yml`
  - [ ] Test with intentional failure
  - [ ] Verify blocking behavior
- [ ] **Install git hooks** (optional)
  - [ ] `bash scripts/git-hooks/install.sh`
  - [ ] Test with sample commit
- [ ] **Set up freshness monitoring**
  - [ ] Add `check-freshness.sh` to weekly cron
  - [ ] Configure Slack/email alerts
- [ ] **Communicate to team**
  - [ ] Share migration progress
  - [ ] Announce CI/CD enforcement date
  - [ ] Provide training session

### During Migration - Phase 4: Scale (Week 9-12)

- [ ] **Expand to all documentation**
  - [ ] Remaining services
  - [ ] Legacy documentation
  - [ ] Historical content (archive if stale)
- [ ] **Team training workshop**
  - [ ] 1-hour session
  - [ ] Hands-on with templates
  - [ ] Q&A
- [ ] **Measure success metrics**
  - [ ] Documentation coverage: target 80%+
  - [ ] Freshness score: target 70%+
  - [ ] Quality score: target 85%+
  - [ ] CI/CD integration: 100%
- [ ] **Create maintenance plan**
  - [ ] Weekly freshness reviews
  - [ ] Monthly quality checks
  - [ ] Quarterly retrospectives

### Post-Migration Validation (After Week 12)

- [ ] **Run full validation suite**
  - [ ] `bash scripts/validate-frontmatter.sh .`
  - [ ] `bash scripts/validate-structure.sh .`
  - [ ] `bash scripts/validate-quality.sh .`
  - [ ] `bash scripts/check-freshness.sh .`
- [ ] **Verify CI/CD gates** - Test with intentional errors
- [ ] **Measure improvements**
  - [ ] Before/after documentation coverage
  - [ ] Before/after freshness score
  - [ ] Team satisfaction survey
- [ ] **Document lessons learned** - Share with organization
- [ ] **Celebrate success** - Team retrospective and recognition

---

## Common Pitfalls

### Pitfall 1: Migrating Everything at Once

**Symptom:** Trying to migrate all documentation in a single sprint, overwhelming the team.

**Why It Happens:**

- Underestimating migration scope
- Pressure to "get it done quickly"
- Not prioritizing documents

**Solution:**

- Use phased approach: top 10 docs → next 20 → remaining
- Set realistic timeline (2-12 weeks based on team size)
- Celebrate small wins (e.g., "5 critical docs migrated!")

**Prevention:**

- Follow migration timeline from "Migration Overview"
- Use priority matrix (High/Medium/Low)
- Allocate 20-30% of documentation champion's time, not 100%

### Pitfall 2: Not Getting Team Buy-In First

**Symptom:** Standards announced top-down, team resists, migration stalls.

**Why It Happens:**

- Leadership mandates without explanation
- Team not involved in decision
- Value not communicated

**Solution:**

- Present "before/after" examples
- Show metrics: onboarding time reduction, support ticket decrease
- Involve team in pilot (ask for volunteers to migrate first 5 docs)

**Prevention:**

- Follow Week 1-2 of [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md)
- Get team input on priorities
- Address "what's in it for me?" for each role

### Pitfall 3: Breaking Existing Links

**Symptom:** Moving docs to new locations breaks internal links, search bookmarks, external references.

**Why It Happens:**

- Not planning for backward compatibility
- Restructuring without redirects
- No link checking before/after

**Solution:**

- Keep old files with redirect notices (for 6 months)
- Update all internal links in one PR
- Add redirect stubs: `See new location: [docs/NEW_PATH.md](../docs/NEW_PATH.md)`

**Prevention:**

- Run `npx markdown-link-check **/*.md` before and after migration
- Document all file moves in CHANGELOG.md
- Communicate link changes to team

### Pitfall 4: Not Updating CI/CD Pipelines

**Symptom:** Validation scripts exist but aren't enforced, quality regresses.

**Why It Happens:**

- CI/CD integration seen as "optional"
- Delayed until "later"
- Technical complexity concerns

**Solution:**

- Add CI/CD in Week 7 (not "eventually")
- Use template from `docs/standards/templates/ci-cd/`
- Start with warning-only mode, switch to blocking after 1 week

**Prevention:**

- Make CI/CD part of migration checklist (Phase 3)
- Test enforcement with intentional failures
- Document bypass procedure for emergencies only

### Pitfall 5: Abandoning Old Docs Too Quickly

**Symptom:** Deleting old documentation immediately, losing valuable historical context.

**Why It Happens:**

- Eager to "clean up"
- Not considering that old docs may be bookmarked/linked
- No archival strategy

**Solution:**

- Mark old docs as `status: deprecated` instead of deleting
- Keep deprecated docs for 6 months minimum
- Add prominent notices pointing to new location

**Prevention:**

- Create `docs/archive/` folder for deprecated content
- Update `status` field in frontmatter instead of deleting
- Communicate deprecation timeline

### Pitfall 6: Ignoring Backward Compatibility

**Symptom:** Existing tools/scripts break when documentation structure changes.

**Why It Happens:**

- Not auditing documentation dependencies
- Scripts that parse specific doc formats
- Integration tools expecting old structure

**Solution:**

- Audit all scripts that read documentation
- Update automation to handle both old and new formats (transitional period)
- Version documentation structure (v1.0 → v2.0)

**Prevention:**

- Ask team: "What tools/scripts use our documentation?"
- Maintain compatibility shims for 6 months
- Document breaking changes in migration announcement

### Pitfall 7: Skipping Validation Setup

**Symptom:** Migrating docs manually without automated validation, introducing errors.

**Why It Happens:**

- Validation seen as extra work
- Manual review assumed to be sufficient
- Scripts installation deferred

**Solution:**

- Install validation scripts in Week 1 (first action)
- Run validation after every document migration
- Automate in CI/CD immediately

**Prevention:**

- Make "Set Up Validation" the first migration step
- Block migration PRs without validation
- Command: `bash scripts/validate-*.sh .` before every commit

### Pitfall 8: No Rollback Plan

**Symptom:** Migration causes issues, no way to quickly revert.

**Why It Happens:**

- Assuming migration will be smooth
- No backup created
- Changes made directly to main branch

**Solution:**

- Create git tag before migration: `git tag pre-migration-backup`
- Use feature branch for migration work
- Merge only after validation passes

**Prevention:**

- Always create backup tag (first step in checklist)
- Use PRs for migration changes (review before merge)
- Test rollback procedure: `git checkout pre-migration-backup`

---

## Post-Migration

### Validation Steps

After completing migration, verify success:

#### 1. Run All Validation Scripts

```bash
# Full validation suite
bash scripts/validate-frontmatter.sh .
bash scripts/validate-structure.sh .
bash scripts/validate-quality.sh .
bash scripts/check-freshness.sh .

# Link health
npx markdown-link-check **/*.md

# Search for common issues
grep -r "TODO\|FIXME\|example\.com" docs/
```

#### 2. Test CI/CD Pipeline

```bash
# Create test PR with intentional error
# Example: Remove frontmatter from a doc
# Verify: CI should fail

# Create test PR with valid changes
# Verify: CI should pass
```

#### 3. Measure Improvement

| Metric | Before Migration | After Migration | Improvement |
|--------|------------------|-----------------|-------------|
| Documentation Coverage | ___% | ___% | ___ percentage points |
| Freshness Score (< 90 days) | ___% | ___% | ___ percentage points |
| Broken Links | ___ | 0 | ___ fixed |
| Team Satisfaction (1-5) | ___ | ___ | ___ point increase |
| CI/CD Integration | No | Yes | ✅ Automated |

### Team Training and Handoff

#### 1. Documentation Workshop (1 hour)

- Agenda:
  - Overview of new standards (10 min)
  - Document types and templates (15 min)
  - Validation workflow (10 min)
  - AI-assisted documentation (10 min)
  - Q&A (15 min)

#### 2. Create Quick Reference Guide

```markdown
# Documentation Quick Reference

## Creating New Documentation
1. Copy template from `docs/standards/templates/`
2. Replace placeholders with actual content
3. Run validation: `bash scripts/validate-*.sh .`
4. Commit and create PR

## Updating Existing Documentation
1. Edit document
2. Update `last_updated` field in frontmatter
3. Run validation
4. Commit and create PR

## Common Commands
- Validate frontmatter: `bash scripts/validate-frontmatter.sh .`
- Check freshness: `bash scripts/check-freshness.sh .`
- Find broken links: `npx markdown-link-check **/*.md`
```

#### 3. Establish Documentation Office Hours

- Weekly 30-minute sessions
- Answer questions
- Help with tricky docs
- Gradually reduce frequency (weekly → biweekly → monthly)

### Monitoring and Metrics

**Weekly Dashboard** (track for first 3 months):

```
┌────────────────────────────────────────────┐
│      POST-MIGRATION HEALTH DASHBOARD       │
│             Week of [Date]                 │
├────────────────────────────────────────────┤
│  Docs Migrated:       42/50  (84%)        │
│  Validation Passing:  98%                 │
│  Freshness Score:     76%                 │
│  Broken Links:        2                   │
│  Team Questions:      5 this week         │
│  Status: ✓ ON TRACK                      │
└────────────────────────────────────────────┘
```

**Monthly Review Questions:**

1. Are we maintaining quality standards post-migration?
2. What documentation issues are emerging?
3. Is the team comfortable with new workflow?
4. Do we need to adjust validation thresholds?
5. What templates need improvement?

### Archiving Old Documentation

**Archival Strategy:**

1. **Mark as Deprecated** (Month 1)

   ```yaml
   ---
   status: "deprecated"
   deprecated_date: "2025-12-15"
   replacement: "docs/new-location.md"
   ---

   > **⚠️ DEPRECATED:** This document has been replaced by [New Location](./docs/new-location.md)
   ```

2. **Move to Archive** (Month 3)

   ```bash
   mkdir -p docs/archive/2025-Q4/
   mv old-doc.md docs/archive/2025-Q4/
   ```

3. **Consider Deletion** (Month 6)
   - Review analytics: Is anyone still accessing?
   - Check for external links
   - Delete only if confirmed unused

### Celebrating Success and Lessons Learned

**Retrospective Questions:**

1. What went well during migration?
2. What was harder than expected?
3. What would we do differently next time?
4. What tools/processes should we keep?
5. What should we share with other teams?

**Share Success Metrics:**

- Present before/after dashboard to leadership
- Blog post or internal wiki article
- Shoutouts to team members who contributed
- Document lessons learned for future teams

**Continuous Improvement:**

- Add migration learnings to this guide
- Update templates based on feedback
- Contribute improvements back to standards repository
- Mentor other teams undergoing migration

---

**Related Documents:**

- [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md) - 12-week adoption plan
- [05-QUALITY.md](./05-QUALITY.md) - Quality criteria for validation
- [40-METRICS.md](./40-METRICS.md) - Metrics to track success

**Previous:** [36 - Context Guidance](./36-CONTEXT_GUIDANCE.md)
**Next:** [38 - Open Source](./38-OPEN_SOURCE.md)
