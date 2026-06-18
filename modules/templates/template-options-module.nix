{
  lib,
  config,
  pkgs,
  ...
}:

let
cfg = MODULE
in

{

  options = {
    MODULE.enable = lib.mkEnableOption "enable module";
    MODULE.youroption = lib.mkEnableOption "togglable submodule";
  };

  config = lib.mkIf config.MODULE.enable (
    lib.mkMerge [
      {
        # base config, enabled by module
      }

      (lib.mkIf config.MODULE.youroption {
        # here goes part of the configuration that can be toggled
      })
    ]
  );

}
