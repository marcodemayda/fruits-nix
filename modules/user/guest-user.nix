# guest-user.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.guest-user;
in
{
  options.guest-user = {
    enable = lib.mkEnableOption "enable module";

  };

  config = lib.mkIf cfg.enable {

    users.users.guest = {
      isNormalUser = true;
      description = "Guest";
      extraGroups = [
        "users"
      ];
      password = "guest";
    };

    # reset contents on reboot
    systemd.tmpfiles.rules = [
      "D! /home/guest 0700 guest users"
    ];
  };
}
