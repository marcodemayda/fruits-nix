# firefox.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    firefox.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.firefox.enable {

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

    # For screensharing, need pipe-wire
    # (actually works for me already...)
    # environment.systemPackages = [
    #   # Replace pkgs.firefox with:
    #   (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
    # ];

  };
}
