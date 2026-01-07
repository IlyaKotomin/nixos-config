# NixOS Configuration

Multi-host NixOS configuration for Lenovo Legion 5 Pro and Microsoft Surface Pro 7.

## 🚀 Quick Links

- **[📖 Full Documentation](./docs/README.md)** - Complete documentation
- **[⚡ Quick Start](./docs/QUICK-START.md)** - Get started in minutes
- **[🚢 Deployment Guide](./docs/DEPLOYMENT.md)** - Update and maintain systems
- **[🐛 Troubleshooting](./docs/TROUBLESHOOTING.md)** - Fix common issues
- **[💻 Hardware Notes](./docs/HARDWARE-NOTES.md)** - Hardware-specific information
- **[📝 Code Style](./docs/CODE-STYLE.md)** - Contribution guidelines

## 📋 Overview

This repository contains a modular, maintainable NixOS configuration that manages two machines:

- **Lenovo Legion 5 Pro**: Gaming and development workstation
- **Microsoft Surface Pro 7**: Portable productivity device

### Key Features

- ✅ **Modular design** - Reusable configuration modules
- ✅ **Multi-host support** - Single repo for multiple machines
- ✅ **Remote deployment** - Update Surface from Legion
- ✅ **Hardware-optimized** - Specific configs for each device
- ✅ **Well-documented** - Comprehensive guides and notes

## 🏗️ Structure

```
nixos-config/
├── flake.nix              # Main configuration entry point
├── hosts/                 # Host-specific configurations
│   ├── lenovo-legion/
│   └── surface-pro/
├── modules/               # Reusable configuration modules
│   ├── shared/
│   ├── desktop/
│   └── development/
├── packages/              # Custom package definitions
├── scripts/               # Deployment scripts
└── docs/                  # Documentation
```

## 🎯 Hosts

### Lenovo Legion 5 Pro
- Linux Zen kernel (gaming optimized)
- NVIDIA RTX 3070 + AMD iGPU (PRIME offload)
- Gaming, mobile development, embedded development
- Desktop: KDE Plasma 6 + Hyprland

### Surface Pro 7
- Linux Surface kernel (touchscreen support)
- Intel integrated graphics
- Portable development and productivity
- Desktop: KDE Plasma 6 + Hyprland

## 📦 What's Included

### Development
- .NET 8 & 9 SDK
- Node.js 22
- Azure tools
- JetBrains IDEs (Rider, WebStorm, DataGrip)
- VSCode

### Mobile Development (Lenovo only)
- Android Studio
- Android SDK (Nix-managed)
- React Native / Expo
- Emulator support

### Embedded Development (Lenovo only)
- PlatformIO
- ESP tools
- OpenOCD

### Desktop
- KDE Plasma 6
- Hyprland (Wayland compositor)
- Communication (Vesktop, Slack, Telegram)
- Media (Spotify, qBittorrent)

### Gaming (Lenovo only)
- Steam
- GameMode
- Gamescope
- MangoHud

## 🚀 Quick Start

### 1. Initial Setup (Lenovo)

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#lenovo-legion
```

### 2. Deploy to Surface Pro

```bash
# After setting up SSH access
./scripts/update-all.sh
```

### 3. Update Both Machines

```bash
./scripts/update-all.sh
```

For detailed instructions, see [Quick Start Guide](./docs/QUICK-START.md).

## 📚 Documentation

- **[README.md](./docs/README.md)** - Full documentation overview
- **[QUICK-START.md](./docs/QUICK-START.md)** - Setup instructions
- **[DEPLOYMENT.md](./docs/DEPLOYMENT.md)** - Deployment workflows
- **[CODE-STYLE.md](./docs/CODE-STYLE.md)** - Coding standards
- **[TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)** - Common issues
- **[HARDWARE-NOTES.md](./docs/HARDWARE-NOTES.md)** - Hardware details

## 🤝 Contributing

When modifying this configuration:

1. Follow the [code style guide](./docs/CODE-STYLE.md)
2. Test changes locally first
3. Update documentation as needed
4. Commit with descriptive messages

## 📝 License

Personal configuration, shared for educational purposes.

## 🔗 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Hardware](https://github.com/NixOS/nixos-hardware)
- [Linux Surface](https://github.com/linux-surface/linux-surface)
- [Nix Pills](https://nixos.org/guides/nix-pills/)

---

**Note**: This configuration is actively maintained and optimized for specific hardware. Adapt as needed for your setup.
