---
title: "Contributing to [Project Name]"
type: "guide"
status: "draft"
classification: "public"
owner: "@maintainers"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
---

# Contributing to [Project Name]

Thank you for your interest in contributing! This guide will help you get started.

---

## Code of Conduct

This project adheres to our [Code of Conduct](./CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

---

## How to Contribute

### Reporting Bugs

**Before reporting:**

- Search existing issues to avoid duplicates
- Check the FAQ or troubleshooting guide
- Verify you're using the latest version

**When reporting:**

1. Use the bug report template
2. Include steps to reproduce
3. Describe expected vs actual behavior
4. Add relevant logs or screenshots

### Suggesting Features

- Open an issue with the "feature request" label
- Describe the problem you're trying to solve
- Explain your proposed solution
- Consider alternatives you've explored

### Submitting Code

1. **Fork** the repository
2. **Create a branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes** with clear commit messages
4. **Test thoroughly** before submitting
5. **Open a Pull Request** with a clear description

---

## Development Setup

```bash
# Clone your fork
git clone https://github.com/[your-username]/[project].git
cd [project]

# Install dependencies
npm install  # or pip install -r requirements.txt

# Run tests
npm test     # or pytest

# Start development server
npm run dev  # or python app.py
```

---

## Code Standards

### Style Guidelines

- Follow existing code style
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
feat: add user authentication
fix: resolve login timeout issue
docs: update API documentation
test: add unit tests for auth module
```

### Pull Request Guidelines

- Link related issues
- Include test coverage
- Update documentation if needed
- Request review from maintainers

---

## Review Process

1. **Automated checks** must pass (CI/CD)
2. **Code review** by at least one maintainer
3. **Approval** before merge
4. **Squash merge** to keep history clean

---

## Getting Help

- 💬 [Discussions](https://github.com/[username]/[project]/discussions) — Questions and ideas
- 🐛 [Issues](https://github.com/[username]/[project]/issues) — Bug reports
- 📧 Email — [maintainer@example.com]

---

## Recognition

Contributors are recognized in:

- [CONTRIBUTORS.md](./CONTRIBUTORS.md)
- Release notes
- Project README

Thank you for contributing! 🎉
