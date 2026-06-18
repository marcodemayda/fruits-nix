# alacritty.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    alacritty.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.alacritty.enable {

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

      # xdg.configFile = {
      #   "alacritty" = {
      #     source = ./../../files/homes/users/dotconfig/alacritty;
      #     recursive = true;
      #   };
      # };
    };

  };
}
