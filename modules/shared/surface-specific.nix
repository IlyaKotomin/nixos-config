{ config, lib, pkgs, ... }:

{
  # Microsoft Surface specific configuration
  # This module should only be imported for Surface devices
  # Requires nixos-hardware.nixosModules.microsoft-surface-common
  
  # Touch screen support with IPTSD
  services.iptsd = {
    enable = true;
    config = {
      Config = {
        BlockOnPalm = true;
        TouchThreshold = 20;
        StabilityThreshold = 0.1;
      };
    };
  };

  # Surface-specific kernel configuration
  # The kernelVersion option is provided by nixos-hardware module
  # Options: "longterm" (LTS) or "stable" (latest stable)
  hardware.microsoft-surface.kernelVersion = lib.mkDefault "longterm";

  # WORKAROUND: Volume buttons support
  # The pinctrl module needs to be loaded explicitly
  boot.kernelModules = [ "pinctrl_sunrisepoint" ];

  # WORKAROUND: Disable problematic camera module to fix audio
  # This prevents libcamera from crashing wireplumber
  # If you need camera support, consider using the wireplumber overlay instead
  boot.blacklistedKernelModules = [ 
    "ipu3_imgu"
  ];

  # Alternative camera fix using wireplumber overlay (commented out by default)
  # Uncomment if you need camera support - requires longer rebuild time
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     wireplumber = prev.wireplumber.overrideAttrs (_: {
  #       version = "git";
  #       src = prev.fetchFromGitLab {
  #         domain = "gitlab.freedesktop.org";
  #         owner = "pipewire";
  #         repo = "wireplumber";
  #         rev = "71f868233792f10848644319dbdc97a4f147d554";
  #         hash = "sha256-VX3OFsBK9AbISm/XTx8p05ak+z/VcKXfUXhB9aI9ev8=";
  #       };
  #     });
  #
  #     libcamera = prev.libcamera.overrideAttrs (_: {
  #       postFixup = ''
  #         ../src/ipa/ipa-sign-install.sh src/ipa-priv-key.pem $out/lib/libcamera/ipa_*.so
  #       '';
  #     });
  #   })
  # ];

  # Power management for better battery life
  services.power-profiles-daemon.enable = true;
  
  # TLP should be avoided or carefully configured on Surface devices
  # See: https://github.com/linux-surface/linux-surface#power-management
  services.tlp.enable = lib.mkForce false;

  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  # Auto-rotate screen support (optional)
  # hardware.sensor.iio.enable = true;

  # Surface Control utility for performance modes
  # Add user to 'surface-control' group to use without sudo
  # microsoft-surface.surface-control.enable = true;
}
