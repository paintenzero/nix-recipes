{ lib, config, pkgs, ... }: {
  options = { gaming.enable = lib.mkEnableOption "Enables gaming for user"; };

  config = lib.mkIf config.gaming.enable {
    home.packages = with pkgs; [ protonup lutris heroic bottles ];
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "/home/${config.home.username}/.steam/root/compatibilitytools.d";
    };
  };
}
