# networking.nix

{
  lib,
  config,
  ...
}:
let
  cfg = config.networking;
in
{
  options.networking = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    networking.networkmanager.enable = true;

    # needed for some vpn stuff
    services.resolved = {
      enable = true;
      settings = {
        Resolve.DNSSEC = "allow-downgrade";
        Resolve.DNSOverTLS = "opportunistic";
      };
    };

  };
}
