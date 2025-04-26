{ lib, config, pkgs, ... }: {
  options = { messaging.enable = lib.mkEnableOption "Installs Messengers"; };

  config = lib.mkIf config.messaging.enable {
    home.packages = with pkgs; [ telegram-desktop whatsapp-for-linux ];
  };
}
