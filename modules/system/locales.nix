# locales.nix

{
  lib,
  config,
  ...
}:
let
  cfg = config.locales;
in
{
  options.locales = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.locales.enable {

    time.timeZone = "Europe/London";

    # Overall system language
    i18n.defaultLocale = "en_US.UTF-8";

    # specific overrids for certain formats
    # en_IE (ireland) has nice defaults whilst
    # being in english
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IE.UTF-8";
      LC_IDENTIFICATION = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_NAME = "en_IE.UTF-8";
      LC_NUMERIC = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_TELEPHONE = "en_IE.UTF-8";
      LC_TIME = "en_IE.UTF-8";
    };

  };
}
