# hyprland.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./wayland.nix
    ./xorg.nix
    ./../gui/alacritty.nix
    ./gshell.nix
    ./fuzzel.nix
    ./pcmanfm.nix
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.hyprland.enable {
    # config goes here, then importing and module.enable = true; will make it part of the config
    wayland = {
      enable = true;
      # clipboard = true;
    };
    xorg.enable = true;
    alacritty.enable = true;
    gshell.enable = true;
    fuzzel.enable = true;
    pcmanfm.enable = true;

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
      # unfortunately doesn't remove entry, but doesn't seem to be
      # a way around it without recompiling hyprland
      withUWSM = false;
    };

    home-manager.users.${config.main-user.userName} = {
      xdg = {
        enable = true;
        configFile."hypr" = {
          source = ./../../files/homes/users/dotconfig/hypr;
          recursive = true;
        };
      };
    };

  };

}
