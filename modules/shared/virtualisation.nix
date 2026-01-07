{ config, lib, pkgs, ... }:

{
  # KVM support (no full libvirt)
  boot.kernelModules = [ "kvm-amd" ]; # Use "kvm-intel" for Intel CPUs
  virtualisation.libvirtd.enable = false;
}
