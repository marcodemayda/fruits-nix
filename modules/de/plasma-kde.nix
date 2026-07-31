# plasma-kde.nix

{
  lib,
  config,
  ...
}:
let
  cfg = config.plasma-kde;
in
{
  imports = [
    ./wayland.nix
  ];
  options.plasma-kde = {
    enable = lib.mkEnableOption "enable plasma-kde DE";
  };

  config = lib.mkIf cfg.enable {

    # imported in the module, so we don't have to separately enable it.
    # since wether you want wayland as a module depends on other modules,
    # it's nice to tie them together
    wayland.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.desktopManager.plasma6.enable = true;

  };
}
