# testing-home.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    testing-home.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.testing-home.enable {
    home-manager.users.${config.main-user.userName} = {
      warnings = [ "TEST file enabled, did you mean to have it on?" ];

    };
  };

}
