# Repository Guidelines

## Project Structure & Module Organization
We keep the root compact: `README.md` frames the n8n-in-Codespaces goal, `Dockerfile` (to be added) defines the container, and `scripts/` stores helper shell entrypoints such as `bootstrap.sh` or `healthcheck.sh`. Environment presets belong in `config/.env.example` so we can copy them into real `.env` files without risking secrets. Tests should live in `tests/` and focus on container smoke checks (port reachability, HTTPS redirects) rather than n8n internals, because this repo’s contract stops at provisioning.

## Build, Test, and Development Commands
Use Docker directly to stay aligned with the project charter:
```
docker pull n8nio/n8n:latest                     # sync with the upstream image
./scripts/bootstrap.sh                            # export Codespace env vars and run docker run
./scripts/healthcheck.sh http://localhost:5678    # curl the UI endpoint to confirm readiness
```
Keep `bootstrap.sh` idempotent so rebuilding a Codespace resets the container without manual cleanup.

## Coding Style & Naming Conventions
Shell scripts should start with `#!/usr/bin/env bash`, `set -euo pipefail`, and two-space indentation. Favor descriptive filenames (`scripts/expose-port.sh`) over numbered steps. Comments follow our agent narrative style: explain why a command exists, what it does, and how it behaves so future teammates can extend it without guesswork. For configuration, uppercase snake case (`N8N_HOST`) mirrors n8n’s env variable map.

## Testing Guidelines
Treat every change as infrastructure: run `./scripts/healthcheck.sh` after edits and capture the output in PR discussions. When adding logic-heavy scripts, write minimal Bats tests in `tests/` (name files `test_<topic>.bats`) to ensure flags, retries, and exit codes behave. Aim for coverage of failure paths such as missing Codespace URLs or blocked ports, since those are the most common regressions here.

## Commit & Pull Request Guidelines
Recent history (`init: readme`) shows a `type: summary` convention; continue with verbs like `feat: add docker bootstrap` or `fix: guard missing env`. Keep commits scoped to one concern and include before/after notes if behavior changes. PRs must outline the scenario, list commands run (build, healthcheck, optional Bats suite), and link any GitHub issue or Codespace ticket so teammates can trace intent quickly.

## Security & Configuration Tips
Never commit raw `.env` files; rely on `.env.example` placeholders and document required keys in the README. When sharing Codespace URLs, scrub tokens before posting. If we experiment with volumes, prefer ephemeral paths (`/tmp/n8n-data`) to avoid leaking credentials between sessions.
