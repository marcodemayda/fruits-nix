# boot.nix

{
  lib,
  config,
  ...
}:

let
  cfg = config.boot;
in
{
  options.boot = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };

  };
}
