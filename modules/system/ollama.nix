{ config, lib, pkgs, ... }: {
  options = { ollama.enable = lib.mkEnableOption "enables ollama support"; };

  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      package = pkgs.ollama;
      enable = true;
      host = "0.0.0.0";
    };
  };
}
