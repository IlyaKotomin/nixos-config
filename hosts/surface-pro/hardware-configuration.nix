# Hardware configuration for Microsoft Surface Pro 7
# This is a template - generate actual config with: nixos-generate-config
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Filesystems - UPDATE THESE WITH YOUR ACTUAL UUIDs
  # Run 'blkid' to find your device UUIDs
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Swap - UPDATE WITH YOUR SWAP UUID
  swapDevices = [
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-SWAP-UUID"; }
  ];

  # Networking
  networking.useDHCP = lib.mkDefault true;
  
  # CPU microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
