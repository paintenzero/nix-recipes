{ lib, config, unstable, ... }: {
  options = {
    windsurf.enable = lib.mkEnableOption "Enables Windsurf IDED for the user";
  };

  config = lib.mkIf config.windsurf.enable {
    home.packages = with unstable; [ windsurf ];
  };
}
