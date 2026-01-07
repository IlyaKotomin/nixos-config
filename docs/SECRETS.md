# Secrets Management

This configuration uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption for secure secrets management.

## Overview

```
secrets/
  .gitignore          # Prevents committing unencrypted files
  secrets.yaml        # Encrypted secrets (safe to commit)
  secrets.yaml.example  # Template for new secrets

.sops.yaml            # SOPS configuration (key mappings)
```

## Quick Start

### 1. Generate Your Age Key

```bash
# Create age key directory
mkdir -p ~/.config/sops/age

# Generate a new age key
age-keygen -o ~/.config/sops/age/keys.txt

# Display your public key (needed for .sops.yaml)
age-keygen -y ~/.config/sops/age/keys.txt
```

### 2. Configure SOPS

Edit `.sops.yaml` and replace the placeholder with your public key:

```yaml
keys:
  - &user_kotoxik age1your_actual_public_key_here
```

### 3. Create Secrets File

```bash
# Create and encrypt secrets file (opens in $EDITOR)
sops secrets/secrets.yaml
```

Or copy from example and encrypt:

```bash
cp secrets/secrets.yaml.example secrets/secrets.yaml
sops -e -i secrets/secrets.yaml
```

### 4. Rebuild System

```bash
sudo nixos-rebuild switch --flake .#lenovo-legion
```

## How It Works

### Encryption Flow

```
┌─────────────────┐    sops encrypt    ┌─────────────────┐
│ Plain YAML      │ ─────────────────► │ Encrypted YAML  │
│ (never commit)  │                    │ (safe to commit)│
└─────────────────┘                    └─────────────────┘
                                              │
                                              │ git push
                                              ▼
                                       ┌─────────────────┐
                                       │ Git Repository  │
                                       └─────────────────┘
```

### Decryption Flow (at boot)

```
┌─────────────────┐    sops-nix      ┌─────────────────┐
│ Encrypted YAML  │ ───────────────► │ /run/secrets/   │
│ in repo         │   (via age key)  │ (decrypted)     │
└─────────────────┘                  └─────────────────┘
                                            │
                                            ▼
                                     ┌─────────────────┐
                                     │ Applications    │
                                     │ read secrets    │
                                     └─────────────────┘
```

## File Locations

| File | Purpose |
|------|---------|
| `~/.config/sops/age/keys.txt` | Your personal age key (for editing) |
| `/var/lib/sops-nix/key.txt` | Machine age key (auto-generated) |
| `/run/secrets/<name>` | Decrypted individual secrets |
| `/run/secrets/rendered/<name>` | Rendered templates (env files) |

## Adding New Secrets

### 1. Define Secret in Nix

Edit `modules/shared/secrets.nix`:

```nix
sops.secrets = {
  "myapp/api-key" = {
    owner = "kotoxik";
    group = "users";
    mode = "0400";
  };
};
```

### 2. Add to Secrets File

```bash
sops secrets/secrets.yaml
```

Add the secret with matching path:

```yaml
myapp:
  api-key: "your-secret-value"
```

### 3. Use in Configuration

```nix
# Read secret file path
environment.etc."myapp.conf".text = ''
  API_KEY_FILE=${config.sops.secrets."myapp/api-key".path}
'';

# Or use templates for environment variables
sops.templates."myapp-env" = {
  content = ''
    API_KEY=${config.sops.placeholder."myapp/api-key"}
  '';
  path = "/run/secrets/rendered/myapp.env";
};
```

## Environment Variables

Secrets are loaded as environment variables via `/etc/profile.d/load-secrets.sh`:

```bash
# In your shell, these are available:
echo $RYTHMOS_CERT_PATH
echo $RYTHMOS_CERT_PASSWORD
```

For GUI applications, you may need to source manually or use systemd environment:

```nix
systemd.user.services.myapp = {
  serviceConfig.EnvironmentFile = "/run/secrets/rendered/rythmos.env";
};
```

## Host-Specific Secrets

For secrets only needed on one host, create separate files:

```bash
# Lenovo-only secrets
sops secrets/lenovo.yaml

# Surface-only secrets  
sops secrets/surface.yaml
```

Configure in host's configuration:

```nix
sops.defaultSopsFile = ../../secrets/lenovo.yaml;
```

## Machine Key Setup

On first boot, sops-nix auto-generates a machine key. Add it to `.sops.yaml`:

```bash
# Get machine's public key
sudo cat /var/lib/sops-nix/key.txt | age-keygen -y

# Add to .sops.yaml under the host key
# Then re-encrypt secrets with the new key
sops updatekeys secrets/secrets.yaml
```

## Common Commands

```bash
# Edit encrypted secrets
sops secrets/secrets.yaml

# View decrypted secrets (without editing)
sops -d secrets/secrets.yaml

# Encrypt existing plain file
sops -e -i secrets/secrets.yaml

# Decrypt to stdout
sops -d secrets/secrets.yaml > /tmp/secrets-plain.yaml

# Add new key and re-encrypt
sops updatekeys secrets/secrets.yaml

# Rotate data key (re-encrypt with new key)
sops -r secrets/secrets.yaml
```

## Troubleshooting

### "Failed to get the data key"

The machine doesn't have access to decrypt. Verify:

```bash
# Check machine key exists
sudo cat /var/lib/sops-nix/key.txt

# Get public key
sudo cat /var/lib/sops-nix/key.txt | age-keygen -y

# Ensure this key is in .sops.yaml
```

Then update keys:

```bash
sops updatekeys secrets/secrets.yaml
```

### "No matching creation rules"

Your file path doesn't match any rule in `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/secrets\.yaml$  # Must match your file path
```

### Secrets Not Available After Rebuild

```bash
# Check if secrets are decrypted
ls -la /run/secrets/

# Check sops-nix service status
systemctl status sops-nix

# View service logs
journalctl -u sops-nix
```

### Environment Variables Not Set

```bash
# Source the secrets loader
source /etc/profile.d/load-secrets.sh

# Or restart your shell
exec $SHELL
```

## Security Best Practices

1. **Never commit unencrypted secrets** - The `.gitignore` helps prevent this
2. **Use strong age keys** - Generated keys are cryptographically secure
3. **Rotate secrets regularly** - Use `sops -r` to rotate data keys
4. **Limit secret access** - Use appropriate `owner`, `group`, and `mode`
5. **Audit secret access** - Check which hosts have access in `.sops.yaml`
6. **Backup age keys** - Store personal key backup securely offline

## Integration Examples

### Systemd Service

```nix
systemd.services.myservice = {
  serviceConfig = {
    EnvironmentFile = config.sops.templates."myservice-env".path;
    # Or read individual secret
    ExecStart = "${pkgs.myapp}/bin/myapp --config ${config.sops.secrets."myapp/config".path}";
  };
};
```

### Docker Compose

```nix
sops.templates."docker-env" = {
  content = ''
    DB_PASSWORD=${config.sops.placeholder."database/password"}
  '';
  path = "/run/secrets/rendered/docker.env";
};

# Reference in docker-compose.yml:
# env_file:
#   - /run/secrets/rendered/docker.env
```

### Home Manager

```nix
home-manager.users.kotoxik = {
  home.file.".config/app/secret".source = 
    config.sops.secrets."app/secret".path;
};
```
