{ lib, ... }:

{
  # Helper to create a host configuration
  mkHost = { hostname, system ? "x86_64-linux", modules ? [] }:
    lib.nixosSystem {
      inherit system;
      modules = modules;
      specialArgs = { inherit hostname; };
    };
  
  # Helper to conditionally include modules
  optionalModule = condition: module:
    lib.optional condition module;
}
