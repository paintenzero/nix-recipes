# Inspired by
# https://github.com/Misterio77/nix-starter-configs/blob/main/standard/flake.nix
# https://github.com/shyonae/nixos-main-config/blob/main/flake.nix
{
  description = "My nixos system";

  #### INPUTS
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    unstable.url = "nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #### OUTPUTS
  outputs = { self, nixpkgs, nixpkgs-unstable, unstable, home-manager
    , impermanence, catppuccin, sops-nix, ... }@inputs:
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
        impermanence.nixosModules.impermanence
      ];

      getPkgs =
        { nixpkgs, nixpkgs-unstable, unstable, system, cudaSupport ? false }: {
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
          unstable = import unstable {
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
            inherit nixpkgs nixpkgs-unstable unstable;
            system = "x86_64-linux";
            cudaSupport = true;
          };
          modules = shared-modules ++ [ ./hosts/mainpc.nix ./users/sergey.nix ];
        }; # end of host sbnix

        vmnix = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs // getPkgs {
            inherit nixpkgs nixpkgs-unstable unstable;
            system = "x86_64-linux";
          };
          modules = shared-modules ++ [ ./hosts/vm.nix ./users/vm-user.nix ];
        }; # end of host vmnix
      }; # end of nixosConfigurations
    }; # end of outputs

}
