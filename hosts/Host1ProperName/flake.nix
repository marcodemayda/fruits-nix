# host1/flake.nix

{
  description = "NixOS config flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote-fruit = {
      url = "./../../modules/flake-fruits/lanzaboote-fruit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-fruit = {
      url = "./../../modules/flake-fruits/sops-fruit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-fruit = {
      url = "./../../modules/flake-fruits/noctalia-fruit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscodium-fruit.url = "./../../modules/flake-fruits/vscodium-fruit";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      lanzaboote-fruit,
      sops-fruit,
      noctalia-fruit,
      vscodium-fruit,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      interpolants = builtins.fromJSON (builtins.readFile ./../../modules/lib/interpolants.json);
      privates = builtins.fromJSON (builtins.readFile ./../../modules/sops/privates.json);
      hostName = interpolants.host1.hostname;
    in
    {

      nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          inherit interpolants privates;
          inherit pkgs-unstable;
          HOSTNAME = hostName;
        };
        modules = [
          ./configuration.nix

          inputs.home-manager.nixosModules.default
          # clones flake-directory into /etc/current-system-flake for review
          {
            environment.etc."current-system-flake".source = builtins.path {
              path = ./../..; # copies entire host dir including flake.lock into the store
              name = "${hostName}-config";
            };
          }
          # AI suggests tracking git-tree instead, not sure I agree
          # {
          #   environment.etc."current-system-flake".source = builtins.fetchGit {
          #     url = ./../..;
          #     # no `rev` = uses current HEAD
          #   };
          # }

          lanzaboote-fruit.nixosModules.lanzaboote

          sops-fruit.nixosModules.sops

          noctalia-fruit.nixosModules.noctalia

          (vscodium-fruit.nixosModules.vscodium system)

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit interpolants privates;
              };
            };
          }

        ];
      };

      nixosConfigurations."${hostName}-alt" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          inherit interpolants privates;
          inherit pkgs-unstable;
          HOSTNAME = hostName;
        };
        modules = [
          ./configuration-perf.nix

          inputs.home-manager.nixosModules.default

          # clones flake-directory into /etc/current-system-flake for review
          {
            environment.etc."current-system-flake".source = builtins.path {
              path = ./../..; # copies entire host dir including flake.lock into the store
              name = "${hostName}-config";
            };
          }

          lanzaboote-fruit.nixosModules.lanzaboote

          sops-fruit.nixosModules.sops

          noctalia-fruit.nixosModules.noctalia

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit interpolants privates;
              };
            };
          }

        ];
      };
    };
}
