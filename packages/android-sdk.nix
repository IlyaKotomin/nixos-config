{ androidenv }:

let
  androidComposition = androidenv.composeAndroidPackages {
    # Build tools and platforms for React Native/Expo
    # Include latest stable versions
    buildToolsVersions = [ "35.0.0" "34.0.0" "33.0.2" "30.0.3" ];
    platformVersions = [ "35" "34" "33" "31" "30" "29" ];
    
    # Include CMake and NDK for native modules
    cmakeVersions = [ "3.22.1" ];
    ndkVersions = [ "26.1.10909125" "25.1.8937393" ];
    
    # Include system images for emulators
    includeSystemImages = true;
    systemImageTypes = [ "google_apis_playstore" "google_apis" ];
    abiVersions = [ "x86_64" "arm64-v8a" ];
    
    # Extra packages
    includeEmulator = true;
    includeNDK = true;
    includeSources = false;
    
    # Additional tools
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
in
{
  inherit androidComposition;
  
  # Expose the SDK for use in environment variables
  androidSdk = androidComposition.androidsdk;
}
