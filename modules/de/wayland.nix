# wayland.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.wayland;
in
{
  options.wayland = {
    enable = lib.mkEnableOption "enable module";
    clipboard = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        qt.enable = true;
        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1"; # electron apps stability on wayland
        };

      }

      (lib.mkIf config.wayland.clipboard {
        # here goes part of the configuration that can be toggled
        environment.systemPackages = with pkgs; [
          # wayland-utils # Wayland utilities, prob only useful for debugging
          wl-clipboard # Command-line copy/paste utilities for Wayland
        ];
      })
    ]
  );

}
