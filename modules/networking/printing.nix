# printing.nix

{
  lib,
  config,
  ...
}:

{
  options = {
    printing.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.printing.enable {

    # enable CUPS
    services.printing.enable = true;

  };
}
