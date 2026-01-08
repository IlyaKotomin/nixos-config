{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
    enable = lib.mkEnableOption "Docker container runtime";
    
    azurite = {
      enable = lib.mkEnableOption "Azurite Azure Storage Emulator";
      
      blobPort = lib.mkOption {
        type = lib.types.port;
        default = 10000;
        description = "Port for Azurite Blob service";
      };
      
      queuePort = lib.mkOption {
        type = lib.types.port;
        default = 10001;
        description = "Port for Azurite Queue service";
      };
      
      tablePort = lib.mkOption {
        type = lib.types.port;
        default = 10002;
        description = "Port for Azurite Table service";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # Docker and container runtime
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
      };
    })
    
    (lib.mkIf cfg.azurite.enable {
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
            "${toString cfg.azurite.blobPort}:10000"  # Blob service
            "${toString cfg.azurite.queuePort}:10001" # Queue service
            "${toString cfg.azurite.tablePort}:10002" # Table service
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
    })
  ];
}
