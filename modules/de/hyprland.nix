# hyprland.nix

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hyprland;
in
{
  imports = [
    ./wayland.nix
  ];

  options.hyprland = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    wayland.enable = true;

    security.polkit.enable = true; # polkit
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    services.gnome.gnome-keyring.enable = true; # secret service
    security.pam.services.greetd.enableGnomeKeyring = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    home-manager.users.${config.main-user.userName} = {
      xdg = {
        enable = true;
        configFile."hypr" = {
          source = ./../../files/home/${config.main-user.userName}/dotconfig/hypr;
          # whole folder, in case you want to add other hypr-stuff
          recursive = true;
        };
      };
    };

  };

}
