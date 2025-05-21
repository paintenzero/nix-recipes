{ lib, config, pkgs, ... }: {
  options.kde.enable = lib.mkEnableOption "Enables KDE";
  config = lib.mkIf config.kde.enable {
    xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings.General.DisplayServer = "wayland";
    };
  };
}
