# yazi.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yazi;
in
{
  options.yazi = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    programs = {
      yazi = {
        enable = true;

        settings = {
          yazi = {
            ## git
            plugin.prepend_fetchers = [
              {
                id = "git";
                url = "*";
                run = "git";
                group = "git";
              }
              {
                id = "git";
                url = "*/";
                run = "git";
                group = "git";
              }
            ];
          };

          keymap = {
            mgr.prepend_keymap = [
              ## mount manager
              {
                on = "M";
                run = "plugin mount";
                desc = "Mount manager";
              }
              ## clipboard
              {
                on = "y";
                run = [
                  "yank"
                  "plugin clipboard -- --action=copy"
                ];
              }
              {
                on = [ "<C-p>" ];
                run = [ "plugin clipboard -- --action=paste" ];
              }
            ];
          };
        };

        initLua = ./../../files/homes/users/dotconfig/yazi/init.lua;
      };
    };

    home-manager.users.${config.main-user.userName} = {
      # make y a hotkey for yazi, such that exiting yazi cd's into the
      # directory you visited, not the one you started
      programs.bash.bashrcExtra = ''
        # yazi shell to quit to currenct directory
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d \'\' cwd < "$tmp"
          [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }
      '';
    };

  };

}
