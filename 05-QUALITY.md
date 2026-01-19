---
title: "Quality Standards"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-12"
version: "1.1.0"
---



> Every document must meet these quality criteria to be considered production-ready.

---

## Table of Contents

1. [Six Quality Criteria](#six-quality-criteria)
2. [Quality Gates](#quality-gates)
3. [Health Metrics](#health-metrics)
4. [Three Review Types](#three-review-types)

---

## Six Quality Criteria

### A. Accuracy (100% Required)

**Definition:** Every documented fact matches the actual codebase.

**Verification Checklist:**

- [ ] Framework/library versions match package manifests
- [ ] File names match actual files
- [ ] Function/class names match actual code
- [ ] API endpoints match route definitions
- [ ] Configuration examples match actual configs
- [ ] Architecture descriptions match implementation

**Measurement:**

```text
Accuracy Score = (Correct Facts / Total Verifiable Facts) × 100
Target: 100%
```

### B. Completeness (100% Required)

**Definition:** All important information is documented.

**Verification Checklist:**

- [ ] README.md exists with all required sections
- [ ] All exported functions/classes have inline documentation
- [ ] All configuration files explained
- [ ] All npm scripts / makefile targets documented
- [ ] All environment variables listed
- [ ] Setup instructions complete
- [ ] Common errors have troubleshooting entries

### C. Consistency (100% Required)

**Definition:** Terminology, style, and structure are unified.

**Verification Checklist:**

- [ ] Same terms used throughout
- [ ] Consistent capitalization
- [ ] Consistent path formats
- [ ] Consistent code style in examples
- [ ] All internal links work
- [ ] Version numbers consistent

### D. Usability (100% Required)

**Definition:** New developers can understand and use the code without prior knowledge.

**Test:**
> Can a developer who has never seen this folder follow the README and successfully run/use the code in < 30 minutes?

**Verification Checklist:**

- [ ] Setup instructions work from scratch
- [ ] Prerequisites clearly listed
- [ ] Examples provided for major concepts
- [ ] Common pitfalls addressed
- [ ] Error messages explained with solutions
- [ ] Navigation is clear (TOC for long docs)

### E. Compliance (100% Required)

**Definition:** Follows all repository standards and policies.

**Verification Checklist:**

- [ ] Uses conventional commit format in examples
- [ ] Links to relevant root docs
- [ ] Follows markdown style guidelines
- [ ] Includes maintainer/owner information

### F. Accessibility (WCAG 2.2 AA)

**Definition:** Documentation is accessible to all users, including those using assistive technologies.

**Verification Checklist:**

- [ ] All images/diagrams have descriptive alt text
- [ ] Color contrast ratio ≥4.5:1 for text
- [ ] Reading level Grade 8-10 (Flesch-Kincaid)
- [ ] No information conveyed by color alone
- [ ] Tables have proper headers
- [ ] Links have descriptive text (not "click here")
- [ ] Video content has captions/transcripts

**Automated Checks:**

| Check | Tool | Threshold |
|-------|------|-----------|
| Alt text presence | `accessibility-lint` | 100% images |
| Reading level | Flesch-Kincaid | Grade 8-10 |
| Link text | `md-lint` | No bare URLs |

**Why Accessibility Matters:**

- EU AI Act requires accessible technical documentation
- Inclusive documentation reaches broader audience
- Supports neurodiverse team members

### G. AI Readability (2025 Standard)

**Definition:** Documentation is optimized for AI agent consumption and RAG retrieval.

**AI-Readability Checklist:**

- [ ] Each section is self-contained (Every Page Is Page One)
- [ ] Headers are descriptive and unique (`## Gateway Rate Limiting` not `## Config`)
- [ ] Code blocks include language identifiers
- [ ] No "see above" or relative references within sections
- [ ] Frontmatter includes `concepts` and `related_ids` tags
- [ ] Q&A format used for FAQs

**Automated Checks:**

| Check | Command | Threshold |
|-------|---------|-----------|
| Header uniqueness | `grep -E "^#{2,3}" docs/*.md \| sort \| uniq -d` | 0 duplicates |
| Self-reference patterns | `grep -E "(see above\|as mentioned)" docs/*.md` | 0 matches |
| Semantic frontmatter | `yq '.concepts \| length' docs/*.md` | ≥2 per file |

**Measurement:**

```text
AI-Readability Score = (
  Header Uniqueness × 0.2 +
  Self-Containment × 0.3 +
  Semantic Tags × 0.2 +
  Chunking Friendliness × 0.3
) × 100

Target: ≥85%
```

---

## Quality Gates

### Gate 1: Structure Validation (Automated)

| Check | Script | Failure Behavior |
|-------|--------|------------------|
| Frontmatter valid | `docs/standards/scripts/validate-frontmatter.sh` | ❌ Block PR |
| Required sections present | `docs/standards/scripts/validate-structure.sh` | ❌ Block PR |
| All links valid | `check-links.sh` | ❌ Block PR |
| Code examples correct | `scripts/docs/verify-examples.sh` | ❌ Block PR |

### Gate 2: Freshness & Efficacy Check (Automated/Manual)

| Check | Threshold | Failure Behavior |
|-------|-----------|------------------|
| `last_updated` field | < 90 days | ❌ Block deployment |
| `last_verified` field | < 90 days | ⚠️ Warning |
| **Time-to-Hello-World** | < 10 minutes | ⚠️ Review Trigger |
| **Error Linkage** | 100% of user-facing errors | ❌ QA Failure |

### Gate 3: Completeness Score (Automated)

```text
Completeness Score = (Present Required Sections / Total Required Sections) × 100
```

| Score | Meaning | Merge Allowed? |
|-------|---------|----------------|
| 100% | All sections present | ✅ Yes |
| 90-99% | Minor gaps | ✅ Warning |
| 80-89% | Notable gaps | ⚠️ Requires approval |
| < 80% | Major gaps | ❌ No |

### Gate 4: Human Review (Manual)

| Reviewer | Must Review |
|----------|-------------|
| Document owner | All changes to their docs |
| CODEOWNERS | Changes touching their areas |
| Doc maintainer | Structural changes |

---

## Documentation Testing Matrix

**Documentation as Code** requires automated testing. Implement these checks:

| Test Type | Tool | What It Validates | CI Stage |
|-----------|------|-------------------|----------|
| **Link validation** | `markdown-link-check` | No broken internal/external links | Pre-commit |
| **Spell check** | `cspell` | Correct spelling, custom dictionary | Pre-commit |
| **Style lint** | `vale` | Google style guide adherence | Pre-commit |
| **Frontmatter validation** | `validate-frontmatter.sh` | Required YAML fields present | CI |
| **Structure validation** | `validate-structure.sh` | Required sections exist | CI |
| **Code execution** | `pytest --doctest-modules` | Code examples actually run | CI |
| **Schema validation** | `ajv` | Frontmatter matches JSON schema | CI |
| **Accessibility** | `pa11y` | WCAG 2.2 AA for generated sites | Deploy |
| **Reading level** | Flesch-Kincaid | Grade 8-10 readability | Manual |

### Example CI Configuration

```yaml
# .github/workflows/docs-test.yml
jobs:
  test-docs:
    steps:
      - name: Check links
        run: npx markdown-link-check **/*.md
      - name: Lint style
        run: vale docs/
      - name: Validate frontmatter
        run: bash docs/standards/scripts/validate-frontmatter.sh
      - name: Test code examples
        run: pytest --doctest-modules docs/
```

---

## Health Metrics

### Repository-Wide Dashboard

| Metric | Target | Calculation | Frequency |
|--------|--------|-------------|-----------|
| **Coverage** | 100% | Documented exports / Total exports | Per commit |
| **Freshness** | <90 days | Days since last update | Daily |
| **Link Health** | 100% | Valid links / Total links | Per commit |
| **Audit Score** | 95%+ | Average of 5 criteria | Monthly |

### Per-Service Scorecard

```text
┌─────────────────────────────────────────────┐
│  Service: backend-gateway                   │
├─────────────────────────────────────────────┤
│  Accuracy:      100/100  ████████████████   │
│  Completeness:   95/100  ███████████████░   │
│  Consistency:   100/100  ████████████████   │
│  Usability:      90/100  ██████████████░░   │
│  Compliance:    100/100  ████████████████   │
├─────────────────────────────────────────────┤
│  OVERALL:        97/100  STATUS: PASS ✓     │
└─────────────────────────────────────────────┘
```

---

## Three Review Types

From Google's documentation practices:

| Review Type | Focus | Reviewer |
|-------------|-------|----------|
| **Technical Review** | Is it accurate? Does it match the code? | Engineer on the team |
| **Audience Review** | Is it clear for the target audience? | Someone NOT on the team |
| **Writing Review** | Is it consistent with style guide? | Technical writer or peer |

### When to Use Each

| Document Type | Technical | Audience | Writing |
|---------------|-----------|----------|---------|
| API Reference | ✅ Required | Optional | ✅ Required |
| Tutorial | ✅ Required | ✅ Required | Optional |
| Architecture | ✅ Required | Optional | Optional |
| Runbook | ✅ Required | ✅ Required | Optional |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [AI Agents](./04-AI_AGENTS.md) | AI-optimized docs |
| [Operations](./06-OPERATIONS.md) | Freshness SLAs |

---

**Previous:** [04 - AI Agents](./04-AI_AGENTS.md)
**Next:** [06 - Operations](./06-OPERATIONS.md)
