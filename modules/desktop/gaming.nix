{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.gaming;
in
{
  options.modules.desktop.gaming = {
    enable = lib.mkEnableOption "gaming support with Steam, GameMode, etc.";
  };

  config = lib.mkIf cfg.enable {
    # Steam and gaming configuration
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    hardware.steam-hardware.enable = true;

    # Gamemode for performance tweaks
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    # Gamescope compositor for HDR and frame pacing
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    # Gaming utilities and tools
    environment.systemPackages = with pkgs; [
      mangohud         # FPS overlay and performance monitoring
      goverlay         # GUI for MangoHud configuration
      protonup-qt      # Proton-GE installer
      protontricks     # Winetricks for Proton games
      lutris           # Game launcher
      gamemode         # Performance optimizer
      vulkan-tools     # vulkaninfo, vkcube for testing
    ];

    # Graphics optimization
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        vulkan-loader
        vulkan-validation-layers
      ];
      
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva-vdpau-driver
        vulkan-loader
      ];
    };
  };
}
