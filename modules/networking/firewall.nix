# firewall.nix

{
  lib,
  config,
  privates,
  ...
}:

{
  options = {
    firewall.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.firewall.enable {

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

  };
}
