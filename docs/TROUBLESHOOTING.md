# Troubleshooting Guide

Common issues and solutions.

## Build Issues

### Flake Lock Conflicts

```bash
rm flake.lock
nix flake update
```

### Syntax Errors

```bash
nix flake check
nixos-rebuild build --flake .#hostname --show-trace
```

### Package Not Found

```bash
nix search nixpkgs packageName
nix flake lock --update-input nixpkgs
```

## Deployment Issues

### SSH Connection Failed

```bash
ping surface-pro.local
ssh -v kotoxik@surface-pro.local

# On target: enable SSH
sudo systemctl start sshd
```

### SSH Key Issues

```bash
ssh-copy-id kotoxik@surface-pro.local

# Fix permissions on target
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Deployment Hangs

```bash
# Cancel with Ctrl+C
ssh kotoxik@surface-pro.local journalctl -xe
```

## Lenovo Legion Issues

### NVIDIA GPU Not Working

```bash
# Verify PCI bus IDs
lspci | grep -E "VGA|3D"

# Check driver
nvidia-smi

# Run with NVIDIA
nvidia-offload steam
```

### Wrong PCI Bus ID (2 Drives)

Change in `hosts/lenovo-legion/configuration.nix`:

```nix
hardware.nvidia.prime.amdgpuBusId = "PCI:6:0:0";  # Was PCI:5:0:0
```

### Gaming Performance Issues

```bash
# Check governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Use GameMode
gamemoderun %command%
```

## Surface Pro Issues

### Touchscreen Not Working

```bash
systemctl status iptsd
sudo systemctl restart iptsd
journalctl -u iptsd -f
```

### No Audio

Camera module conflicts with audio. Verify it's disabled:

```bash
lsmod | grep ipu3_imgu  # Should return nothing
```

### Poor Battery Life

```bash
powerprofilesctl set power-saver
sudo powertop
```

### Volume Buttons Not Working

Check module is loaded:

```bash
lsmod | grep pinctrl_sunrisepoint
sudo modprobe pinctrl_sunrisepoint
```

## Development Tools

### Android Emulator Won't Start

```bash
ls -la /dev/kvm
sudo usermod -aG kvm kotoxik
# Log out and back in
```

### ADB Can't Find Device

```bash
sudo usermod -aG adbusers kotoxik
adb kill-server && adb start-server
```

### PlatformIO Upload Fails

```bash
sudo usermod -aG dialout kotoxik
# Log out and back in
```

### Docker Permission Denied

```bash
sudo usermod -aG docker kotoxik
# Log out and back in
```

## General

### Check Logs

```bash
journalctl -xe           # Recent errors
journalctl -u service -f # Specific service
journalctl -b            # Boot messages
dmesg | tail -50         # Kernel messages
```

### Rollback

```bash
# From bootloader: Select previous generation

# From command line
sudo nixos-rebuild switch --rollback

# Specific generation
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-env --switch-generation <number> --profile /nix/var/nix/profiles/system
```

### Clean Disk Space

```bash
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage -d
sudo nix-store --optimize
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [nixos-hardware issues](https://github.com/NixOS/nixos-hardware/issues)
- [linux-surface wiki](https://github.com/linux-surface/linux-surface/wiki)
- [NixOS Discourse](https://discourse.nixos.org/)
