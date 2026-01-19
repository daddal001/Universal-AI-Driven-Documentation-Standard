---
title: "Example: Getting Started Guide"
type: "example"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
context: "onboarding"
---

# Getting Started with TaskFlow

Welcome to TaskFlow! This guide will get you up and running in about 15 minutes.

**Time Estimate:** ~15 minutes
**Prerequisites:** Node.js 18+, Docker Desktop

---

## What You'll Build

By the end of this guide, you'll have:

```bash

  -H "Content-Type: application/json" \
  | jq -r '.token')

  -H "Authorization: Bearer $TOKEN" \

    "title": "My first API task",

  }'

**Expected Response:**
  "data": {
    "title": "My first API task",
    "created_at": "2025-12-15T10:00:00Z"
```

## Step 4: Make Your First Change (5 minutes)

### Find the Code

```bash
frontend/src/components/Header.tsx
### Make the Change

// Add task count display
const taskCount = tasks.length;
    <h1>TaskFlow</h1>
  </header>
```

1. Save the file
2. Check browser — task count appears in header!

- [Architecture Overview](./docs/ARCHITECTURE.md) — Understand the system
- [API Documentation](./docs/API.md) — Complete API reference
- [Development Guide](./docs/DEVELOPMENT.md) — Development workflow

- [Database Migrations](./docs/MIGRATIONS.md) — Working with the database
- [Deployment](./docs/DEPLOYMENT.md) — Deploying to staging/production

### Get Help

- **Stuck?** Check [Troubleshooting Guide](./docs/TROUBLESHOOTING.md)
- **Bugs?** Open an issue on GitHub

---

```bash

```

✓ Docker running
✓ Database connected

**Error:** `Port 3000 is already in use`
**Solution:**

```bash
lsof -i :3000

**Error:** `Cannot connect to database`
**Solution:**

docker-compose restart postgres

### Dependencies Installation Failed

**Solution:**

```bash
# Clear cache and retry


- ✅ You have TaskFlow running locally
- ✅ You've made your first code change


- Includes verification steps

- Shows both UI and API examples
