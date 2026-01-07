{ config, lib, pkgs, ... }:

{
  imports = [
    ./rythmos.nix
  ];

  # Secret management tools
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  # SOPS base configuration
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;

    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  # Age key setup via home-manager
  home-manager.users.kotoxik = { pkgs, ... }: {
    home.file.".config/sops/age/.keep".text = "";
  };
}
