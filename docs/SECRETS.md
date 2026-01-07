# Secrets Management

Uses [sops-nix](https://github.com/Mic92/sops-nix) with age encryption.

## Setup

```bash
# Generate user key
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Add public key to .sops.yaml, then encrypt secrets
sops -e -i secrets/secrets.yaml
```

## After First Boot

Add machine keys to `.sops.yaml`:

```bash
# Get machine public key
sudo cat /var/lib/sops-nix/key.txt | age-keygen -y

# Update .sops.yaml with the key, then re-encrypt
sops updatekeys secrets/secrets.yaml
```

## Adding Secrets

1. Add secret definition in `modules/shared/secrets/<theme>.nix`
2. Import in `modules/shared/secrets/default.nix`
3. Add value to `secrets/secrets.yaml`:
   ```bash
   sops secrets/secrets.yaml
   ```

## File Locations

| Path | Purpose |
|------|---------|
| `~/.config/sops/age/keys.txt` | User key (for editing) |
| `/var/lib/sops-nix/key.txt` | Machine key (auto-generated) |
| `/run/secrets/<name>` | Decrypted secrets |
| `/run/secrets/rendered/<name>` | Environment files |

## Common Commands

```bash
sops secrets/secrets.yaml          # Edit secrets
sops -d secrets/secrets.yaml       # View decrypted
sops updatekeys secrets/secrets.yaml  # Add new key
```
