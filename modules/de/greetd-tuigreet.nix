# greetd-tuigreet.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    greetd-tuigreet.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.greetd-tuigreet.enable {

    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          # --remember and co. are making me go insane. I don't know if the user
          # relative needs the general one aswell, or a base cmd to override.
          # idk sometimes one works, sometimes the other, sometimes notihng...
          command = "${pkgs.tuigreet}/bin/tuigreet --sessions /etc/console-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --cmd bash --remember --remember-session --user-menu --asterisks --time";
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      # these supposedly saves us from some error messaging spamming on the screen
      # instead of being just registered to journal as they should.
      # from reddit thread "tuigreet with xmonad how".
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true; # flushes boot logs, may want to change
    };
    environment.systemPackages = [ pkgs.tuigreet ];

    environment.etc = {
      "console-sessions/bash-zellij.desktop".text = ''
        [Desktop Entry]
        Name=Bash Zellij
        Comment=Bash with Zellij terminal multiplexer
        Exec=${pkgs.bash}/bin/bash -c "${pkgs.zellij}/bin/zellij"
        Type=Application
      '';

      "console-sessions/zsh-zellij.desktop".text = ''
        [Desktop Entry]
        Name=Zsh Zellij
        Comment=Zsh with Zellij terminal multiplexer
        Exec=${pkgs.zsh}/bin/zsh -c "SHELL=zsh && ${pkgs.zellij}/bin/zellij"
        Type=Application
      '';
    };

  };
}
