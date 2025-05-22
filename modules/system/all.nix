{ ... }: {
  # included in modules mkNixosConfiguration in flake.nix
  imports = [
    ./mbr.nix
    ./efi.nix
    ./impermanence.nix
    ./fonts.nix
    ./appimage.nix
    ./xserver.nix
    ./kde.nix
    ./nvidia.nix
    ./cuda.nix
    ./ollama.nix
    ./3dprint.nix
  ];
}
