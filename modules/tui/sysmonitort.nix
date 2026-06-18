# sysmonitort.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    sysmonitort.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.sysmonitort.enable {

    environment.systemPackages = with pkgs; [
      btop
      # btop-cuda
    ];

    users.users.${config.main-user.userName} = {
      packages = with pkgs; [
        fastfetch
      ];
    };

  };
}
