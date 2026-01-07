{ config, lib, pkgs, ... }:

let
  androidSdkConfig = pkgs.androidSdkCustom;
in
{
  # General development tools and IDEs
  environment.systemPackages = with pkgs; [
    # Editors and IDEs
    vscode
    
    # JetBrains suite
    jetbrains.rider       # .NET IDE
    jetbrains.webstorm    # JavaScript/TypeScript IDE
    jetbrains.datagrip    # Database IDE
    
    # SDKs and runtimes
    dotnetCorePackages.dotnet_8.sdk
    dotnetCorePackages.dotnet_9.sdk
    nodejs_22
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    
    # Azure tools
    azure-cli
    # Note: Azure Functions CLI available as custom package (azureFunctionsCli)
    # Uncomment in host config if needed
    
    # Deployment tools
    flyctl
    
    # Version control
    git
    git-lfs
    gh              # GitHub CLI
    github-desktop
    
    # Utilities
    direnv
    jq              # JSON processor
    yq              # YAML processor
  ];

  # Environment variables for .NET
  environment.sessionVariables = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.dotnet_8.sdk}";
  };

  # Enable direnv integration
  programs.direnv.enable = true;
}
