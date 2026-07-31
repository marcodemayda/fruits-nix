# media.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.media;
in
{
  options.media = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vlc # video
      qimgv # images
      audacious # audio
    ];
  };
}
