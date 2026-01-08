{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.kde;
in
{
  options.modules.desktop.kde = {
    enable = lib.mkEnableOption "KDE Plasma 6 desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # KDE Plasma 6 desktop environment
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Keyboard layout
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Additional KDE portal
    xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

    # Enable Firefox
    programs.firefox.enable = true;
  };
}
