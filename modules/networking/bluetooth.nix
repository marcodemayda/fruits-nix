# bluetooth.nix

{
  lib,
  config,
  ...
}:
let
  cfg = config.bluetooth;
in
{
  options.bluetooth = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

  };
}
