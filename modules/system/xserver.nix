{ lib, config, pkgs, ... }: {
  options.xserver.enable = lib.mkEnableOption "Enables X server";
  config = lib.mkIf config.xserver.enable {
    services.xserver = {
        enable = true;
        xkb.layout = "us,ru,gr";
        xkb.options = "grp:alt_shift_toggle";
    };
  };
}
