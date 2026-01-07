{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "lenovo-legion";

  # Zen kernel for lower latency and better gaming performance
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # AMD CPU frequency driver
  boot.kernelParams = [ "amd_pstate=active" ];

  # CPU governor for performance
  # Use "schedutil" for balanced performance/power
  # Use "performance" for maximum performance
  powerManagement.cpuFreqGovernor = "schedutil";

  # Power profiles daemon for gamemode integration
  services.power-profiles-daemon.enable = true;

  # NVIDIA Configuration for RTX 3070 Mobile
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Power management - disabled because nvidia-powerd fails with PRIME offload
    # The GPU will be powered off when not in use via PRIME offload mechanism
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Settings panel
    nvidiaSettings = true;

    # Use proprietary driver (recommended for 30xx mobile)
    open = false;

    # PRIME offload configuration
    # Note: Using lib.mkForce because nixos-hardware sets this to false
    prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = true;
      };

      # Verify these PCI bus IDs with: lspci | grep -E "VGA|3D"
      # May change if you have multiple drives installed
      amdgpuBusId = "PCI:5:0:0";  # Use "PCI:6:0:0" with 2 drives
      nvidiaBusId = "PCI:1:0:0";
    };

    # Dynamic boost support for performance profiles (Fn + Q)
    dynamicBoost.enable = lib.mkDefault true;
  };

  # Additional system packages for this host
  environment.systemPackages = with pkgs; [
    # NVIDIA tools
    nvtopPackages.full
    
    # Performance monitoring
    s-tui
    
    # Azure Functions CLI (custom package)
    # azureFunctionsCli  # Uncomment if needed
  ];

  # Enable SSH for remote deployment
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Mask nvidia-powerd service as it fails with PRIME offload configuration
  # The service is enabled by nixos-hardware but incompatible with our setup
  systemd.services.nvidia-powerd.enable = lib.mkForce false;

  # Secrets are managed via sops-nix
  # Environment variables loaded from /run/secrets/rendered/rythmos.env
  # See: modules/shared/secrets.nix and docs/SECRETS.md
}
