# alacritty.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.alacritty;
in
{
  options.alacritty = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      alacritty
    ];

    home-manager.users.${config.main-user.userName} = {

      programs.alacritty = {
        enable = true;
        settings = {
          window.startup_mode = "Maximized";
          terminal = {
            shell.program = "${pkgs.zellij}/bin/zellij";
          };
          font = {
            size = 13;
          };
        };
        theme = "gruber_darker";

      };

      # configured via nix instead, as above
      # xdg.configFile = {
      #   "alacritty" = {
      #     source = ./../../files/homes/users/dotconfig/alacritty;
      #     recursive = true;
      #   };
      # };
    };

  };
}
