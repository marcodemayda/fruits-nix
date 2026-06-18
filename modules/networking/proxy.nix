# proxy.nix

{ lib, config, ... }:

{
  options = {
    proxy.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.proxy.enable {

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  };
}
