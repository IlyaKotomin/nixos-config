#!/usr/bin/env bash
# Update only Surface Pro from Lenovo Legion
# Usage: ./update-surface.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SURFACE_HOST="kotoxik@surface-pro.local"  # Update with your Surface's hostname/IP
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${GREEN}=== Surface Pro Update Script ===${NC}"
echo "Configuration directory: $CONFIG_DIR"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

print_error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ERROR:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] WARNING:${NC} $1"
}

cd "$CONFIG_DIR"

# Export experimental features for all nix commands
export NIX_CONFIG="experimental-features = nix-command flakes"

# Check if Surface Pro is reachable
print_status "Checking connectivity to Surface Pro..."
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$SURFACE_HOST" exit 2>/dev/null; then
    print_error "Cannot connect to Surface Pro at $SURFACE_HOST"
    print_warning "Make sure:"
    print_warning "  1. Surface Pro is powered on and connected to network"
    print_warning "  2. SSH is enabled on Surface Pro"
    print_warning "  3. SSH keys are set up (no password prompt)"
    print_warning "  4. Hostname/IP is correct in this script"
    exit 1
fi

print_status "Surface Pro is reachable, proceeding with update..."

# Update flake inputs
print_status "Updating flake inputs..."
nix flake update

# Build Surface Pro configuration on local machine (faster than on Surface)
print_status "Building Surface Pro configuration locally..."
nixos-rebuild build --flake .#surface-pro

if [ $? -ne 0 ]; then
    print_error "Failed to build Surface Pro configuration"
    exit 1
fi

# Deploy to Surface Pro
print_status "Deploying to Surface Pro..."
nixos-rebuild switch --flake .#surface-pro \
    --target-host "$SURFACE_HOST" \
    --build-host localhost \
    --use-remote-sudo

if [ $? -eq 0 ]; then
    print_status "${GREEN}Surface Pro updated successfully!${NC}"
else
    print_error "Failed to update Surface Pro"
    exit 1
fi
