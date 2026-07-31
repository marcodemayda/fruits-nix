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

  # TODO: delete warning once done
  config.warnings = [ "Did you set username and description? \n Did you set hostname?" ];

  ####################
  # NIXOS
  ####################

  # Set home manager for user
  home-manager = {
    backupFileExtension = "backup";
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
      mainUserName = config.main-user.userName;
      HOSTNAME = config.networking.hostName;
    };
    users = {
      "${config.main-user.userName}" = import ./home.nix;
    };
    sharedModules = [
      # flake modules to give hm access to,
      # eg nice for sops-nix
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  # TODO: delete assertions once done
  assertions = [
    {
      assertion = false;
      message = " you MUST match your system stateVersion to the one in your generated config file. \n Delete the assertion block in configuration.nix to continue.";
    }
  ];

}
