# Inspired by
# https://gitlab.com/kylesferrazza/nix-configs
# https://github.com/Misterio77/nix-starter-configs/blob/main/standard/flake.nix
# https://github.com/shyonae/nixos-main-config/blob/main/flake.nix
{
  description = "sebi's nix configs";

  #### INPUTS
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #### OUTPUTS
  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-master,
    home-manager,
    impermanence,
    sops-nix
  }: let
    mkPkgs = system: {
      stablePkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
    mkHome = nixos-config: home-manager.lib.homeManagerConfiguration {
      pkgs = (mkPkgs nixos-config.system).stablePkgs;
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
      mkNixosConfiguration = { name, system ? "x86_64-linux", cudaSupport ? false }: {
        "${name}" = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit system inputs;
          };
          modules = [
	    home-manager.nixosModules.home-manager {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
        };
	    }
	    impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            (import (./modules/system/all.nix)) # Import all system modules options
            (import (./hosts/all.nix))
            (import (./hosts + "/${name}.nix"))
          ];     
        };
      };
    in { }
    // (mkNixosConfiguration { name = "sbsrv"; })
    ; # end of nixosConfigurations

    ### HOME MANAGER STUFF
    homeConfigurations = {
      "sergey@sbsrv" = mkHome nixosConfigurations."sbsrv";
    };

  }; # end of outputs
}
