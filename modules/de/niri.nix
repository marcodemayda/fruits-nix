# niri.nix

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
    niri.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.niri.enable {

    wayland = {
      enable = true;
      clipboard = true;
    };

    xorg.enable = true;
    alacritty.enable = true;
    gshell.enable = true;
    fuzzel.enable = true;
    pcmanfm.enable = true;

    programs = {
      xwayland.enable = true;
      niri.enable = true;
    };

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

    xdg = {
      mime.enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true; # might fix some app launches
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          # kdePackages.xdg-desktop-portal-kde
        ];
        config.common.default = "gtk"; # AI suggestion
      };
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite # reccomended for niri
      polkit_gnome
      brightnessctl
      # stasis # cool but a bit overly complicated
    ];

    environment.etc."xdg-desktop-portal/niri-portals.conf".text = ''
      [preferred]
      default=gtk
    '';

    home-manager.users.${config.main-user.userName} = {
    };

  };

}
