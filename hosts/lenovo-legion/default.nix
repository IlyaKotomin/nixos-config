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
    ../../modules/desktop/gaming.nix
    ../../modules/development/general.nix
    ../../modules/development/embedded.nix
    ../../modules/development/mobile.nix
    ../../modules/shared/docker.nix
    ../../modules/shared/virtualisation.nix
    
    # Hardware
    inputs.nixos-hardware.nixosModules.lenovo-legion-16ach6h
    ./hardware-configuration.nix
    ./configuration.nix
    
    # Enable modules
    {
      modules.desktop.gaming.enable = true;
      modules.desktop.kde.enable = true;
      modules.desktop.hyprland.enable = true;
      modules.development.general.enable = true;
      modules.development.embedded.enable = true;
      modules.development.mobile.enable = true;
      modules.services.docker.enable = true;
      modules.services.docker.azurite.enable = true;
      modules.virtualisation.enable = true;
      modules.virtualisation.kvmType = "amd";
      modules.networking.developmentPorts.enable = true;
      
      # Add module-specific user groups
      modules.users.kotoxik.extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "docker"        # For Docker
        "dialout"       # For embedded serial access
        "uucp"          # Alternative serial port group
        "adbusers"      # For Android development
        "kvm"           # For virtualization
      ];
    }
  ];
}
