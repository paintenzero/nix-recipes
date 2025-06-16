{ lib, config, pkgs, ... }: let
  sim_reader = pkgs.callPackage ../../apps/sim_reader/package.nix {};
in {
  environment.systemPackages = [
    sim_reader
  ];

  systemd.services.sim_reader = {
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "always";
      ExecStart = "${sim_reader}/bin/sim_reader -config /run/secrets/sim_reader/config -log-level 0";
    };
  };
}
