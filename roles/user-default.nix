{ pkgs, ... }@inputs: {
  home.stateVersion = "24.11";

  imports = [
    ../modules/home/all.nix
  ];

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  systemd.user.startServices = "sd-switch";
}
