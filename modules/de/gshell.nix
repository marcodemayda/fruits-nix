# gshell.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    gshell.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.gshell.enable {

    home-manager.users.${config.main-user.userName} =
      { config, ... }:
      {
        xdg.enable = true;
        xdg.userDirs = {
          enable = true;
          createDirectories = true;
          # 26.05 evalwarn, legacy behaviour
          setSessionVariables = true;
        };

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };
          # 26.05 eval warning, legacy
          gtk4.theme = config.gtk.theme;
        };

        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = "adwaita-dark";
        };

      };
  };
}
