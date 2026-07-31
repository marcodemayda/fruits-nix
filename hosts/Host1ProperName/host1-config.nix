# host1-config.nix

{
  HOSTNAME,
  ...
}:

{

  networking.hostName = HOSTNAME;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

}
