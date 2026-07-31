# firewall.nix

{
  lib,
  config,
  ...
}:
let
  cfg = config.firewall;
in
{
  options.firewall = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    networking.firewall.enable = true;

  };
}
