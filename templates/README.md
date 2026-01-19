# Documentation Templates

This directory contains reusable templates and configuration files for documentation projects.

## Available Templates

### Configuration Files

- **`.markdownlint.json`** - Markdownlint configuration template
  - Disables MD013 (line length), MD040 (fenced code language), MD060 (inline HTML)
  - Copy to repository root to use

### CI/CD Workflows

See `ci-cd/` directory for GitHub Actions workflow templates:

- `docs-validation.yml` - Comprehensive documentation validation
- `vale-style.yml` - Vale prose linting
- `freshness-check.yml` - Document age checking
- `link-checker.yml` - Broken link detection
- `check-changelog.yml` - CHANGELOG format validation
- `frontmatter-date-check.yml` - Frontmatter date validation

### Document Templates

See tier-specific directories:

- `tier-1-system/` - System-level documentation (ADRs, Architecture, API specs)
- `tier-2-operational/` - Operational docs (Runbooks, On-call guides, SLOs)
- `tier-3-developer/` - Developer guides (Getting started, How-tos)
- `tier-4-process/` - Process docs (Migrations, Postmortems)
- `tier-5-troubleshooting/` - Troubleshooting (FAQs, Troubleshooting guides)
- `tier-enterprise/` - Enterprise docs (Compliance, Audit trails)
- `tier-oss/` - Open source templates (LICENSE, CONTRIBUTING, CODE_OF_CONDUCT)

### Portal Configuration

See `portal/` directory for MkDocs configuration templates.

## Usage

1. Copy the relevant template to your repository
2. Customize for your project's needs
3. Update paths and configurations as required
