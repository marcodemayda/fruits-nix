# MODULE.nix

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
  };

  config = lib.mkIf cfg.enable {
    # config goes here, then importing and module.enable = true; will make it part of the system

    home-manager.users.${config.main-user.userName} = {
      # home manager config goes here
    };

  };

}
