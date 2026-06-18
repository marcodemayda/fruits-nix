{
  lib,
  ...
}:

{

  imports = [ ./default.nix ];

  boot.enable = lib.mkDefault true;
  locales.enable = lib.mkDefault true;
  security.enable = lib.mkDefault true;
  tty.enable = lib.mkDefault true;
  shells.enable = lib.mkDefault true;

  sops.enable = true;

  firewall.enable = lib.mkDefault true;
  networking.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;

  file-utilities.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  sysmonitort.enable = lib.mkDefault true;
  multiplex.enable = lib.mkDefault true;

}
