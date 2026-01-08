.PHONY: switch test update fmt check help

# Default target
help:
	@echo "Available targets:"
	@echo "  make switch     - Rebuild and switch to new configuration"
	@echo "  make test       - Build and test configuration (don't activate)"
	@echo "  make update     - Update flake inputs"
	@echo "  make fmt        - Format Nix files"
	@echo "  make check      - Check flake"

# Rebuild and switch
switch:
	sudo nixos-rebuild switch --flake .

# Build and test (don't switch)
test:
	sudo nixos-rebuild test --flake .

# Update flake inputs
update:
	nix flake update

# Format Nix files
fmt:
	nix fmt

# Check flake
check:
	nix flake check
