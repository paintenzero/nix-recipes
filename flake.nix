# Inspired by
# https://gitlab.com/kylesferrazza/nix-configs
# https://github.com/Misterio77/nix-starter-configs/blob/main/standard/flake.nix
# https://github.com/shyonae/nixos-main-config/blob/main/flake.nix
{
  description = "sebi's nix configs";

  #### INPUTS
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #### OUTPUTS
  outputs = inputs@{ self, nixpkgs, nixpkgs-master, home-manager, impermanence
    , sops-nix }:
    let
      username = "sergey";
      mkPkgs = system: {
        stable = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        master = import nixpkgs-master {
          inherit system;
          config.allowUnfree = true;
          overlays = [ (import ./overlays/cursor.nix) ];
        };
      };
      mkHome = nixos-config:
        home-manager.lib.homeManagerConfiguration {
          pkgs = (mkPkgs nixos-config.system).stable;
          modules = [
            {
              home = {
                username = "sergey";
                homeDirectory = "/home/sergey";
              };
            }
            nixos-config.config.home-manager.users.${nixos-config.config.sergey.username}
          ];
        };
    in rec {

      ### COMPUTER CONFIGURATIONS
      nixosConfigurations = let
        # Function to create nixosConfigurations 
        mkNixosConfiguration =
          { name, system ? "x86_64-linux", cudaSupport ? false }: {
            "${name}" = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit system inputs;
                inherit username;
                packages = mkPkgs system;
              };
              modules = [
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useUserPackages = true;
                    useGlobalPkgs = true;
                  };
                }
                { home-manager.users.${username}.nixpkgs.overlays = [ myoverlay ]; }
                impermanence.nixosModules.impermanence
                sops-nix.nixosModules.sops
                (import
                  (./modules/system/all.nix)) # Import all system modules options
                (import (./hosts/all.nix))
                (import (./hosts + "/${name}.nix"))
              ];
            };
          };
      in { } // (mkNixosConfiguration { name = "sbsrv"; })
      // (mkNixosConfiguration {
        name = "sbnix";
      }); # end of nixosConfigurations

      ### HOME MANAGER STUFF
      homeConfigurations = {
        "sergey@sbsrv" = mkHome nixosConfigurations."sbsrv";
        "sergey@sbnix" = mkHome nixosConfigurations."sbnix";
      };

    }; # end of outputs
}
