#!/bin/bash
# docs/standards/scripts/generate-ai-rules.sh
# Generates .cursorrules, .github/copilot-instructions.md, and CLAUDE.md
# based on documentation standards.

set -e

PROJ_NAME="${1:-Project}"
PROJ_TYPE="${2:-oss}"

echo "Generating AI Context rules..."

# 1. Generate .cursorrules
cat > .cursorrules <<EOF
# AI Behavior Rules for $PROJ_NAME

You are an expert AI software engineer working on $PROJ_NAME.
You MUST follow these documentation standards for every code change.

## 1. Documentation First
- NEVER change code without checking if documentation needs updates.
- IF you add a new feature, YOU MUST add a corresponding section to the README or a new guide.
- IF you modify an API, YOU MUST update the API reference.
- documentation is NOT optional.

## 2. Documentation Standards
- Tone: Clear, concise, professional.
- Format: Markdown.
- Language: English (US).
- Cross-References: Use relative links, do NOT duplicate content.
- Frontmatter: All markdown files must have YAML frontmatter (title, type, status, owner).

## 3. Project Context
- Project Type: $PROJ_TYPE
- See docs/standards/ for full guidelines.

## 4. Prohibited Actions
- Do NOT invent version numbers. Check package.json/pyproject.toml.
- Do NOT hallucinate config options. Verify in code.
- Do NOT leave "TODO" or "foo/bar" examples in documentation. Use realistic examples.

## 5. File Creation Rules
- When creating a new file, always include a file header comment.
- When creating a markdown file, start with YAML frontmatter.

EOF

echo "  - Created .cursorrules"

# 2. Generate .github/copilot-instructions.md
mkdir -p .github
cat > .github/copilot-instructions.md <<EOF
# GitHub Copilot Instructions for $PROJ_NAME

## Documentation Standards
This project enforces strict documentation standards.

1. **Frontmatter**: All markdown files require YAML frontmatter.
   \`\`\`yaml
   ---
   title: "Doc Title"
   type: "guide"
   status: "draft"
   owner: "@team"
   ---
   \`\`\`

2. **Code Comments**:
   - Python: Google style docstrings.
   - TypeScript: JSDoc for all exported functions.

3. **Validation**:
   - Run \`./scripts/docs/validate-frontmatter.sh docs/\` to check your work.

## Project Structure
- src/: Source code
- docs/: Documentation (Tier 1)
- scripts/docs/: Validation scripts

## Behavior
- When asked to "document this", look for the appropriate template in docs/templates/.
- Prefer updating existing docs over creating new files unless necessary.
EOF

echo "  - Created .github/copilot-instructions.md"

# 3. Generate CLAUDE.md
cat > CLAUDE.md <<EOF
# CLAUDE.md - Master Orchestrator for $PROJ_NAME

## Documentation Standards
This repository adheres to the **Universal Documentation Standard**.
- **Location:** \`docs/standards/\`
- **Validation:** Run \`bash scripts/docs/validate-structure.sh docs/\` before submitting.

## Core Rules
1. **No Code Without Docs:** Every feature must include documentation.
2. **No Hallucinations:** Verify every import, path, and config option.
3. **Use Templates:** Start new documents from \`docs/templates/\`.

## Project Context
- **Name:** $PROJ_NAME
- **Type:** $PROJ_TYPE

## Useful Commands
- Validate Docs: \`bash scripts/docs/validate-frontmatter.sh docs/\`
- Check Freshness: \`bash scripts/docs/check-freshness.sh docs/\`
EOF

echo "  - Created CLAUDE.md"
