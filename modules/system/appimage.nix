{ lib, config, pkgs, ... }: {
  options.appimage.enable = lib.mkEnableOption "Enables AppImage support";
  config = lib.mkIf config.appimage.enable {
    programs.appimage = {
        enable = true;
        binfmt = true;
    };
  };
}
