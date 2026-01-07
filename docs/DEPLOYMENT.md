# Deployment Guide

How to deploy, update, and maintain your NixOS configurations.

## Prerequisites

### SSH Key Setup

```bash
# On Lenovo: Generate key
ssh-keygen -t ed25519

# Copy to Surface
ssh-copy-id kotoxik@surface-pro.local

# Test (should not prompt for password)
ssh kotoxik@surface-pro.local exit
```

## Deployment Methods

### Update All Machines

```bash
cd ~/nixos-config
./scripts/update-all.sh
```

This updates flake inputs, rebuilds both machines, and deploys via SSH.

### Update Surface Only

```bash
./scripts/update-surface.sh
```

### Update Lenovo Only

```bash
./scripts/update-lenovo.sh
```

### Manual Deployment

```bash
# Update flake inputs
nix flake update

# Build and switch locally
sudo nixos-rebuild switch --flake .#lenovo-legion

# Build for Surface on Lenovo, deploy via SSH
nixos-rebuild switch --flake .#surface-pro \
  --target-host kotoxik@surface-pro.local \
  --build-host localhost \
  --use-remote-sudo
```

## Workflow

### Regular Updates

```bash
cd ~/nixos-config
git pull
./scripts/update-all.sh
git add flake.lock && git commit -m "Update: $(date +%Y-%m-%d)"
git push
```

### Making Changes

```bash
# Edit configuration
vim modules/shared/base.nix

# Test on Lenovo first
sudo nixos-rebuild switch --flake .#lenovo-legion

# If good, deploy to Surface
./scripts/update-surface.sh

# Commit
git commit -am "Add package X"
git push
```

### Emergency Rollback

```bash
# From bootloader: Select previous generation

# Or from command line
sudo nixos-rebuild switch --rollback

# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Maintenance

### Clean Up Disk Space

```bash
# Remove old generations (keep last 5)
sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system

# Garbage collect
sudo nix-collect-garbage -d

# Optimize store
sudo nix-store --optimize
```

### Check System Health

```bash
# Failed services
systemctl --failed

# Disk usage
df -h
du -sh /nix/store

# List generations
sudo nixos-rebuild list-generations
```

## Troubleshooting

### SSH Connection Failed

```bash
# Check connectivity
ping surface-pro.local

# Check SSH
ssh -v kotoxik@surface-pro.local
```

### Build Failed

```bash
# Check syntax
nix flake check

# Detailed errors
nixos-rebuild build --flake .#hostname --show-trace
```

### Deployment Stuck

```bash
# Cancel with Ctrl+C
# Check remote logs
ssh kotoxik@surface-pro.local journalctl -xe
```

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for more solutions.
