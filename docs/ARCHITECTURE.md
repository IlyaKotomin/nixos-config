# System Architecture

This document explains the architectural design of this NixOS configuration, including the module system, build process, and how everything fits together.

## Overview

This is a **modular, multi-host NixOS configuration** built using Nix Flakes. It manages two distinct machines (Lenovo Legion 5 Pro and Surface Pro 7) from a single repository, with shared configuration and host-specific overrides.

### Design Principles

1. **Modularity**: Configuration split into reusable modules
2. **DRY (Don't Repeat Yourself)**: Shared configuration with host-specific overrides
3. **Maintainability**: Clear structure, well-documented, easy to understand
4. **Flexibility**: Easy to add new hosts or modules
5. **Type Safety**: Leverage Nix's type system for configuration validation

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         flake.nix                            │
│  (Entry point, inputs, outputs, system configurations)      │
└───────────────────┬─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
┌───────────────┐       ┌───────────────┐
│ lenovo-legion │       │  surface-pro  │
│ configuration │       │ configuration │
└───────┬───────┘       └───────┬───────┘
        │                       │
        │     Common Modules    │
        └───────────┬───────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌──────────┐
    │ Shared │  │Desktop │  │Development│
    │Modules │  │Modules │  │  Modules  │
    └────────┘  └────────┘  └──────────┘
        │           │           │
        └───────────┴───────────┘
                    │
            ┌───────┴────────┐
            │                │
            ▼                ▼
    ┌──────────────┐  ┌─────────────┐
    │ Home Manager │  │   Secrets   │
    │ (per-user)   │  │  (sops-nix) │
    └──────────────┘  └─────────────┘
```

## Directory Structure Explained

### Root Level
```
nixos-config/
├── flake.nix              # Main entry point, defines system configurations
├── flake.lock             # Locked versions of all dependencies
├── .editorconfig          # Editor configuration for consistency
└── .sops.yaml             # Secrets management configuration
```

### Hosts (`/hosts`)
Host-specific configurations for each machine:

```
hosts/
├── lenovo-legion/
│   ├── configuration.nix         # Host-specific settings (hostname, etc.)
│   └── hardware-configuration.nix # Auto-generated hardware config
└── surface-pro/
    ├── configuration.nix
    └── hardware-configuration.nix
```

**Purpose**: Contains configuration unique to each machine that can't be shared.

### Modules (`/modules`)
Reusable configuration modules organized by category:

```
modules/
├── shared/              # Configuration shared across all hosts
│   ├── base.nix         # Base system (boot, locale, packages)
│   ├── networking.nix   # Network configuration
│   ├── users.nix        # User account definitions
│   ├── docker.nix       # Docker and containerization
│   ├── virtualisation.nix # QEMU/KVM virtualization
│   ├── surface-specific.nix # Surface-specific drivers
│   └── secrets/         # Encrypted secrets (sops-nix)
│
├── desktop/             # Desktop environment modules
│   ├── kde.nix          # KDE Plasma 6 configuration
│   ├── hyprland.nix     # Hyprland Wayland compositor
│   └── gaming.nix       # Gaming tools (Steam, GameMode, etc.)
│
└── development/         # Development environment modules
    ├── general.nix      # Common dev tools (IDEs, SDKs)
    ├── mobile.nix       # Android/React Native development
    └── embedded.nix     # PlatformIO/embedded development
```

**Purpose**: Modular features that can be mixed and matched per host.

### Home Manager (`/home`)
User-specific configuration using Home Manager:

```
home/
├── default.nix          # Home Manager integration setup
└── kotoxik/             # Per-user configuration
    ├── default.nix      # User profile entry point
    ├── programs.nix     # User applications
    ├── development.nix  # User dev tools (VSCode, etc.)
    ├── desktop.nix      # Desktop applications
    ├── hyprland.nix     # Hyprland user config
    ├── git.nix          # Git configuration
    └── shell.nix        # Shell configuration (aliases, etc.)
```

**Purpose**: User-level configuration (dotfiles, user packages, application settings).

### Packages (`/packages`)
Custom package definitions:

```
packages/
├── android-sdk.nix            # Custom Android SDK
├── azure-functions-cli-bin.nix # Azure Functions CLI
└── platformio-fhs.nix         # PlatformIO in FHS environment
```

**Purpose**: Custom packages not available in nixpkgs or needing special configuration.

### Scripts (`/scripts`)
Deployment and maintenance scripts:

```
scripts/
├── update-all.sh       # Update all machines
├── update-surface.sh   # Update Surface Pro remotely
└── update-lenovo.sh    # Update Lenovo Legion remotely
```

**Purpose**: Automation scripts for deployment and maintenance.

## Module System Design

### How Modules Work

NixOS uses a **module system** where each module can:
1. **Import other modules** - Compose functionality
2. **Define options** - Declare configuration options
3. **Set configuration** - Provide values for options

### Module Pattern

A typical module follows this pattern:

```nix
{ config, lib, pkgs, ... }:

{
  # Import other modules if needed
  imports = [ ./other-module.nix ];
  
  # Define new options (optional)
  options = {
    # Define custom options here
  };
  
  # Set configuration
  config = {
    # Configuration goes here
  };
}
```

### Module Loading Order

1. **flake.nix** loads core inputs (nixpkgs, home-manager, etc.)
2. **Common modules** loaded for all hosts
3. **Host-specific modules** loaded per host
4. **Module system merges** all configuration
5. **Home Manager** loads user-specific config

## Home Manager Integration

### System vs User Packages

**System Packages** (`environment.systemPackages`):
- Installed system-wide
- Available to all users
- Requires sudo to update
- Used for: System utilities, core tools, IDEs

**User Packages** (`home.packages`):
- Installed per-user
- Managed by Home Manager
- Can be updated without sudo
- Used for: User applications, CLI tools, development tools

### Integration Method

We use the **NixOS module integration** method:

```nix
# In flake.nix
home-manager.nixosModules.home-manager

# In common modules
./home  # Home Manager configuration
```

This integrates Home Manager directly into the NixOS system configuration, ensuring:
- Single activation (no separate home-manager command)
- Consistent package versions between system and user
- Atomic updates of both system and user configuration

## Build and Deployment Process

### Local Build & Activation

```bash
# Build and activate on current machine
sudo nixos-rebuild switch --flake .#lenovo-legion
```

**Process**:
1. Evaluates flake.nix and all modules
2. Builds system configuration
3. Builds home-manager configuration
4. Switches to new configuration
5. Activates services and updates bootloader

### Remote Build & Deployment

```bash
# Build locally, deploy remotely
nixos-rebuild switch --flake .#surface-pro \
  --target-host kotoxik@surface-pro \
  --use-remote-sudo
```

**Process**:
1. Builds configuration on local (fast) machine
2. Copies derivation to remote machine via SSH
3. Activates on remote machine
4. Updates remote bootloader

**Benefits**:
- Faster builds on powerful machine (Lenovo Legion)
- Deploy to slower devices (Surface Pro) efficiently
- Single command deployment

## Secrets Management (sops-nix)

### How It Works

1. **Secrets are encrypted** using age/GPG keys
2. **Stored in repository** (safe because encrypted)
3. **Decrypted at activation** time by sops-nix
4. **Mounted as files** in `/run/secrets/`

### Secret Definition

```nix
# In modules/shared/secrets/
sops.secrets."example-secret" = {
  sopsFile = ./secrets.yaml;
  owner = "kotoxik";
  group = "users";
  mode = "0400";
};
```

### Access Control

- Each machine has its own age key
- Secrets encrypted for specific machines
- Only authorized machines can decrypt

## Configuration Flow

### Complete Build Flow

```
1. User runs: nixos-rebuild switch --flake .#host

2. Nix evaluates flake.nix
   ↓
3. Loads nixpkgs and other inputs
   ↓
4. Evaluates common modules
   ↓
5. Evaluates host-specific modules
   ↓
6. Module system merges all configuration
   ↓
7. Builds system derivation
   ↓
8. Builds home-manager derivation
   ↓
9. Activates system configuration
   ↓
10. Activates home-manager configuration
   ↓
11. Updates bootloader
   ↓
12. System ready with new configuration
```

## Extending the Configuration

### Adding a New Host

1. Create `hosts/new-host/configuration.nix`
2. Generate hardware config: `nixos-generate-config`
3. Add configuration in `flake.nix`:

```nix
new-host = nixpkgs.lib.nixosSystem {
  inherit system;
  modules = commonModules ++ [
    ./hosts/new-host/hardware-configuration.nix
    ./hosts/new-host/configuration.nix
    # Add desired feature modules
  ];
};
```

### Adding a New Module

1. Create module file: `modules/category/new-feature.nix`
2. Write module configuration
3. Import in host configuration (flake.nix)

Example module:

```nix
{ config, lib, pkgs, ... }:

{
  # Enable feature
  programs.new-feature.enable = true;
  
  # Install packages
  environment.systemPackages = with pkgs; [
    feature-package
  ];
  
  # Configure services
  services.new-feature = {
    enable = true;
    settings = {
      # ...
    };
  };
}
```

### Adding a New User

1. Create user directory: `home/newuser/`
2. Create `home/newuser/default.nix`
3. Add user in `modules/shared/users.nix`
4. Add home-manager config in `home/default.nix`

## Performance Considerations

### Build Optimization

- **Binary Cache**: Use Cachix or binary cache for pre-built packages
- **Parallel Builds**: Enabled by default in Nix
- **Remote Building**: Build on fast machine, deploy to slow

### Storage Optimization

- **Garbage Collection**: Automatic (weekly, 30-day retention)
- **Store Optimization**: Auto-optimization enabled
- **Shared Dependencies**: Nix store deduplicates packages

### Deployment Speed

- **Local**: ~2-5 minutes (depends on changes)
- **Remote**: +1-2 minutes (network transfer)
- **Incremental**: Only changed parts are rebuilt

## Best Practices

### Module Organization

1. **Keep modules focused**: One feature per module
2. **Use semantic names**: Clear, descriptive filenames
3. **Document complex parts**: Add comments for non-obvious config
4. **Group related modules**: Use subdirectories

### Configuration Management

1. **Test before deploying**: Use `nixos-rebuild test` first
2. **Commit often**: Version control is your friend
3. **Document changes**: Good commit messages
4. **Keep secrets secure**: Never commit unencrypted secrets

### Debugging

```bash
# Dry-run build (no activation)
nixos-rebuild dry-build --flake .#host

# Show configuration changes
nixos-rebuild dry-activate --flake .#host

# Verbose output
nixos-rebuild switch --flake .#host --show-trace
```

## Resources

### Official Documentation
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Language](https://nixos.org/manual/nix/stable/language/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Flakes](https://nixos.wiki/wiki/Flakes)

### Community Resources
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)

### This Configuration
- [Code Style Guide](./CODE-STYLE.md)
- [Hardware Notes](./HARDWARE-NOTES.md)
- [Troubleshooting](./TROUBLESHOOTING.md)
