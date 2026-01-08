{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
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
      
      # Fonts for comprehensive Unicode support
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans      # Chinese, Japanese, Korean
      noto-fonts-cjk-serif
      noto-fonts-emoji         # Emoji support
      noto-fonts-color-emoji
      font-awesome             # Icons
      liberation_ttf
      dejavu_fonts
      fira-code
      fira-code-symbols
      source-han-sans          # Additional CJK font
      source-han-serif
      wqy_zenhei               # Chinese font
      unifont                  # Fallback for rare characters
    ];

    # XDG portal for Hyprland
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    
    # Ensure fontconfig is enabled system-wide
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [ "Noto Serif" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Serif CJK KR" ];
          sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Sans CJK KR" ];
          monospace = [ "JetBrains Mono" "Noto Sans Mono CJK SC" "Noto Sans Mono CJK TC" "Noto Sans Mono CJK JP" "Noto Sans Mono CJK KR" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
