{ config, lib, pkgs, pkgs-unstable, ... }: {
  options = { gaming.enable = lib.mkEnableOption "enables gaming"; };

  config = lib.mkIf config.gaming.enable {
    programs.gamemode.enable = true;
    programs.java.enable = true;
    programs.gamescope.enable = true;

    # Sunshine for streaming
    services.sunshine = {
      package = pkgs-unstable.sunshine; # .override { cudaSupport = false; };
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    services.avahi.publish = {
      enable = true;
      userServices = true;
    };
  };
}
