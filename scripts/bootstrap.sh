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
CADDY_CONTAINER="${N8N_CADDY_CONTAINER_NAME:-n8n-caddy}"
CADDY_IMAGE="${N8N_CADDY_IMAGE:-caddy:2-alpine}"
CADDY_CONFIG="${N8N_CADDY_CONFIG:-config/Caddyfile}"
DOCKER_NETWORK="${N8N_DOCKER_NETWORK:-n8n_proxy}"
PUBLIC_LISTEN="${N8N_PUBLIC_LISTEN:-:${PORT}}"

# We infer the public hostname inside Codespaces when teammates have not provided one explicitly.
if [[ -n "${N8N_HOST:-}" ]]; then
  HOSTNAME="$N8N_HOST"
elif [[ -n "${CODESPACE_NAME:-}" && -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]]; then
  HOSTNAME="${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
else
  HOSTNAME="localhost"
fi

# We align the public editor URL with the Codespace hostname so push connections honor the tightened origin checks introduced in n8n 1.87.
PROTOCOL="${N8N_PROTOCOL:-https}"
EDITOR_URL="${N8N_EDITOR_BASE_URL:-${PROTOCOL}://${HOSTNAME}}"
WEBHOOK_BASE="${WEBHOOK_URL:-${PROTOCOL}://${HOSTNAME}/}"
N8N_UPSTREAM="http://${CONTAINER_NAME}:5678"

log() {
  printf '[n8n bootstrap] %s\n' "$1"
}

# We verify Docker is reachable before doing anything destructive so failures surface early with actionable context.
if ! command -v docker >/dev/null 2>&1; then
  log "Docker CLI is missing. Please install Docker or use a Codespace with Docker enabled."
  exit 1
fi

log "Pulling image ${IMAGE} so we track upstream security patches automatically (Docker shows progress below)."
docker pull "$IMAGE"

# We provision the persistent volume once so workflow data survives container restarts within the Codespace.
if ! docker volume ls --format '{{.Name}}' | grep -q "^${DATA_VOLUME}$"; then
  log "Creating Docker volume ${DATA_VOLUME} to store /home/node/.n8n state."
  docker volume create "$DATA_VOLUME" >/dev/null
fi

# We stand up a dedicated Docker network so the Caddy proxy can forward traffic to n8n without exposing extra host ports.
if ! docker network ls --format '{{.Name}}' | grep -q "^${DOCKER_NETWORK}$"; then
  log "Creating Docker network ${DOCKER_NETWORK} so Caddy and n8n communicate privately."
  docker network create "$DOCKER_NETWORK" >/dev/null
fi

# We stop and remove any prior container to guarantee a clean state, acknowledging that Codespaces are ephemeral anyway.
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  log "Removing previous container ${CONTAINER_NAME} so we can redeploy with fresh settings."
  docker rm -f "$CONTAINER_NAME" >/dev/null
fi

if docker ps -a --format '{{.Names}}' | grep -q "^${CADDY_CONTAINER}$"; then
  log "Removing previous proxy container ${CADDY_CONTAINER} to avoid stale configs."
  docker rm -f "$CADDY_CONTAINER" >/dev/null
fi

log "Starting n8n container on network ${DOCKER_NETWORK} so Caddy can front it."
docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  --network "$DOCKER_NETWORK" \
  -v "${DATA_VOLUME}:/home/node/.n8n" \
  -e N8N_HOST="$HOSTNAME" \
  -e N8N_PORT="5678" \
  -e N8N_PROTOCOL="$PROTOCOL" \
  -e N8N_EDITOR_BASE_URL="$EDITOR_URL" \
  -e GENERIC_TIMEZONE="$TIMEZONE" \
  -e TZ="$TIMEZONE" \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS="$ENFORCE_PERMS" \
  -e N8N_RUNNERS_ENABLED="$RUNNERS_ENABLED" \
  -e WEBHOOK_URL="$WEBHOOK_BASE" \
  "$IMAGE"

if [[ ! -f "$CADDY_CONFIG" ]]; then
  log "Caddy config ${CADDY_CONFIG} is missing. Please copy config/Caddyfile before running the proxy."
  exit 1
fi

CADDY_CONFIG_ABS="$(cd "$(dirname "$CADDY_CONFIG")" && pwd)/$(basename "$CADDY_CONFIG")"

log "Starting Caddy reverse proxy on port ${PORT} so we can normalize Origin headers before traffic reaches n8n."
docker run -d \
  --name "$CADDY_CONTAINER" \
  --restart unless-stopped \
  --network "$DOCKER_NETWORK" \
  -p "${PORT}:5678" \
  -v "${CADDY_CONFIG_ABS}:/etc/caddy/Caddyfile:ro" \
  -e N8N_UPSTREAM="$N8N_UPSTREAM" \
  -e N8N_PUBLIC_LISTEN="$PUBLIC_LISTEN" \
  "$CADDY_IMAGE"

log "n8n is launching behind Caddy. Use scripts/healthcheck.sh to confirm the proxy endpoint is reachable."
log "Visit https://${HOSTNAME} to open the n8n UI from this Codespace."
