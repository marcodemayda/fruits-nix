# sops.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    sops.enable = lib.mkEnableOption "enable module";
  };

  config = lib.mkIf config.sops.enable {

    environment.systemPackages = with pkgs; [
      sops
    ];

    # sets the edit-decryption key to be the same as the generated one for rebuild-decryption
    # If Bootstrapping, you need to comment this out, and use the ./config/... one
    environment.sessionVariables.SOPS_AGE_KEY_FILE = config.sops.age.keyFile;

    # It seems to already be root-only (rw), but in case it isn't you can uncommet:
    # systemd.tmpfiles.rules = [ "f ${config.sops.age.keyFile} 0660 root root" ];

    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
    sops.defaultSopsFile = ./../../modules/sops/sops-nix.yaml;
    # This will automatically import SSH keys as age keys
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # This is using an age key that is expected to already be in the filesystem
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    # This will generate a new key if the key specified above does not exist
    sops.age.generateKey = true; # make sure ssh is not password protected

    # This is the actual specification of the secrets.
    # an example to test
    sops.secrets.example-key = { };

  };
}
