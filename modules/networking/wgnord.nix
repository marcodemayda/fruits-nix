# wgnord.nix

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.wgnord;
in
{
  options.wgnord = {
    enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      wgnord
    ];

    systemd.tmpfiles.rules = [
      "d /etc/wireguard 0700 root root -"

      "d /var/lib/wgnord 0700 root root -"
    ];
    environment.etc."var/lib/wgnord/template.conf".text = ''
      [Interface]
      PrivateKey = PRIVKEY
      Address = 10.5.0.2/32
      MTU = 1350
      DNS = 103.86.96.100 103.86.99.100

      [Peer]
      PublicKey = SERVER_PUBKEY
      AllowedIPs = 0.0.0.0/0, ::/0
      Endpoint = SERVER_IP:51820
      PersistentKeepalive = 25
    '';

    sops.secrets.nordvpn-token = { };

  };

}
