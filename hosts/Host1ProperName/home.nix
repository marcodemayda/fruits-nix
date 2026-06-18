# host1/home.nix

{
  pkgs,
  mainUserName,
  HOSTNAME,
  ...
}:

{

  home.shellAliases = {
    rebuildperf = "privadd && sudo nixos-rebuild switch --flake ~/nixos-config/hosts/${HOSTNAME}/#${HOSTNAME}-perf && privund";
    cddata = "cd /run/media/${mainUserName}/DATA";
  };

  home.username = "${mainUserName}";
  home.homeDirectory = "/home/${mainUserName}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.sessionVariables = {
    SHELL = "${pkgs.bash}/bin/bash";
    EDITOR = "hx";
    TERM = "alacritty";
    PAGER = "less";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
