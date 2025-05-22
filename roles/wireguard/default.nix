{ lib, config, ... }: let
  port = 10102;
in {
  networking.firewall.allowedUDPPorts = [ port ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.97.97.9/29" ];
      listenPort = port;
      privateKeyFile = "/run/secrets/wireguard/private";
      peers = [
        {
          publicKey = "60CxmfWcoJvX4oXHeHnws/D4T1Qj0sT+IS6DiTSUj3g=";
          allowedIPs = [ "10.97.97.10/32" ];
        }
      ];
    };
  };
}
