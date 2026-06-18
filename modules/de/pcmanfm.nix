# pcmanfm.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    pcmanfm.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.pcmanfm.enable {
    # config goes here, then importing and module.enable = true; will make it part of the config

    environment.systemPackages = with pkgs; [
      kdePackages.qtsvg
      shared-mime-info # file extensions help
      pcmanfm
    ];
    xdg.menus.enable = true;
    xdg.mime.enable = true;

    home-manager.users.${config.main-user.userName} = {
      # home manager config goes here
    };

  };

}
