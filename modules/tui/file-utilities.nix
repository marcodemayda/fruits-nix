# file-utilities.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./yazi.nix
  ];

  options = {
    file-utilities.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.file-utilities.enable {

    yazi.enable = true;

    environment.systemPackages = with pkgs; [
      tree
      fzf # fuzzy search
      #p7zip
      rar
      rsync
    ];

    home-manager.users.${config.main-user.userName} = {
    };

  };
}
