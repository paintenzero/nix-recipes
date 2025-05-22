{ inputs, username, packages, ... }: {
  home-manager = {
    users.${username} = { pkgs, ... }: {
      home.packages = with pkgs; [ protonup lutris packages.master.heroic ];
      home.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS =
          "/home/${username}/.steam/root/compatibilitytools.d";
      };
    };
  };
}
