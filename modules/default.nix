# default.nix

{ lib, ... }:
let
  umportLib = import ./lib/umport.nix { inherit lib; };

  rawImports = umportLib.umport {
    path = ./.;
    recursive = true;
    exclude = [
      ./default.nix
      ./core.nix
      ./templates
      ./lib/umport.nix
    ];
  };

  importsFiltered = lib.filter (
    p:
    let
      s = toString p;
    in

    lib.strings.match ".*fruit.*" s == null
    # && lib.strings.match ".*template.*" s == null # example of how to add exclude pattern.

  ) rawImports;
in
{
  imports = importsFiltered;
}
