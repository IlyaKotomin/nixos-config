{ config, lib, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./programs.nix
    ./development.nix
  ];

  # SOPS age key setup for user
  home.file.".config/sops/age/.keep".text = "";
}
