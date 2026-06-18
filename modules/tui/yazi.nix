# yazi.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    yazi.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.yazi.enable {

    # TODO Maybe try to inject Nix config
    # with lib.fromToml (or whatever)
    programs = {
      yazi = {
        enable = true;
        plugins = with pkgs.yaziPlugins; {
          # remember they're not plug-n-play
          # you need to edit some of the configs
          git = git;
          mount = mount;
          clipboard = clipboard;
          # yafg = yafg; # fuzzy finder
          # yaziPlugins.sudo
          # restore/recycle-bin
        };

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
