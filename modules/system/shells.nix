# shells.nix

{
  lib,
  config,
  HOSTNAME,
  ...
}:
let
  cfg = config.shells;
in
{
  options.shells = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    environment.pathsToLink = [ "/share/zsh" ];

    home-manager.users.${config.main-user.userName} =
      { config, ... }:
      {

        programs.bash = {
          enable = true;
          # NOTE: deafults to test, meaning to actually generate a generation entry you need to explcity
          # give the "switch" argument instead. I find it usefull not to clutter generations when i'm doing
          # lots of rebuilds for tests, and instead explcitly add a generation when I know i got things neat and
          # working
          # AI:
          initExtra = ''
            rebuild() {
            	(
            		local action="''${1:-test}"
            		local hostname="''${2:-${HOSTNAME}}"
            		local repo="$HOME/nixos-config"

            		git -C "$repo" add -N -f modules/sops/privates.json
            		trap "git -C '$repo' restore --staged modules/sops/privates.json" EXIT
            		sudo nixos-rebuild "$action" --flake "$repo/hosts/$hostname"
            	)
            }

            _rebuild_complete() {
            	local actions="switch boot test dry-activate build dry-build"
            	COMPREPLY=($(compgen -W "$actions" -- "''${COMP_WORDS[COMP_CWORD]}"))
            }
            complete -F _rebuild_complete rebuild
          '';
        };

        home.shellAliases = {
          nixedit = "hx ~/nixos-config";
          nixgit = "lazygit -p ~/nixos-config";
          nixoptimize = "sudo nix-store --optimize";
          nixgc = "sudo nix-collect-garbage --delete-older-than 5d";
          nixgcdel = "sudo nix-collect-garbage -d";
          nixconfig = "y ~/nixos-config";
          nixupdate = "nix flake update --flake ~/nixos-config/hosts/${HOSTNAME}";

          privadd = "git -C ~/nixos-config add -N -f modules/sops/privates.json";
          privund = "git -C ~/nixos-config restore --staged modules/sops/privates.json";
          privenc = ''sudo bash -c "sops -e ~/nixos-config/modules/sops/privates.json > ~/nixos-config/modules/sops/privates_enc.json"'';
          privdec = ''sudo bash -c "sops -d ~/nixos-config/modules/sops/privates_enc.json > ~/nixos-config/modules/sops/privates.json"'';
        };

        programs.starship = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          # Configuration written to ~/.config/starship.toml
          settings = {
            format = ''
              $username@$hostname $battery $fill $time $jobs
              $shell $nix_shell $direnv $fill $memory_usage $cmd_duration
              $directory $git_branch$git_commit$git_state$git_status$git_metrics
              $sudo$shlvl$character
            '';
            add_newline = true;

            battery = {
              full_symbol = "f";
              charging_symbol = "c";
              discharging_symbol = "d";
              unknown_symbol = "u";
              empty_symbol = "e";
              format = "[$symbol$percentage]($style)";
              display = [
                {
                  threshold = 80;
                  style = "green";
                }
                {
                  threshold = 55;
                  style = "yellow";
                }
                {
                  threshold = 15;
                  style = "bold red";
                }
              ];
            };

            cmd_duration = {
              disabled = false;
              min_time = 30000;
              style = "yellow";
              show_notifications = true;
              min_time_to_notify = 60000;
              format = "[$duration]($style)";
            };

            character = {
              success_symbol = "[>](bold green)";
              error_symbol = "[x](bold red)";
            };

            directory = {
              truncation_length = 3;
              truncate_to_repo = false;
              read_only = " (r--)";
              read_only_style = "magenta";
              truncation_symbol = "../";
            };

            direnv = {
              disabled = true;
            };

            fill = {
              symbol = " ";
              style = "grey";
            };

            git_branch = {
              symbol = "|/";
              format = "[$symbol$branch(:$remote_brnach)]($style)";
            };

            git_commit = {
              only_detached = true;
            };

            git_state = {
              rebase = "<->";
              merge = "M";
            };

            git_metrics = {
              disabled = true;
            };

            git_status = {

            };

            hostname = {
              ssh_only = false;
              ssh_symbol = "§";
              format = "[$ssh_symbol$hostname](bold dimmed green)";
            };

            line_break = {
              disabled = true;
            };

            memory_usage = {
              disabled = false;
              threshold = 50;
              symbol = "mem";
              format = "$symbol[$ram swp$swap]($style)";
            };

            nix_shell = {
              impure_msg = "[impure](bold red)";
              pure_msg = "[pure ](bold green)";
              unknown_msg = "[unknown](bold yellow)";
              format = "[$state(nix-\($name\))](bold blue)";
              heuristic = true;
            };

            shell = {
              disabled = false;
              format = "$indicator";
              bash_indicator = "[bsh](bright-white) ";
              zsh_indicator = "[zsh](bright-white) ";
            };

            shlvl = {
              disabled = false;
              format = "[$symbol]($style) "; # $shlvl for numerical option
              symbol = ">";
              repeat = true;
              repeat_offset = 1;
            };

            sudo = {
              disabled = false;
              symbol = "!!";
              format = "$symbol($style)";
            };

            time = {
              disabled = false;
              format = "[$time]($style)";
            };

            username = {
              show_always = true;
              style_user = "bright-white bold";
              style_root = "bright-red bold";
              format = "[$user]($style)";
            };

            package.disabled = true;
          };
        };

      };

  };
}
