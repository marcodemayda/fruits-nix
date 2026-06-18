# noctalia/flake.nix
#
# in the relevant flake, set:
#
# inputs:
# noctalia-fruit = {
#  url = "path/to/this/module";
#  inputs.nixpkgs.follows = "nixpkgs" (if applicable)
# };
#
# outputs:
# {noctalia-fruit,...}:
# modules = [
# noctalia-fruit.nixosModules.noctalia
# ];
#
# you might have to update the flake.lock to rebuild without error

{

  description = "flake-fruit for noctalia";

  inputs = {
    # best to have unstable, since it doesn't have to be manually changed,
    # it always exist. Use  inputs.nixpkgs.follows in the flake to use desired channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NOTCALIA REQUIRES UNSTABLE; FOLLOW UNSTABLE IN FLAKE
    noctalia.url = "github:noctalia-dev/noctalia-shell";
  };

  outputs =
    inputs@{
      # you need to define outputs here aswell
      self,
      nixpkgs,
      noctalia,
      ...
    }:
    {
      nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./noctalia.nix
          ./../../de/niri.nix
          ./../../de/hyprland.nix
        ];

      };

      nixosModules.noctalia =
        {
          pkgs,
          pkgs-unstable,
          config,
          ...
        }:
        {

          environment.systemPackages = with pkgs-unstable; [
            noctalia-shell
          ];
          niri.enable = true;
          hyprland.enable = true;

          networking.networkmanager.enable = true;
          hardware.bluetooth.enable = true;
          services.power-profiles-daemon.enable = true;
          services.upower.enable = true;
          home-manager.users.${config.main-user.userName} = {
            # home manager config goes here
            imports = [
              noctalia.homeModules.default
            ];

            programs.noctalia = {
              enable = true;
              settings = ./../../../files/homes/users/dotconfig/noctalia/config.toml;
            };

          };

        };

      nixConfig = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

    };

}
