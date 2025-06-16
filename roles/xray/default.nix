{ lib, config, pkgs, ... }: let
  user_id = (builtins.readFile /run/secrets/xray/user_id);
in {
  services.xray = {
    enable = true;
    settingsFile = "/run/secrets/xray/config";
  }; # services.xray
}
