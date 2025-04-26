{ lib, pkgs, pkgs-stable, userSettings, ... }:
{
  imports = [ 
    ../modules/home/.all.nix
  ];
  programs.home-manager.enable = true;
}	