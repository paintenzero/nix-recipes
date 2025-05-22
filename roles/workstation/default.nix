{ lib, config, pkgs, ... }: {
  imports = [
    ./home.nix
  ];

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    libreoffice
    ripgrep
    htop
    btop
    lm_sensors
  ];

}
