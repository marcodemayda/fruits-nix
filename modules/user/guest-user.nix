# guest-user.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    guest-user.enable = lib.mkEnableOption "enable module";

  };

  config = lib.mkIf config.guest-user.enable {

    users.users.guest = {
      isNormalUser = true;
      description = "Guest";
      extraGroups = [
        "users"
      ];
      password = "guest";

      packages = with pkgs; [

      ];
    };

    # reset contents on reboot
    systemd.tmpfiles.rules = [
      "D! /home/guest 0700 guest users"
    ];
  };
}
