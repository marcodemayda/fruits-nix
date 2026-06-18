# networking.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    networking.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.networking.enable {

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
