{ lib, config, pkgs, inputs, packages, ... }: {
	imports = [
		./home.nix
	];

	programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs.direnv;
  };

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
		meson
    devenv
	];
}
