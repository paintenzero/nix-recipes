{ inputs, username, packages, ... }: {
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" ];
    initialPassword = username;
  };

  home-manager = {
    users.${username} = { pkgs, ... }: {
      imports = [ ../user-default.nix ];
      rclone.enable = true;
      kitty.enable = true;
      messaging.enable = true;

      home.packages = with packages.stable; [ remmina rustdesk ];
    };
  };
}
