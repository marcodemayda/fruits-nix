# git.nix

{
  lib,
  config,
  pkgs,
  privates,
  ...
}:

{
  options = {
    git.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.git.enable {

    environment.systemPackages = with pkgs; [
      lazygit
    ];

    home-manager.users.${config.main-user.userName} = {

      programs.git = {
        enable = true;
        settings = {
          user.name = "${config.main-user.userName}";
          user.email = "${privates.email.gmail}";
          init.defaultBranch = "main";
          pull.rebase = true;
          # submodule.recurse = true;
          # push.recurseSubmodules = "on-demand";
        };
      };

      home.shellAliases.gitgraph = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";

    };

  };

}
