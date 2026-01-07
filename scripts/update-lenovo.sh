#!/usr/bin/env bash
# Update only Lenovo Legion laptop
# Usage: ./update-lenovo.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${GREEN}=== Lenovo Legion Update Script ===${NC}"
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

# Update flake inputs
print_status "Updating flake inputs..."
nix flake update

if [ $? -ne 0 ]; then
    print_error "Failed to update flake inputs"
    exit 1
fi

# Build configuration
print_status "Building Lenovo Legion configuration..."
sudo nixos-rebuild build --flake .#lenovo-legion

if [ $? -ne 0 ]; then
    print_error "Failed to build configuration"
    exit 1
fi

# Switch to new configuration
print_status "Switching to new configuration..."
sudo nixos-rebuild switch --flake .#lenovo-legion

if [ $? -eq 0 ]; then
    print_status "${GREEN}Lenovo Legion updated successfully!${NC}"
    echo ""
    print_status "Summary:"
    echo "  ✓ Flake inputs updated"
    echo "  ✓ Configuration built"
    echo "  ✓ System switched to new generation"
    echo ""
    print_status "You may want to reboot to ensure all changes take effect."
else
    print_error "Failed to switch to new configuration"
    print_warning "You can rollback with: sudo nixos-rebuild switch --rollback"
    exit 1
fi
