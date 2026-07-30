My flake-fruit configuration framework.

Working on making "bare" and "working example"
versions, right now it's a mish-mash of the two.
Not even sure it compiles at the moment. Lots to improve.


 short first draft of featured ideas:

- modular: its a modular config, of course. You configure some specific thing you may want, and then get to enable or disable it per-host.
- eval-time secrets; about as close I could get
  (because it's not fully possible period. NOTE: also that it is only adequate for "privacy" secrets, not actual secrets; they're still placed in the world readable nix store).
- automatic imports at the top level
- flake "modules": top-level flake has "flake fruits" that it can import cleanly. The main point is just to leave the top-level flake clean and clear; and leave messy details of specific flake pulls to its own file
- no new knowledge: 99% of modules are written like you would write any part of your basic modular config; no new conventions to learn
- homogeneous writing: much like no new knowledge; 99% of modules are written the same. Copy the template, write configuration as you know how to write it.

Ideally, you should be at the "daily driving" level, already be familiar with configuration shenanigans. But should be possible to jump in on day1 of NixOS, since you're just writing nix the same as you're writing it in `configuration.nix` on a fresh install.

# NixOS

## Bootsratp

(from a fresh install)

### Starter Config

In the starter-config, add/edit the hostname, uncomment openssh,
and add git to the packages.
I also like to add convienence packages:
An editor: helix/neovim. Multi-plexer zellij. And yazi and lazygit for navigation of files and repos.

Enable flakes with
```
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
```

This is now a nice and bare fall-back config.
Rebuild with `nixos-rebuild switch`.

### Get Config

create an ssh-key `ssh-keygen`, and allow it in relevant git repo.

```
git clone <ssh-link-to-repo>
```

This part is the most annoying, since on a non-gui install,
you'll need to manually type the key, not having any mode of comunication. 
I haven't thought of a better way... probably would be to temporarily
use password login on ssh and use another machine
that has clipboard utilities and browser at hand. 

### Prepare config

#### Merge with generated
Copy the generated config so we have them in the config repo.
I like to just have it the home folder.

```
mkdir ~/nixos-config/hosts/<host>/temp
cp /etc/nixos/configuration.nix ~/nixos-config/hosts/<host>/temp
rm ~/nixos-config/hosts/<host>/hardware-configuration
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/<host>
```

As of the current setup, the only thing that needs merging is the
`boot.initrd.luks.devices."luks-<device-id>".device = "<disk-uuid-path>"`
for some reason it is generated in `configuration.nix` instead of `hardware-configuration.nix`.
I like to place it in `<host>-hardware.nix`

### Other preparation

Set relevant "HOSTNAME" and "username" entries in `flake.nix` and `configuration.nix`
respectively.

If applicable, the privates.json file needs to be decrypted manually
You'll need a decryption-capable machine, follow [[#adding new hosts]].
Then you can decrypt it with
```
sops -d ~/nixos-config/modules/sops/privates_enc.json > ~/nixos-config/modules/sops/privates.json
```
and fake-stage it for nix to be able to pull its values. After a rebuild, aliases/hooks should take care of it
`cd ~/nixos-config && git -N -f modules/sops/privates.json`

