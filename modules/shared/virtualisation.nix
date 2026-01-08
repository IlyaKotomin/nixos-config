{ config, lib, pkgs, ... }:

let
  cfg = config.modules.virtualisation;
in
{
  options.modules.virtualisation = {
    enable = lib.mkEnableOption "KVM virtualization support";
    
    kvmType = lib.mkOption {
      type = lib.types.enum [ "intel" "amd" ];
      default = "amd";
      description = "Type of KVM module to load (intel or amd)";
    };
  };

  config = lib.mkIf cfg.enable {
    # KVM support (no full libvirt)
    boot.kernelModules = [ 
      (if cfg.kvmType == "intel" then "kvm-intel" else "kvm-amd")
    ];
    virtualisation.libvirtd.enable = false;
  };
}
