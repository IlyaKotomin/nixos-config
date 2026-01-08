{ config, lib, pkgs, ... }:

{
  # User-specific packages managed by Home Manager
  home.packages = with pkgs; [
    # Text editors
    kdePackages.kate

    # Communication
    vencord
    slack
    telegram-desktop

    # Media & Entertainment
    spotify

    # Utilities
    qbittorrent

    # CLI tools
    ripgrep
    fd
    bat
    eza
    fzf
    tldr
    
    # Archive tools (p7zip only, unzip/zip are system-wide)
    p7zip
  ];
}
