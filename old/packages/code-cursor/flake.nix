{
  description = "Cursor AI IDE AppImage flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # pkgs = nixpkgs.legacyPackages.${system};

        mkAppImagePackage = { pname, version, src, appimageContents ? "", meta ? {} }:
          pkgs.stdenv.mkDerivation {
            inherit pname version src meta;

            dontUnpack = true;
            dontBuild = true;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              mkdir -p $out/bin $out/share/applications

              # Copy the AppImage to the output directory
              cp $src $out/share/${pname}.AppImage
              chmod +x $out/share/${pname}.AppImage

              # Create a wrapper script
              makeWrapper $out/share/${pname}.AppImage $out/bin/${pname} \
                --set APPIMAGE_EXTRACT_AND_RUN 1

              # Create desktop file if contents provided
              ${if appimageContents != "" then ''
                echo "${appimageContents}" > $out/share/applications/${pname}.desktop
              '' else ""}
            '';
          };

        code-cursor = mkAppImagePackage {
          pname = "code-cursor";
          version = "0.50.4";
          src = pkgs.fetchurl {
            url = "https://downloads.cursor.com/production/8ea935e79a50a02da912a034bbeda84a6d3d355d/linux/x64/Cursor-0.50.4-x86_64.AppImage";
            sha256 = "sha256-ik+2TqmRhnzXM+qoCQ+KLQkW/cqZSqcZS2P2yuUPGI8=";
          };
          meta = {
            description = "AI-powered code editor built on vscode";
            homepage = "https://cursor.com";
            changelog = "https://cursor.com/changelog";
            license = pkgs.lib.licenses.mit; # How do I install it if I set unfree?
            sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
            platforms = pkgs.lib.platforms.linux;
            mainProgram = "cursor";
          };
        };
      in {
        packages = {
          inherit code-cursor;
          default = code-cursor;
        };
      }
    );
}
