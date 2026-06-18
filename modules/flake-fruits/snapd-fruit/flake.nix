# snapd/flake.nix
#
# in the relevant flake, set:
#
# inputs:
# snapd-fruit = {
#  url = "path/to/this/module"
#  inputs.nixpkgs.follows = "nixpkgs" (if applicable)
# };
#
# outputs:
# {snapd-fruit,...}:
# modules = [
# snapd-fruit.nixosModules.snapd
# ];
#
#
# ("-fruit" is used to differentiate
# from the flake repo name, often including "-nix",
# and from the module name itself)

{

  description = "flake-fruit for snap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-snapd.url = "github:nix-community/nix-snapd";
  };

  outputs =
    {
      self,
      nix-snapd,
      ...
    }:
    {
      nixosModules.snapd = {

        imports = [
          nix-snapd.nixosModules.default
        ];

        config = {
          services.snap.enable = true;
        };
      };
    };
}
