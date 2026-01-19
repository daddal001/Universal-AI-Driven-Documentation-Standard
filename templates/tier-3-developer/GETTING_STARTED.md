---
title: "Getting Started with [Project Name]"
type: "guide"
status: "approved"
owner: "@team-lead"
classification: "internal"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Getting Started with [Project Name]

Complete setup guide for new developers joining the team. Follow these steps to go from zero to a running development environment in under 30 minutes.

---

## Time Estimate

| Step | Time |
|------|------|
| Prerequisites | 10 min |
| Installation | 10 min |
| Verification | 5 min |
| **Total** | **~25 min** |

---

## Prerequisites

Before you begin, ensure you have:

- [ ] Docker Desktop running
- [ ] VS Code (Recommended)
- [ ] Git installed

---

## Installation

### Option A: Dev Container (Recommended)

1. Open folder in VS Code.
2. Click **Reopen in Container**.
3. Run `make setup` inside the integrated terminal.

### Option B: Local Setup

#### Step 1: Clone the Repository

```bash
git clone https://github.com/org/[repo].git
cd [repo]
```

#### Step 2: Install Dependencies

```bash
npm install
# or
make install
```

### Step 3: Configure Environment

```bash
cp .env.example .env
# Edit .env with your settings
```

Required environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | Database connection | `postgres://localhost:5432/dev` |
| `API_KEY` | API key for [service] | Get from [location] |

### Step 4: Start Dependencies

```bash
docker-compose up -d
```

### Step 5: Run the Application

```bash
npm run dev
# or
make dev
```

You should see:

```
✓ Server running at http://localhost:8080
✓ Database connected
✓ Ready for development
```

---

## Verification

### Health Check

```bash
curl http://localhost:8080/health
# Expected: {"status": "healthy"}
```

### Run Tests

```bash
npm test
# Expected: All tests passing
```

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Port 8080 already in use | `lsof -i :8080` then kill the process |
| Database connection failed | Ensure Docker is running: `docker ps` |
| Missing environment variable | Check `.env` file exists and is complete |

---

## Next Steps

Now that you're set up:

1. [ ] Read the [Architecture Overview](./ARCHITECTURE.md)
2. [ ] Review the Coding Standards
3. [ ] Pick a `good-first-issue` from the issue tracker
4. [ ] Join the team Slack channel: #team-[name]

---

## Getting Help

| Question Type | Where to Ask |
|---------------|--------------|
| Setup issues | #eng-help Slack channel |
| Code questions | Your buddy / team lead |
| Architecture | @tech-lead |
