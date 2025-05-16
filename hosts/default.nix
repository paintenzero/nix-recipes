{ lib, config, pkgs, unstable, ... }: {
  imports = [ ../modules/system/.all.nix ];

  nix.settings = {

    experimental-features = [ "nix-command" "flakes" ];
    nix-path = config.nix.nixPath;

    trusted-users = [ "sergey" ];
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://nixpkgs-python.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  environment.systemPackages = with unstable; [
    samba
    cifs-utils
    sops
    cachix
    vim
    wget
    curl
  ];

  services.timesyncd.enable = true;

  system.stateVersion = "24.11";
}
