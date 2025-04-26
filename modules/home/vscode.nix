{ lib, config, pkgs, ... }: {
  options = {
    vscode.enable = lib.mkEnableOption "Installs Visual Studio Code";
  };

  config =
    lib.mkIf config.vscode.enable { home.packages = with pkgs; [ vscode ]; };
}
