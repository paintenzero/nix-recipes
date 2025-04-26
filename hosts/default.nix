{ lib, config, pkgs, pkgs-stable, ... }: {
  imports = [
    ../modules/system/.all.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.nix-path = config.nix.nixPath;

  services.timesyncd.enable = true;

  system.stateVersion = "24.11";
}
