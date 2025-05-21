{ lib, pkgs, pkgs-unstable, unstable, userSettings, ... }: {
  imports = [ ../modules/home/.all.nix ];
  programs.home-manager.enable = true;
  programs.bash.enable = true;
}
