# printing.nix

{
  lib,
  config,
  ...
}:

let
  cfg = config.printing;
in
{
  options.printing = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    # enable CUPS
    services.printing.enable = true;

  };
}
