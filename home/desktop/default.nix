{ config, lib, pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./gtk.nix
    ./waybar.nix
    ./hyprland.nix
  ];
}
