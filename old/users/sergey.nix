{ pkgs, pkgs-unstable, unstable, ... }@inputs:
let
  userSettings = {
    username = "sergey";
    sshKey =
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9e25d7pHU1oQHcKjWpgOMrI70HCVt/yUyxJlCg7Pb3ixgclVSTKVHdPPZbLRj4lxzOL+rXJbcLfljrC/etSkN+MX8mkL4r6yuAj82J21c01XhA/jISsFMzplssv3rBIrJGUMniLi6KCayWmT2TIvGRffv5kJvlM2EIg5HlrDfUbpuCF8Eul+AWT+H91q2q9iRZN9ZxeP6FOMQWbe5hbV+vHmwvpEaVgJ39HN9zfIhQUp7TDq6+f1keAOw9AOB6WMm72eYkVyP1fxMRylw5foq0XdWb7FlaOyq4g5FIZHRpSMftq4K6LC+luJ6BwvXqIEi9uJmVmAmTSzz0xtF9D2b";
  };
in {

  users.users.${userSettings.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "dialout"
      "audio"
      "adbusers"
      "docker"
      "libvirtd"
      "tty"
      "video"
    ];
    openssh.authorizedKeys.keys = [ userSettings.sshKey ];
  };

  home-manager = {
    extraSpecialArgs = { inherit pkgs pkgs-unstable unstable userSettings; };

    users.${userSettings.username} = { pkgs, ... }: {
      imports = [ ./default.nix ];
      home = {
        username = userSettings.username;
        homeDirectory = "/home/${userSettings.username}";
        stateVersion = "24.11";
      };

      gaming.enable = true;
      vscode.enable = true;
      messaging.enable = true;
      kitty.enable = true;
      rclone.enable = true;
      cursor.enable = true;
      windsurf.enable = true;
      zed-editor.enable = true;
      programs.bash.enable = true;

      programs.neovim.enable = true;
      home.packages = with pkgs; [ nixfmt ];

      programs.home-manager.enable = true;
      programs.git = {
        enable = true;
        userName = "Sergei Biriukov";
        userEmail = "sergeyb26@gmail.com";
        extraConfig.init.defaultBranch = "main";
      };

      programs.helix = {
        enable = true;
        settings = {
          theme = "catppuccin_macchiato";
          editor.cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
        };
        languages.language = [{
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }];
        defaultEditor = true;
      };

      systemd.user.startServices = "sd-switch";

    };
  };
}
