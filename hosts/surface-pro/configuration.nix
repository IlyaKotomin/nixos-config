{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "surface-pro";

  # Linux Surface kernel with patches for Surface hardware
  # The linux-surface kernel is pulled in by nixos-hardware module

  # Additional Surface-specific boot parameters
  boot.kernelParams = [
    # Enable Intel Graphics
    "i915.enable_fbc=1"
    "i915.enable_psr=2"
  ];

  # Intel graphics support
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };

  # Intel video drivers
  services.xserver.videoDrivers = [ "modesetting" ];

  # CPU governor optimized for battery life
  powerManagement.cpuFreqGovernor = "powersave";

  # Additional touchscreen/pen support packages
  environment.systemPackages = with pkgs; [
    # System monitoring
    intel-gpu-tools
    powertop
    
    # Note-taking with pen support
    xournalpp
    
    # Screen rotation utility
    wdisplays
  ];

  # Enable SSH for remote deployment
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Tablet-optimized settings
  # Increase font DPI for better readability on high-DPI screen
  # services.xserver.dpi = 150;

  # Automatic screen rotation based on orientation (optional)
  # services.iio-sensor-proxy.enable = true;
}
