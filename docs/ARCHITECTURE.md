# Architecture

This document describes the architecture and design decisions of this NixOS configuration.

## Overview

This is a modular, multi-host NixOS configuration using flakes and proper NixOS module patterns. It manages two machines with shared and host-specific configurations.

## Module System

This configuration uses a proper modular architecture where all features are implemented as NixOS modules with options that can be enabled/disabled.

### Module Structure

```
modules/
├── desktop/          # Desktop environment modules
│   ├── gaming.nix    # Gaming support (Steam, GameMode, etc.)
│   ├── hyprland.nix  # Hyprland Wayland compositor
│   └── kde.nix       # KDE Plasma 6 desktop
├── development/      # Development tool modules
│   ├── general.nix   # General dev tools (.NET, JetBrains, etc.)
│   ├── embedded.nix  # Embedded development (PlatformIO, ESP, etc.)
│   └── mobile.nix    # Mobile development (Android SDK, React Native)
└── shared/           # Core system modules
    ├── base.nix      # Base system configuration
    ├── networking.nix # Network configuration
    ├── users.nix     # User account management
    ├── docker.nix    # Docker and Azurite
    ├── virtualisation.nix # KVM support
    └── surface-specific.nix # Surface hardware support
```

### Enabling Features

All modules follow the options pattern. To enable a feature:

```nix
{
  modules.desktop.gaming.enable = true;
  modules.development.mobile.enable = true;
  modules.services.docker.enable = true;
  modules.services.docker.azurite.enable = true;
}
```

### Module Options

Each module exposes options under `modules.*`:

- `modules.desktop.gaming.enable` - Gaming support
- `modules.desktop.hyprland.enable` - Hyprland compositor
- `modules.desktop.kde.enable` - KDE Plasma 6
- `modules.development.general.enable` - General development tools
- `modules.development.embedded.enable` - Embedded development
- `modules.development.mobile.enable` - Mobile development
- `modules.services.docker.enable` - Docker runtime
- `modules.services.docker.azurite.*` - Azurite configuration
- `modules.virtualisation.enable` - KVM support
- `modules.virtualisation.kvmType` - "intel" or "amd"
- `modules.networking.developmentPorts.enable` - Open dev ports
- `modules.hardware.surface.enable` - Surface-specific hardware
- `modules.users.kotoxik.enable` - User account
- `modules.users.kotoxik.extraGroups` - User groups

## Home Manager Integration

Home Manager is configured per-host with shared common modules.

### Home Directory Structure

```
home/
├── default.nix       # Main home-manager entry point
├── kotoxik/          # User-specific entry point
│   └── default.nix   # Imports common, desktop, and host-specific configs
├── common/           # Shared across all hosts
│   ├── default.nix
│   ├── shell.nix     # Bash, direnv, fzf
│   ├── git.nix       # Git configuration
│   ├── programs.nix  # Common user packages
│   └── development.nix # VSCode, btop
├── desktop/          # Desktop environment configs
│   ├── default.nix
│   ├── kitty.nix     # Terminal emulator
│   ├── gtk.nix       # GTK/Qt theming
│   ├── hyprland.nix  # Hyprland user config
│   └── waybar.nix    # Waybar configuration
└── hosts/            # Host-specific home configs
    ├── lenovo-legion.nix  # Gaming-specific user config
    └── surface-pro.nix    # Portable-specific user config
```

### Host-Aware Configuration

The home configuration uses conditional imports based on hostname:

```nix
{ hostName, ... }:
{
  imports = [
    ../common
    ../desktop
  ] ++ lib.optionals (hostName == "lenovo-legion") [
    ../hosts/lenovo-legion.nix
  ] ++ lib.optionals (hostName == "surface-pro") [
    ../hosts/surface-pro.nix
  ];
}
```

The hostname is passed via `extraSpecialArgs` in `home/default.nix`:

```nix
{
  home-manager.extraSpecialArgs = {
    inherit (config.networking) hostName;
  };
}
```

## Data Flow

1. **Flake Entry Point** (`flake.nix`)
   - Defines inputs (nixpkgs, home-manager, etc.)
   - Exports configurations for each host
   - Provides formatter and devShells

2. **Host Configuration** (`hosts/<hostname>/default.nix`)
   - Imports all required modules
   - Applies overlays
   - Enables specific modules via options
   - Sets host-specific options

3. **Module Evaluation**
   - Each module checks if it's enabled
   - Only enabled modules apply their configuration
   - Modules can depend on options from other modules

4. **Home Manager Evaluation**
   - Receives hostname from system config
   - Loads common configurations
   - Conditionally loads host-specific configs
   - Applies user-level settings

## Directory Layout

```
nixos-config/
├── flake.nix              # Main flake entry point
├── flake.lock             # Locked input versions
├── hosts/                 # Host-specific configurations
│   ├── lenovo-legion/
│   │   ├── default.nix    # Module imports and options
│   │   ├── configuration.nix # Host-specific settings
│   │   └── hardware-configuration.nix
│   └── surface-pro/
│       ├── default.nix
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/               # Feature modules
│   ├── desktop/
│   ├── development/
│   └── shared/
├── home/                  # Home Manager configurations
│   ├── default.nix
│   ├── kotoxik/
│   ├── common/
│   ├── desktop/
│   └── hosts/
├── packages/              # Custom package definitions
├── overlays/              # Package overlays
├── lib/                   # Helper functions
├── scripts/               # Deployment scripts
├── secrets/               # SOPS secrets
└── docs/                  # Documentation
```

## Overlays

Custom packages are defined in `overlays/default.nix`:

```nix
final: prev: {
  azureFunctionsCli = prev.callPackage ../packages/azure-functions-cli-bin.nix { };
  platformioFHS = prev.callPackage ../packages/platformio-fhs.nix { };
  androidSdkCustom = prev.callPackage ../packages/android-sdk.nix { };
}
```

## Secrets Management

Secrets are managed using SOPS-nix:

- Secrets are encrypted with age
- Encrypted files are stored in `secrets/`
- Age key is generated automatically on first boot
- User age directory is created via Home Manager

## Design Principles

1. **Modularity** - Each feature is a self-contained module
2. **Explicit Enabling** - Features must be explicitly enabled
3. **DRY** - No duplication between hosts
4. **Type Safety** - Use proper NixOS options with types
5. **Documentation** - Each module should be self-documenting
6. **Host Awareness** - Home Manager adapts to the host

## Development Workflow

1. **Local Testing**: `make test` or `sudo nixos-rebuild test --flake .`
2. **Apply Changes**: `make switch` or `sudo nixos-rebuild switch --flake .`
3. **Format Code**: `make fmt` or `nix fmt`
4. **Update Inputs**: `make update` or `nix flake update`
5. **Validate**: `make check` or `nix flake check`

## Remote Deployment

Scripts in `scripts/` handle remote deployment:

- `update-all.sh` - Update both machines
- `update-surface.sh` - Update Surface Pro only
- `update-lenovo.sh` - Update Lenovo Legion only

These scripts use SSH to build and activate configurations remotely.
