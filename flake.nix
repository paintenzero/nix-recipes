# Inspired by
# https://github.com/Misterio77/nix-starter-configs/blob/main/standard/flake.nix
# https://github.com/shyonae/nixos-main-config/blob/main/flake.nix
{
  description = "My nixos system";

  #### INPUTS
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  #### OUTPUTS
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, ... }@inputs:
  let
    inherit (self) outputs;

    sharedArgs = inputs // { inherit inputs outputs; };

    shared-modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
        };
      }
    ];

    getPkgs = { nixpkgs, nixpkgs-unstable, system, cudaSupport ? false }:
    {
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = cudaSupport;
        };
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = cudaSupport;
        };
      };
    };

  in {

    nixosConfigurations = {

      sbnix = nixpkgs.lib.nixosSystem {

        specialArgs = sharedArgs // getPkgs { 
          inherit nixpkgs nixpkgs-unstable;
          system = "x86_64-linux";
          cudaSupport = true;
        };

        modules = shared-modules ++ [ ./hosts/mainpc.nix ./users/sergey.nix ];
      }; # end of host sbnix
    }; # end of nixosConfigurations
  }; # end of outputs

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
