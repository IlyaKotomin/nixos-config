{ config, lib, pkgs, ... }:

{
  # Embedded development tools
  environment.systemPackages = with pkgs; [
    # PlatformIO in FHS environment
    platformioFHS
    
    # ESP tools
    esptool
    esphome
    
    # Debugging and flashing
    openocd
    avrdude
    
    # Serial communication
    picocom
    minicom
    screen
    
    # Additional embedded tools
    stlink
    dfu-util
  ];

  # Udev rules for embedded development boards
  services.udev.packages = with pkgs; [
    platformio-core.udev
    openocd
  ];

  # PlatformIO environment variable
  environment.sessionVariables = {
    PLATFORMIO_CORE_DIR = "$HOME/.platformio";
  };
}
