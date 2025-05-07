{ config, lib, pkgs, ... }: {
  options = { 
    cuda.enable = lib.mkEnableOption "enables cuda support";
  };

  config = lib.mkIf config.cuda.enable {
		nvidia.enable = true;
    build-essentials.enable = true;
    environment.systemPackages = with pkgs; [
      cudatoolkit
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvcc
      cudaPackages.libcublas
      cudaPackages.cuda_cccl
      # Other development tools
      libGLU libGL
      xorg.libXi xorg.libXmu freeglut
      xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr
    ];
  };
}
