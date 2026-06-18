# helix.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    helix.enable = lib.mkEnableOption "enable module";
    helix.mdoxide = lib.mkEnableOption "enable markdown-oxide";
  };

  config = lib.mkIf config.helix.enable (
    lib.mkMerge [
      {
        # base config, enabled by module
        home-manager.users.${config.main-user.userName} = {
          programs.helix = {
            enable = true;
            #package = pkgs.evil-helix; # for full vim commands
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
                # {
                #   name = "markdown";
                #   config = {
                #     markdown.preview.auto = true;
                #     markdown.preview.browser = "firefox";
                #   };
                # }
              ];
            };

            themes = {
              # example custom theme
              mytheme =
                let
                  transparent = "none";
                  white = "#ffffff";
                  gray = "#665c54";
                  dark-gray = "#3c3836";
                  whiteless = "#fbf1c7";
                  black = "#282828";
                  red = "#fb4934";
                  green = "#b8bb26";
                  yellow = "#fabd2f";
                  orange = "#fe8019";
                  blue = "#83a598";
                  magenta = "#d3869b";
                  cyan = "#8ec07c";
                in
                {
                  "ui.menu" = transparent;
                  "ui.menu.selected" = {
                    modifiers = [ "reversed" ];
                  };
                  "ui.linenr" = {
                    fg = gray;
                    bg = dark-gray;
                  };
                  "ui.popup" = {
                    modifiers = [ "reversed" ];
                  };
                  "ui.linenr.selected" = {
                    fg = white;
                    bg = black;
                    modifiers = [ "bold" ];
                  };
                  "ui.selection" = {
                    fg = black;
                    bg = blue;
                  };
                  "ui.selection.primary" = {
                    modifiers = [ "reversed" ];
                  };
                  "comment" = {
                    fg = gray;
                  };
                  "ui.statusline" = {
                    fg = white;
                    bg = dark-gray;
                  };
                  "ui.statusline.inactive" = {
                    fg = dark-gray;
                    bg = white;
                  };
                  "ui.help" = {
                    fg = dark-gray;
                    bg = white;
                  };
                  "ui.cursor" = {
                    modifiers = [ "reversed" ];
                  };
                  "variable" = red;
                  "variable.builtin" = orange;
                  "constant.numeric" = orange;
                  "constant" = orange;
                  "attributes" = yellow;
                  "type" = yellow;
                  "ui.cursor.match" = {
                    fg = yellow;
                    modifiers = [ "underlined" ];
                  };
                  "string" = green;
                  "variable.other.member" = red;
                  "constant.character.escape" = cyan;
                  "function" = blue;
                  "constructor" = blue;
                  "special" = blue;
                  "keyword" = magenta;
                  "label" = magenta;
                  "namespace" = blue;
                  "diff.plus" = green;
                  "diff.delta" = yellow;
                  "diff.minus" = red;
                  "diagnostic" = {
                    modifiers = [ "underlined" ];
                  };
                  "ui.gutter" = {
                    bg = black;
                  };
                  "info" = blue;
                  "hint" = dark-gray;
                  "debug" = dark-gray;
                  "warning" = yellow;
                  "error" = red;
                };

            };

          };
        };
      }

      (lib.mkIf config.helix.mdoxide {
        # here goes part of the configuration that can be toggled
        home-manager.users.${config.main-user.userName} = {
          programs.helix.extraPackages = with pkgs; [
            markdown-oxide # obsidian-like pkm. not fully featured yet but promising
          ];
        };
      })
    ]

  );

}
