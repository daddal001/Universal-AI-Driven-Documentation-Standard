#!/bin/bash

# generate-quickstart.sh
# Interactive script to generate a minimal viable documentation standards package

set -e

echo "📚 Documentation Standards Quick Start Generator"
echo "================================================"
echo ""

# Questions with timeout for CI/CD environments (30 second timeout, defaults if no input)
read -t 30 -p "What is your context? (oss/startup/mid-size/enterprise): " CONTEXT || CONTEXT=""
read -t 30 -p "What is your team size? (1-10/10-50/50-100/100+): " TEAM_SIZE || TEAM_SIZE=""
read -t 30 -p "What is your tech stack? (node/python/go/mixed): " TECH_STACK || TECH_STACK=""
read -t 30 -p "Where should standards be installed? (default: ./docs/standards): " INSTALL_DIR || INSTALL_DIR=""

# Apply defaults
CONTEXT=${CONTEXT:-oss}
TEAM_SIZE=${TEAM_SIZE:-1-10}
TECH_STACK=${TECH_STACK:-mixed}

INSTALL_DIR=${INSTALL_DIR:-./docs/standards}

echo ""
echo "Generating quick start package for:"
echo "  Context: $CONTEXT"
echo "  Team Size: $TEAM_SIZE"
echo "  Tech Stack: $TECH_STACK"
echo "  Install Directory: $INSTALL_DIR"
echo ""

# Create directory
mkdir -p "$INSTALL_DIR"

# Copy core standards
echo "📋 Copying core standards..."
cp 01-PHILOSOPHY.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  01-PHILOSOPHY.md not found (will need to copy manually)"
cp 03-DOCUMENT_TYPES.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  03-DOCUMENT_TYPES.md not found (will need to copy manually)"
cp 05-QUALITY.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  05-QUALITY.md not found (will need to copy manually)"

# Context-specific standards
case $CONTEXT in
  oss)
    echo "📦 Adding open source standards..."
    cp 38-OPEN_SOURCE.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  38-OPEN_SOURCE.md not found"
    cp -r templates/tier-oss "$INSTALL_DIR/templates/" 2>/dev/null || echo "  ⚠️  OSS templates not found"
    ;;
  startup)
    echo "🚀 Adding startup-focused standards..."
    cp 26-ONBOARDING.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  26-ONBOARDING.md not found"
    ;;
  enterprise)
    echo "🏢 Adding enterprise standards..."
    cp 24-SECURITY_COMPLIANCE.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  24-SECURITY_COMPLIANCE.md not found"
    cp 07-GOVERNANCE.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  07-GOVERNANCE.md not found"
    cp -r templates/tier-enterprise "$INSTALL_DIR/templates/" 2>/dev/null || echo "  ⚠️  Enterprise templates not found"
    ;;
esac

# Copy context guidance
echo "📖 Copying context guidance..."
cp 36-CONTEXT_GUIDANCE.md "$INSTALL_DIR/" 2>/dev/null || echo "  ⚠️  36-CONTEXT_GUIDANCE.md not found"

# Copy templates
echo "📝 Copying templates..."
mkdir -p "$INSTALL_DIR/templates"
cp -r templates/tier-1-system "$INSTALL_DIR/templates/" 2>/dev/null || echo "  ⚠️  Templates not found"

# Copy scripts
echo "🔧 Copying validation scripts..."
mkdir -p "$INSTALL_DIR/scripts"
cp scripts/validate-frontmatter.sh "$INSTALL_DIR/scripts/" 2>/dev/null || echo "  ⚠️  Scripts not found"
cp scripts/check-freshness.sh "$INSTALL_DIR/scripts/" 2>/dev/null || echo "  ⚠️  Scripts not found"

# Create README
cat > "$INSTALL_DIR/README.md" << EOF
# Documentation Standards

This directory contains documentation standards customized for your context.

## Quick Start

1. Read [36-CONTEXT_GUIDANCE.md](./36-CONTEXT_GUIDANCE.md)
2. Review core standards (01, 03, 05)
3. Use templates from \`templates/\` directory
4. Run validation: \`bash scripts/validate-frontmatter.sh .\`

## Your Configuration

- **Context:** $CONTEXT
- **Team Size:** $TEAM_SIZE
- **Tech Stack:** $TECH_STACK

## Next Steps

See [00-ADOPTION_PLAYBOOK.md](../00-ADOPTION_PLAYBOOK.md) for detailed adoption guide.
EOF

echo ""
echo "✅ Quick start package generated in: $INSTALL_DIR"
echo ""
echo "Next steps:"
echo "1. Review the standards in $INSTALL_DIR"
echo "2. Customize templates for your organization"
echo "3. Start with your first document using a template"
echo "4. Set up CI validation (see templates/ci-cd/)"
echo ""
