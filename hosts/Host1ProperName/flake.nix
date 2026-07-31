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

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
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
      hostName = interpolants.host1.hostname;
    in
    {

      nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          HOSTNAME = hostName;
        };
        modules = [
          ./configuration.nix

          inputs.home-manager.nixosModules.default
          # clones flake-directory into /etc/current-system-flake
          # so that each generation contains the config it was generated against.
          {
            environment.etc."current-system-flake".source = builtins.path {
              path = ./../..; # copies entire host dir including flake.lock into the store
              name = "${hostName}-config";
            };
          }

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit interpolants;
              };
            };
          }

        ];
      };

    };
}
