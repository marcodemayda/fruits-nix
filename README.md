Bare fruits-nix framework.
Just a skeleton to get a rough idea of the structure,
or slowly transition by grabbing the template files.

## Overview chart

(broken on codeberg for some reason)

```mermaid
flowchart BT

  subgraph HOST1
    direction BT
    configuration.nix --> flake.nix
    home.nix --> configuration.nix
    home.nix --inputs&module--- flake.nix
    host1-config.nix --> configuration.nix
    host1-hardware.nix --> configuration.nix
    hardware.nix --> configuration.nix
  end

subgraph HOST2
    direction BT
    conf2[configuration.nix] --> flake2[flake.nix]
    home2[home.nix] --> conf2
    home2 --inputs&module--- flake2
    host2-config.nix --> conf2
    host2-hardware.nix --> conf2
    hardware2[hardware.nix] --> conf2
  end


 subgraph MODULES
  direction BT
  default.nix --> core.nix
  core.nix --> configuration.nix
  core.nix --> conf2
  module1 --auto --> default.nix
  module2 --auto --> default.nix
  module3[...] --auto --> default.nix

    subgraph flake-fruits
        subgraph module1-fruit
        flake-fruit[flake.nix] --inputs--> flake.nix
        end
        subgraph module2-fruit
        flake-fruit2[flake.nix] --inputs--> flake2
        end
    end
  end
```


## Bootsratp

(from a fresh install)

### Starter Config

In the starter-config, add/edit the hostname, and add git to the packages.
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

### Get fruits-nix

```
git clone <link-to-repo>
```

Instructions assume you cloned under your home folder, and renamed the repo "nixos-config".
Adjust accordingly.

### Prepare config

#### Merge with generated
Copy the generated config so we have them in the repo.
I like to just have it in the home folder.

```
cd <repo>
mkdir hosts/<host>/temp
cp /etc/nixos/configuration.nix hosts/<host>/temp
cp /etc/nixos/hardware-configuration.nix hosts/<host>
```
As of the current setup, the only thing that needs merging is the
`boot.initrd.luks.devices."luks-<device-id>".device = "<disk-uuid-path>"`
for some reason it is generated in `configuration.nix` instead of `hardware-configuration.nix`.
I like to place it in `<host>-hardware.nix`

### TODO's

Now follow the [[TODO]] file.
