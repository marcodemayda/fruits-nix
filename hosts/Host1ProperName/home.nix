# host1/home.nix

{
  mainUserName,
  ...
}:

{

  home.username = "${mainUserName}";
  home.homeDirectory = "/home/${mainUserName}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
  # TODO: delete assertions once done
  # If you already had home-manager, match this to the existing installation. Otherwise, set it to the latest version; it's usually the latest stable nixpkgs version.
  assertions = [
    {
      assertion = false;
      message = "you MUST match your home.stateVersion, see comment in file. \n Delete the assertion block in home.nix to continue.";
    }
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
