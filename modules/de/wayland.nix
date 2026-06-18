# wayland.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    wayland.enable = lib.mkEnableOption "enable module";
    wayland.clipboard = lib.mkEnableOption "enable module";
    wayland.screenshare = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.wayland.enable (
    lib.mkMerge [
      {
        # base config, enabled by module
        qt.enable = true;
        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1"; # electron apps stability on wayland

          #   XDG_CURRENT_DESKTOP = "sway";
        };

        # Ensure that the environment variables are correctly set for the user systemd units, e.g.:
        # Sway users might achieve this by adding the following to their Sway config file
        # This ensures all user units started after the command (not those already running) set the variables
        # exec systemctl --user import-environment
      }

      (lib.mkIf config.wayland.clipboard {
        # here goes part of the configuration that can be toggled
        environment.systemPackages = with pkgs; [
          # wayland-utils # Wayland utilities, prob only useful for debugging
          wl-clipboard # Command-line copy/paste utilities for Wayland
        ];
      })

      (lib.mkIf config.wayland.screenshare {
        # here goes part of the configuration that can be toggled
        xdg = {
          portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
        };
      })
    ]
  );

}
