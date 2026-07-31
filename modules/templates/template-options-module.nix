{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.MODULE;
in

{

  options.MODULE = {
    enable = lib.mkEnableOption "enable module";
    youroption = lib.mkEnableOption "togglable submodule";
  };

  config = lib.mkIf cfg.enable (
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
