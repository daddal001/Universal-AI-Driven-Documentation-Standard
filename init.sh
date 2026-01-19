#!/bin/bash
# docs/standards/init.sh
#
# Universal Documentation Standard - Interactive Installer
#
# Usage:
#   bash docs/standards/init.sh              # Interactive mode
#   bash docs/standards/init.sh --solo       # Solo dev: just README.md (30 seconds)
#   bash docs/standards/init.sh --oss        # OSS: README + CONTRIBUTING + CHANGELOG
#   bash docs/standards/init.sh --team       # Team: Standard + runbooks + AI support
#   bash docs/standards/init.sh --no-frontmatter  # Skip YAML frontmatter in templates
#
# This script sets up documentation standards in your repository.
# It auto-detects your project type and offers multiple installation modes.

set -e

# ─────────────────────────────────────────────────────────────────────────────
# CLI Arguments
# ─────────────────────────────────────────────────────────────────────────────
SOLO_MODE="false"
OSS_MODE="false"
TEAM_MODE="false"
NO_FRONTMATTER="false"

for arg in "$@"; do
    case $arg in
        --solo)
            SOLO_MODE="true"
            shift
            ;;
        --oss)
            OSS_MODE="true"
            shift
            ;;
        --team)
            TEAM_MODE="true"
            shift
            ;;
        --no-frontmatter)
            NO_FRONTMATTER="true"
            shift
            ;;
        --help|-h)
            echo "Universal Documentation Standard Installer"
            echo ""
            echo "Usage:"
            echo "  bash init.sh              Interactive mode (recommended)"
            echo "  bash init.sh --solo       Solo dev: just README.md"
            echo "  bash init.sh --oss        OSS project: README + CONTRIBUTING + CHANGELOG"
            echo "  bash init.sh --team       Team/startup: Standard + runbooks + AI support"
            echo "  bash init.sh --no-frontmatter  Skip YAML metadata headers"
            echo ""
            echo "Use this if:"
            echo "  --solo       <5 engineers OR side project OR no compliance needs"
            echo "  --oss        Open source, need community contribution guidelines"
            echo "  --team       5-50 engineers, need runbooks, want AI assistant support"
            echo "  (interactive) 50+ engineers OR compliance requirements"
            echo ""
            echo "Flags can be combined: bash init.sh --oss --no-frontmatter"
            exit 0
            ;;
    esac
done

