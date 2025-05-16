{ ... }: {
  imports = [
    ./build-essentials.nix
    ./gaming.nix
    ./nvidia.nix
    ./cuda.nix
    ./cuda.nix
    ./ollama.nix
    ./3dprint.nix
    ./rdp.nix
  ];
}
