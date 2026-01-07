{ config, lib, pkgs, ... }:

{
  # Hyprland Wayland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Required for Hyprland
  environment.systemPackages = with pkgs; [
    waybar           # Status bar
    dunst            # Notification daemon
    rofi             # Application launcher
    swww             # Wallpaper daemon
    kitty            # Terminal emulator
    
    # Screenshot and screen recording
    grim
    slurp
    wl-clipboard
    
    # File manager
    kdePackages.dolphin
  ];

  # XDG portal for Hyprland
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
}
