# Code Style Guide

Coding conventions for this NixOS configuration.

## Principles

1. **Modularity** - Split into logical, reusable modules
2. **Clarity** - Self-documenting with clear names
3. **Consistency** - Same patterns throughout
4. **Documentation** - Comment non-obvious decisions

## File Organization

```
modules/
  shared/         # All hosts
  desktop/        # Desktop environments
  development/    # Dev tools

hosts/<hostname>/
  configuration.nix         # Host-specific
  hardware-configuration.nix  # Auto-generated

packages/         # Custom packages
scripts/          # Deployment scripts
```

## Formatting

**Indentation**: 2 spaces

```nix
{
  services.foo = {
    enable = true;
    port = 8080;
  };
}
```

**Lists**: One item per line for >3 items

```nix
environment.systemPackages = with pkgs; [
  git
  vim
  wget
];
```

**Blank lines**: Separate logical sections

```nix
{
  # Boot
  boot.loader.systemd-boot.enable = true;

  # Networking
  networking.hostName = "example";

  # Locale
  time.timeZone = "Europe/Sofia";
}
```

## Comments

```nix
# Section headers for major sections
################################
## Networking
################################

# Explain WHY, not what
boot.kernelParams = [ "amd_pstate=active" ];  # Better perf on Zen CPUs

# Mark incomplete work
# TODO: Move to secrets manager
password = "changeme";

# FIXME: Workaround until upstream fix
# HACK: Temporary solution, see github.com/...
```

## Module Structure

```nix
{ config, lib, pkgs, ... }:

{
  # Services
  services.example.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [ ... ];

  # Environment
  environment.sessionVariables = { ... };
}
```

## Common Patterns

### Conditional Configuration

```nix
# Optional feature
services.x = lib.mkIf config.features.x { ... };

# Default that can be overridden
hostName = lib.mkDefault "nixos";
```

### Conditional Packages

```nix
environment.systemPackages = with pkgs;
  [ git vim ]
  ++ lib.optionals config.services.xserver.enable [ firefox vscode ];
```

## Avoid

- Deeply nested attribute sets
- Unclear variable names
- Mixing concerns in one module
- Hardcoded paths (`/nix/store/...`)
- Secrets in git

## Git Commits

```
<type>: <description>

Types: feat, fix, docs, refactor, chore
```

Example:
```
feat: Add Surface Pro configuration
fix: Correct NVIDIA PCI bus ID
docs: Update quick start guide
```

## Before Committing

- [ ] Follows formatting
- [ ] No hardcoded secrets
- [ ] Configuration builds: `nix flake check`
- [ ] Tested on relevant host
