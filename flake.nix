{
  description = "Multi-host NixOS configuration for Lenovo Legion and Surface Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    
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
      pkgs = nixpkgs.legacyPackages.${system};
      
    in {
      # Formatter for `nix fmt`
      formatter.${system} = pkgs.nixpkgs-fmt;
      
      # Development shell
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil           # Nix LSP
          nixpkgs-fmt   # Nix formatter
          sops          # Secrets management
          age           # Encryption
        ];
        
        shellHook = ''
          echo "NixOS Configuration Development Shell"
          echo "Available commands:"
          echo "  nix fmt           - Format nix files"
          echo "  nix flake check   - Check flake"
          echo "  nixos-rebuild     - Rebuild system"
        '';
      };
      
      # NixOS configurations
      nixosConfigurations = {
        # Lenovo Legion 5 Pro (Gaming + Development workstation)
        lenovo-legion = import ./hosts/lenovo-legion { inherit inputs system; };
        
        # Microsoft Surface Pro 7 (Portable productivity device)
        surface-pro = import ./hosts/surface-pro { inherit inputs system; };
      };
      
      # Deployment helpers
      deploy = {
        # Update both machines from lenovo-legion
        updateAll = pkgs.writeShellScriptBin "update-all" ''
          ${builtins.readFile ./scripts/update-all.sh}
        '';
        
        # Update only surface-pro remotely
        updateSurface = pkgs.writeShellScriptBin "update-surface" ''
          ${builtins.readFile ./scripts/update-surface.sh}
        '';

        # Update only lenovo legion remotely
        updateLenovo = pkgs.writeShellScriptBin "update-lenovo" ''
          ${builtins.readFile ./scripts/update-lenovo.sh}
        '';
      };
    };
}
