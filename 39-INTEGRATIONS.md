---
title: "Documentation Tool Integrations"
type: "guide"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
---

# Documentation Tool Integrations

> **Goal:** Guide for integrating these documentation standards with popular tools and platforms used by open source projects and enterprises.

---

## Table of Contents

1. [GitHub Integration](#github-integration)
2. [GitLab Integration](#gitlab-integration)
3. [Backstage Integration](#backstage-integration)
4. [MkDocs Material](#mkdocs-material)
5. [Docusaurus](#docusaurus)
6. [Read the Docs](#read-the-docs)
7. [Notion/Confluence](#notionconfluence)
8. [Context-Specific Recommendations](#context-specific-recommendations)

---

## GitHub Integration

### GitHub Actions

**Use Case:** Automated documentation validation and deployment

**Workflow Template:**

```yaml
# .github/workflows/docs.yml
name: Documentation Validation

on:
  pull_request:
    paths:
      - 'docs/**'
      - '*.md'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Validate frontmatter
        run: bash docs/standards/scripts/validate-frontmatter.sh docs/

      - name: Check links
        run: npx markdown-link-check **/*.md

      - name: Lint style
        run: vale docs/
```

**Templates:** See `templates/ci-cd/docs-validation.yml`

### GitHub Pages

**Use Case:** Host documentation site

**Setup:**

```yaml
# .github/workflows/deploy-docs.yml
name: Deploy Documentation

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'
      - 'mkdocs.yml'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: 3.x

      - name: Install MkDocs
        run: pip install mkdocs-material

      - name: Deploy to GitHub Pages
        run: mkdocs gh-deploy --force
```

**Configuration:**

In repository settings:

1. Go to Settings → Pages
2. Source: Deploy from a branch
3. Branch: `gh-pages` / root
4. Custom domain (optional): `docs.example.com`

### CODEOWNERS

**Use Case:** Documentation ownership and review assignments

**File:** `.github/CODEOWNERS`

```plaintext
# Documentation standards
/docs/standards/                  @documentation-team

# Service-specific documentation
/services/backend-gateway/README.md  @backend-team
/services/backend-ai/README.md       @ai-team
/services/frontend_lite/README.md    @frontend-team

# Root documentation
/README.md                        @engineering-leads
/CLAUDE.md                        @ai-team
/DOCUMENTATION_STANDARD.md        @documentation-team

# Compliance documentation
/docs/compliance/                 @security-team @legal-team

# Infrastructure documentation
/docs/deployment/                 @devops-team
/infra/                          @devops-team
```

### Issue Templates

**Use Case:** Standardized documentation requests

**File:** `.github/ISSUE_TEMPLATE/documentation.yml`

```yaml
name: Documentation Request
description: Request new documentation or updates
title: "[DOCS]: "
labels: ["documentation"]
body:
  - type: dropdown
    id: doc-type
    attributes:
      label: Documentation Type
      options:
        - New documentation
        - Update existing docs
        - Fix inaccuracy
        - Add examples
    validations:
      required: true

  - type: textarea
    id: description
    attributes:
      label: What needs to be documented?
      description: Clear description of the documentation need
    validations:
      required: true

  - type: input
    id: location
    attributes:
      label: File or Section
      description: Where should this documentation go?
      placeholder: e.g., services/backend-gateway/README.md

  - type: textarea
    id: context
    attributes:
      label: Additional Context
      description: Why is this documentation needed?
```

### Pull Request Template

**File:** `.github/pull_request_template.md`

```markdown
## Description
<!-- Brief description of changes -->

## Type of Change
- [ ] Code changes with documentation
- [ ] Documentation-only changes
- [ ] Infrastructure/config changes

## Documentation Checklist
- [ ] README updated (if behavior changed)
- [ ] CHANGELOG.md updated (if user-facing)
- [ ] OpenAPI spec updated (if API changed)
- [ ] Inline comments added for complex logic
- [ ] Migration guide provided (if breaking change)

## Testing
<!-- How were these changes tested? -->

## Screenshots (if applicable)
<!-- Add screenshots for UI changes -->
```

---

## GitLab Integration

### GitLab CI/CD

**Use Case:** Documentation validation in pipeline

**File:** `.gitlab-ci.yml`

```yaml
stages:
  - validate
  - deploy

validate-docs:
  stage: validate
  image: node:18
  script:
    - npm install -g markdown-link-check vale
    - bash docs/standards/scripts/validate-frontmatter.sh docs/
    - bash docs/standards/scripts/validate-structure.sh docs/
    - markdown-link-check **/*.md
    - vale docs/
  only:
    changes:
      - docs/**
      - "*.md"

deploy-docs:
  stage: deploy
  image: python:3.11
  script:
    - pip install mkdocs-material
    - mkdocs build
    - cp -r site public/
  artifacts:
    paths:
      - public
  only:
    - main
```

### GitLab Pages

**Configuration:**

```yaml
# .gitlab-ci.yml (pages job)
pages:
  stage: deploy
  image: python:3.11
  script:
    - pip install mkdocs-material
    - mkdocs build --site-dir public
  artifacts:
    paths:
      - public
  only:
    - main
```

**Access:** `https://<namespace>.gitlab.io/<project>/`

### Code Owners (GitLab)

**File:** `CODEOWNERS` (in repository root)

```plaintext
# Documentation
/docs/                          @documentation-team
*.md                            @documentation-team

# Service READMEs
/services/*/README.md           @service-owners
```

**Configuration:** Settings → Repository → Code Owners

**Approvals:**

Settings → Merge Requests → Approval Rules:

- "Require approval from code owners" ✓
- "Prevent author approval" ✓

### Merge Request Templates

**File:** `.gitlab/merge_request_templates/Default.md`

```markdown
## Description
<!-- What does this MR do? -->

## Documentation Changes
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] API docs updated
- [ ] Inline documentation added

## Related Issues
Closes #

## Testing
<!-- How was this tested? -->
```

### Wiki Integration

**Use Case:** User-facing documentation in GitLab Wiki

**Approach:**

1. **Keep standards in Git** (`docs/standards/`)
2. **Link Wiki to docs folder** (Settings → General → Wiki → Clone)
3. **Auto-sync via CI:**

```yaml
sync-wiki:
  script:
    - git clone https://gitlab.com/project/repo.wiki.git
    - cp -r docs/ repo.wiki/
    - cd repo.wiki && git add . && git commit -m "Sync docs" && git push
  only:
    - main
```

---

## Backstage Integration

### TechDocs Setup

**Use Case:** Centralized documentation portal for all services

**Prerequisites:**

- Backstage instance running
- MkDocs installed
- Services have `mkdocs.yml`

### catalog-info.yaml

**File:** `catalog-info.yaml` (per service)

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: backend-gateway
  description: API Gateway service with rate limiting
  annotations:
    github.com/project-slug: yourorg/A_ai_agents
    backstage.io/techdocs-ref: dir:.
  tags:
    - api
    - gateway
    - python
spec:
  type: service
  lifecycle: production
  owner: backend-team
  system: A-platform
```

### Service Documentation Structure

```
services/backend-gateway/
├── catalog-info.yaml
├── mkdocs.yml
├── README.md
└── docs/
    ├── index.md          # Landing page
    ├── architecture.md
    ├── api-reference.md
    ├── deployment.md
    └── troubleshooting.md
```

### mkdocs.yml for Backstage

```yaml
site_name: Backend Gateway
site_description: API Gateway Documentation

nav:
  - Home: index.md
  - Architecture: architecture.md
  - API Reference: api-reference.md
  - Deployment: deployment.md
  - Troubleshooting: troubleshooting.md

plugins:
  - techdocs-core

theme:
  name: material
  palette:
    primary: indigo
```

### Ownership Mapping

**Link CODEOWNERS to Backstage teams:**

```yaml
# catalog-info.yaml
spec:
  owner: backend-team  # Maps to CODEOWNERS @backend-team
```

**Backstage Team Catalog:** `catalog/teams.yaml`

```yaml
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: backend-team
spec:
  type: team
  children: []
  members:
    - alice
    - bob
```

### API Documentation Linking

**OpenAPI Integration:**

```yaml
# catalog-info.yaml
metadata:
  annotations:
    backstage.io/techdocs-ref: dir:.
    openapi: ./openapi.yaml  # Link to OpenAPI spec

spec:
  providesApis:
    - gateway-api
```

**API Entity:** `catalog/apis.yaml`

```yaml
apiVersion: backstage.io/v1alpha1
kind: API
metadata:
  name: gateway-api
  description: Gateway REST API
spec:
  type: openapi
  lifecycle: production
  owner: backend-team
  definition:
    $text: https://github.com/yourorg/repo/blob/main/services/backend-gateway/openapi.yaml
```

### Search Integration

Backstage automatically indexes TechDocs content for search.

**Boost search relevance:** Add keywords to frontmatter

```yaml
---
title: "Getting Started"
tags: [quickstart, setup, tutorial]
keywords: [installation, first steps, hello world]
---
```

---

## MkDocs Material

### MkDocs Installation

```bash
pip install mkdocs-material
```

### MkDocs Configuration

**File:** `mkdocs.yml` (repository root)

```yaml
site_name: A AI Agents Documentation
site_url: https://docs.example.com
site_description: Enterprise AI Platform Documentation

repo_name: yourorg/A_ai_agents
repo_url: https://github.com/yourorg/A_ai_agents
edit_uri: edit/main/docs/

theme:
  name: material
  palette:
    # Light mode
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    # Dark mode
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - navigation.top
    - search.suggest
    - search.highlight
    - content.code.copy

plugins:
  - search:
      lang: en
  - git-revision-date-localized:
      enable_creation_date: true
  - tags:
      tags_file: tags.md

markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
  - pymdownx.tabbed:
      alternate_style: true
  - admonition
  - pymdownx.details
  - attr_list
  - md_in_html
  - tables

nav:
  - Home: index.md
  - Getting Started:
      - Quick Start: getting-started/QUICK_START.md
      - Environment Setup: getting-started/ENVIRONMENT_SETUP.md
  - Architecture:
      - Overview: ARCHITECTURE.md
      - Service Map: architecture/SERVICE_MAP.md
  - Deployment:
      - GKE: deployment/GKE.md
      - Docker Compose: deployment/DOCKER_COMPOSE.md
  - Standards:
      - Index: standards/INDEX.md
      - Adoption Playbook: standards/00-ADOPTION_PLAYBOOK.md
  - Compliance:
      - GDPR: compliance/GDPR/CHECKLIST.md
      - ISO 27001: compliance/ISO27001/CHECKLIST.md
      - SOC 2: compliance/SOC2/CHECKLIST.md

extra:
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/yourorg
  analytics:
    provider: google
    property: G-XXXXXXXXXX  # Optional
```

### Plugins Recommendations

| Plugin | Purpose | Installation |
|--------|---------|--------------|
| `mkdocs-material` | Material Design theme | `pip install mkdocs-material` |
| `mkdocs-git-revision-date-localized-plugin` | Show last updated dates | `pip install mkdocs-git-revision-date-localized-plugin` |
| `mkdocs-minify-plugin` | Minify HTML/JS/CSS | `pip install mkdocs-minify-plugin` |
| `mkdocs-redirects` | Handle URL redirects | `pip install mkdocs-redirects` |
| `mkdocs-macros-plugin` | Variables and macros | `pip install mkdocs-macros-plugin` |

### Deployment Options

**GitHub Pages:**

```bash
mkdocs gh-deploy
```

**Netlify:**

```toml
# netlify.toml
[build]
  command = "pip install mkdocs-material && mkdocs build"
  publish = "site"
```

**Vercel:**

```json
{
  "buildCommand": "pip install mkdocs-material && mkdocs build",
  "outputDirectory": "site",
  "installCommand": "pip install -r requirements.txt"
}
```

### Custom Domain

**GitHub Pages:**

1. Add `CNAME` file to `docs/` folder:

   ```
   docs.example.com
   ```

2. Configure DNS:

   ```
   CNAME docs.example.com -> yourorg.github.io
   ```

3. Enable in repository settings → Pages → Custom domain

---

## Docusaurus

### Docusaurus Installation

```bash
npx create-docusaurus@latest docs classic
```

### Docusaurus Configuration

**File:** `docusaurus.config.js`

```javascript
module.exports = {
  title: 'A AI Agents',
  tagline: 'Enterprise AI Platform Documentation',
  url: 'https://docs.example.com',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  organizationName: 'yourorg',
  projectName: 'A_ai_agents',

  themeConfig: {
    navbar: {
      title: 'A Docs',
      logo: {
        alt: 'Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'doc',
          docId: 'intro',
          position: 'left',
          label: 'Docs',
        },
        {
          to: '/api',
          label: 'API',
          position: 'left'
        },
        {
          href: 'https://github.com/yourorg/A_ai_agents',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Getting Started',
              to: '/docs/intro',
            },
            {
              label: 'Architecture',
              to: '/docs/architecture',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/yourorg/A_ai_agents',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Your Org.`,
    },
    prism: {
      theme: require('prism-react-renderer/themes/github'),
      darkTheme: require('prism-react-renderer/themes/dracula'),
      additionalLanguages: ['bash', 'python', 'yaml'],
    },
    algolia: {
      appId: 'YOUR_APP_ID',
      apiKey: 'YOUR_SEARCH_API_KEY',
      indexName: 'YOUR_INDEX_NAME',
    },
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/yourorg/A_ai_agents/edit/main/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
```

### Versioning

**Create new version:**

```bash
npm run docusaurus docs:version 1.0.0
```

**Configuration:**

```javascript
// docusaurus.config.js
docs: {
  lastVersion: 'current',
  versions: {
    current: {
      label: '2.0.0 (Current)',
      path: '2.0',
    },
    '1.0.0': {
      label: '1.0.0',
      path: '1.0',
      banner: 'unmaintained',
    },
  },
},
```

### Plugin Ecosystem

**OpenAPI Documentation:**

```bash
npm install docusaurus-plugin-openapi-docs
```

```javascript
// docusaurus.config.js
plugins: [
  [
    'docusaurus-plugin-openapi-docs',
    {
      id: 'openapi',
      docsPluginId: 'classic',
      config: {
        gateway: {
          specPath: 'services/backend-gateway/openapi.yaml',
          outputDir: 'docs/api/gateway',
        },
      },
    },
  ],
],
```

### Deployment

**Netlify:**

```toml
# netlify.toml
[build]
  command = "npm run build"
  publish = "build"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

**Vercel:**

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "build",
  "framework": "docusaurus"
}
```

---

## Read the Docs

### Read the Docs Configuration

**File:** `.readthedocs.yaml`

```yaml
version: 2

build:
  os: ubuntu-22.04
  tools:
    python: "3.11"

sphinx:
  configuration: docs/conf.py
  fail_on_warning: false

python:
  install:
    - requirements: docs/requirements.txt

formats:
  - pdf
  - epub
```

### Sphinx Configuration

**File:** `docs/conf.py`

```python
project = 'A AI Agents'
copyright = '2025, Your Org'
author = 'Documentation Team'
release = '1.0.0'

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon',
    'myst_parser',  # For Markdown support
    'sphinx_rtd_theme',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']

# Support both .rst and .md
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

# MyST parser configuration
myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "substitution",
]
```

### Webhook Setup

1. Connect repository in Read the Docs dashboard
2. Add webhook to GitHub/GitLab:
   - URL: `https://readthedocs.org/api/v2/webhook/<project-name>/<id>/`
   - Trigger: Push events, PR events

### When to Use Read the Docs

**Good for:**

- Python projects (Sphinx autodoc)
- Academic/scientific documentation
- PDF/EPUB output required
- Free hosting for OSS

**Not ideal for:**

- JavaScript-heavy projects (use Docusaurus)
- Microservices (use Backstage)
- Modern UI expectations (use MkDocs Material)

---

## Notion/Confluence

### When to Use

**Notion/Confluence:**

- Collaborative editing needed
- Non-technical stakeholders contribute
- Rich media (embeds, databases)
- Team knowledge base

**Git-based documentation (preferred for code projects):**

- Version control critical
- Docs live with code
- CI/CD integration
- Markdown-native workflow

### Export/Import Strategies

**From Notion to Markdown:**

```bash
# Using notion-exporter
npm install -g notion-exporter
notion-exporter export --token TOKEN --output docs/
```

**From Confluence to Markdown:**

```python
# confluence-to-markdown.py
from atlassian import Confluence
import markdownify

confluence = Confluence(url='https://company.atlassian.net', username='user', password='token')
space = 'DOCS'

pages = confluence.get_all_pages_from_space(space, expand='body.storage')
for page in pages:
    title = page['title']
    content = page['body']['storage']['value']
    markdown = markdownify.markdownify(content)

    with open(f"docs/{title}.md", 'w') as f:
        f.write(markdown)
```

### API Integration Options

**Notion API (read-only integration):**

```javascript
// sync-from-notion.js
const { Client } = require('@notionhq/client');
const fs = require('fs');

const notion = new Client({ auth: process.env.NOTION_TOKEN });
const databaseId = 'your-database-id';

async function syncDocs() {
  const response = await notion.databases.query({ database_id: databaseId });

  for (const page of response.results) {
    const content = await getPageContent(page.id);
    fs.writeFileSync(`docs/${page.properties.Name.title[0].plain_text}.md`, content);
  }
}
```

**Confluence API (bidirectional sync):**

```python
# confluence-sync.py
from atlassian import Confluence
import frontmatter

confluence = Confluence(url='https://company.atlassian.net', username='user', password='token')

def sync_to_confluence(md_file):
    post = frontmatter.load(md_file)
    title = post['title']
    content = post.content

    # Convert markdown to Confluence storage format
    confluence.create_page(
        space='DOCS',
        title=title,
        body=markdown_to_confluence(content)
    )
```

### Limitations and Tradeoffs

| Feature | Git-Based | Notion | Confluence |
|---------|-----------|--------|------------|
| **Version Control** | ✅ Native | ⚠️ Limited | ⚠️ Limited |
| **CI/CD Integration** | ✅ Full | ❌ None | ⚠️ API only |
| **Collaborative Editing** | ⚠️ PR-based | ✅ Real-time | ✅ Real-time |
| **Search** | ⚠️ Tool-dependent | ✅ Excellent | ✅ Excellent |
| **Code Blocks** | ✅ Syntax highlighting | ⚠️ Basic | ⚠️ Basic |
| **Cost** | Free (hosting extra) | $8/user/mo | $5.75/user/mo |

### Migration Recommendation

**Phase 1:** Keep Notion/Confluence for internal knowledge base
**Phase 2:** Move technical docs to Git (services, APIs, architecture)
**Phase 3:** Link between systems (Notion links to GitHub docs)
**Phase 4:** Fully consolidate if team workflow supports it

---

## Context-Specific Recommendations

### Open Source Projects

**Recommended Stack:**

```
GitHub + GitHub Pages + MkDocs Material
```

**Why:**

- **Free:** No hosting costs
- **Familiar:** Contributors know GitHub workflow
- **Discoverable:** GitHub search + Google indexing
- **CI/CD:** GitHub Actions built-in

**Setup:**

```bash
# One-time setup
pip install mkdocs-material
echo "site_name: Your Project\ntheme:\n  name: material" > mkdocs.yml

# Deploy
mkdocs gh-deploy
```

### Startups (1-10 Engineers)

**Recommended Stack:**

```
GitHub + README.md + (optional) GitHub Wiki
```

**Why:**

- **Minimal overhead:** Focus on shipping code
- **Low maintenance:** No build pipeline needed
- **Sufficient:** READMEs in each service cover 80% of needs

**When to upgrade:**

- Team > 10 people
- Multiple services need API docs
- External documentation required

### Mid-Size Companies (10-100 Engineers)

**Recommended Stack:**

```
GitHub/GitLab + MkDocs Material + Backstage (if microservices)
```

**Why:**

- **Scalable:** Handles 100s of services
- **Searchable:** Centralized search across all docs
- **Developer Portal:** Backstage provides service catalog + docs

**Setup Effort:** ~2 weeks (1 FTE)

**Maintenance:** ~5 hours/week

### Large Enterprises (100+ Engineers)

**Recommended Stack:**

```
GitHub/GitLab + Backstage + Docusaurus (for product docs)
```

**Why:**

- **Enterprise Features:** SSO, permissions, audit logs
- **Multi-Audience:** Internal (Backstage) + External (Docusaurus)
- **API Governance:** OpenAPI integration

**Additional Tools:**

- Confluence (for business/legal docs)
- Notion (for team knowledge base)
- Link between systems via APIs

**Setup Effort:** ~2 months (2-3 FTEs)

**Maintenance:** 1-3 FTE documentation engineers

### Decision Matrix

| If you need... | Recommended Tool | Alternative |
|----------------|------------------|-------------|
| **Free hosting** | GitHub Pages + MkDocs | Read the Docs |
| **Service catalog** | Backstage | Custom portal |
| **Versioned docs** | Docusaurus | Read the Docs |
| **Collaborative editing** | Notion/Confluence | Google Docs |
| **API documentation** | Backstage + OpenAPI | Stoplight |
| **Internal knowledge base** | Notion | Confluence |
| **Public OSS docs** | MkDocs Material | Docusaurus |
| **Enterprise compliance** | Backstage | SharePoint |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [04-AI_AGENTS.md](./04-AI_AGENTS.md) | AI-assisted documentation generation |
| [36-CONTEXT_GUIDANCE.md](./36-CONTEXT_GUIDANCE.md) | Choose right tools for your context |
| [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md) | Implementation timeline |

---

**Previous:** [38 - Open Source](./38-OPEN_SOURCE.md)
**Next:** [40 - Metrics](./40-METRICS.md)
