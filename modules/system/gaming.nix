{ config, lib, pkgs, pkgs-unstable, ... }: {
  options = { gaming.enable = lib.mkEnableOption "enables gaming"; };

  config = lib.mkIf config.gaming.enable {
    programs.gamemode.enable = true;
    programs.java.enable = true;
    programs.gamescope.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      extraPackages = with pkgs; [ mangohud ];
    };

    # Sunshine for streaming
    services.sunshine = {
      package = pkgs-unstable.sunshine;
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
