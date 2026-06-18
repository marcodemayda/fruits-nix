# multiplex.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    multiplex.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.multiplex.enable {
    # config goes here, then importing and module.enable = true; will make it part of the config
    environment.systemPackages = with pkgs; [
      zellij
    ];
  };
}
