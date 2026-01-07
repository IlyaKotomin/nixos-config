{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = lib.mkDefault "nixos"; # Override in host-specific config
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    
    # Firewall configuration - development friendly
    firewall = {
      enable = true;
      
      # Common development ports
      allowedTCPPorts = [
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
      
      allowedUDPPorts = [
        19000 # Expo LAN connection
        19001 # Expo LAN connection
      ];
      
      trustedInterfaces = [ "lo" ]; # localhost
    };
  };
}
