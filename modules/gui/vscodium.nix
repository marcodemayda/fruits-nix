#vscodium.nix
#
# NOTE: this module only works with vscodium-fruit imported
{
  lib,
  config,
  pkgs,
  pkgs-vscodium,
  ...
}:

{

  options = {
    vscodium.enable = lib.mkEnableOption "enable module";
    vscodium.nix = lib.mkEnableOption "togglable submodule";
  };

  config = lib.mkIf config.vscodium.enable (
    lib.mkMerge [
      {
        home-manager.users.${config.main-user.userName} = {
          # 26.05 intrduced codium directly
          programs.vscodium = {
            enable = true;
            # package = pkgs.vscodium;
            profiles.default.enableUpdateCheck = false;
            mutableExtensionsDir = false;
            profiles.default.extensions = [
              # note not all extensions are in pkgs-vscodium,
              # in that case you need to fetch from the store:
              # pkgs-vscodium.vscode-marketplace.<extensionname>
              pkgs.vscode-extensions.usernamehw.errorlens
              pkgs-vscodium.vscode-marketplace.christian-kohler.path-intellisense
            ];
          };
        };
      }

      (lib.mkIf config.vscodium.nix {
        # here goes part of the configuration that can be toggled
        home-manager.users.${config.main-user.userName} = {
          programs.vscode.profiles.default.extensions = [
            pkgs.vscode-extensions.jnoortheen.nix-ide
          ];
        };
      })

    ]
  );
}
