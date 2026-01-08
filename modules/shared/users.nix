{ config, lib, pkgs, ... }:

let
  cfg = config.modules.users.kotoxik;
in
{
  options.modules.users.kotoxik = {
    enable = lib.mkEnableOption "kotoxik user account" // {
      default = true;
    };
    
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "networkmanager"
        "wheel"
        "video"        # Video devices access
        "audio"        # Audio devices access
      ];
      description = "Additional groups for the user";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.kotoxik = {
      isNormalUser = true;
      description = "kotoxik";
      extraGroups = cfg.extraGroups;
      
      # User-specific packages are now managed by Home Manager
      # See: home/common/
    };
  };
}
