{ lib, config, pkgs, ... }: {
  options.mbr.enable = lib.mkEnableOption "Enables MBR boot loader";
  config = lib.mkIf config.mbr.enable {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
  }; 
}
