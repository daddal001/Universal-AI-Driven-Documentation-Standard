---
title: "Quick Start for Solo Developers"
type: "getting-started"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Quick Start for Solo Developers

> **Time: 30 seconds** | **Files created: 1** | **No setup required**

## Use This If

- ✅ You have **<5 engineers** (or just yourself)
- ✅ It's a **side project** or hackathon
- ✅ You have **no compliance requirements**
- ✅ You just want a **decent README**

**Not you?** Try [OSS](./QUICK_START_OSS.md) | [Team](./QUICK_START_TEAM.md) | [Enterprise](./QUICK_START_ENTERPRISE.md)

---

You have a side project. You want a decent README. That's it.

## One Command

```bash
bash docs/standards/init.sh --solo
```

**Done.** You now have a `README.md` with:

- Project name (auto-detected)
- Quick start section
- Features placeholder
- Usage example
- License

## What You Get

```
my-project/
└── README.md    # Pre-filled, just edit the placeholders
```

## That's It

No templates. No frontmatter. No CI/CD. No validation scripts.

Just a README.

## Want More Later?

If your project grows:

```bash
# Add contributor docs
bash docs/standards/init.sh --oss

# Add AI assistant support
bash docs/standards/init.sh
```

## Alternative: Just Copy This

Don't want to run a script? Copy our [ready-made README template](./examples/COPY_PASTE_README.md).

---

**Philosophy:** Documentation should help, not slow you down. For side projects, a good README is enough.
