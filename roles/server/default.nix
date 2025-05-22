{ lib, config, ... }: {
  imports = [
    ./home.nix
  ];
  services.openssh.enable = true;
}
