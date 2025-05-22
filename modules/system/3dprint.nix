{ lib, config, pkgs, ... }: {
  options = {
    threedprint.enable = lib.mkEnableOption "Installs 3D printing software";
  };

  config = lib.mkIf config.threedprint.enable {
    environment.systemPackages = let
      orca-slicer = pkgs.orca-slicer.overrideAttrs (old: {
        cmakeFlags = old.cmakeFlags
          ++ [ "-DCUDA_TOOLKIT_ROOT_DIR=${pkgs.cudaPackages.cudatoolkit}" ];
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/orca-slicer --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json --set WEBKIT_FORCE_COMPOSITING_MODE 1 --set WEBKIT_DISABLE_COMPOSITING_MODE 1 --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        '';
      });

      # Zink (OpenGL to Vulkan wrapper)
      # wrapProgram $out/bin/orca-slicer --set __GLX_VENDOR_LIBRARY_NAME mesa --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json --set MESA_LOADER_DRIVER_OVERRIDE zink --set GALLIUM_DRIVER zink
    
    in [ orca-slicer ];

  };
}
