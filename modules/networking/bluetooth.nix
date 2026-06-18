# bluetooth.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    bluetooth.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.bluetooth.enable {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

  };
}
