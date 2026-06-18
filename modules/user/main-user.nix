# main-user.nix

{
  lib,
  config,
  ...
}:

{

  options = {
    main-user.enable = lib.mkEnableOption "enable user module";

    main-user.userName = lib.mkOption {
      default = "mainuser";
      description = "Username for admin user";
    };

    main-user.description = lib.mkOption {
      default = "Main User";
      description = "Full name / GECOS description for the main user";
    };
  };

  config = lib.mkIf config.main-user.enable {

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
