# NixOS Multi-Host Configuration

A modular, maintainable NixOS configuration for managing multiple machines: Lenovo Legion 5 Pro (gaming/development workstation) and Microsoft Surface Pro 7 (portable productivity).

## 📋 Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Features](#features)
- [Quick Start](#quick-start)
- [Deployment](#deployment)
- [Documentation](#documentation)

## 🎯 Overview

This configuration supports two machines with different use cases:

### Lenovo Legion 5 Pro (16ach6h)
- **Purpose**: Primary gaming and development workstation
- **Kernel**: Linux Zen (low latency, gaming optimized)
- **GPU**: NVIDIA RTX 3070 Mobile + AMD iGPU (PRIME offload)
- **Special Features**: 
  - Gaming optimization (Steam, Gamemode, Gamescope)
  - Mobile development (Android, React Native, Expo)
  - Embedded development (PlatformIO, ESP tools)
  - 3D printing tools

### Microsoft Surface Pro 7
- **Purpose**: Portable productivity and development
- **Kernel**: Linux Surface (touchscreen, pen, hardware support)
- **GPU**: Intel integrated graphics
- **Special Features**:
  - Touchscreen and pen support (IPTSD)
  - Power optimization for battery life
  - Portable form factor

### Shared Features (Both Machines)
- KDE Plasma 6 desktop
- Hyprland Wayland compositor
- Docker with Azurite (Azure Storage Emulator)
- Full development stack (.NET, Node.js, Azure tools)
- Communication apps (Vesktop, Slack, Telegram)
- Media (Spotify, qBittorrent)

## 📁 Directory Structure

```
nixos-config/
├── flake.nix                 # Main flake configuration
├── flake.lock                # Locked dependency versions
│
├── hosts/                    # Host-specific configurations
│   ├── lenovo-legion/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── surface-pro/
│       ├── configuration.nix
│       └── hardware-configuration.nix
│
├── modules/                  # Modular feature configurations
│   ├── shared/              # Shared across all hosts
│   │   ├── base.nix         # Base system config
│   │   ├── networking.nix   # Network configuration
│   │   ├── users.nix        # User accounts
│   │   ├── docker.nix       # Docker and Azurite
│   │   ├── virtualisation.nix
│   │   └── surface-specific.nix
│   ├── desktop/             # Desktop environments
│   │   ├── kde.nix          # KDE Plasma 6
│   │   ├── hyprland.nix     # Hyprland compositor
│   │   └── gaming.nix       # Gaming tools and optimization
│   └── development/         # Development environments
│       ├── general.nix      # Common dev tools
│       ├── mobile.nix       # Android/React Native
│       └── embedded.nix     # PlatformIO/embedded
│
├── packages/                # Custom package definitions
│   ├── android-sdk.nix
│   ├── azure-functions-cli-bin.nix
│   └── platformio-fhs.nix
│
├── scripts/                 # Deployment and utility scripts
│   ├── update-all.sh       # Update both machines
│   └── update-surface.sh   # Update Surface only
│
└── docs/                    # Documentation
    ├── README.md           # This file
    ├── QUICK-START.md      # Getting started guide
    ├── DEPLOYMENT.md       # Deployment instructions
    ├── CODE-STYLE.md       # Coding conventions
    └── TROUBLESHOOTING.md  # Common issues and fixes
```

## ✨ Features

### Modular Design
- Reusable modules for easy maintenance
- Host-specific and shared configurations
- Clean separation of concerns

### Multi-Host Support
- Single repository for multiple machines
- Shared configuration with host-specific overrides
- Easy to add new hosts

### Remote Deployment
- Build configurations on powerful machine
- Deploy to slower devices (e.g., Surface)
- One-command updates for all systems

### Hardware Optimization
- Lenovo Legion: Zen kernel, NVIDIA PRIME, gaming optimization
- Surface Pro: Linux Surface kernel, touchscreen, power management

### Development Ready
- Full-stack development (web, mobile, embedded, desktop)
- Containerized services (Docker, Azurite)
- IDE support (VSCode, JetBrains suite)

## 🚀 Quick Start

See [QUICK-START.md](./QUICK-START.md) for detailed setup instructions.

### Initial Setup

1. **Clone this repository** on your Lenovo Legion:
   ```bash
   git clone <your-repo-url> ~/nixos-config
   cd ~/nixos-config
   ```

2. **Update hardware configurations** for your specific hardware:
   - Already have `hosts/lenovo-legion/hardware-configuration.nix` from your current setup
   - Generate Surface Pro config when you set it up: `nixos-generate-config`

3. **Review and customize** configurations:
   - Update hostnames if needed
   - Review PCI bus IDs for NVIDIA (may differ with multiple drives)
   - Update SSH hostnames in deployment scripts

4. **Apply configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#lenovo-legion
   ```

## 🔄 Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for complete deployment guide.

### Update All Machines

From your Lenovo Legion:

```bash
./scripts/update-all.sh
```

This will:
1. Update flake inputs
2. Rebuild Lenovo Legion locally
3. Build Surface Pro configuration locally (faster)
4. Deploy to Surface Pro via SSH

### Update Surface Pro Only

```bash
./scripts/update-surface.sh
```

## 📚 Documentation

- **[QUICK-START.md](./QUICK-START.md)** - Initial setup and installation
- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - How to deploy and update systems
- **[CODE-STYLE.md](./CODE-STYLE.md)** - Coding conventions and best practices
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Common issues and solutions

## 🤝 Contributing

When modifying this configuration:

1. Follow the coding style in [CODE-STYLE.md](./CODE-STYLE.md)
2. Test changes on non-production machine first
3. Document any new features or workarounds
4. Update relevant documentation

## 📄 License

This configuration is personal but shared for educational purposes. Feel free to use and adapt for your own systems.

## 🔗 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Hardware](https://github.com/NixOS/nixos-hardware)
- [Linux Surface](https://github.com/linux-surface/linux-surface)
- [Lenovo Legion 16ach6h Notes](https://github.com/NixOS/nixos-hardware/tree/master/lenovo/legion/16ach6h)
- [Surface on NixOS Guide](https://tomas.zakrocki.co.uk/articles/07-nixos-surface/)
