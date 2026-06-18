# testing-config.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    testing-config.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.testing-config.enable {
    warnings = [ "TEST file enabled, did you mean to have it on?" ];
  };
}
