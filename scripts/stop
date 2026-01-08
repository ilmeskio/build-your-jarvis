#!/usr/bin/env bash
set -euo pipefail

# Stop Cloudflare Tunnel daemon for build-your-jarvis workshop

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${PROJECT_ROOT}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Stopping Cloudflare Tunnel..."
echo

# Check if PID file exists
if [[ ! -f .tunnel/cloudflared.pid ]]; then
  echo "No tunnel is running (PID file not found)"
  exit 0
fi

# Read PID
PID=$(cat .tunnel/cloudflared.pid)

# Check if process is running
if ! kill -0 "${PID}" 2>/dev/null; then
  echo -e "${YELLOW}⚠${NC} Tunnel process not running (stale PID file)"
  rm -f .tunnel/cloudflared.pid
  exit 0
fi

# Send SIGTERM for graceful shutdown
echo "Stopping tunnel (PID: ${PID})..."
kill "${PID}" 2>/dev/null || true

# Wait for graceful shutdown
TIMEOUT=5
ELAPSED=0

while kill -0 "${PID}" 2>/dev/null && [[ ${ELAPSED} -lt ${TIMEOUT} ]]; do
  sleep 1
  ELAPSED=$((ELAPSED + 1))
done

# Force kill if still running
if kill -0 "${PID}" 2>/dev/null; then
  echo "Force killing tunnel..."
  kill -9 "${PID}" 2>/dev/null || true
fi

# Clean up PID file
rm -f .tunnel/cloudflared.pid

echo -e "${GREEN}✓${NC} Tunnel stopped"
echo
echo "To restart the tunnel, run: ./scripts/start-tunnel.sh"
