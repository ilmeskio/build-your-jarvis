#!/usr/bin/env bash
set -euo pipefail

# Cloudflare Tunnel Automation for build-your-jarvis workshop
# This script automates the entire tunnel setup workflow

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${PROJECT_ROOT}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
  echo -e "${BLUE}Cloudflare Tunnel Setup for build-your-jarvis${NC}"
  echo "=============================================="
  echo
}

print_phase() {
  echo -e "${BLUE}[$1/6] $2${NC}"
}

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗ ERROR:${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠ WARNING:${NC} $1"
}

# Phase 0: Ensure .env exists
ensure_env() {
  if [[ ! -f .env ]]; then
    if [[ ! -f .env.example ]]; then
      print_error ".env.example not found"
      echo "This file should exist in the repository."
      echo "Please check your git clone or pull latest changes."
      exit 1
    fi

    echo "Creating .env from .env.example..."
    cp .env.example .env
    print_success "Created .env from .env.example"
    echo
  fi
}

# Phase 1: Check/download cloudflared binary
check_cloudflared() {
  print_phase 1 "Checking cloudflared binary..."

  if [[ -x "bin/cloudflared" ]]; then
    VERSION=$(./bin/cloudflared --version 2>&1 | head -1 || echo "unknown")
    print_success "cloudflared found at bin/cloudflared ($VERSION)"
    return 0
  fi

  echo "cloudflared not found, downloading..."

  # Detect OS and architecture
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)

  case "${OS}" in
    darwin)
      CLOUDFLARED_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz"
      ;;
    linux)
      if [[ "${ARCH}" == "x86_64" ]]; then
        CLOUDFLARED_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
      elif [[ "${ARCH}" == "aarch64" ]] || [[ "${ARCH}" == "arm64" ]]; then
        CLOUDFLARED_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
      else
        print_error "Unsupported architecture: ${ARCH}"
        echo "Please download cloudflared manually from:"
        echo "https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
        exit 1
      fi
      ;;
    *)
      print_error "Unsupported operating system: ${OS}"
      echo "Please download cloudflared manually from:"
      echo "https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
      exit 1
      ;;
  esac

  # Create bin directory
  mkdir -p bin

  # Download cloudflared
  echo "Downloading from: ${CLOUDFLARED_URL}"
  if [[ "${OS}" == "darwin" ]]; then
    # macOS version comes as .tgz
    if ! curl -fL -o /tmp/cloudflared.tgz "${CLOUDFLARED_URL}"; then
      print_error "Failed to download cloudflared"
      echo "Please download manually from: ${CLOUDFLARED_URL}"
      exit 1
    fi
    tar -xzf /tmp/cloudflared.tgz -C bin/
    rm /tmp/cloudflared.tgz
  else
    # Linux version is a direct binary
    if ! curl -fL -o bin/cloudflared "${CLOUDFLARED_URL}"; then
      print_error "Failed to download cloudflared"
      echo "Please download manually from: ${CLOUDFLARED_URL}"
      exit 1
    fi
  fi

  chmod +x bin/cloudflared

  # Verify the download
  if ! file bin/cloudflared | grep -q "executable"; then
    print_error "Downloaded file is not executable"
    rm -f bin/cloudflared
    exit 1
  fi

  VERSION=$(./bin/cloudflared --version 2>&1 | head -1 || echo "unknown")
  print_success "cloudflared downloaded successfully ($VERSION)"
}

# Phase 2: Start tunnel daemon
start_tunnel() {
  print_phase 2 "Starting tunnel daemon..."

  # Check for existing tunnel
  if [[ -f .tunnel/cloudflared.pid ]]; then
    OLD_PID=$(cat .tunnel/cloudflared.pid)
    if kill -0 "${OLD_PID}" 2>/dev/null; then
      print_warning "Tunnel already running (PID: ${OLD_PID})"
      echo "Stopping existing tunnel..."
      kill "${OLD_PID}" 2>/dev/null || true
      sleep 2
    fi
  fi

  # Create .tunnel directory
  mkdir -p .tunnel

  # Clear old log file
  > .tunnel/cloudflared.log

  # Start tunnel in background
  nohup ./bin/cloudflared tunnel --url http://localhost:5678 > .tunnel/cloudflared.log 2>&1 &
  CLOUDFLARED_PID=$!
  echo "${CLOUDFLARED_PID}" > .tunnel/cloudflared.pid

  # Verify process started
  sleep 1
  if ! kill -0 "${CLOUDFLARED_PID}" 2>/dev/null; then
    print_error "Failed to start cloudflared"
    echo "Check .tunnel/cloudflared.log for details"
    exit 1
  fi

  print_success "Tunnel started (PID: ${CLOUDFLARED_PID})"
}

