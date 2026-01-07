{ config, lib, pkgs, ... }:

{
  sops.secrets = {
    "rythmos/cert-path" = {
      owner = "kotoxik";
      group = "users";
      mode = "0400";
    };

    "rythmos/cert-password" = {
      owner = "kotoxik";
      group = "users";
      mode = "0400";
    };
  };

  sops.templates."rythmos-env" = {
    content = ''
      RYTHMOS_CERT_PATH=${config.sops.placeholder."rythmos/cert-path"}
      RYTHMOS_CERT_PASSWORD=${config.sops.placeholder."rythmos/cert-password"}
    '';
    path = "/run/secrets/rendered/rythmos.env";
    owner = "kotoxik";
    group = "users";
    mode = "0400";
  };

  environment.etc."profile.d/load-rythmos.sh" = {
    mode = "0444";
    text = ''
      if [ -f /run/secrets/rendered/rythmos.env ]; then
        set -a
        source /run/secrets/rendered/rythmos.env
        set +a
      fi
    '';
  };
}
