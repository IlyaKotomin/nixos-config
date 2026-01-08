{ config, lib, pkgs, ... }:

let
  cfg = config.modules.development.general;
in
{
  options.modules.development.general = {
    enable = lib.mkEnableOption "general development tools and IDEs";
  };

  config = lib.mkIf cfg.enable {
    # System-level development tools and IDEs
    # User-specific tools are managed by Home Manager (home/common/development.nix)
    
    environment.systemPackages = with pkgs; [
      # JetBrains suite (system-wide for licensing)
      jetbrains.rider       # .NET IDE
      jetbrains.webstorm    # JavaScript/TypeScript IDE
      jetbrains.datagrip    # Database IDE
      
      # SDKs and runtimes (system-wide)
      dotnetCorePackages.dotnet_8.sdk
      dotnetCorePackages.dotnet_9.sdk
      
      # Azure tools
      azure-cli
      # Note: Azure Functions CLI available as custom package (azureFunctionsCli)
      # Uncomment in host config if needed
      
      # Version control (system-wide)
      git-lfs
      github-desktop
    ];

    # Environment variables for .NET
    environment.sessionVariables = {
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";
      DOTNET_ROOT = "${pkgs.dotnetCorePackages.dotnet_8.sdk}";
    };

    # Enable direnv integration (system-wide)
    programs.direnv.enable = true;
  };
}