# Phase 3: Extract tunnel URL
extract_url() {
  print_phase 3 "Extracting tunnel URL..."
  echo "⏳ Waiting for tunnel URL (timeout: 15 seconds)..."

  TIMEOUT=15
  ELAPSED=0
  TUNNEL_URL=""

  while [[ ${ELAPSED} -lt ${TIMEOUT} ]]; do
    # cloudflared prints: "https://random-words-123.trycloudflare.com"
    TUNNEL_URL=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' .tunnel/cloudflared.log 2>/dev/null | head -1 || true)

    if [[ -n "${TUNNEL_URL}" ]]; then
      print_success "Tunnel URL: ${TUNNEL_URL}"
      return 0
    fi

    sleep 1
    ELAPSED=$((ELAPSED + 1))
  done

  print_error "Failed to extract tunnel URL after ${TIMEOUT}s"
  echo "Check .tunnel/cloudflared.log for details:"
  tail -20 .tunnel/cloudflared.log
  exit 1
}

# Phase 4: Update .env file
update_env() {
  print_phase 4 "Updating .env file..."

  if [[ ! -f .env ]]; then
    print_error ".env file not found"
    exit 1
  fi

  # Backup .env
  cp .env .env.backup
  print_success "Created backup: .env.backup"

  # Detect OS for sed compatibility
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  # Update N8N_PUBLIC_URL line
  if grep -q '^N8N_PUBLIC_URL=' .env; then
    # Update existing line
    if [[ "${OS}" == "darwin" ]]; then
      # macOS sed requires empty string after -i
      sed -i '' "s|^N8N_PUBLIC_URL=.*|N8N_PUBLIC_URL=${TUNNEL_URL}|" .env
    else
      # Linux sed
      sed -i "s|^N8N_PUBLIC_URL=.*|N8N_PUBLIC_URL=${TUNNEL_URL}|" .env
    fi
    print_success "Updated .env with N8N_PUBLIC_URL=${TUNNEL_URL}"
  else
    # Append if missing
    echo "N8N_PUBLIC_URL=${TUNNEL_URL}" >> .env
    print_success "Added N8N_PUBLIC_URL=${TUNNEL_URL} to .env"
  fi
}

# Phase 5: Recreate Docker container
recreate_container() {
  print_phase 5 "Recreating Docker container..."

  # Verify Docker is running
  if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running"
    echo "Please start Docker Desktop and try again"
    echo
    echo "Rollback: Restoring .env from backup..."
    mv .env.backup .env
    exit 1
  fi

  # Verify compose.yml exists
  if [[ ! -f compose.yml ]]; then
    print_error "compose.yml not found"
    echo "Run this script from the repository root"
    exit 1
  fi

  # Recreate container
  if ! docker compose up -d --force-recreate; then
    print_error "Failed to recreate container"
    echo
    echo "Rollback: Restoring .env from backup..."
    mv .env.backup .env
    exit 1
  fi

  # Wait for n8n to be ready
  echo "⏳ Waiting for n8n to start..."
  TIMEOUT=30
  ELAPSED=0

  while [[ ${ELAPSED} -lt ${TIMEOUT} ]]; do
    if curl -fsS http://localhost:5678 >/dev/null 2>&1; then
      print_success "n8n is ready!"
      return 0
    fi
    sleep 2
    ELAPSED=$((ELAPSED + 2))
  done

  print_warning "n8n did not respond within ${TIMEOUT}s"
  echo "Check logs: docker compose logs -f n8n"
}

# Phase 6: Verify tunnel accessibility
verify_tunnel() {
  print_phase 6 "Verifying tunnel accessibility..."

  # Wait for cloudflared to establish edge connection
  echo "⏳ Waiting for tunnel edge connection..."
  sleep 3

  # Test tunnel URL
  if curl -fsS --max-time 10 "${TUNNEL_URL}" >/dev/null 2>&1; then
    print_success "SUCCESS! Tunnel is accessible at: ${TUNNEL_URL}"
  else
    print_warning "Tunnel URL responded but may not be fully ready yet"
    echo "Try opening in browser: ${TUNNEL_URL}"
    echo "If it fails, wait 10-20 seconds and retry"
  fi
}

# Main execution
main() {
  print_header

  ensure_env

  check_cloudflared
  echo

  start_tunnel
  echo

  extract_url
  echo

  update_env
  echo

  recreate_container
  echo

  verify_tunnel
  echo

  # Final success message
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}Tunnel setup complete!${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo
  echo "Your n8n instance is now publicly accessible at:"
  echo -e "${BLUE}${TUNNEL_URL}${NC}"
  echo
  echo "Next steps:"
  echo "1. Open n8n in your browser: ${TUNNEL_URL}"
  echo "2. Create your Telegram bot with BotFather"
  echo "3. Configure webhook in n8n using this public URL"
  echo
  echo "Useful commands:"
  echo "  Stop tunnel: ./scripts/stop-tunnel.sh"
  echo "  View logs: tail -f .tunnel/cloudflared.log"
  echo "  n8n logs: docker compose logs -f n8n"
}

# Run main function
main
