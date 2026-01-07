{ config, lib, pkgs, ... }:

{
  # Docker and container runtime
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Azurite - Azure Storage Emulator
  virtualisation.oci-containers = {
    backend = "docker";

    containers.azurite = {
      image = "mcr.microsoft.com/azure-storage/azurite";
      autoStart = true;
      
      volumes = [
        "/var/lib/azurite:/data"
      ];
      
      ports = [
        "10000:10000" # Blob service
        "10001:10001" # Queue service
        "10002:10002" # Table service
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

  # Create azurite data directory
  systemd.tmpfiles.rules = [
    "d /var/lib/azurite 0755 root root -"
  ];
}
