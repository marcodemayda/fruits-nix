# host1/configuration.nix

{
  inputs,
  config,
  interpolants,
  privates,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./host1-config.nix
    ./host1-hardware.nix
    ./../../modules/core.nix
  ];

  ####################
  # MODULES
  ####################
  main-user = {
    enable = true;
    userName = "${interpolants.general.user}";
    description = "${privates.fullname}";
  };

  bluetooth.enable = true;
  printing.enable = true;
  ssh.enable = true;

  audiodriver.enable = true;
  greetd-tuigreet.enable = true;
  helix = {
    enable = true;
    mdoxide = true;
  };

  firefox.enable = true;
  media.enable = true;

  ####################
  # NIXOS
  ####################

  # Set home manager for user
  home-manager = {
    backupFileExtension = "backup";
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
      inherit privates;
      mainUserName = config.main-user.userName;
      HOSTNAME = config.networking.hostName;
    };
    users = {
      "${config.main-user.userName}" = import ./home.nix;
    };
    sharedModules = [
      # might need this since configuruation and
      # home-manager are unified, but not sure,
      # HM might need secrets defined in its own modules
      inputs.sops-fruit.homeManagerModules.sops
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # make shell command follow your system's packages channel
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
