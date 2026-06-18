# MODULE.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    MODULE.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.MODULE.enable {
    # config goes here, then importing and module.enable = true; will make it part of the config

    home-manager.users.${config.main-user.userName} = {
      # home manager config goes here
    };

  };

}
