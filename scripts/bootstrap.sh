#!/usr/bin/env bash
# We orchestrate the n8n container in GitHub Codespaces so every teammate can boot it with one command.
# This script detects the Codespace hostname, injects the correct HTTPS settings, ensures persistent storage, and recreates the container safely.
# We rely on the upstream n8n image hosted at docker.n8n.io, so first runs pull layers once and subsequent runs are instant.
set -euo pipefail

# We load optional overrides from config/.env so teams can pin image tags or tweak container names without editing the script.
if [[ -f config/.env ]]; then
  # We export variables temporarily so docker run inherits them, then disable export to avoid polluting the shell.
  set -a
  # shellcheck disable=SC1091
  source config/.env
  set +a
fi

PORT="${N8N_PORT:-5678}"
IMAGE="${N8N_IMAGE:-docker.n8n.io/n8nio/n8n:latest}"
CONTAINER_NAME="${N8N_CONTAINER_NAME:-n8n-codespace}"
DATA_VOLUME="${N8N_DATA_VOLUME:-n8n_data}"
TIMEZONE="${N8N_TIMEZONE:-UTC}"
ENFORCE_PERMS="${N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS:-true}"
RUNNERS_ENABLED="${N8N_RUNNERS_ENABLED:-true}"

# We infer the public hostname inside Codespaces when teammates have not provided one explicitly.
if [[ -n "${N8N_HOST:-}" ]]; then
  HOSTNAME="$N8N_HOST"
elif [[ -n "${CODESPACE_NAME:-}" && -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]]; then
  HOSTNAME="${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
else
  HOSTNAME="localhost"
fi

log() {
  printf '[n8n bootstrap] %s\n' "$1"
}

# We verify Docker is reachable before doing anything destructive so failures surface early with actionable context.
if ! command -v docker >/dev/null 2>&1; then
  log "Docker CLI is missing. Please install Docker or use a Codespace with Docker enabled."
  exit 1
fi

log "Pulling image ${IMAGE} so we track upstream security patches automatically."
docker pull "$IMAGE" >/dev/null

# We provision the persistent volume once so workflow data survives container restarts within the Codespace.
if ! docker volume ls --format '{{.Name}}' | grep -q "^${DATA_VOLUME}$"; then
  log "Creating Docker volume ${DATA_VOLUME} to store /home/node/.n8n state."
  docker volume create "$DATA_VOLUME" >/dev/null
fi

# We stop and remove any prior container to guarantee a clean state, acknowledging that Codespaces are ephemeral anyway.
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  log "Removing previous container ${CONTAINER_NAME} so we can redeploy with fresh settings."
  docker rm -f "$CONTAINER_NAME" >/dev/null
fi

log "Starting n8n container and binding port ${PORT} for Codespace previews."
docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p "${PORT}:5678" \
  -v "${DATA_VOLUME}:/home/node/.n8n" \
  -e N8N_HOST="$HOSTNAME" \
  -e N8N_PORT="5678" \
  -e N8N_PROTOCOL="${N8N_PROTOCOL:-https}" \
  -e GENERIC_TIMEZONE="$TIMEZONE" \
  -e TZ="$TIMEZONE" \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS="$ENFORCE_PERMS" \
  -e N8N_RUNNERS_ENABLED="$RUNNERS_ENABLED" \
  -e WEBHOOK_URL="https://${HOSTNAME}/" \
  "$IMAGE"

log "n8n is launching. Use scripts/healthcheck.sh to confirm the UI is reachable."
