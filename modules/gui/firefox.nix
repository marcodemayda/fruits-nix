# firefox.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.firefox;
in
{
  options.firefox = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265 is promising
    programs.firefox = {
      enable = true;

      languagePacks = [
        "en-US"
      ];

      preferences = {
        # "widget.use-xdg-desktop-portal.file-picker" = 1;
        # "widget.gtk.libadwaita-colors.enabled" = false; # themeing, depends on DE if you want this true or false
      };
      wrapperConfig = {
        pipewireSupport = true;
      };
    };
    # use ALSA
    programs.firefox.package =
      (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped
        { };

  };
}
