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
    
    # User-specific packages
    packages = with pkgs; [
      kdePackages.kate
      
      # Communication
      vencord
      slack
      telegram-desktop
      
      # Utilities
      qbittorrent
      spotify
    ];
  };
}
