# ssh.nix

{
  lib,
  config,
  privates,
  ...
}:

{
  options = {
    ssh.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.ssh.enable {

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "${config.main-user.userName}" ];
      };

      extraConfig = ''
        Match user git
          AllowTcpForwarding no
          AllowAgentForwarding no
          PermitTTY no
          X11Forwarding no
      '';
    };

    services.fail2ban.enable = true;

    home-manager.users.${config.main-user.userName} = {

      programs.ssh = {
        enable = true;
        extraConfig = ''
          Host <Host2>
            HostName ${privates.host2.addr}
            Port ${toString privates.host2.port}
            User ${config.main-user.userName}
            IdentityFile ~/.ssh/id_ed25519
            IdentitiesOnly yes
        '';

        # 25.11 eval warning: defautls removed, matchBlock are the equivalents made explicit
        enableDefaultConfig = false;
        # 26.05 evalwarn : changed to
        settings."*" = {
          # ForwardAgent = false;
          # AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };

      };

      services.ssh-agent.enable = true;
    };

  };
}
