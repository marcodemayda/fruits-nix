# file-utilities.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.file-utilities;
in
{
  imports = [
    ./yazi.nix
  ];

  options.file-utilities = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    yazi.enable = true;

    environment.systemPackages = with pkgs; [
      tree
      fzf # fuzzy search
      p7zip
      rar
      rsync
    ];

  };
}
