# host1-hardware.nix

{
  config,
  ...
}:

{

  # generated at install
  boot.initrd.luks.devices."luks-5bab1ca5-1713-4b9f-a93f-4lua58edb03f" = {
    device = "/dev/disk/by-uuid/5bab1ca5-1713-4b9f-a93f-4lua58edb03f";
  };
  # TODO: if you LUKS encrypted during installation,
  # in your generated configuration.nix you should have an entry just like the above, but with its own code.
  # Match it and then delete the assertion
  # If you didn't LUKS encrypt, ignore this, and delete both the assertion block and the boot.initrd.luks.devices entry
  assertions = [
    {
      assertion = false;
      message = "If you LUKS encryted you must match your generated boot.initrd.luks.devices";
    }
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "en";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "en";

}
