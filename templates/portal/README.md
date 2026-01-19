---
title: "Documentation Portal Template"
type: "reference"
status: "approved"
classification: "public"
category: "process"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Documentation Portal Template

> Deploy the Documentation Standards as a beautiful, searchable website.

## Quick Start

### Prerequisites

- Python 3.9+
- pip

### Installation

```bash
# Install MkDocs Material
pip install mkdocs-material

# Optional: Additional plugins
pip install mkdocs-git-revision-date-localized-plugin
```

### Local Development

```bash
# Copy mkdocs.yml to your standards directory root
cp mkdocs.yml ../../mkdocs.yml

# Navigate to standards root
cd ../..

# Start local server (hot reload enabled)
mkdocs serve

# Open http://localhost:8000
```

### Build Static Site

```bash
# Build to site/ directory
mkdocs build

# Preview built site
cd site && python -m http.server 8080
```

### Deploy to GitHub Pages

```bash
# One-command deploy
mkdocs gh-deploy --force
```

## Docker Alternative

```bash
# Serve locally with Docker (no Python install needed)
docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material

# Build with Docker
docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build
```

## Customization Checklist

Before deploying, update these in `mkdocs.yml`:

- [ ] `site_name` → Your organization name
- [ ] `site_url` → Your docs URL
- [ ] `repo_url` → Your GitHub repo
- [ ] `copyright` → Your copyright notice
- [ ] `extra.social` → Your social links

## File Structure

Place `mkdocs.yml` at the same level as your standards files:

```
your-repo/
├── mkdocs.yml          ← Copy here
├── INDEX.md
├── README.md
├── 01-PHILOSOPHY.md
├── 02-KNOW_YOUR_AUDIENCE.md
├── ...
└── templates/
    └── portal/
        ├── mkdocs.yml  ← Source template
        └── README.md   ← This file
```

## Features Included

✅ Dark mode toggle
✅ Instant navigation (SPA-like)
✅ Full-text search with suggestions
✅ Mermaid diagram support
✅ Code copy buttons
✅ Mobile responsive
✅ GitHub edit links

---

## 🔍 Search Options

### Built-in Search (Default)

Works out of the box with no setup:

- Press `/` or `s` to open search
- Instant results as you type
- Highlights matches on page
- Works offline

### Algolia DocSearch (Premium)

For the best search experience, upgrade to Algolia (free for open-source):

1. Apply at [docsearch.algolia.com/apply](https://docsearch.algolia.com/apply/)
2. Once approved, update `mkdocs.yml` with your credentials
3. See commented section in `mkdocs.yml` for configuration

**Benefits:**

- Typo tolerance ("autentication" → "authentication")
- Synonym support ("auth" → "authentication")
- Search analytics dashboard
- Better relevance ranking

---

## 📚 Version Support (Mike)

**Previous versions are always accessible.** When you release a new version, old versions stay online.

### Local Development vs Deployment

| Stage | Command | Use Case |
|-------|---------|----------|
| **Local dev** | `mkdocs serve` | Fast editing with hot reload (no versions) |
| **Test versions** | `mike serve` | Preview version dropdown locally |
| **Deploy** | `mike deploy X.X --push` | Publish to GitHub Pages |

### Typical Workflow

```bash
# STEP 1: Develop locally (fast iteration, no versioning)
mkdocs serve
# → http://localhost:8000 with hot reload

# STEP 2: Ready for first release - deploy version 1.0
mike deploy 1.0 latest --update-aliases --push
# → Creates /1.0/ and /latest/ on GitHub Pages

# STEP 3: Continue editing, deploy updates to same version
mike deploy 1.0 latest --update-aliases --push
# → Updates /1.0/ in place

# STEP 4: Breaking changes? Create new version
mike deploy 2.0 latest --update-aliases --push
# → /1.0/ still exists (users can access it!)
# → /2.0/ is new
# → /latest/ now points to 2.0
```

### Site Structure After Deployment

```
your-site.github.io/
├── 1.0/           ← Version 1.0 (always accessible)
├── 2.0/           ← Version 2.0 (always accessible)
├── latest/        ← Alias pointing to 2.0
└── index.html     ← Redirects to 'latest'
```

Users see a **version dropdown** in the header and can switch between any version.

### When to Create a New Version

| Scenario | Action |
|----------|--------|
| Major breaking changes | New version (1.0 → 2.0) |
| New standards added | Update existing version |
| Typo fixes | Update existing version |
| Restructuring navigation | New version |
