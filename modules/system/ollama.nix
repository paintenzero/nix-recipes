{ config, lib, pkgs-unstable, ... }: {
  options = { ollama.enable = lib.mkEnableOption "enables ollama support"; };

  config = lib.mkIf config.ollama.enable { 
    services.ollama = {
      package = pkgs-unstable.ollama;
      enable = true; 
    };
  };
}
