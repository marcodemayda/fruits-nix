# host1-config.nix

{
  pkgs,
  config,
  HOSTNAME,
  interpolants,
  ...
}:

{

  networking.hostName = HOSTNAME;

  # could remove once stable caught up to kernel 7.(...)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.${config.main-user.userName}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 <host2-pub-key> ${interpolants.general.user}"
  ];

}
