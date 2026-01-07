{ config, lib, pkgs, ... }:

{
  users.users.kotoxik = {
    isNormalUser = true;
    description = "kotoxik";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"      # Serial port access
      "uucp"         # Alternative serial port group
      "adbusers"     # Android Debug Bridge
      "kvm"          # Virtualization
      "video"        # Video devices access
      "audio"        # Audio devices access
    ];
    
    # User-specific packages are now managed by Home Manager
    # See: home/kotoxik/programs.nix
  };
}
