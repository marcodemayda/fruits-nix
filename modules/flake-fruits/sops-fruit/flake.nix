# sops/flake.nix
#
# in the relevant flake, set:
#
# inputs:
# sops-fruit = {
#  url = "path/to/this/module"
#  inputs.nixpkgs.follows = "nixpkgs" (if applicable)
# };
#
# outputs:
# {sops-fruit,...}:
# modules = [
# sops-fruit.nixosModules.sops
# ];
#
#
# ("-fruit" is used to differentiate
# from the flake repo name, often including "-nix",
# and from the module name itself)

{

  description = "flake-fruit for sops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      # you need to define outputs here aswell
      self,
      sops-nix,
      ...
    }:
    {
      nixosModules.sops = {
        imports = [
          sops-nix.nixosModules.sops
        ];

        config = {
          # if you want some configurations to be pulled in
          # directly from importing the flake
        };

      };
      homeManagerModules.sops = sops-nix.homeManagerModules.sops;
    };

}
