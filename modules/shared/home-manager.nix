{ config, lib, pkgs, ... }:

{
  # Home Manager configuration
  home-manager = {
    # Use the same nixpkgs as the system
    useGlobalPkgs = true;
    
    # Install packages to /etc/profiles instead of ~/.nix-profile
    useUserPackages = true;
    
    # Pass additional arguments to home-manager modules
    extraSpecialArgs = { };
    
    # Backup existing files instead of erroring
    backupFileExtension = "backup";

    # User configuration
    users.kotoxik = { pkgs, ... }: {
      # Let Home Manager manage itself
      programs.home-manager.enable = true;

      # Home state version - don't change after initial setup
      home.stateVersion = "24.11";

      # User-specific packages managed by Home Manager
      home.packages = with pkgs; [
        # Add user packages here
      ];

      # Git configuration
      programs.git = {
        enable = true;
        userName = "kotoxik";
        # userEmail = "your@email.com";  # Set your email
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
        };
      };

      # Shell configuration (bash example)
      programs.bash = {
        enable = true;
        shellAliases = {
          ll = "ls -la";
          nrs = "sudo nixos-rebuild switch --flake .";
          nrt = "sudo nixos-rebuild test --flake .";
        };
      };

      # Additional dotfiles and configurations can be added here
      # Example: xdg.configFile."app/config".text = "...";
    };
  };
}