# ─────────────────────────────────────────────────────────────────────────────
# ANSI Colors
# ─────────────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────
print_header() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}  🚀 Universal Documentation Standard Installer${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

print_info() {
    echo -e "  ${BLUE}→${NC} $1"
}

# Safe copy - won't overwrite existing files
safe_copy() {
    local src="$1"
    local dest="$2"
    if [[ -f "$dest" ]]; then
        print_warning "Skipped $dest (already exists)"
        return 1
    fi
    mkdir -p "$(dirname "$dest")"

    if [[ "$NO_FRONTMATTER" == "true" ]]; then
        # Strip YAML frontmatter (content between --- markers at start of file)
        awk 'BEGIN{skip=0} /^---$/{if(NR==1){skip=1;next}else if(skip){skip=0;next}} !skip{print}' "$src" > "$dest"
    else
        cp "$src" "$dest"
    fi
    print_success "Created $dest"
    return 0
}

# ─────────────────────────────────────────────────────────────────────────────
# Solo Mode - Ultra-minimal installation (just README.md)
# ─────────────────────────────────────────────────────────────────────────────
run_solo_mode() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}  🚀 Solo Developer Quick Start${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Detect project name
    if [[ -f "package.json" ]]; then
        PROJECT_NAME=$(grep -o '"name": *"[^"]*"' package.json 2>/dev/null | head -1 | cut -d'"' -f4)
    elif [[ -f "pyproject.toml" ]]; then
        PROJECT_NAME=$(grep -o 'name = "[^"]*"' pyproject.toml 2>/dev/null | head -1 | cut -d'"' -f2)
    elif [[ -f "Cargo.toml" ]]; then
        PROJECT_NAME=$(grep -o 'name = "[^"]*"' Cargo.toml 2>/dev/null | head -1 | cut -d'"' -f2)
    else
        PROJECT_NAME=$(basename "$(pwd)")
    fi
    PROJECT_NAME=${PROJECT_NAME:-"my-project"}

    print_info "Project: ${BOLD}$PROJECT_NAME${NC}"
    echo ""

    # Create README.md directly (no template needed)
    if [[ -f "README.md" ]]; then
        print_warning "README.md already exists - not overwriting"
    else
        cat > "README.md" << EOF
# $PROJECT_NAME

> One-line description of what this project does.

## Quick Start

\`\`\`bash
# Clone the repository
git clone https://github.com/username/$PROJECT_NAME.git
cd $PROJECT_NAME

# Install dependencies
npm install  # or: pip install -r requirements.txt

# Run the project
npm start    # or: python main.py
\`\`\`

## Features

- Feature 1: Brief description
- Feature 2: Brief description
- Feature 3: Brief description

## Usage

\`\`\`bash
# Example command or code snippet
$PROJECT_NAME --help
\`\`\`

## Contributing

Contributions welcome! Please open an issue or submit a PR.

## License

MIT
EOF
        print_success "Created README.md"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}  ✅ Done! Your README.md is ready.${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    echo "  1. Edit README.md with your project details"
    echo "  2. That's it! Ship your code."
    echo ""
    echo -e "  ${CYAN}Want more? Run: bash docs/standards/init.sh --oss${NC}"
    echo ""
    exit 0
}

# ─────────────────────────────────────────────────────────────────────────────
# OSS Mode - Minimal open source setup
# ─────────────────────────────────────────────────────────────────────────────
run_oss_mode() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}  🌟 Open Source Quick Start${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Detect project name
    if [[ -f "package.json" ]]; then
        PROJECT_NAME=$(grep -o '"name": *"[^"]*"' package.json 2>/dev/null | head -1 | cut -d'"' -f4)
    elif [[ -f "pyproject.toml" ]]; then
        PROJECT_NAME=$(grep -o 'name = "[^"]*"' pyproject.toml 2>/dev/null | head -1 | cut -d'"' -f2)
    else
        PROJECT_NAME=$(basename "$(pwd)")
    fi
    PROJECT_NAME=${PROJECT_NAME:-"my-project"}

    print_info "Project: ${BOLD}$PROJECT_NAME${NC}"
    echo ""
    echo -e "${BOLD}Creating OSS documentation...${NC}"
    echo ""

    # Create README.md
    if [[ -f "README.md" ]]; then
        print_warning "README.md already exists"
    else
        cat > "README.md" << EOF
# $PROJECT_NAME

> One-line description of what this project does.

## Quick Start

\`\`\`bash
git clone https://github.com/username/$PROJECT_NAME.git
cd $PROJECT_NAME
npm install && npm start
\`\`\`

## Features

- Feature 1: Brief description
- Feature 2: Brief description

## Documentation

- [Contributing Guide](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT - see [LICENSE](LICENSE) for details.
EOF
        print_success "Created README.md"
    fi

    # Create CONTRIBUTING.md
    if [[ -f "CONTRIBUTING.md" ]]; then
        print_warning "CONTRIBUTING.md already exists"
    else
        cat > "CONTRIBUTING.md" << EOF
# Contributing to $PROJECT_NAME

Thank you for your interest in contributing!

## How to Contribute

1. **Fork** the repository
2. **Clone** your fork: \`git clone https://github.com/YOUR-USERNAME/$PROJECT_NAME.git\`
3. **Create a branch**: \`git checkout -b feature/your-feature\`
4. **Make changes** and commit: \`git commit -m "Add your feature"\`
5. **Push** to your fork: \`git push origin feature/your-feature\`
6. **Open a Pull Request**

## Development Setup

\`\`\`bash
# Install dependencies
npm install

# Run tests
npm test

# Run linter
npm run lint
\`\`\`

## Code Style

- Use meaningful variable names
- Add comments for complex logic
- Write tests for new features

## Questions?

Open an issue and we'll help you out!
EOF
        print_success "Created CONTRIBUTING.md"
    fi

    # Create CHANGELOG.md
    if [[ -f "CHANGELOG.md" ]]; then
        print_warning "CHANGELOG.md already exists"
    else
        cat > "CHANGELOG.md" << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Initial release

## [0.1.0] - $(date +%Y-%m-%d)

### Added
- Project scaffolding
- Basic functionality
EOF
        print_success "Created CHANGELOG.md"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}  ✅ OSS Documentation Ready!${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${BOLD}Created:${NC}"
    echo "  • README.md - Project overview"
    echo "  • CONTRIBUTING.md - Contributor guide"
    echo "  • CHANGELOG.md - Version history"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    echo "  1. Edit each file with your project details"
    echo "  2. Add a LICENSE file (e.g., MIT, Apache 2.0)"
    echo "  3. Push to GitHub and start accepting contributions!"
    echo ""
    echo -e "  ${CYAN}Want AI agent support? Run: bash docs/standards/init.sh${NC}"
    echo ""
    exit 0
}

# ─────────────────────────────────────────────────────────────────────────────
# Team Mode (5-50 engineers, runbooks, AI support)
# ─────────────────────────────────────────────────────────────────────────────
run_team_mode() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}  👥 Team/Startup Quick Start${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Detect project name
    if [[ -f "package.json" ]]; then
        PROJECT_NAME=$(grep -o '"name": *"[^"]*"' package.json 2>/dev/null | head -1 | cut -d'"' -f4)
    elif [[ -f "pyproject.toml" ]]; then
        PROJECT_NAME=$(grep -o 'name = "[^"]*"' pyproject.toml 2>/dev/null | head -1 | cut -d'"' -f2)
    else
        PROJECT_NAME=$(basename "$(pwd)")
    fi
    PROJECT_NAME=${PROJECT_NAME:-"my-project"}

    print_info "Project: ${BOLD}$PROJECT_NAME${NC}"
    echo ""
    echo -e "${BOLD}Creating team documentation with AI support...${NC}"
    echo ""

    # Detect script location for templates
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    TEMPLATES_DIR="$SCRIPT_DIR/templates"

    mkdir -p docs/templates

    # Create README.md
    if [[ -f "README.md" ]]; then
        print_warning "README.md already exists"
    else
        cat > "README.md" << EOF
# $PROJECT_NAME

> One-line description of what this project does.

## Quick Start

\`\`\`bash
# Installation
npm install  # or pip install, etc.

# Run
npm start
\`\`\`

## Documentation

- [Getting Started](./docs/GETTING_STARTED.md)
- [Architecture](./docs/ARCHITECTURE.md)
- [Runbooks](./docs/runbooks/)

## Development

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development setup.

## License

[Your License]
EOF
        print_success "Created README.md"
    fi

    # Copy standard templates
    if [[ -d "$TEMPLATES_DIR/tier-1-system" ]]; then
        cp "$TEMPLATES_DIR/tier-3-developer/GETTING_STARTED.md" "docs/templates/" 2>/dev/null && print_success "Copied GETTING_STARTED.md template" || true
        cp "$TEMPLATES_DIR/tier-1-system/ARCHITECTURE.md" "docs/templates/" 2>/dev/null && print_success "Copied ARCHITECTURE.md template" || true
    fi

    if [[ -d "$TEMPLATES_DIR/tier-2-operational" ]]; then
        mkdir -p docs/runbooks
        cp "$TEMPLATES_DIR/tier-2-operational/RUNBOOK.md" "docs/runbooks/TEMPLATE.md" 2>/dev/null && print_success "Copied RUNBOOK.md template" || true
        cp "$TEMPLATES_DIR/tier-2-operational/ONCALL_GUIDE.md" "docs/templates/" 2>/dev/null && print_success "Copied ONCALL_GUIDE.md template" || true
    fi

    # Create AGENTS.md for AI assistants
    cat > "AGENTS.md" << 'EOF'
# AI Agent Guidelines

## Project Context

This is a [describe your project type] project.

## Architecture Rules

- Services communicate via [REST/gRPC/etc.]
- All API endpoints require authentication
- Database access through repository pattern

## Code Style

- Follow existing patterns in the codebase
- Use TypeScript strict mode / Python type hints
- Write tests for new functionality

## Common Tasks

### Adding a new endpoint
1. Create route handler in `src/routes/`
2. Add validation schema
3. Write tests
4. Update API documentation

### Debugging issues
1. Check logs in `logs/` directory
2. Review recent commits
3. Check monitoring dashboards

## What NOT to do

- Don't modify generated files
- Don't commit secrets or credentials
- Don't bypass linting rules
EOF
    print_success "Created AGENTS.md"

    # Create llms.txt
    cat > "llms.txt" << EOF
# $PROJECT_NAME

## Overview
[Brief description of what this project does]

## Key Technologies
- [List main frameworks and libraries]

## Project Structure
- src/ - Source code
- docs/ - Documentation
- tests/ - Test files

## Getting Help
- Read AGENTS.md for AI-specific guidelines
- Check docs/ for detailed documentation
EOF
    print_success "Created llms.txt"

    # Copy validation scripts
    if [[ -d "$SCRIPT_DIR/scripts" ]]; then
        mkdir -p scripts/docs
        cp "$SCRIPT_DIR/scripts/validate-frontmatter.sh" "scripts/docs/" 2>/dev/null && print_success "Copied validate-frontmatter.sh" || true
        cp "$SCRIPT_DIR/scripts/check-freshness.sh" "scripts/docs/" 2>/dev/null && print_success "Copied check-freshness.sh" || true
        chmod +x scripts/docs/*.sh 2>/dev/null || true
    fi

    echo ""
    echo -e "${GREEN}${BOLD}✅ Team documentation setup complete!${NC}"
    echo ""
    echo "  Created:"
    echo "  • README.md - Project overview"
    echo "  • AGENTS.md - AI assistant guidelines"
    echo "  • llms.txt - AI context file"
    echo "  • docs/templates/ - Documentation templates"
    echo "  • docs/runbooks/ - Operational runbook templates"
    echo "  • scripts/docs/ - Validation scripts"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    echo "  1. Edit README.md with your project details"
    echo "  2. Customize AGENTS.md with your architecture"
    echo "  3. Copy templates to docs/ and fill them in"
    echo "  4. Run: bash scripts/docs/validate-frontmatter.sh docs/"
    echo ""
    echo -e "  ${CYAN}Need compliance docs? Run: bash docs/standards/init.sh${NC}"
    echo ""
    exit 0
}

# ─────────────────────────────────────────────────────────────────────────────
# Detect Script Location
# ─────────────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

if [[ ! -d "$TEMPLATES_DIR" ]]; then
    print_error "Templates directory not found at: $TEMPLATES_DIR"
    print_info "Ensure you're running this from a repository with docs/standards/"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Detect Project Type
# ─────────────────────────────────────────────────────────────────────────────
detect_project() {
    echo -e "${BOLD}Detecting project type...${NC}"

    DETECTED_TYPES=()

    # Node.js detection
    if [[ -f "package.json" ]]; then
        print_success "Found package.json (Node.js/JavaScript)"
        DETECTED_TYPES+=("nodejs")
    fi

    # Python detection
    if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
        print_success "Found Python project files"
        DETECTED_TYPES+=("python")
    fi

    # Go detection
    if [[ -f "go.mod" ]]; then
        print_success "Found go.mod (Go)"
        DETECTED_TYPES+=("go")
    fi

    # Rust detection
    if [[ -f "Cargo.toml" ]]; then
        print_success "Found Cargo.toml (Rust)"
        DETECTED_TYPES+=("rust")
    fi

    # Java/Kotlin detection
    if [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        print_success "Found Java/Kotlin project files"
        DETECTED_TYPES+=("java")
    fi

    # Determine if monorepo
    if [[ ${#DETECTED_TYPES[@]} -gt 1 ]]; then
        print_info "Detected: ${BOLD}Monorepo${NC} (${DETECTED_TYPES[*]})"
        PROJECT_TYPE="monorepo"
    elif [[ ${#DETECTED_TYPES[@]} -eq 1 ]]; then
        print_info "Detected: ${BOLD}${DETECTED_TYPES[0]}${NC}"
        PROJECT_TYPE="${DETECTED_TYPES[0]}"
    else
        print_warning "Could not auto-detect project type"
        PROJECT_TYPE="generic"
    fi

    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Select Installation Mode
# ─────────────────────────────────────────────────────────────────────────────
select_mode() {
    echo -e "${BOLD}Select installation mode:${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} ${BOLD}Minimal (OSS)${NC}"
    echo "     README, CONTRIBUTING, LICENSE, CODE_OF_CONDUCT templates"
    echo "     Best for: Open source projects, small teams"
    echo ""
    echo -e "  ${CYAN}2)${NC} ${BOLD}Standard${NC} (Recommended)"
    echo "     Adds: Runbooks, ADRs, CI workflows, Getting Started guides"
    echo "     Best for: Professional teams, production services"
    echo ""
    echo -e "  ${CYAN}3)${NC} ${BOLD}Enterprise${NC}"
    echo "     Adds: Compliance matrices, audit trails, data classification"
    echo "     Best for: Regulated industries, large organizations"
    echo ""

    while true; do
        read -p "  Enter choice [1-3] (default: 2): " MODE_CHOICE
        MODE_CHOICE=${MODE_CHOICE:-2}

        case $MODE_CHOICE in
            1) INSTALL_MODE="minimal"; break ;;
            2) INSTALL_MODE="standard"; break ;;
            3) INSTALL_MODE="enterprise"; break ;;
            *) print_error "Invalid choice. Please enter 1, 2, or 3." ;;
        esac
    done

    print_info "Selected: ${BOLD}$INSTALL_MODE${NC} mode"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# AI Agent Support
# ─────────────────────────────────────────────────────────────────────────────
ask_ai_support() {
    echo -e "${BOLD}AI Agent Support:${NC}"
    echo "  Creates llms.txt and AGENTS.md for AI coding assistants"
    echo "  (Claude, Copilot, Cursor, etc.)"
    echo ""

    read -p "  Enable AI agent support? [Y/n]: " AI_CHOICE
    AI_CHOICE=${AI_CHOICE:-Y}

    if [[ "$AI_CHOICE" =~ ^[Yy]$ ]]; then
        ENABLE_AI="true"
        print_success "AI agent support enabled"
    else
        ENABLE_AI="false"
        print_info "AI agent support skipped"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Install Templates
# ─────────────────────────────────────────────────────────────────────────────
install_templates() {
    echo -e "${BOLD}Installing templates...${NC}"
    echo ""

    # Create docs directory
    mkdir -p docs/templates

    # ─────────────────────────────────────────────────────────────────────────
    # MINIMAL MODE: OSS essentials
    # ─────────────────────────────────────────────────────────────────────────
    if [[ -d "$TEMPLATES_DIR/tier-oss" ]]; then
        safe_copy "$TEMPLATES_DIR/tier-oss/CONTRIBUTING.md" "docs/templates/CONTRIBUTING.md"
        safe_copy "$TEMPLATES_DIR/tier-oss/CODE_OF_CONDUCT.md" "docs/templates/CODE_OF_CONDUCT.md"
        safe_copy "$TEMPLATES_DIR/tier-oss/SECURITY.md" "docs/templates/SECURITY.md"
    fi

    if [[ -d "$TEMPLATES_DIR/tier-1-system" ]]; then
        safe_copy "$TEMPLATES_DIR/tier-1-system/SERVICE_README.md" "docs/templates/README.md"
        safe_copy "$TEMPLATES_DIR/tier-1-system/CHANGELOG.md" "docs/templates/CHANGELOG.md"
    fi

    # ─────────────────────────────────────────────────────────────────────────
    # STANDARD MODE: Professional additions
    # ─────────────────────────────────────────────────────────────────────────
    if [[ "$INSTALL_MODE" == "standard" ]] || [[ "$INSTALL_MODE" == "enterprise" ]]; then
        # System templates
        if [[ -d "$TEMPLATES_DIR/tier-1-system" ]]; then
            safe_copy "$TEMPLATES_DIR/tier-1-system/ADR.md" "docs/templates/ADR.md"
            safe_copy "$TEMPLATES_DIR/tier-1-system/ARCHITECTURE.md" "docs/templates/ARCHITECTURE.md"
            safe_copy "$TEMPLATES_DIR/tier-1-system/API.md" "docs/templates/API.md"
        fi

        # Operational templates
        if [[ -d "$TEMPLATES_DIR/tier-2-operational" ]]; then
            safe_copy "$TEMPLATES_DIR/tier-2-operational/RUNBOOK.md" "docs/templates/RUNBOOK.md"
            safe_copy "$TEMPLATES_DIR/tier-2-operational/ONCALL_GUIDE.md" "docs/templates/ONCALL_GUIDE.md"
            safe_copy "$TEMPLATES_DIR/tier-2-operational/SLO.md" "docs/templates/SLO.md"
        fi

        # Developer templates
        if [[ -d "$TEMPLATES_DIR/tier-3-developer" ]]; then
            safe_copy "$TEMPLATES_DIR/tier-3-developer/GETTING_STARTED.md" "docs/templates/GETTING_STARTED.md"
            safe_copy "$TEMPLATES_DIR/tier-3-developer/HOW_TO.md" "docs/templates/HOW_TO.md"
        fi

        # Process templates
        if [[ -d "$TEMPLATES_DIR/tier-4-process" ]]; then
            safe_copy "$TEMPLATES_DIR/tier-4-process/POSTMORTEM.md" "docs/templates/POSTMORTEM.md"
            safe_copy "$TEMPLATES_DIR/tier-4-process/MIGRATION.md" "docs/templates/MIGRATION.md"
        fi

        # Troubleshooting templates
        if [[ -d "$TEMPLATES_DIR/tier-5-troubleshooting" ]]; then
            safe_copy "$TEMPLATES_DIR/tier-5-troubleshooting/FAQ.md" "docs/templates/FAQ.md"
            safe_copy "$TEMPLATES_DIR/tier-5-troubleshooting/TROUBLESHOOTING.md" "docs/templates/TROUBLESHOOTING.md"
        fi

        # CI/CD workflows
        if [[ -d "$TEMPLATES_DIR/ci-cd" ]]; then
            mkdir -p .github/workflows
            safe_copy "$TEMPLATES_DIR/ci-cd/docs-validation.yml" ".github/workflows/docs-validation.yml"
        fi
    fi

    # ─────────────────────────────────────────────────────────────────────────
    # ENTERPRISE MODE: Compliance additions
    # ─────────────────────────────────────────────────────────────────────────
    if [[ "$INSTALL_MODE" == "enterprise" ]]; then
        if [[ -d "$TEMPLATES_DIR/tier-enterprise" ]]; then
            safe_copy "$TEMPLATES_DIR/tier-enterprise/COMPLIANCE_MATRIX.md" "docs/templates/COMPLIANCE_MATRIX.md"
            safe_copy "$TEMPLATES_DIR/tier-enterprise/AUDIT_TRAIL.md" "docs/templates/AUDIT_TRAIL.md"
            safe_copy "$TEMPLATES_DIR/tier-enterprise/DATA_CLASSIFICATION.md" "docs/templates/DATA_CLASSIFICATION.md"
            safe_copy "$TEMPLATES_DIR/tier-enterprise/VENDOR_DOCUMENTATION.md" "docs/templates/VENDOR_DOCUMENTATION.md"
        fi
    fi

    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Create AI Agent Files
# ─────────────────────────────────────────────────────────────────────────────
create_ai_files() {
    if [[ "$ENABLE_AI" != "true" ]]; then
        return
    fi

    echo -e "${BOLD}Creating AI agent configuration...${NC}"
    echo ""

    # Detect project name
    if [[ -f "package.json" ]]; then
        PROJECT_NAME=$(grep -o '"name": *"[^"]*"' package.json | head -1 | cut -d'"' -f4)
    elif [[ -f "pyproject.toml" ]]; then
        PROJECT_NAME=$(grep -o 'name = "[^"]*"' pyproject.toml | head -1 | cut -d'"' -f2)
    else
        PROJECT_NAME=$(basename "$(pwd)")
    fi
    PROJECT_NAME=${PROJECT_NAME:-"my-project"}

    # Create llms.txt
    if [[ ! -f "llms.txt" ]]; then
        cat > "llms.txt" << EOF
# $PROJECT_NAME

> Brief description of your project for AI assistants.

## Overview
This project provides [describe main functionality].

## Documentation Entry Points
- /README.md - Project overview
- /docs/INDEX.md - Documentation index
- /docs/ARCHITECTURE.md - System architecture

## Quick Facts
- Languages: [e.g., TypeScript, Python]
- Frameworks: [e.g., Next.js, FastAPI]
- API Style: [e.g., REST, GraphQL]
- Test Framework: [e.g., Jest, pytest]

## Key Patterns
- Authentication: [describe auth approach]
- Error format: { "error": string, "code": number }
- Rate limiting: [describe if applicable]

## Important Files
- /src/index.ts - Main entry point
- /src/config.ts - Configuration
- /.env.example - Environment variables template
EOF
        print_success "Created llms.txt"
    else
        print_warning "Skipped llms.txt (already exists)"
    fi

    # Create AGENTS.md
    if [[ ! -f "AGENTS.md" ]]; then
        cat > "AGENTS.md" << EOF
# Agent Instructions

> Instructions for AI coding agents (Claude, Copilot, Cursor, etc.)

## Project Context
This is a $PROJECT_TYPE project. [Add brief description].

## Code Standards
- Use async/await for all I/O operations
- Type hints/annotations required on all functions
- Follow existing patterns in the codebase
- Write tests for new functionality

## Naming Conventions
- Functions: camelCase (JS/TS) or snake_case (Python)
- Classes: PascalCase
- Constants: SCREAMING_SNAKE_CASE
- Files: kebab-case or snake_case

## Architecture Rules
- [Add your architecture guidelines]
- [e.g., Services communicate via REST, not direct imports]
- [e.g., All API endpoints require authentication]

## Restricted Actions
- Do not modify CODEOWNERS without approval
- Do not change authentication/security code without review
- Do not delete migration files
- Do not commit secrets or credentials

## Common Tasks
- New endpoint: Follow pattern in src/api/routes/
- New model: Add to src/models/ with migrations
- Tests: Add to tests/ matching source structure

## Documentation Requirements
- Update README.md for user-facing changes
- Add JSDoc/docstrings for public functions
- Update CHANGELOG.md for releases
EOF
        print_success "Created AGENTS.md"
    else
        print_warning "Skipped AGENTS.md (already exists)"
    fi

    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Copy Validation Scripts
# ─────────────────────────────────────────────────────────────────────────────
copy_scripts() {
    if [[ "$INSTALL_MODE" == "minimal" ]]; then
        return
    fi

    echo -e "${BOLD}Setting up validation scripts...${NC}"
    echo ""

    SCRIPTS_DIR="$SCRIPT_DIR/scripts"
    if [[ -d "$SCRIPTS_DIR" ]]; then
        mkdir -p scripts/docs

        if [[ -f "$SCRIPTS_DIR/validate-frontmatter.sh" ]]; then
            safe_copy "$SCRIPTS_DIR/validate-frontmatter.sh" "scripts/docs/validate-frontmatter.sh"
            chmod +x "scripts/docs/validate-frontmatter.sh" 2>/dev/null || true
        fi

        if [[ -f "$SCRIPTS_DIR/check-freshness.sh" ]]; then
            safe_copy "$SCRIPTS_DIR/check-freshness.sh" "scripts/docs/check-freshness.sh"
            chmod +x "scripts/docs/check-freshness.sh" 2>/dev/null || true
        fi
    fi

    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Print Summary
# ─────────────────────────────────────────────────────────────────────────────
print_summary() {
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}  ✅ Installation Complete!${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${BOLD}Installed:${NC}"
    echo "  • Documentation templates in docs/templates/"
    [[ "$INSTALL_MODE" != "minimal" ]] && echo "  • CI workflow in .github/workflows/"
    [[ "$ENABLE_AI" == "true" ]] && echo "  • AI agent files (llms.txt, AGENTS.md)"
    [[ "$INSTALL_MODE" != "minimal" ]] && echo "  • Validation scripts in scripts/docs/"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    echo "  1. Review and customize templates in docs/templates/"
    echo "  2. Copy templates to create your documentation"
    [[ "$ENABLE_AI" == "true" ]] && echo "  3. Update llms.txt and AGENTS.md with project details"
    echo ""
    echo -e "  ${BOLD}Validate your docs:${NC}"
    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        echo "  bash scripts/docs/validate-frontmatter.sh docs/"
    else
        echo "  bash docs/standards/scripts/validate-frontmatter.sh docs/ --minimal"
    fi
    echo ""
    echo -e "  ${CYAN}Documentation: https://github.com/your-org/universal-docs-standard${NC}"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Main Execution
# ─────────────────────────────────────────────────────────────────────────────
main() {
    # Check for quick modes first
    if [[ "$SOLO_MODE" == "true" ]]; then
        run_solo_mode
    fi

    if [[ "$OSS_MODE" == "true" ]]; then
        run_oss_mode
    fi

    if [[ "$TEAM_MODE" == "true" ]]; then
        run_team_mode
    fi

    # Interactive mode
    print_header
    detect_project
    select_mode
    ask_ai_support
    install_templates
    create_ai_files
    copy_scripts
    print_summary
}

# Run main function
main "$@"
