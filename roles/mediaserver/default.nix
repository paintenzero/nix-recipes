{ lib, config, pkgs, ... }: let
  zurg = pkgs.callPackage ../../apps/zurg/package.nix {};
in {
  environment.systemPackages = [
    zurg
  ];

  environment.etc."zurg/config.yaml.tpl" = {
    text = builtins.readFile ./zurg.yaml.tpl;
    mode = "0644";
  };
  environment.etc."zurg/create_config.sh" = {
    text = builtins.readFile ./create_zurg_config.sh;
    mode = "0755";
  };
  environment.etc."zurg/rclone.conf" = {
    text = builtins.readFile ./zurg_rclone.conf;
    mode = "0644";
  };

  systemd.services.zurg = {
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "remote-fs.target" ];
    
    serviceConfig = {
      Restart = "always";
      WorkingDirectory = "/etc/zurg";
      StandardOutput = "file:/var/log/zurg.log";
      StandardError = "file:/var/log/zurg.log";
      ExecStartPre = [ 
        "${pkgs.bash}/bin/bash /etc/zurg/create_config.sh"
        "-${pkgs.coreutils-full}/bin/mkdir -p /media/zurg"
      ];
      ExecStart = "${zurg}/bin/zurg -c /etc/zurg/config.yaml";
      ExecStartPost = "${pkgs.rclone}/bin/rclone mount debrid: /media/zurg --config /etc/zurg/rclone.conf --dir-cache-time 30s --allow-other --vfs-cache-mode off --daemon";
      ExecStop = "${pkgs.util-linux}/bin/umount /media/zurg";
    };
  };
}
