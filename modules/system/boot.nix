# boot.nix

{
  lib,
  config,
  ...
}:

{
  options = {
    boot.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.boot.enable {

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
