# Repository Guidelines

## Project Structure & Module Organization
We keep the root compact: `README.md` frames the workshop goal (run n8n via Docker Compose and optionally expose it via Cloudflare Tunnel), and `.env` captures the workshop defaults (port, pinned `docker.n8n.io/n8nio/n8n:<tag>` image, timezone). Tests should live in `tests/` and focus on container smoke checks (port reachability, HTTPS reachability through a tunnel) rather than n8n internals, because this repo’s contract stops at provisioning. We rely entirely on the official image, so the only stateful artifact is the local `./data` directory that stores `/home/node/.n8n`.

## Build, Test, and Development Commands
Use Docker directly to stay aligned with the project charter:
```
docker compose up -d                              # pull the pinned n8n image and start the container
curl -fsS http://localhost:5678 >/dev/null        # confirm the UI endpoint is reachable
docker compose logs n8n --follow                  # inspect runtime output when debugging
```
Keep `docker compose up -d` idempotent so reruns converge without manual cleanup, while preserving data inside `./data`.

## Coding Style & Naming Conventions
If we add shell scripts in the future, start them with `#!/usr/bin/env bash`, `set -euo pipefail`, and two-space indentation. Favor descriptive filenames over numbered steps. Comments follow our agent narrative style: explain why a command exists, what it does, and how it behaves so future teammates can extend it without guesswork. For configuration, uppercase snake case (`N8N_HOST`) mirrors n8n’s env variable map.

## Testing Guidelines
Treat every change as infrastructure: run a quick curl healthcheck after edits and capture the output in PR discussions. When adding logic-heavy scripts, write minimal Bats tests in `tests/` (name files `test_<topic>.bats`) to ensure flags, retries, and exit codes behave. Aim for coverage of failure paths such as missing `cloudflared` or a blocked port, since those are the most common regressions here.

## Commit & Pull Request Guidelines
Recent history (`init: readme`) shows a `type: summary` convention; continue with verbs like `feat: add docker bootstrap` or `fix: guard missing env`. Keep commits scoped to one concern and include before/after notes if behavior changes. PRs must outline the scenario, list commands run (build, healthcheck, optional Bats suite), and link any GitHub issue so teammates can trace intent quickly.

## Security & Configuration Tips
When sharing public tunnel URLs, avoid posting anything that embeds secrets. Treat `./data` as sensitive because it can contain credentials, and keep it out of git.
