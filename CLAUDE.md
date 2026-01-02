# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Build Your Jarvis**, a workshop repository that teaches participants how to build a personal AI assistant using n8n, Telegram, Gemini, and Supabase. The workshop is delivered in Italian and uses Docker Compose to run n8n locally with optional Cloudflare Tunnel exposure for webhooks.

The repository serves two purposes:
1. **Workshop infrastructure**: Docker setup, slides, and documentation for participants
2. **Learning materials**: Step-by-step guides showing how to build workflows in n8n

## Architecture

### Core Components

- **n8n (v2.0.2)**: Official Docker image runs as the main automation platform
  - Web UI on port 5678
  - Persists data to `./data/` (SQLite database, credentials, workflows)
  - Configured via environment variables in `.env` and `compose.yml`

- **Cloudflare Tunnel**: Optional HTTPS exposure for webhook integrations
  - Quick Tunnel: `cloudflared tunnel --url http://localhost:5678` (random URL each run)
  - Named Tunnel: Stable hostname requires Cloudflare account setup
  - URL must be set in `N8N_PUBLIC_URL` for correct webhook generation

- **Slidev**: Workshop presentation slides
  - Source in `slides.md`
  - Built to `dist/` for GitHub Pages deployment

### Data Flow

Workshop participants follow this progression:
1. Fork repo → Clone locally
2. Start n8n with `docker compose up -d`
3. Complete onboarding at `http://localhost:5678`
4. Follow step-by-step guides in `docs/` to build workflows
5. Optionally expose via Cloudflare Tunnel for webhook testing

### Important Constraints

- **Pinned image version**: `N8N_IMAGE=docker.n8n.io/n8nio/n8n:2.0.2` ensures workshop consistency
- **Stateful data directory**: `./data/` is gitignored and treated as sensitive (contains credentials)
- **No custom n8n logic**: This repo provides infrastructure only; workflow logic stays in n8n UI
- **Workshop-focused**: Changes should support teaching goals, not production deployment

## Common Commands

### Docker Operations
```bash
# Start n8n (idempotent, preserves ./data)
docker compose up -d

# Check container status
docker compose ps

# View logs (useful for debugging webhook delivery)
docker compose logs -f n8n

# Stop and remove container (data persists in ./data)
docker compose down

# Healthcheck
curl -fsS http://localhost:5678 >/dev/null && echo OK
```

### Cloudflare Tunnel
```bash
# Start quick tunnel (URL changes each run)
cloudflared tunnel --url http://localhost:5678

# After getting URL, update environment and recreate container
cat > .env <<'EOF'
N8N_PUBLIC_URL=https://random.trycloudflare.com
EOF
docker compose up -d --force-recreate
```

### Slidev Operations
```bash
# Install dependencies (first time only)
pnpm install

# Development server with hot reload
pnpm slides:dev

# Build static site to dist/
pnpm slides:build

# Format slides with Prettier
pnpm format:slides
```

## Configuration Details

### Environment Variables (.env)

The `.env` file is committed to the repository (workshop default values):
- `N8N_IMAGE`: Pinned Docker image tag (currently 2.0.2)
- `N8N_PORT`: Host port mapping (default 5678)
- `N8N_TIMEZONE`: Timezone for scheduled workflows (default UTC)
- `N8N_PUBLIC_URL`: Public-facing URL for webhooks (commented out by default)
  - **CRITICAL**: Must NOT include trailing slash
  - Set this after starting Cloudflare Tunnel with the assigned URL

### Docker Compose (compose.yml)

Key environment mappings:
- `N8N_EDITOR_BASE_URL`: Controls UI URLs (uses `N8N_PUBLIC_URL` or localhost)
- `WEBHOOK_URL`: Where third-party services send webhooks (includes trailing slash)
- `GENERIC_TIMEZONE` and `TZ`: Both set to ensure consistent time handling

Volume mount:
- `./data:/home/node/.n8n`: Persists workflows, credentials, and SQLite database

## Development Workflow

### Adding Workshop Content

1. **New step guides**: Create in `docs/step-N-description.md`
   - Follow narrative style from existing `step-1-telegram-echo-bot.md`
   - Explain WHY each action matters, not just WHAT to click
   - Include troubleshooting tips for common issues

2. **Slide updates**: Edit `slides.md`
   - Use Slidev syntax (frontmatter delimited by `---`)
   - Format with `pnpm format:slides` before committing
   - Test locally with `pnpm slides:dev`

3. **Configuration changes**: Update both `.env` and `compose.yml`
   - Keep comments explaining workshop rationale
   - Test idempotency: `docker compose up -d` should work repeatedly

### Testing Changes

No automated test suite exists yet. Manual verification:
1. Start from clean state: `docker compose down && rm -rf data/`
2. Run `docker compose up -d`
3. Wait for "Editor is now accessible" in logs
4. Access UI and complete onboarding
5. Test with Step 1 guide (Telegram echo bot)
6. If using tunnels, verify webhook delivery

### Commit Conventions

Follow the existing pattern from git history:
- `feat: add new workshop step`
- `fix: correct docker healthcheck`
- `docs: update README for tunnel setup`

## Security Considerations

- `./data/` directory is gitignored and contains sensitive credentials
- Never commit actual `N8N_PUBLIC_URL` values with real tunnel hostnames
- Workshop participants use personal API keys (Telegram, Gemini, Supabase)
- `.env` is committed only because it contains workshop defaults, not secrets

## Repository Structure

```
.
├── compose.yml          # Docker Compose configuration with narrative comments
├── .env                 # Workshop defaults (committed, no secrets)
├── slides.md            # Slidev presentation source
├── README.md            # Workshop setup instructions (Italian)
├── AGENTS.md            # Repository guidelines for AI agents
├── docs/
│   └── step-1-telegram-echo-bot.md  # Extended step-by-step guides
├── data/                # n8n persistent data (gitignored, sensitive)
├── dist/                # Built slides for GitHub Pages
└── .github/workflows/
    └── slides-pages.yml # CI for deploying slides
```

## Common Workshop Issues

### "Webhook not receiving events"
- Check `N8N_PUBLIC_URL` is set correctly (no trailing slash)
- Verify Cloudflare Tunnel is still running
- Check n8n logs: `docker compose logs -f n8n`
- Ensure webhook URL in third-party service matches n8n's generated URL

### "Port 5678 already in use"
- Check for other n8n instances: `docker ps`
- Stop conflicting containers: `docker compose down`

### "Workflows disappeared"
- Data is in `./data/` directory
- If directory is empty/corrupted, workflows are lost (no backup)
- Consider backing up `./data/database.sqlite` periodically

### "Cloudflare Tunnel URL changed"
- Quick Tunnels generate new URLs on each restart
- Update `.env` with new `N8N_PUBLIC_URL`
- Recreate container: `docker compose up -d --force-recreate`
- Update webhook URLs in third-party services

## Workshop Learning Path

The repository supports a progressive learning model:
1. **Step 1**: Telegram echo bot (trigger → action pattern)
2. **Future steps**: TODO management, API integration, Gemini AI, Supabase storage

Each step builds on previous concepts, teaching n8n workflow patterns that participants can extend independently after the workshop.
