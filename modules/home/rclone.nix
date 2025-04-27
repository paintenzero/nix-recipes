{ lib, config, pkgs, ... }: {

  options = { rclone.enable = lib.mkEnableOption "Installs rclone and configures remotes"; };
  config = lib.mkIf config.rclone.enable {
    home.packages = [ pkgs.rclone ]; 
  };
}
