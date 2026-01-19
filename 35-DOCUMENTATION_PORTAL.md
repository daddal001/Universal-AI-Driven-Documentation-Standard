---
title: "Documentation Portal"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-13"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Documentation Portal

> 💡 **Open Source Projects:** This standard is optional for most OSS projects.
> See [36-CONTEXT_GUIDANCE](./36-CONTEXT_GUIDANCE.md) for what you actually need.

> **Goal:** Provide a unified, searchable documentation experience across the entire organization, enabling engineers to discover and access any documentation in seconds.

---

## 1. How Industry Leaders Solve Documentation

Understanding how top companies handle documentation at scale informs our approach.

### Google's Approach

| Component | Implementation |
|-----------|----------------|
| **Repository** | Single monorepo ("google3") for ~95% of code |
| **Discovery** | `go/` links (short URLs like `go/auth-guide`) |
| **Search** | Internal Code Search + dedicated doc search |
| **Format** | g3doc (Markdown stored with code) |
| **Automation** | Code Wiki (AI-generated, auto-updated docs) |

**Key Insight:** Google uses `go/` links extensively — short, memorable URLs that redirect to internal resources. Engineers claim these links before writing docs, creating canonical sources.

### Amazon's Approach

| Component | Implementation |
|-----------|----------------|
| **Repository** | Federated repos managed by "Brazil" build system |
| **Discovery** | Amazon Kendra (AI-powered enterprise search) |
| **Tools** | WorkDocs, Amazon Q Developer |
| **Culture** | Strong writing culture — detailed docs for everything |

**Key Insight:** Amazon emphasizes AI-powered search (Kendra) that aggregates scattered knowledge from wikis, docs, and presentations into a unified interface.

### Stripe's Approach

| Component | Implementation |
|-----------|----------------|
| **Platform** | Custom internal documentation platform |
| **Framework** | Markdoc (open-source, Markdown-based) |
| **Philosophy** | "Docs as application" — interactive, personalized |
| **Culture** | Doc quality tied to career progression |

**Key Insight:** Stripe built a custom platform addressing freshness, fragmentation, and discoverability. They treat docs like a product.

### Meta's Approach

| Component | Implementation |
|-----------|----------------|
| **Repository** | Monorepo |
| **External Docs** | Docusaurus (React-based, open source) |
| **Culture** | "Read the source" when docs are scarce |

---

## 2. Architecture Patterns

### Pattern A: Monorepo with Unified Portal (Recommended)

```
┌─────────────────────────────────────────────────────────────────┐
│                    MONOREPO                                      │
│                                                                  │
│  services/                                                       │
│  ├── backend-api/                                                │
│  │   ├── src/                                                    │
│  │   └── docs/          ← Service-specific docs                  │
│  ├── frontend/                                                   │
│  │   └── docs/                                                   │
│  └── data-pipeline/                                              │
│      └── docs/                                                   │
│                                                                  │
│  docs/                   ← Company-wide docs                     │
│  ├── standards/          ← Documentation standards (35 files)   │
│  ├── architecture/       ← System architecture                   │
│  ├── compliance/         ← GDPR, ISO, SOC2                       │
│  └── operations/         ← Runbooks, incident response           │
│                                                                  │
│  mkdocs.yml              ← ONE config, ONE portal                │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   MkDocs Material   │
                    │   docs.company.com  │
                    │                     │
                    │  🔍 Unified Search  │
                    │  📚 All Docs        │
                    │  🔗 go/ Links       │
                    └─────────────────────┘
```

**Best for:** Companies with a single large repo containing multiple services.

### Pattern B: Multi-Repo with Aggregation

```
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Repo A  │  │ Repo B  │  │ Repo C  │
│ docs/   │  │ docs/   │  │ docs/   │
└────┬────┘  └────┬────┘  └────┬────┘
     │            │            │
     └────────────┼────────────┘
                  │
                  ▼
     ┌────────────────────────┐
     │   Backstage TechDocs   │
     │   OR                   │
     │   Algolia Unified      │
     │   Search               │
     └────────────────────────┘
```

**Best for:** Organizations with many independent repositories.

---

## 3. Recommended Stack (Monorepo)

### Primary Tool: MkDocs Material

| Criterion | MkDocs Material | Docusaurus | GitBook |
|-----------|-----------------|------------|---------|
| Setup Time | 15 min | 30 min | 10 min |
| Learning Curve | Low | Medium | Very Low |
| Customization | High | Very High | Limited |
| Search | Built-in | Algolia | Built-in |
| Python Stack | ✅ Ideal | ❌ Node.js | ❌ SaaS |
| Self-hosted | ✅ Yes | ✅ Yes | ⚠️ Limited |
| Monorepo Support | ✅ Native | ✅ Good | ⚠️ Limited |

**Decision:** Use **MkDocs Material** for monorepo documentation.

### Why MkDocs Material

