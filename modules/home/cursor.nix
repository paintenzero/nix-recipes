{ lib, config, unstable, ... }: {
  options = {
    cursor.enable = lib.mkEnableOption "Enables Cursor for the user";
  };

  config = lib.mkIf config.cursor.enable {
    home.packages = with unstable; [ code-cursor ];
  };
}
