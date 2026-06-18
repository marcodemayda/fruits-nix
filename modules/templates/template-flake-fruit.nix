# MODULE/flake.nix
#
# in the relevant flake, set:
#
# inputs:
# MODULE-fruit = {
#  url = "../flake-fruits/module-folder";
# inputs.nixpkgs.follows = "nixpkgs"; # (if applicable)
# };
#
# outputs:
# {MODULE-fruit,...}:
# modules = [
# MODULE-fruit.nixosModules.MODULE
# ];
#
# you might have to update the flake.lock to rebuild without error

{

  description = "flake-fruit for MODULE";

  inputs = {
    # best to have unstable, since it doesn't have to be manually changed,
    # it always exist. Use  inputs.nixpkgs.follows in the flake to use desired channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      # you need to define outputs here aswell
      self,
      ...
    }:
    {
      nixosModules.MODULE = {
        imports = [
          # what you import
        ];

        config = {
          # if you want some configurations to be pulled in
          # directly from importing the flake
        };
      };
    };

}
