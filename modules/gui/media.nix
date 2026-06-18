# media.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    media.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.media.enable {
    # config goes here, then importing and module.enable = true; will make it part of the config
    environment.systemPackages = with pkgs; [
      vlc # video
      qimgv # images
      audacious # audio
    ];
  };
}
