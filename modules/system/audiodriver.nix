# audiodriver.nix

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.audiodriver;
in
{
  options.audiodriver = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    # Enable sound with pipewire.
    services.pulseaudio.enable = false; # older
    security.rtkit.enable = true;
    services.pipewire = {
      # newer
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    environment.systemPackages = [
      pkgs.pavucontrol
    ];

  };
}
