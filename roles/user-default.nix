{ ... }@inputs: {
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  systemd.user.startServices = "sd-switch";
}