Disable lanzaboote flake, tpm options (in `<host>-hardware.nix`). Follow [[#Secure boot]]
when deciding to re-enable it, as it contains manual steps.

I also like to disable every configuration module in `configuration.nix`
so first rebuild is light and clean with cores only, rather than taking an hour.

### Rebuild

You'll need to manually rebuild once with
```
sudo nixos-rebuild switch --flake ~/nixos-config/hosts/<host>/#hostname
```
(actually "#hostname" should be omittable if it's matched the in config)

From now you should have `rebuild` alias.

Change file owner and permissions

```
sudo chown -R <user>:wheel ~/nixos-config
sudo chmod -R 770 ~/nixos-config
```

### Dissalow Root login

run `sudo passwd -l root`

## Sops

Following the [sops-nix git page](https://github.com/Mic92/sops-nix)
(but re-explained in my own words, cause the guide is way too expansive)

### bootstrapping
Generate the age-key based on the ssh, or a new one. In the former case
you'll have to temporarily remove the password with `ssh-keygen -p`
(enter old password, then empty at prompts).The rest is just as instructed in the guide.

Remember to remove the declared enviroment variable that sets the keypath in sops.nix,
so that you can use the `.config/sops/age` one (see comment in sops.nix).

tl;dr:
1. add sops to flake
2. Enter a shell with `nix-shell -p ssh-to-age age`, then run:

```
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```
or for ssh-based one (you need to remove password):
```
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
```

3. run `age-keygen -y ~/.config/sops/age/keys.txt` to get the public key
4. add said public key to `.sops.yaml` file (use template of the guide if creating new)
5. run `sops secrets/example.yaml` (make sure you have sops package, otherwise use shell)

After rebuilding once, the key in `/var/lib/sops-nix` will be generated.
Fetch it's public key,
```
sudo age-keygen -y /var/lib/sops-nix/key.txt
```
and replace the bootsraped one in `.sops.yaml` file.
Reactivate the enviroment variable setting it's path, rebuild and `sops update <file>`.

Now `sops <sops-file.yaml>` requires `sudo`, since it has to fish a root-owned key.
But we have one key for both editing and rebuilding. And secrets are 
locked behind sudo, which I like.
(we could alternatively manually run the sops command with `SOPS_AGE_KEY_FILE=<path>` each time,
or with an alias, instead of setting it globally in the config file)

Remeber to re-add the ssh passphrase if you had removed it! `ssh-keygen -p`
And remove the keys in .config `rm -r .config/sops/`

### adding new hosts

Rebuild once on the new host (sops will fail to decrypt),
to generate the `/var/lib/sops-nix` key. Fetch the public key
```
sudo age-keygen -y /var/lib/sops-nix/key.txt
```
And add it in the `.sops.yaml` file. Push the changes to git.
You now need to switch to a decryption-capable host.
Pull the changes on the new host, and with it, update the `<sops-file>.yaml`
```
sops updatekeys <path/to/sops-nix.yaml
```
(might have to sudo it as usual)
Push the changes, and once fetched by the new host, they should now be decryptable



## Secure boot

Can be automated, but for the time being, follow
[lanzaboote instructions](https://nix-community.github.io/lanzaboote/introduction.html).
They're suprisingly good

**Note, have the flake OFF to start**, it is to be added as a step, not beforehand.

### TL;DR

Run `bootctl status`. At the top, you should see
```System:
  Firmware: UEFI <version/models>
<...>
Current Boot Loader:
      Product: systemd-boot <version>
```
If not, system cannot be switched to lanzaboote.

Run `sudo sbctl create-keys` (enter shell with sbctl if not available).
Or `sbctl setup --migrate` if keys where already present (doesn't hurt to run both).

_Now add the flake, and rebuild._
Check things are ready, running `sudo sbctl verify`
You should see a bunch of checkmarked entries, except for "kernel-..." ones.
If so, things are ready.

Reboot into BIOS. Genearlly the steps are as follows,
**but things may vary by device, check guide unless you're pretty sure**.

1. Go to “Security” tab.
2. Select the “Secure Boot” entry.
3. Set “Secure Boot” to enabled.
4. Select “Reset to Setup Mode”.

(I've foudn that step 4 actually resets secure boot to disabled.
Just re-enable it if so).
Save and exit.

Once back `sudo sbctl enroll-keys --microsoft`. After restarting,
secure boot should be enabled. You can check as much with
`bootctl status` (shoudl see `Secure Boot: enabled (user)`).
Some devices might need the BIOS option to be re-enabled manually once again.


### TPM
(avoiding to enter password, auto-unlock LUKS by checking if boot keys have
been tampered with).

Following https://discourse.nixos.org/t/a-modern-and-secure-desktop-setup/41154.
But it's a mess, so rephrasing myself (for ext4 systems).

Enable secureboot (make sure it's working, as per guide), ideally put a BIOS password.
Enroll the keys, entering the luks encryption password when prompted:
```
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs="0+2+3+7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000" /dev/<root-partition>
```
Find the partitions with `lsblk`,
(usually `nvme0n1p2` for root and `nvme0n1p3` for swap)

Other potential flags are 1+8+12+13+14:
- 1: BIOS parameters. Triggers with each hibernate (or/and generally missbehaves, for me it always triggered, making tpm pointless)
- 14: triggers with each nixos rebuild

NOTE: if swap has it's own partition and it is also encrypted, you must enroll (same command with `/dev/<swap-partition>`) it too!

Usually in your `<host>-hardware.nix` you should have an entry like
`boot.initrd.luks.devices."luks-<...>".device = "/dev/disk/by-uuid/<...>`.
Add to it:
```
boot.initrd.luks.devices."luks-<...>".crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure-pcr=yes" ];
```

And after rebuilding, it should be done. May have to enter the keys once to activate,
so reboot twice before debugging.


## Troubleshooting

### /boot full, can't rebuild
Especially with lanzaboote, especially at nixos version switches,
`/boot` can fill-up with older generations.
Because cleanup is done after placing new files, this can block rebuilds
as boot directory is out of space.

If this occurs:

- You can double check space `sudo df -h /boot`
- Check entries `sudo ls -lh /boot/EFI/nixos/`
  you'll get entries like: `<...> 195M May 31 10:50 initrd-7.0.10-<...>.efi`
  and `<...> 195M May 31 10:50 kernel-7.0.10-<...>.efi`
- Delete the oldest of each, one `initrd` and one `kernel`, that should be enough

# Manual Steps

## wgnord

You must login once witht he access token. Since it is stored with sops,
you can simply run

```
sudo wgnord l "$(sudo cat /run/secrets/wgnord-token)"
```
