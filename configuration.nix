# configuration.nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Kernel: Zen for lower latency ---
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  # Prefer modern AMD CPU frequency driver
  boot.kernelParams = [ "amd_pstate=active" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Sofia";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # GUI
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us, ru";
    variant = "";
    xkbOptions = "grp:alt_shift_toggle";
  };

  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Proton/older games need this
    pulse.enable = true;
  };

  # === GPU & Graphics (Vulkan/OpenGL + 32-bit) ===
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiVdpau ];
  };

  # --- NVIDIA discrete setup (Ampere: RTX 3070 Mobile) ---
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;    # better thermals on laptops
    nvidiaSettings = true;            # nvidia-settings GUI
    open = false;                     # <-- closed kernel module (builds fine with Zen)
    # package = config.boot.kernelPackages.nvidiaPackages.production; # default driver
  };

  # === Steam & Gaming QoL ===
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    # gamescopeSession.enable = true;  # leave off unless you want it as your default session
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;     # udev rules for controllers
  # hardware.xpadneo.enable = true;          # uncomment if you use Xbox BT controllers

  programs.gamemode.enable = true;

  # Let Gamemode toggle power profiles for you
  services.power-profiles-daemon.enable = true;

  # Gamescope compositor (for pacing/upscaling)
  programs.gamescope = {
    enable = true;
    capSysNice = true;  # small latency/scheduling improvement
  };

  # Wayland: Steam + Electron apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  xdg.portal.xdgOpenUsePortal = true;

  # --- Compressed RAM swap to avoid rare stalls ---
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # --- User & packages ---
  users.users.kotoxik = {
    isNormalUser = true;
    description = "kotoxik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      goverlay          # GUI for MangoHud/Gamescope
      protonup-qt       # Proton-GE installer
      protontricks      # Winetricks-like for Proton
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vscodium
    direnv
    vesktop
    mangohud       # use via launch options (no module on this channel)
    gamescope
    vulkan-tools   # vulkaninfo / vkcube
  ];

  system.stateVersion = "25.05";
}
