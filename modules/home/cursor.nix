{ lib, config, packages, ... }: {
  options = {
    cursor.enable = lib.mkEnableOption "Enables Cursor for the user";
  };

  config = lib.mkIf config.cursor.enable {
    home.packages = [ packages.master.code-cursor ];
  };
}
