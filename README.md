# NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-25.11-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.org)
[![Built with Nix](https://img.shields.io/badge/Built_With-Nix-5277C3.svg?logo=nixos&labelColor=73C3D5)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Nix_Flakes-Enabled-green?logo=nixos&logoColor=white)](https://nixos.wiki/wiki/Flakes)

Multi-host NixOS configuration for Lenovo Legion 5 Pro and Microsoft Surface Pro 7, featuring a modular design with proper NixOS module patterns.

## 🚀 Quick Links

- **[📖 Full Documentation](./docs/README.md)** - Complete documentation
- **[🏗️ Architecture](./docs/ARCHITECTURE.md)** - System design and module structure
- **[💻 Hardware Notes](./docs/HARDWARE-NOTES.md)** - Hardware-specific information
- **[⚡ Quick Start](./docs/QUICK-START.md)** - Get started in minutes
- **[🚢 Deployment](./docs/DEPLOYMENT.md)** - Update and maintain systems
- **[🐛 Troubleshooting](./docs/TROUBLESHOOTING.md)** - Fix common issues
- **[📝 Code Style](./docs/CODE-STYLE.md)** - Contribution guidelines

## 📋 Overview

This repository contains a modular, maintainable NixOS configuration using flakes that manages two machines:

| Host | Use Case | Key Features |
|------|----------|--------------|
| **Lenovo Legion 5 Pro** | Gaming & Development | RTX 3070, Gaming, Mobile/Embedded Dev |
| **Surface Pro 7** | Portable Productivity | Touch screen, Lightweight, Battery optimized |

### ✨ Key Features

- ✅ **Modular Architecture** - Proper NixOS module pattern with options
- ✅ **Multi-Host Support** - Single repo, multiple machines
- ✅ **Host-Aware Home Manager** - Config adapts to hostname
- ✅ **Remote Deployment** - Update Surface from Legion via SSH
- ✅ **Hardware-Optimized** - Specific configs for each device
- ✅ **Well-Documented** - Comprehensive guides and architecture docs

## 🏗️ Structure

```
nixos-config/
├── flake.nix              # Main entry point with formatter & devShells
├── hosts/                 # Host-specific configurations
│   ├── lenovo-legion/     # Gaming workstation
│   └── surface-pro/       # Portable device
├── modules/               # Feature modules with options
│   ├── desktop/           # Gaming, KDE, Hyprland
│   ├── development/       # General, Embedded, Mobile
│   └── shared/            # Base, networking, users, docker
├── home/                  # Home Manager (host-aware)
│   ├── common/            # Shared configs (shell, git, dev)
│   ├── desktop/           # Desktop apps (kitty, waybar, hyprland)
│   └── hosts/             # Host-specific user configs
├── packages/              # Custom packages
├── overlays/              # Package overlays
├── lib/                   # Helper functions & colors
├── scripts/               # Deployment automation
└── docs/                  # Documentation
```

## 🎯 Hosts

### Lenovo Legion 5 Pro (16ACH6H)
- **CPU**: AMD Ryzen 7 5800H
- **GPU**: NVIDIA RTX 3070 + AMD iGPU (PRIME offload)
- **Display**: 16" 2560x1600 165Hz
- **Desktop**: KDE Plasma 6 + Hyprland
- **Features**: Gaming, Mobile dev, Embedded dev, Full dev stack

### Microsoft Surface Pro 7
- **CPU**: Intel Core i5/i7 (10th gen)
- **GPU**: Intel Iris Plus
- **Display**: 12.3" 2736x1824 Touchscreen
- **Desktop**: KDE Plasma 6 + Hyprland (touch-enabled)
- **Features**: Portable productivity, Development, Battery-optimized

## 📦 Module System

All features use proper NixOS module patterns and can be enabled/disabled:

```nix
{
  # Desktop
  modules.desktop.gaming.enable = true;
  modules.desktop.kde.enable = true;
  modules.desktop.hyprland.enable = true;
  
  # Development
  modules.development.general.enable = true;
  modules.development.embedded.enable = true;
  modules.development.mobile.enable = true;
  
  # Services
  modules.services.docker.enable = true;
  modules.services.docker.azurite.enable = true;
  
  # System
  modules.virtualisation.enable = true;
  modules.virtualisation.kvmType = "amd"; # or "intel"
  modules.networking.developmentPorts.enable = true;
}
```

See [Architecture Documentation](./docs/ARCHITECTURE.md) for details.

## 🚀 Quick Start

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/IlyaKotomin/nixos-config.git ~/nixos-config
cd ~/nixos-config

# Apply configuration
sudo nixos-rebuild switch --flake .#lenovo-legion
# or
sudo nixos-rebuild switch --flake .#surface-pro
```

### Using the Makefile

```bash
make switch    # Rebuild and activate
make test      # Build but don't activate
make update    # Update flake inputs
make fmt       # Format Nix files
make check     # Check flake validity
```

### Development Shell

```bash
nix develop
# Provides: nil, nixpkgs-fmt, sops, age
```

For detailed instructions, see [Quick Start Guide](./docs/QUICK-START.md).

## 📦 What's Included

### Development Tools
- **.NET**: SDK 8 & 9
- **Node.js**: v22 with npm, yarn, pnpm
- **IDEs**: JetBrains (Rider, WebStorm, DataGrip), VSCode
- **Azure**: Azure CLI, Azurite emulator
- **Database**: PostgreSQL client, DataGrip

### Mobile Development (Lenovo only)
- Android Studio & Android SDK
- React Native / Expo tools
- Emulator support with KVM

### Embedded Development (Lenovo only)
- PlatformIO (FHS environment)
- ESP tools (esptool, esphome)
- OpenOCD, avrdude, stlink
- Serial communication tools

### Desktop Environment
- **KDE Plasma 6** - Primary desktop
- **Hyprland** - Wayland compositor with full CJK & emoji font support
- **Communication**: Vesktop (Discord), Slack, Telegram
- **Media**: Spotify, VLC, qBittorrent

### Gaming (Lenovo only)
- Steam with Proton
- GameMode & Gamescope
- MangoHud & Goverlay
- Lutris

## 🔒 Secrets Management

Secrets are managed with SOPS-nix:
- Encrypted with age
- Automatic key generation on first boot
- See [Secrets Guide](./docs/SECRETS.md)

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Architecture](./docs/ARCHITECTURE.md) | Module system, data flow, design |
| [Hardware Notes](./docs/HARDWARE-NOTES.md) | Hardware specs and troubleshooting |
| [Quick Start](./docs/QUICK-START.md) | Setup instructions |
| [Deployment](./docs/DEPLOYMENT.md) | Update workflows |
| [Code Style](./docs/CODE-STYLE.md) | Contribution guidelines |
| [Troubleshooting](./docs/TROUBLESHOOTING.md) | Common issues |
| [Secrets](./docs/SECRETS.md) | SOPS setup and usage |

## 🤝 Contributing

When modifying this configuration:

1. Follow the [code style guide](./docs/CODE-STYLE.md)
2. Use proper module patterns with options
3. Test changes with `make test` first
4. Format code with `make fmt`
5. Update documentation as needed
6. Keep changes minimal and focused

## 📝 License

Personal configuration, shared for educational purposes.

## 🔗 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://github.com/nix-community/home-manager)
- [NixOS Hardware](https://github.com/NixOS/nixos-hardware)
- [Linux Surface](https://github.com/linux-surface/linux-surface)
- [Nix Pills](https://nixos.org/guides/nix-pills/)

---

**Note**: Actively maintained for specific hardware. Adapt module options as needed for your setup.
