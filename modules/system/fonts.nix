{ lib, config, pkgs, ... }: {
  options.fonts.enable = lib.mkEnableOption "Enables fonts";
  config = lib.mkIf config.fonts.enable {
    fonts.enableDefaultPackages = true;
    fonts.enableGhostscriptFonts = true;
    fonts.packages = with pkgs; [
      corefonts
      vistafonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fonts.fontconfig.enable = true;
  }; 
}
