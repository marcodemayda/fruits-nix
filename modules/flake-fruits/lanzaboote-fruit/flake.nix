# lanzaboote/flake.nix
#
# in the relevant flake, set:
#
# inputs:
# lanzaboote-fruit = {
#  url = "path/to/this/module"
#  inputs.nixpkgs.follows = "nixpkgs" (if applicable)
# };
#
# outputs:
# {lanzaboote-fruit,...}:
# modules = [
# lanzaboote-fruit.nixosModules.lanzaboote
# ];

{

  description = "flake-fruit for lanzaboote";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
  };

  outputs =
    {
      # you need to define outputs here aswell
      self,
      lanzaboote,
      ...
    }:
    {
      nixosModules.lanzaboote = {
        imports = [
          # what you import
          lanzaboote.nixosModules.lanzaboote
          (
            { pkgs, lib, ... }:
            {
              environment.systemPackages = [
                # For debugging and troubleshooting Secure Boot.
                pkgs.sbctl
              ];

              # Lanzaboote currently replaces the systemd-boot module.
              # This setting is usually set to true in configuration.nix
              # generated at installation time. So we force it to false
              # for now.
              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            }
          )
        ];

        config = {
          # if you want some configurations to be pulled in
          # directly from importing the flake
        };
      };
    };

}
