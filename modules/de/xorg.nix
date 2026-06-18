# xorg.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    xorg.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.xorg.enable {

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;
    # you can optimize by adding
    # services.xserver.videoDrivers = [ "brand" ]
    # to the config

    # AI, to remove annoying xterm app
    services.xserver.excludePackages = [ pkgs.xterm ];

  };
}
