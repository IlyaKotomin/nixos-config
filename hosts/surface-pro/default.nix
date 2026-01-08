{ inputs, system, ... }:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  
  modules = [
    # Overlays
    { nixpkgs.overlays = [ (import ../../overlays { inherit inputs; }) ]; }
    
    # Core modules
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    
    # Shared modules
    ../../modules/shared/base.nix
    ../../modules/shared/networking.nix
    ../../modules/shared/users.nix
    ../../modules/shared/secrets
    ../../home
    
    # Feature modules
    ../../modules/desktop/kde.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/development/general.nix
    ../../modules/shared/docker.nix
    
    # Hardware-specific modules
    ../../modules/shared/surface-specific.nix
    
    # Hardware
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    ./hardware-configuration.nix
    ./configuration.nix
    
    # Enable modules
    {
      modules.desktop.kde.enable = true;
      modules.desktop.hyprland.enable = true;
      modules.development.general.enable = true;
      modules.services.docker.enable = true;
      modules.services.docker.azurite.enable = true;
      modules.virtualisation.enable = true;
      modules.virtualisation.kvmType = "intel";
      modules.networking.developmentPorts.enable = true;
      modules.hardware.surface.enable = true;
      
      # Add module-specific user groups
      modules.users.kotoxik.extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "docker"        # For Docker
        "kvm"           # For virtualization
      ];
    }
  ];
}
