{ lib, config, pkgs, ... }: {
  options.efi.enable = lib.mkEnableOption "Enables EFI boot loader";
  config = lib.mkIf config.efi.enable {
    boot.loader = {
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
      #    systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  }; 
}
