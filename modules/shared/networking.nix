{ config, lib, pkgs, ... }:

let
  cfg = config.modules.networking;
in
{
  options.modules.networking = {
    enable = lib.mkEnableOption "networking configuration" // {
      default = true;
    };
    
    developmentPorts = {
      enable = lib.mkEnableOption "open common development ports";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = lib.mkDefault "nixos"; # Override in host-specific config
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
      
      # Firewall configuration
      firewall = {
        enable = true;
        
        # Common development ports
        allowedTCPPorts = lib.optionals cfg.developmentPorts.enable [
          # Expo/React Native
          8081  # Metro bundler
          19000 # Expo Dev Tools
          19001 # Expo Dev Tools
          19002 # Expo Dev Tools
          
          # Common web development
          3000  # React/Next.js default
          4200  # Angular default
          5173  # Vite default
          8080  # Alternative HTTP
        ];
        
        allowedUDPPorts = lib.optionals cfg.developmentPorts.enable [
          19000 # Expo LAN connection
          19001 # Expo LAN connection
        ];
        
        trustedInterfaces = [ "lo" ]; # localhost
      };
    };
  };
}
