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

    # User configurations
    users.kotoxik = import ./kotoxik;
  };
}
