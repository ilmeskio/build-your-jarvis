#!/usr/bin/env bash
# We probe the n8n HTTP endpoint so CI and teammates can verify the container is healthy before sharing URLs.
# The check performs lightweight retries with curl, which mirrors how Codespaces preview the service.
# Expect failures to surface quickly with a non-zero exit code so GitHub Actions or devs can react.
set -euo pipefail

TARGET_URL="${1:-http://localhost:5678}"
RETRIES="${HEALTHCHECK_RETRIES:-10}"
SLEEP_SECONDS="${HEALTHCHECK_INTERVAL:-3}"

log() {
  printf '[n8n healthcheck] %s\n' "$1"
}

for attempt in $(seq 1 "$RETRIES"); do
  if curl --fail --silent --show-error "$TARGET_URL" >/dev/null; then
    log "Service responded on attempt ${attempt}."
    exit 0
  fi
  log "Attempt ${attempt} failed; sleeping ${SLEEP_SECONDS}s before retrying."
  sleep "$SLEEP_SECONDS"
done

log "n8n did not respond at ${TARGET_URL} after ${RETRIES} attempts."
exit 1
