# Hardware Notes

This document contains hardware-specific information and configuration details for each machine.

## Lenovo Legion 5 Pro (16ACH6H)

### Specifications

- **Model**: Lenovo Legion 5 Pro 16ACH6H
- **CPU**: AMD Ryzen 7 5800H (8 cores, 16 threads)
- **GPU**: NVIDIA RTX 3070 Mobile (8GB) + AMD iGPU
- **RAM**: Configurable (typically 16-32GB DDR4)
- **Display**: 16" 2560x1600 165Hz IPS
- **Storage**: NVMe SSD

### NixOS Hardware Support

Uses `nixos-hardware.nixosModules.lenovo-legion-16ach6h` for:
- Proper GPU configuration
- Display scaling
- Keyboard backlight
- Battery management

### Graphics Configuration

The system uses NVIDIA PRIME offload:

- **AMD iGPU**: Used for desktop and lightweight tasks
- **NVIDIA GPU**: Available for gaming and GPU-intensive work
- **Switching**: Automatic via PRIME offload

To run an application with NVIDIA GPU:
```bash
nvidia-offload <application>
```

### Important Notes

1. **PCI Bus IDs**: The NVIDIA GPU PCI bus ID may change if you modify drive configuration or BIOS settings. If graphics issues occur, check `lspci | grep -i nvidia` and update the configuration if needed.

2. **Kernel**: Uses Linux Zen kernel for gaming optimizations:
   - Lower latency
   - Better gaming performance
   - Improved responsiveness

3. **Power Management**: 
   - TLP is disabled (conflicts with AMD platform drivers)
   - Uses kernel's default power management
   - Battery life: ~4-6 hours typical usage

4. **Virtualization**: KVM (AMD) is enabled for virtual machines

### Enabled Features

- Gaming (Steam, GameMode, Gamescope)
- KDE Plasma 6
- Hyprland
- General development tools
- Embedded development
- Mobile development (Android)
- Docker with Azurite
- KVM virtualization

## Microsoft Surface Pro 7

### Specifications

- **Model**: Microsoft Surface Pro 7
- **CPU**: Intel Core i5-1035G4 or i7-1065G7 (10th gen)
- **GPU**: Intel Iris Plus Graphics
- **RAM**: 8GB or 16GB LPDDR4X
- **Display**: 12.3" 2736x1824 touchscreen
- **Storage**: NVMe SSD

### NixOS Hardware Support

Uses `nixos-hardware.nixosModules.microsoft-surface-common` which provides:
- Linux Surface kernel with touchscreen support
- IPTSD for touch and pen input
- Camera and sensor support
- Power management optimizations

### Surface-Specific Configuration

#### Touch Screen (IPTSD)

The Intel Precise Touch & Stylus Daemon (IPTSD) handles touch and pen input:

```nix
services.iptsd = {
  enable = true;
  config = {
    Config = {
      BlockOnPalm = true;        # Ignore palm touches
      TouchThreshold = 20;        # Touch sensitivity
      StabilityThreshold = 0.1;   # Pen stability
    };
  };
};
```

#### Kernel

Uses Linux Surface kernel (longterm LTS by default):
- Better hardware support
- Touch and pen drivers
- Camera support
- Surface-specific fixes

Can be changed to "stable" if needed:
```nix
hardware.microsoft-surface.kernelVersion = "stable";
```

#### Volume Buttons

Requires explicit kernel module loading:
```nix
boot.kernelModules = [ "pinctrl_sunrisepoint" ];
```

#### Camera Workaround

The camera module (`ipu3_imgu`) is blacklisted by default because it causes wireplumber (audio) to crash:

```nix
boot.blacklistedKernelModules = [ "ipu3_imgu" ];
```

**If you need camera support**: Uncomment the wireplumber overlay in the configuration (see module for details). This requires a longer rebuild time but fixes the audio/camera conflict.

#### Power Management

- **Power Profiles Daemon**: Enabled for battery optimization
- **TLP**: Forcefully disabled (conflicts with Surface drivers)
- **Battery Life**: ~6-8 hours typical usage

See: https://github.com/linux-surface/linux-surface#power-management

#### Touchpad

Configured via libinput:
- Natural scrolling enabled
- Tap-to-click enabled
- Disable typing while typing

### Virtualization

KVM (Intel) is enabled for virtual machines.

### Enabled Features

- KDE Plasma 6
- Hyprland (with touch support)
- General development tools
- Docker with Azurite
- KVM virtualization

### Disabled Features (vs Lenovo)

The Surface Pro does NOT include:
- Gaming modules (no discrete GPU)
- Embedded development
- Mobile development (Android)

This keeps the system lighter for portable productivity use.

## Common Configuration Notes

### Fonts

Both systems include comprehensive font support:
- JetBrains Mono (monospace)
- Noto Sans/Serif (Latin, CJK, Emoji)
- Font Awesome (icons)
- Liberation Fonts
- DejaVu Fonts
- Source Han Sans/Serif (CJK)

This ensures proper display of:
- Emoji 😀
- Chinese: 你好
- Japanese: こんにちは
- Korean: 안녕하세요
- Icons: 

### Desktop Environment

Both systems use:
- **Primary**: KDE Plasma 6
- **Alternative**: Hyprland (Wayland compositor)

### Development Ports

When `modules.networking.developmentPorts.enable = true`, the following ports are open:

**TCP**:
- 3000 (React/Next.js)
- 4200 (Angular)
- 5173 (Vite)
- 8080 (HTTP alt)
- 8081 (React Native Metro)
- 19000-19002 (Expo)

**UDP**:
- 19000-19001 (Expo LAN)

### User Groups

User groups are automatically configured based on enabled modules:

**Always**:
- networkmanager, wheel, video, audio

**Lenovo Legion**:
- docker, dialout, uucp, adbusers, kvm

**Surface Pro**:
- docker, kvm

## Troubleshooting

### Lenovo Legion

**Problem**: Graphics not working after BIOS update
- **Solution**: Check PCI bus IDs with `lspci | grep -i nvidia`

**Problem**: Poor gaming performance
- **Solution**: Ensure using `nvidia-offload` or set `__NV_PRIME_RENDER_OFFLOAD=1`

**Problem**: High idle power consumption
- **Solution**: Normal for dual-GPU setup, disable NVIDIA when not needed

### Surface Pro

**Problem**: Touch not working
- **Solution**: Check `systemctl status iptsd`, ensure `services.iptsd.enable = true`

**Problem**: No audio
- **Solution**: Verify camera module is blacklisted, check `lsmod | grep ipu3_imgu`

**Problem**: Screen rotation not working
- **Solution**: Install `iio-sensor-proxy`, enable `hardware.sensor.iio.enable = true`

**Problem**: Poor battery life
- **Solution**: Ensure `services.power-profiles-daemon.enable = true` and TLP is disabled

## References

- [NixOS Hardware Repo](https://github.com/NixOS/nixos-hardware)
- [Linux Surface Project](https://github.com/linux-surface/linux-surface)
- [Lenovo Legion Linux Wiki](https://wiki.archlinux.org/title/Lenovo_Legion_5_Pro_16ACH6H)
