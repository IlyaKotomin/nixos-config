{ config, lib, pkgs, ... }:

{
  imports = [
    ./programs.nix
    ./shell.nix
    ./git.nix
    ./development.nix
    ./desktop.nix
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
    EDITOR = "vim";
    VISUAL = "code";
  };

  # Session path additions
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
