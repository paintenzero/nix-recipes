{ lib, config, pkgs, ... }: {

  options = { kitty.enable = lib.mkEnableOption "Installs Kitty and configures it"; };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
    };  
  };
  
}
