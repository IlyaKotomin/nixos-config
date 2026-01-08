{ config, lib, pkgs, ... }:

{
  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Locale and timezone
  time.timeZone = "Europe/Sofia";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "bg_BG.UTF-8";
      LC_IDENTIFICATION = "bg_BG.UTF-8";
      LC_MEASUREMENT = "bg_BG.UTF-8";
      LC_MONETARY = "bg_BG.UTF-8";
      LC_NAME = "bg_BG.UTF-8";
      LC_NUMERIC = "bg_BG.UTF-8";
      LC_PAPER = "bg_BG.UTF-8";
      LC_TELEPHONE = "bg_BG.UTF-8";
      LC_TIME = "bg_BG.UTF-8";
    };
  };

  # Enable printing support
  services.printing.enable = true;

  # Audio with PipeWire
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Compressed RAM swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python3.12-ecdsa-0.19.1"
    ];
    android_sdk.accept_license = true;
  };

  # Nix settings for flakes and performance
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Common system packages
  environment.systemPackages = with pkgs; [
    # Essential utilities
    git
    wget
    curl
    htop
    tree
    unzip
    zip
    
    # File management
    ranger
    
    # Network tools
    iftop
    nethogs
  ];

  # XDG portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Wayland support for Electron apps
    NIXPKGS_ALLOW_INSECURE = "1";
  };

  # NixOS version (update this when you upgrade)
  system.stateVersion = "25.11";
}
