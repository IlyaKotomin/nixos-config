# Hardware-Specific Notes

This document contains hardware-specific information, quirks, and optimizations for the machines in this configuration.

## Lenovo Legion 5 Pro (16ach6h)

### Specifications
- **Model**: Lenovo Legion 5 Pro 16ACH6H
- **CPU**: AMD Ryzen 7 5800H (8 cores, 16 threads)
- **GPU**: 
  - NVIDIA GeForce RTX 3070 Mobile (8GB GDDR6)
  - AMD Radeon Graphics (integrated)
- **RAM**: 16GB DDR4
- **Display**: 16" WQXGA (2560x1600) 165Hz
- **Storage**: NVMe SSD

### Hardware Support
- **Kernel**: Linux Zen (gaming optimized, low latency)
- **Hardware Module**: `nixos-hardware.nixosModules.lenovo-legion-16ach6h`
- **GPU Configuration**: NVIDIA PRIME offload mode
  - Integrated AMD GPU for power efficiency
  - NVIDIA GPU for gaming and GPU-intensive tasks
  - Use `prime-run <command>` to run applications on NVIDIA GPU

### Known Issues & Solutions

#### 1. NVIDIA PRIME Configuration
The NVIDIA GPU uses PRIME offload mode for better battery life and thermal management:
- **Default**: Uses AMD integrated GPU
- **On-demand**: Run with `nvidia-offload <command>` or `prime-run <command>`
- **Check active GPU**: `glxinfo | grep "OpenGL renderer"`

#### 2. Display Scaling
The high-resolution display (2560x1600) may require scaling:
- **KDE Plasma**: Set to 125% or 150% scaling in Display Settings
- **Wayland**: Generally better HiDPI support
- **X11**: May need manual DPI configuration

#### 3. Gaming Optimizations
- **GameMode**: Automatically enabled for Steam games
- **Gamescope**: Available for game-specific window management
- **MangoHud**: FPS and performance monitoring overlay
- **CPU Governor**: Performance mode enabled for gaming

#### 4. Thermal Management
- High-performance components generate significant heat
- Ensure adequate ventilation during gaming/heavy workloads
- Consider using a cooling pad for extended gaming sessions

### Performance Tips
1. **Power Profiles**: Switch between power-saver and performance modes
2. **GPU Selection**: Use integrated GPU for regular work, NVIDIA for gaming
3. **Refresh Rate**: Can be lowered to 60Hz for better battery life
4. **Background Services**: Disable unnecessary services when gaming

## Microsoft Surface Pro 7

### Specifications
- **Model**: Microsoft Surface Pro 7
- **CPU**: Intel Core i5-1035G4 (4 cores, 8 threads)
- **GPU**: Intel Iris Plus Graphics
- **RAM**: 8GB LPDDR4x
- **Display**: 12.3" PixelSense (2736x1824) touchscreen with pen support
- **Storage**: 256GB SSD

### Hardware Support
- **Kernel**: Linux Surface (official Surface kernel patches)
- **Hardware Module**: `nixos-hardware.nixosModules.microsoft-surface-common`
- **Additional Module**: `./modules/shared/surface-specific.nix` for IPTSD and camera support

### Surface-Specific Features

#### 1. Touchscreen & Pen Support
- **IPTSD**: Intel Precise Touch & Stylus Daemon
  - Enables multitouch gestures
  - Surface Pen pressure sensitivity
  - Palm rejection
- **Configuration**: Enabled in `surface-specific.nix`

#### 2. Cameras
- **Front Camera**: Working with linux-firmware-surface
- **Rear Camera**: Supported via IPU3 driver
- **Configuration**: Enabled via `hardware.ipu6.enable` option

#### 3. Type Cover
- **Keyboard**: Works out of the box
- **Trackpad**: Full gesture support
- **Backlight**: Function keys work for adjustment

#### 4. Battery Management
- **Battery Life**: 6-8 hours typical usage
- **Power Profiles**: Use power-saver mode for extended battery
- **Thermal**: Fanless design, throttles under sustained load

### Known Issues & Solutions

#### 1. Wifi Performance
Some Surface Pro 7 models may have wifi issues:
- **Driver**: Uses Intel AX201 wifi card
- **Solution**: Ensure latest linux-firmware is installed
- **Workaround**: Disable power management if experiencing drops

#### 2. Suspend/Resume
Occasionally has issues with suspend:
- **Solution**: Use systemd suspend instead of kernel suspend
- **Workaround**: Configured in surface-specific.nix

#### 3. Display Scaling
Very high resolution display (2736x1824) requires scaling:
- **Recommended**: 200% scaling in KDE
- **Wayland**: Better support for fractional scaling
- **X11**: May have slight blur with fractional scaling

#### 4. Pen Calibration
Surface Pen may need calibration:
- **Tool**: Use `xinput` for X11 or Wayland calibration tools
- **Tip**: Keep pen firmware updated via Windows (if dual-booting)

### Performance Tips
1. **Power Management**: Enable TLP or auto-cpufreq for better battery
2. **Thermal**: Avoid sustained high-load tasks without external cooling
3. **Display**: Lower brightness for better battery life
4. **Background**: Minimize background services for performance

## General Hardware Recommendations

### Common to Both Machines

#### 1. Firmware Updates
- Keep firmware updated via fwupd: `fwupdmgr refresh && fwupdmgr update`
- Check for BIOS/UEFI updates periodically

#### 2. Storage Management
- Use TRIM for SSDs: Enabled automatically in NixOS
- Monitor disk health: `smartctl -a /dev/nvme0n1` or `smartctl -a /dev/sda`

#### 3. Network Configuration
- Both machines support WiFi 6 (802.11ax)
- Ethernet available via USB-C adapters
- NetworkManager handles connection management

#### 4. External Displays
- Both support USB-C/Thunderbolt displays
- Lenovo: Additional HDMI port
- Surface: DisplayPort over USB-C

## Troubleshooting Hardware Issues

### GPU Issues (Lenovo)
```bash
# Check NVIDIA GPU status
nvidia-smi

# Test NVIDIA rendering
prime-run glxgears

# Check loaded modules
lsmod | grep nvidia
```

### Touchscreen Issues (Surface)
```bash
# Check IPTSD status
systemctl status iptsd

# Restart IPTSD
sudo systemctl restart iptsd

# Check input devices
libinput list-devices
```

### General Hardware Info
```bash
# List all hardware
lshw -short

# Check PCI devices
lspci

# Check USB devices
lsusb

# System info
inxi -Fxxxrz
```

## Resources

### Lenovo Legion
- [NixOS Hardware - Lenovo Legion](https://github.com/NixOS/nixos-hardware/tree/master/lenovo/legion/16ach6h)
- [Arch Wiki - Lenovo Legion](https://wiki.archlinux.org/title/Lenovo_Legion_5)

### Microsoft Surface
- [Linux Surface Project](https://github.com/linux-surface/linux-surface)
- [Surface on NixOS Guide](https://tomas.zakrocki.co.uk/articles/07-nixos-surface/)
- [NixOS Hardware - Surface](https://github.com/NixOS/nixos-hardware/tree/master/microsoft/surface)

### General
- [NixOS Hardware Repository](https://github.com/NixOS/nixos-hardware)
- [NixOS Wiki - Hardware](https://nixos.wiki/wiki/Hardware)
