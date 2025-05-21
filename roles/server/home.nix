{ inputs, username, ... }: {
  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9e25d7pHU1oQHcKjWpgOMrI70HCVt/yUyxJlCg7Pb3ixgclVSTKVHdPPZbLRj4lxzOL+rXJbcLfljrC/etSkN+MX8mkL4r6yuAj82J21c01XhA/jISsFMzplssv3rBIrJGUMniLi6KCayWmT2TIvGRffv5kJvlM2EIg5HlrDfUbpuCF8Eul+AWT+H91q2q9iRZN9ZxeP6FOMQWbe5hbV+vHmwvpEaVgJ39HN9zfIhQUp7TDq6+f1keAOw9AOB6WMm72eYkVyP1fxMRylw5foq0XdWb7FlaOyq4g5FIZHRpSMftq4K6LC+luJ6BwvXqIEi9uJmVmAmTSzz0xtF9D2b" ];
    hashedPasswordFile = "/persist/passwords/sergey";
  };

  home-manager = {
    users.${username} = { pkgs, ... }: {
      imports = [ 
        ../user-default.nix
      #  "${inputs.impermanence}/home-manager.nix"
      ];
    };
  };
}
