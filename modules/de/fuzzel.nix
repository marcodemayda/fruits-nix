# fuzzel.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    fuzzel.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.fuzzel.enable {
    # config goes here, then importing and module.enable = true; will make it part of the config

    environment.systemPackages = with pkgs; [
      fuzzel
    ];

    home-manager.users.${config.main-user.userName} = {
      # home manager config goes here
      xdg = {
        enable = true;
        configFile."fuzzel/fuzzel.ini".source = ./../../files/homes/users/dotconfig/fuzzel/fuzzel.ini;
      };
    };
  };

}