1. **Unified Portal** — One `mkdocs.yml` serves all docs from the monorepo
2. **Built-in Search** — No external service required
3. **Python Ecosystem** — Matches our backend stack
4. **GitHub Pages** — Free, simple deployment
5. **Mermaid Diagrams** — Native support for architecture diagrams
6. **Code Highlighting** — Excellent developer experience
7. **Versioning with Mike** — Multiple versions accessible simultaneously

### Ready-to-Use Template

We provide a complete, pre-configured MkDocs setup:

```
templates/portal/
├── mkdocs.yml        # Full configuration (search, versioning, navigation)
├── requirements.txt  # Python dependencies (mkdocs-material, mike)
└── README.md         # Deployment instructions
```

**Quick Start:**

```bash
# Copy template to your repo root
cp templates/portal/mkdocs.yml ./

# Install dependencies
pip install -r templates/portal/requirements.txt

# Start local development server
mkdocs serve
```

See [templates/portal/README.md](./templates/portal/README.md) for full documentation.

---

## 4. go/ Links System

### What Are go/ Links?

Short, memorable URLs that redirect to internal resources:

| go/ Link | Redirects To |
|----------|--------------|
| `go/standards` | docs.company.com/standards/ |
| `go/api-guide` | docs.company.com/api/getting-started/ |
| `go/deploy` | docs.company.com/deployment/production/ |
| `go/runbooks` | docs.company.com/operations/runbooks/ |
| `go/gdpr` | docs.company.com/compliance/gdpr/ |

### Implementation Options

#### Option 1: golinks.io (SaaS)

```bash
# Commercial service
# Sign up at golinks.io
# Create links via web UI or API
```

#### Option 2: Self-Hosted (Open Source)

```bash
# Using github.com/crhuber/golinks
git clone https://github.com/crhuber/golinks.git
cd golinks
docker-compose up -d
```

#### Option 3: Simple Redirect Service

```python
# Flask-based go link server
from flask import Flask, redirect

app = Flask(__name__)

LINKS = {
    "standards": "https://docs.company.com/standards/",
    "api-guide": "https://docs.company.com/api/",
    "deploy": "https://docs.company.com/deployment/",
}

@app.route("/go/<path:shortname>")
def go_link(shortname):
    url = LINKS.get(shortname)
    if url:
        return redirect(url)
    return "Link not found", 404
```

### go/ Link Best Practices

| Practice | Example |
|----------|---------|
| Claim before writing | Reserve `go/new-feature` early |
| Use lowercase | `go/api-guide` not `go/API-Guide` |
| Be descriptive | `go/auth-troubleshooting` not `go/at` |
| Document ownership | Track who owns each link |

---

## 5. Search Strategy

### For Monorepo: Built-in MkDocs Search (Sufficient)

```yaml
# mkdocs.yml
plugins:
  - search:
      separator: '[\s\-\.]+'
      lang: en
```

**Capabilities:**

- Indexes all docs automatically
- Instant results as you type
- Highlights matching terms
- No external service needed

### For Scale: Algolia DocSearch (Enhanced)

```yaml
# mkdocs.yml
extra:
  analytics:
    provider: google
    property: G-XXXXXXXXXX

# For Algolia (optional upgrade)
# Apply at: https://docsearch.algolia.com/
```

**When to upgrade to Algolia:**

- 1000+ documentation pages
- Need for typo tolerance
- Advanced analytics on search queries
- Federated search across multiple sites

### For Enterprise: AI-Powered Search

| Solution | Use Case |
|----------|----------|
| Amazon Kendra | Full enterprise knowledge graph |
| Meilisearch | Self-hosted, fast, typo-tolerant |
| Typesense | Open-source Algolia alternative |

---

## 6. Navigation Structure for Monorepo

### Recommended `mkdocs.yml` Structure

```yaml
site_name: Company Documentation
site_url: https://docs.company.com
repo_url: https://github.com/company/monorepo

nav:
  # Landing
  - Home: README.md

  # Onboarding (first thing new engineers see)
  - 🚀 Getting Started:
    - Quick Start: getting-started/QUICKSTART.md
    - Environment Setup: getting-started/ENVIRONMENT.md
    - First Contribution: getting-started/FIRST_CONTRIBUTION.md

  # Standards (company-wide)
  - 📚 Standards:
    - Index: standards/INDEX.md
    - Philosophy: standards/01-PHILOSOPHY.md
    - Document Types: standards/03-DOCUMENT_TYPES.md
    - AI Agents: standards/04-AI_AGENTS.md
    - Quality: standards/05-QUALITY.md
    # ... all 35 standards files

  # Architecture (system-wide)
  - 🏗️ Architecture:
    - System Overview: architecture/OVERVIEW.md
    - Data Flow: architecture/DATA_FLOW.md
    - Security: architecture/SECURITY.md

  # Per-Service Docs (from service directories)
  - 🔧 Services:
    - Backend API:
      - Overview: services/backend-api/README.md
      - API Reference: services/backend-api/docs/API.md
    - Frontend:
      - Overview: services/frontend/README.md
      - Components: services/frontend/docs/COMPONENTS.md
    - Data Pipeline:
      - Overview: services/data-pipeline/README.md

  # Operations
  - 🚨 Operations:
    - Runbooks: operations/runbooks.md
    - Incident Response: operations/INCIDENT_RESPONSE.md
    - On-Call Guide: operations/ON_CALL.md

  # Deployment
  - 🚢 Deployment:
    - Production: deployment/PRODUCTION.md
    - Local Development: deployment/LOCAL.md
    - Kubernetes: deployment/KUBERNETES.md

  # Compliance
  - 🔒 Compliance:
    - Overview: compliance/OVERVIEW.md
    - GDPR: compliance/GDPR/CHECKLIST.md
    - ISO 27001: compliance/ISO27001/CHECKLIST.md
    - SOC 2: compliance/SOC2/CHECKLIST.md

theme:
  name: material
  features:
    - navigation.tabs           # Top-level tabs
    - navigation.tabs.sticky    # Tabs stay visible on scroll
    - navigation.sections       # Collapsible sections
    - navigation.expand         # Expand all by default
    - navigation.top            # Back to top button
    - search.suggest            # Search suggestions
    - search.highlight          # Highlight search terms
    - content.code.copy         # Copy button on code blocks
```

