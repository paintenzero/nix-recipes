{ pkgs, ... }: let
  pname = "code-cursor";
  version = "0.50.4";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/production/8ea935e79a50a02da912a034bbeda84a6d3d355d/linux/x64/Cursor-0.50.4-x86_64.AppImage";
    hash = "sha256-ik+2TqmRhnzXM+qoCQ+KLQkW/cqZSqcZS2P2yuUPGI8=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      pkgs = pkgs;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${appimageContents}/usr/share/icons $out/share

        ln -s $out/bin/${pname}-${version} $out/bin/${pname}
      '';

      extraBwrapArgs = [
        "--bind-try /etc/nixos/ /etc/nixos/"
      ];

      # vscode likes to kill the parent so that the
      # gui application isn't attached to the terminal session
      dieWithParent = false;

      extraPkgs = pkgs: with pkgs; [
        unzip
        autoPatchelfHook
        asar
        # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
        (buildPackages.wrapGAppsHook.override {inherit (buildPackages) makeWrapper;})
      ];
    }
