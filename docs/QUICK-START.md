# Quick Start Guide

Setup instructions for the NixOS multi-host configuration.

## Lenovo Legion Setup

### 1. Backup Current Configuration

```bash
sudo cp -r /etc/nixos /etc/nixos.backup
```

### 2. Clone Configuration

```bash
cd ~
git clone <your-repo-url> nixos-config
cd nixos-config
```

### 3. Verify Hardware Configuration

Check `hosts/lenovo-legion/hardware-configuration.nix`:
- File system UUIDs match your setup
- Boot partition is correct
- Swap device is configured

### 4. Verify NVIDIA PCI Bus IDs

```bash
lspci | grep -E "VGA|3D"
```

Update `hosts/lenovo-legion/configuration.nix` if needed:

```nix
hardware.nvidia.prime = {
  amdgpuBusId = "PCI:5:0:0";  # PCI:6:0:0 with 2 drives
  nvidiaBusId = "PCI:1:0:0";
};
```

### 5. Enable Flakes (if not enabled)

Add to `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Apply: `sudo nixos-rebuild switch`

### 6. Build and Apply

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#lenovo-legion
```

### 7. Reboot and Verify

```bash
sudo reboot
```

Check: display, audio, network, gaming tools.

---

## Surface Pro Setup

### 1. Install NixOS

Install NixOS on Surface Pro with minimal configuration.

### 2. Generate Hardware Configuration

On Surface Pro:

```bash
nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

Copy to Lenovo:

```bash
scp /tmp/hardware-configuration.nix kotoxik@lenovo-legion:~/nixos-config/hosts/surface-pro/
```

### 3. Configure SSH

On Surface Pro:

```bash
sudo systemctl start sshd
```

On Lenovo:

```bash
ssh-copy-id kotoxik@surface-pro.local
```

Test: `ssh kotoxik@surface-pro.local`

### 4. Deploy from Lenovo

```bash
cd ~/nixos-config
./scripts/update-surface.sh
```

First build takes ~30 minutes (kernel compilation).

### 5. Reboot and Verify

Verify: touchscreen, pen, audio, Wi-Fi.

---

## Customization

### Adding Packages

| Type | File |
|------|------|
| User packages | `modules/shared/users.nix` |
| System packages | `modules/shared/base.nix` |
| Development tools | `modules/development/general.nix` |
| Gaming | `modules/desktop/gaming.nix` |

### Disabling Features

Comment out modules in `flake.nix`:

```nix
modules = commonModules ++ [
  # ./modules/desktop/gaming.nix  # Disabled
  ./modules/development/general.nix
];
```

### Adding New Hosts

1. Create `hosts/new-machine/configuration.nix` and `hardware-configuration.nix`
2. Add to `flake.nix`:

```nix
nixosConfigurations = {
  new-machine = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = commonModules ++ [ ./hosts/new-machine/configuration.nix ];
  };
};
```

---

## Troubleshooting

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues.

**Rollback if needed:**
- From bootloader: select previous generation
- From command line: `sudo nixos-rebuild switch --rollback`

## Next Steps

- [DEPLOYMENT.md](./DEPLOYMENT.md) - Ongoing maintenance
- [CODE-STYLE.md](./CODE-STYLE.md) - Before making modifications
