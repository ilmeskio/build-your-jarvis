# Repository Guidelines

## Project Structure & Module Organization
We keep the root compact: `README.md` frames the n8n-in-Codespaces goal, `scripts/` stores helper shell entrypoints such as `bootstrap.sh` or `healthcheck.sh`, and `config/.env.example` captures override knobs (port, container name, upstream `docker.n8n.io/n8nio/n8n:latest` image, timezone, persistence volume). Tests should live in `tests/` and focus on container smoke checks (port reachability, HTTPS redirects) rather than n8n internals, because this repo’s contract stops at provisioning. We rely entirely on the official image, so the only stateful artifact is the Docker volume that stores `/home/node/.n8n`.

## Build, Test, and Development Commands
Use Docker directly to stay aligned with the project charter:
```
./scripts/bootstrap.sh                            # pull docker.n8n.io/n8nio/n8n, ensure volume, start the container
./scripts/healthcheck.sh http://localhost:5678    # curl the UI endpoint to confirm readiness
docker logs n8n-codespace --follow                # inspect runtime output when debugging
```
Keep `bootstrap.sh` idempotent so rebuilding a Codespace resets the container without manual cleanup, while preserving data inside the `n8n_data` volume.

## Coding Style & Naming Conventions
Shell scripts should start with `#!/usr/bin/env bash`, `set -euo pipefail`, and two-space indentation. Favor descriptive filenames (`scripts/expose-port.sh`) over numbered steps. Comments follow our agent narrative style: explain why a command exists, what it does, and how it behaves so future teammates can extend it without guesswork. For configuration, uppercase snake case (`N8N_HOST`) mirrors n8n’s env variable map.

## Testing Guidelines
Treat every change as infrastructure: run `./scripts/healthcheck.sh` after edits and capture the output in PR discussions. When adding logic-heavy scripts, write minimal Bats tests in `tests/` (name files `test_<topic>.bats`) to ensure flags, retries, and exit codes behave. Aim for coverage of failure paths such as missing Codespace URLs or blocked ports, since those are the most common regressions here.

## Commit & Pull Request Guidelines
Recent history (`init: readme`) shows a `type: summary` convention; continue with verbs like `feat: add docker bootstrap` or `fix: guard missing env`. Keep commits scoped to one concern and include before/after notes if behavior changes. PRs must outline the scenario, list commands run (build, healthcheck, optional Bats suite), and link any GitHub issue or Codespace ticket so teammates can trace intent quickly.

## Security & Configuration Tips
Never commit raw `.env` files; rely on `.env.example` placeholders and document required keys in the README. When sharing Codespace URLs, scrub tokens before posting. If we touch Docker volumes beyond the default `n8n_data`, note persistence expectations so teammates understand whether secrets remain between Codespace restarts.
