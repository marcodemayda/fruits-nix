# main-user.nix

{
  lib,
  config,
  ...
}:
let
  cfg = config.main-user;
in
{

  options.main-user = {
    enable = lib.mkEnableOption "enable user module";

    userName = lib.mkOption {
      default = "mainuser";
      description = "Username for admin user";
    };

    description = lib.mkOption {
      default = "Main User";
      description = "Full name / GECOS description for the main user";
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.${config.main-user.userName} = {
      isNormalUser = true;
      description = config.main-user.description;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
      ];
    };

  };
}
