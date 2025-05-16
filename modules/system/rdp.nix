{ config, lib, pkgs, unstable, ... }: {
  options = { rdp.enable = lib.mkEnableOption "enables RDP"; };

  config = lib.mkIf config.rdp.enable {

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-wayland";
    services.xrdp.openFirewall = true;

  };
}
