# sysmonitor.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysmonitor;
in
{
  options.sysmonitor = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      btop
      # btop-cuda
      fastfetch
    ];

  };
}
