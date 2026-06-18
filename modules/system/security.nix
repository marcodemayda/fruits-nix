# security.nix

{
  lib,
  config,
  ...
}:

{
  options = {
    security.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.security.enable {

    security.sudo = {
      enable = true;
      execWheelOnly = true;
      # extraRules = [
      #   {
      #     # rebuilds
      #     users = [ "${config.main-user.userName}" ];
      #     groups = [ "wheel" ];
      #     commands = [
      #       {
      #         command = "/run/current-system/sw/bin/nixos-rebuild switch --flake *";
      #         options = [ "NOPASSWD" ];
      #       }
      #       {
      #         command = "/run/current-system/sw/bin/nixos-rebuild test --flake *";
      #         options = [ "NOPASSWD" ];
      #       }
      #       {
      #         command = "/run/current-system/sw/bin/nixos-rebuild boot --flake *";
      #         options = [ "NOPASSWD" ];
      #       }
      #       {
      #         command = "/run/current-system/sw/bin/nix-store --optimize";
      #         options = [ "NOPASSWD" ];
      #       }
      #       {
      #         command = "/run/current-system/sw/bin/nix-collect-garbage *";
      #         options = [ "NOPASSWD" ];
      #       }
      #     ];
      #   }
      # ];
    };

  };
}
