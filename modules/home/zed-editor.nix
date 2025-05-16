{ lib, config, unstable, ... }: {
  options = {
    zed-editor.enable = lib.mkEnableOption "Enables Zed Editor for the user";
  };

  config = lib.mkIf config.zed-editor.enable {
    home.packages = with unstable; [ zed-editor ];
  };
}