---

## 7. Deployment

### Option A: GitHub Pages (Recommended)

```bash
# One-time: Enable GitHub Pages in repo settings
# Point to gh-pages branch

# Deploy
mkdocs gh-deploy --force
```

### Option B: Internal Hosting

```bash
# Build static files
mkdocs build

# Copy to web server
rsync -avz site/ user@server:/var/www/docs/
```

### Option C: CI/CD Automation

```yaml
# .github/workflows/docs.yml
name: Deploy Documentation

on:
  push:
    branches: [main]
    paths: ['docs/**', 'mkdocs.yml', 'services/**/docs/**']

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # For git revision plugin

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install mkdocs-material
          pip install mkdocs-git-revision-date-localized-plugin
          pip install mkdocs-minify-plugin

      - name: Deploy to GitHub Pages
        run: mkdocs gh-deploy --force
```

### Option D: Versioned Deployment with Mike

**Mike** enables multi-version documentation. Previous versions remain accessible when you release new versions.

```bash
# Install mike
pip install mike

# Deploy version 1.0 (first release)
mike deploy 1.0 latest --update-aliases --push
# Creates: /1.0/, /latest/ → points to 1.0

# Deploy version 2.0 (breaking changes)
mike deploy 2.0 latest --update-aliases --push
# Creates: /2.0/, /latest/ → points to 2.0
# /1.0/ still accessible!

# Set default version
mike set-default latest
```

**Site structure after versioned deployment:**

```
your-site.github.io/
├── 1.0/           ← Always accessible
├── 2.0/           ← Always accessible
├── latest/        ← Alias to 2.0
└── index.html     ← Redirects to latest
```

Users see a **version dropdown** in the header.

**Local Development vs Versioned Deploy:**

| Stage | Command | Purpose |
|-------|---------|----------|
| Editing | `mkdocs serve` | Fast iteration, hot reload |
| Preview versions | `mike serve` | Test version dropdown |
| Deploy | `mike deploy X.X --push` | Publish to GitHub Pages |

---

## 8. Discoverability Checklist

```markdown
## Documentation Discoverability Checklist

### Portal Setup
- [ ] MkDocs Material installed and configured
- [ ] Navigation structure covers all doc categories
- [ ] Service docs included in navigation
- [ ] Search working correctly
- [ ] Deployed to accessible URL

### go/ Links
- [ ] go/ link service deployed or configured
- [ ] Key docs have go/ links assigned
- [ ] go/ links documented in onboarding
- [ ] Link ownership tracked

### Search
- [ ] Built-in search tested with common queries
- [ ] Search suggestions enabled
- [ ] Search highlighting enabled

### Maintenance
- [ ] CI/CD pipeline deploys on doc changes
- [ ] Freshness monitoring in place
- [ ] Broken link checking automated
```

---

## 9. Comparison: When to Use What

| Scenario | Recommended Tool |
|----------|------------------|
| Monorepo, internal docs | **MkDocs Material** |
| Multi-repo, need aggregation | **Backstage TechDocs** |
| Public API docs, React team | **Docusaurus** |
| Non-technical contributors | **GitBook** or **Notion** |
| Enterprise-scale, many sources | **MkDocs + Algolia** or **Kendra** |

---

## 10. Related Documents

| Document | Purpose |
|----------|---------|
| [Portal Template](./templates/portal/README.md) | Ready-to-use MkDocs configuration |
| [34-SEARCH_OPTIMIZATION.md](./34-SEARCH_OPTIMIZATION.md) | Advanced search configuration |
| [21-SERVICE_CATALOG.md](./21-SERVICE_CATALOG.md) | Backstage integration |
| [26-ONBOARDING.md](./26-ONBOARDING.md) | New engineer documentation |
| [01-PHILOSOPHY.md](./01-PHILOSOPHY.md) | Documentation principles |

---

**Previous:** [34 - Search Optimization](./34-SEARCH_OPTIMIZATION.md)
**Next:** [36 - Context Guidance](./36-CONTEXT_GUIDANCE.md)
