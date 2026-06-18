# vscodium/flake.nix
#
# Lots of AI help
#
# in the relevant flake, set:
#
# inputs:
# vscodium-fruit.url = "../flake-fruits/module-folder";
#
# outputs:
# {vscodium-fruit,...}:
# modules = [
# (vscodium-fruit.nixosModules.vscodium system)
# ];
#
# NOTE: unlike others, this fruit isn't a self contained package.
# it just enables usage of microsoft store plugins.
# Vscodium features are controlled in vscodium.nix
#
# NOTE: this fruit is called as a function with `system` as argument,
# because it needs to instantiate pkgs. Example:
#   (vscodium-fruit.nixosModules.vscodium "x86_64-linux")
# Normally this should be pulled from a let...in argument anyways
# no need to worry about it in that case, simply leave `system`

{

  description = "flake-fruit for vscodium";

  inputs = {
    # best to have unstable, since it doesn't have to be manually changed,
    # it always exist. Use  inputs.nixpkgs.follows in the flake to use desired channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    {
      # you need to define outputs here aswell
      self,
      nixpkgs,
      nix-vscode-extensions,
      ...
    }:
    {
      # Exposed as a function: nixosModules.vscodium <system>
      # so the fruit can instantiate pkgs for the right system
      nixosModules.vscodium =
        system:
        let
          pkgs-vscodium = import nixpkgs {
            inherit system;
            overlays = [ nix-vscode-extensions.overlays.default ];
            config.allowUnfree = true;
          };
        in
        { ... }:
        {
          # make pkgs-vscodium usable as a module argument
          _module.args.pkgs-vscodium = pkgs-vscodium;

          # Inject pkgs-vscodium into home-manager's specialArgs
          # so any HM module in this host can do `{ pkgs-vscodium, ... }:`
          home-manager.extraSpecialArgs.pkgs-vscodium = pkgs-vscodium;

          imports = [
            ./../../gui/vscodium.nix

            (
              { ... }:
              {
                config.vscodium.enable = true;
              }
            )
          ];

        };
    };

}
