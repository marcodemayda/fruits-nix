# plasma-kde.nix

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
  ];
  options = {
    plasma-kde.enable = lib.mkEnableOption "enable plasma-kde DE";

    plasma-kde.extraApps = lib.mkEnableOption "enable extra KDE applications";
  };

  config = lib.mkIf config.plasma-kde.enable {
    wayland.enable = true;
    xorg.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.desktopManager.plasma6.enable = true;

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      kwallet # cuz gnome keyring better
      kwalletmanager
    ];

    environment.systemPackages = lib.optionals config.plasma-kde.extraApps (
      with pkgs;
      [
        konsave
        kdePackages.kcharselect
        kdePackages.kclock
        kdePackages.kolourpaint
        kdePackages.ksystemlog
        kdePackages.sddm-kcm
      ]
    );

  };
}
