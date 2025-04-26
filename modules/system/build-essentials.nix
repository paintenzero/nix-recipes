{ config, lib, pkgs, ... }: {
  options = { build-essentials.enable = lib.mkEnableOption "enables build-essentials tools"; };

  config = lib.mkIf config.build-essentials.enable {
    environment.systemPackages = with pkgs; [
      gcc12
      gdb
      cmake
      gnumake
      ninja
      clang-tools
      valgrind
      zlib
      pkg-config
      binutils
    ];
  };
}

