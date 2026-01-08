{
  description = "Multi-host NixOS configuration for Lenovo Legion and Surface Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Import custom packages overlay
      packagesOverlay = final: prev: {
        azureFunctionsCli = prev.callPackage ./packages/azure-functions-cli-bin.nix { };
        platformioFHS = prev.callPackage ./packages/platformio-fhs.nix { };
        androidSdkCustom = prev.callPackage ./packages/android-sdk.nix { };
      };
      
      # Common configuration for both hosts
      commonModules = [
        { nixpkgs.overlays = [ packagesOverlay ]; }
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        ./modules/shared/base.nix
        ./modules/shared/networking.nix
        ./modules/shared/users.nix
        ./home  # Home Manager configuration
        ./modules/shared/secrets
      ];
      
    in {
      nixosConfigurations = {
        # Lenovo Legion 5 Pro (Gaming + Development workstation)
        lenovo-legion = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            # Hardware-specific
            nixos-hardware.nixosModules.lenovo-legion-16ach6h
            ./hosts/lenovo-legion/hardware-configuration.nix
            
            # Host-specific configuration
            ./hosts/lenovo-legion/configuration.nix
            
            # Feature modules
            ./modules/desktop/kde.nix
            ./modules/desktop/hyprland.nix
            ./modules/desktop/gaming.nix
            ./modules/development/embedded.nix
            ./modules/development/mobile.nix
            ./modules/development/general.nix
            ./modules/shared/docker.nix
            ./modules/shared/virtualisation.nix
          ];
        };
        
        # Microsoft Surface Pro 7 (Portable productivity device)
        surface-pro = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            # Hardware-specific - MUST be before surface-specific.nix
            nixos-hardware.nixosModules.microsoft-surface-common
            ./hosts/surface-pro/hardware-configuration.nix
            
            # Host-specific configuration
            ./hosts/surface-pro/configuration.nix
            
            # Surface-specific module (requires nixos-hardware module above)
            ./modules/shared/surface-specific.nix
            
            # Feature modules
            ./modules/desktop/kde.nix
            ./modules/desktop/hyprland.nix
            ./modules/development/general.nix
            ./modules/shared/docker.nix
          ];
        };
      };
      
      # Deployment helpers
      deploy = {
        # Update both machines from lenovo-legion
        updateAll = nixpkgs.legacyPackages.${system}.writeShellScriptBin "update-all" ''
          ${builtins.readFile ./scripts/update-all.sh}
        '';
        
        # Update only surface-pro remotely
        updateSurface = nixpkgs.legacyPackages.${system}.writeShellScriptBin "update-surface" ''
          ${builtins.readFile ./scripts/update-surface.sh}
        '';

        # Update only lenovo legion remotely
        updateLenovo = nixpkgs.legacyPackages.${system}.writeShellScriptBin "update-lenovo" ''
          ${builtins.readFile ./scripts/update-lenovo.sh}
        '';
      };
    };
}
