{ inputs, ... }:

final: prev: {
  # Custom packages overlay
  azureFunctionsCli = prev.callPackage ../packages/azure-functions-cli-bin.nix { };
  platformioFHS = prev.callPackage ../packages/platformio-fhs.nix { };
  androidSdkCustom = prev.callPackage ../packages/android-sdk.nix { };
}
