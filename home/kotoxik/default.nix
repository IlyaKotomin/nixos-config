{ config, lib, pkgs, hostName, ... }:

{
  imports = [
    ../common
    ../desktop
  ] ++ lib.optionals (hostName == "lenovo-legion") [
    ../hosts/lenovo-legion.nix
  ] ++ lib.optionals (hostName == "surface-pro") [
    ../hosts/surface-pro.nix
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Home state version - don't change after initial setup
  home.stateVersion = "25.11";

  # User info
  home.username = "kotoxik";
  home.homeDirectory = "/home/kotoxik";

  # Allow unfree packages in Home Manager
  nixpkgs.config.allowUnfree = true;

  # Session variables
  home.sessionVariables = {
    VISUAL = "code";
  };

  # Session path additions
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
