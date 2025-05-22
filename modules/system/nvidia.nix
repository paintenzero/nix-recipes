{ config, lib, pkgs, packages, ... }: {

  options = { nvidia.enable = lib.mkEnableOption "Installs nvidia drivers"; };

  config = let

    mesa = pkgs.mesa; # .override {
    # galliumDrivers = [ "zink" ];
    # };

  in lib.mkIf config.nvidia.enable {

    environment.systemPackages = [ pkgs.mesa-demos pkgs.libGL pkgs.vulkan-tools ];

    environment.variables = {
      VDPAU_DRIVER = "va_gl";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    hardware = {
      graphics = {
        package = mesa;
        extraPackages = [ pkgs.libvdpau-va-gl ];
        enable = true;
        enable32Bit = true;
      };
      enableRedistributableFirmware = true;
      nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        package = packages.stable.linuxPackages.nvidiaPackages.latest;
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        # 	version = "570.144";
        # 	sha256_64bit = lib.fakeSha256;
        # 	sha256_aarch64 = lib.fakeSha256;
        # 	openSha256 = lib.fakeSha256;
        # 	settingsSha256 = lib.fakeSha256;
        # 	persistencedSha256 = lib.fakeSha256;
        # };
        forceFullCompositionPipeline = false;
        powerManagement.enable = true;
      };
    };
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
