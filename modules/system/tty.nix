# tty.nix

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.tty;
in
{
  options.tty = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    # working decently. colors could be more precise
    # but the coloring logic is different for some reason, so it's hard
    console = {
      earlySetup = true;
      useXkbConfig = true; # uses xserver layout
      packages = with pkgs; [ terminus_font ];
      font = "ter-220b";

      # A sort of gruber-darker theme.
      # tried my best...
      colors = [
        "000000"
        "ffdd33"
        "96a6c8"
        "f4f4ff"

        "cc8c3c"
        "ffdd33"
        "ffdd33"
        "9e95c7"

        "484848"
        "f43841"
        "ffdd33"
        "96a6c8"

        "96a6c8"
        "f43841"
        "95a99f"
        "e4e4ef"
      ];

    };

  };
}
