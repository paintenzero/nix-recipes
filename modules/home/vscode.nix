{ lib, config, packages, ... }: {
  options = {
    vscode.enable = lib.mkEnableOption "Installs Visual Studio Code";
  };

  config =
    lib.mkIf config.vscode.enable { home.packages = with packages.stable; [ vscode ]; };
}
