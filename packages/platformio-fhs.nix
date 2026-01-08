{ buildFHSEnv
, platformio-core
, python3
, python3Packages
, git
, gcc
, gnumake
, cmake
, ninja
, stdenv
, zlib
, libusb1
, libftdi1
, picocom
, minicom
, cacert
}:

buildFHSEnv {
  name = "platformio";
  
  targetPkgs = pkgs: with pkgs; [
    platformio-core
    python3
    python3Packages.pip
    python3Packages.virtualenv
    git
    
    # Essential build tools for embedded toolchains
    gcc
    gnumake
    cmake
    ninja
    
    # Libraries that embedded toolchains might need
    stdenv.cc.cc.lib
    zlib
    libusb1
    libftdi1
    
    # Serial port access
    picocom
    minicom
  ];
  
  multiPkgs = pkgs: with pkgs; [
    # 32-bit support for some toolchains
    zlib
  ];
  
  runScript = "platformio";
  
  profile = ''
    export PLATFORMIO_CORE_DIR="$HOME/.platformio"
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';
}
