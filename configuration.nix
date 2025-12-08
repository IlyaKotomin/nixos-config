{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ################################
  ## Boot / Kernel
  ################################

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel: Zen for lower latency.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Prefer modern AMD CPU frequency driver.
  boot.kernelParams = [ "amd_pstate=active" ];

  ################################
  ## Networking / Locale
  ################################

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

  ################################
  ## GUI (Plasma 6 + SDDM)
  ################################

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  ################################
  ## Audio (PipeWire)
  ################################

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Proton/older games need this.
    pulse.enable = true;
  };

  ################################
  ## GPU / Graphics (Nvidia + Vulkan + 32-bit)
  ################################

  # New-style graphics module.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      vulkan-loader
    ];
  };

  # Use Nvidia driver for X.
  services.xserver.videoDrivers = [ "nvidia" ];

  # Nvidia configuration (RTX 3070 Laptop).
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false; # safer on laptops.

    nvidiaSettings = true;
    open = false; # Proprietary module is recommended for 30xx mobile.

    # PRIME offload: run games on the dGPU.
    prime = {
      offload.enable = true;

      # IMPORTANT: verify these with:
      #   lspci | grep -E "VGA|3D"
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # You can override the driver like this if needed:
    # package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  ################################
  ## Steam / Gaming
  ################################

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    # gamescopeSession.enable = true; # leave off unless you want it as default session.
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;
  # hardware.xpadneo.enable = true; # uncomment if you use Xbox BT controllers.

  # Feral gamemode for per-game performance tweaks.
  programs.gamemode.enable = true;

  # Let power-profiles-daemon exist; gamemode can interact with it.
  services.power-profiles-daemon.enable = true;

  # CPU governor: good default with amd_pstate=active.
  powerManagement.cpuFreqGovernor = "schedutil";
  # For max performance at the cost of power/heat:
  # powerManagement.cpuFreqGovernor = "performance";

  # Gamescope compositor (optional, for frame pacing/upscaling).
  programs.gamescope = {
    enable = true;
    capSysNice = true; # small latency/scheduling improvement.
  };

  ################################
  ## Session env / Portals
  ################################

  environment.sessionVariables = {
    # Prefer Wayland when possible for Electron / Chromium apps.
    NIXOS_OZONE_WL = "1";

    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";

    # Cert path is fine, but avoid hardcoding passwords here.
    RYTHMOS_CERT_PATH = "/home/kotoxik/certs/certificate.pfx";
    RYTHMOS_CERT_PASSWORD = "";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  xdg.portal.xdgOpenUsePortal = true;

  ################################
  ## Memory / Swap
  ################################

  # Compressed RAM swap to avoid rare stalls.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  ################################
  ## User & Packages
  ################################

  users.users.kotoxik = {
    isNormalUser = true;
    description = "kotoxik";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout" # needed for /dev/ttyUSB*
      "uucp"    # optional, some distros use this for serial
    ];
    packages = with pkgs; [
      kdePackages.kate
      goverlay          # GUI for MangoHud/Gamescope.
      protonup-qt       # Proton-GE installer.
      protontricks      # Winetricks-like for Proton.
    ];
  };

  ################################
  ## System Packages (incl. Azure Functions FHS env)
  ################################

  environment.systemPackages =
    let
      azureFunctionsEnv = pkgs.buildFHSEnvBubblewrap {
        pname = "azure-functions-cli-bin";
        version = "4.0.6821";
        runScript = "func";

        targetPkgs = pkgs: [
          (pkgs.callPackage ./azure-functions-cli-bin.nix { })
          pkgs.dotnetCorePackages.dotnet_8.sdk
          pkgs.nodejs_22
          pkgs.azure-cli
        ];
      };
    in
    with pkgs; [
      git
      vscodium
      direnv
      vesktop
      mangohud       # use via launch options: "mangohud %command%"
      gamescope
      vulkan-tools   # vulkaninfo / vkcube.

      # IDEs.
      jetbrains.rider
      jetbrains.webstorm
      jetbrains.datagrip

      # SDKs.
      dotnetCorePackages.dotnet_8.sdk
      nodejs_22
      azure-cli

      # Other for work.
      slack

      # FHS-wrapped Azure Functions CLI (run as: azure-functions-cli-bin).
      azureFunctionsEnv

      # Embedded development.
      esptool

      # 3D
      prusa-slicer
    ];

  ################################
  ## Docker / Azurite
  ################################

  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.azurite = {
      image = "mcr.microsoft.com/azure-storage/azurite";
      volumes = [
        "/var/lib/azurite:/data"
      ];
      ports = [
        "10000:10000" # Blob
        "10001:10001" # Queue
        "10002:10002" # Table
      ];
      cmd = [
        "azurite"
        "--location" "/data"
        "--blobHost" "0.0.0.0"
        "--queueHost" "0.0.0.0"
        "--tableHost" "0.0.0.0"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/azurite 0755 root root -"
  ];

  ################################
  ## NixOS Version
  ################################

  system.stateVersion = "25.05";
}
