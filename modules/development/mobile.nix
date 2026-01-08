{ config, lib, pkgs, ... }:

let
  cfg = config.modules.development.mobile;
  androidSdkConfig = pkgs.androidSdkCustom;
in
{
  options.modules.development.mobile = {
    enable = lib.mkEnableOption "mobile development tools (Android, React Native)";
  };

  config = lib.mkIf cfg.enable {
    # Android development configuration
    programs.adb.enable = true;

    # Environment variables for React Native and Android
    environment.sessionVariables = {
      ANDROID_HOME = "${androidSdkConfig.androidSdk}/libexec/android-sdk";
      ANDROID_SDK_ROOT = "${androidSdkConfig.androidSdk}/libexec/android-sdk";
      ANDROID_NDK_ROOT = "${androidSdkConfig.androidSdk}/libexec/android-sdk/ndk-bundle";
      JAVA_HOME = "${pkgs.jdk17}";
      CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
    };

    # Mobile development packages
    environment.systemPackages = with pkgs; [
      # Android
      android-studio
      android-tools        # adb, fastboot, etc.
      androidSdkConfig.androidSdk
      
      # Java
      jdk17
      
      # React Native / Expo
      watchman            # File watching for React Native
      nodePackages.eas-cli # Expo Application Services CLI
      # Note: expo-cli is deprecated, use 'npx expo' instead
      
      # Build tools
      gradle
      kotlin
      
      # Browser for debugging
      google-chrome
    ];

    # Note: android-udev-rules has been removed (superseded by systemd uaccess rules)
    # programs.adb.enable = true (above) automatically handles Android device permissions
  };
}
