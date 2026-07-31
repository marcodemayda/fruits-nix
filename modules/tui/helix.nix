# helix.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.helix;
in
{
  options.helix = {
    enable = lib.mkEnableOption "enable module";
    mdoxide = lib.mkEnableOption "enable markdown-oxide";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home-manager.users.${config.main-user.userName} = {
          programs.helix = {
            enable = true;
            package = pkgs.evil-helix; # for vim commands, enabled since more people are familiar with that.
            extraPackages = with pkgs; [
              nil
              marksman
              yaml-language-server
              tombi
              bash-language-server
              vscode-json-languageserver
              vscode-css-languageserver
            ];

            settings = {
              theme = "gruber-darker";
              editor = {
                line-number = "relative";
                lsp.display-messages = true;
                cursor-shape = {
                  normal = "block";
                  insert = "bar";
                  select = "underline";
                };
                file-picker = {
                  ignore = false;
                  git-ignore = false;
                  hidden = false;
                };
              };
            };

            languages = {
              language = [
                {
                  name = "nix";
                  auto-format = true;
                  formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
                  # official wiki usees instead:
                  # formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
                }
              ];
            };

          };
        };
      }

      (lib.mkIf config.helix.mdoxide {
        home-manager.users.${config.main-user.userName} = {
          programs.helix.extraPackages = with pkgs; [
            markdown-oxide # some obsidian-like functions
          ];
        };
      })
    ]

  );

}
