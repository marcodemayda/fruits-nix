# host1-hardware.nix

{
  config,
  ...
}:

{

  imports = [
    ./../../modules/system/nvidia-shenanigans.nix
  ];

  # generated at install
  boot.initrd.luks.devices."luks-5aeb1ca5-1713-4b9f-a93f-4eea58edb03f" = {
    device = "/dev/disk/by-uuid/5aeb1ca5-1713-4b9f-a93f-4eea58edb03f";

    # TPM UNLOCK
    crypttabExtraOpts = [
      "tpm2-device=auto"
      "tpm2-measure-pcr=yes"
    ];

  };
  # TPM UNLOCK
  boot.initrd.systemd = {
    enable = true;
    tpm2.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "en";
    variant = "";
  };

  # Configure console keymap
  # grabbed automatically
  # console.keyMap = "it";

}
