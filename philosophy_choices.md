Some stuff that you might wnat to think about setting up. Here you can sort of see via my bias what motivated choices for this framework.


### per-host flake vs monolithic flake

Nix-fruits chooses to have per-host flakes. This means `flake.nix` and `flake.lock`live in each host's own config directory, and pull in `./configuration.nix`

This is opposed to having a single flake at the top of your repo that manages all your hosts. Fret not, this is still modular. The flake would have

```
nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
```

and each such instance would pull the modules `hosts/<host>/configuration.nix`. Tis will still correctly rebuild modularly on each hosts.


##### pros of per-host:
- Generally, I like the modularity philosophy being down to the flake level.
- updates (`flake.lock`) are per-host.
  To me, this is important: suppose I'm at home for 4 months, with no reason to use my travel laptop. So, it falls quite behind on updates. I'm now visiting an event abroad; packed my laptop and am on the way. I'm working a little on the train, with scrappy wifi, and notice I'm missing a package i want; i go ahead and add it, rebuild and.... oh 30gb of updates. That's not happening on public wifi. That's annoying as hell. I'm just adding a package, i should have to update every other package i don't care to update, just to add one app. But i'm forced because the lockfile is shared. We can work around it thanks to nix magic () but it's comparatively insanely annoying.
  - relatedly, lock files are more readable (not that they're particularly readable in the first place, but nonetheless).
- MUCH cleaner flake. Having a handfull of host entries in a single flake gets it pretty big and messy pretty fast.
- flake inputs are per-hosts. This is very minor, but it means hosts don't have to download stuff they don't use. 

##### pros of mono flake (and relatedly cons of per-host flake):
- well... one file, tidy (though not internally).
- one configuration: when making eg a fruit that you definetly want in every machine (eg sops for secrets is needed for rebuilds), you don't have to worry about every machine's file.
- (maybe?) top level flake in the repo means the flake is exposed where most people/configs assume it to be.
- TODO: look for more caues idk


### dotfiles: nix-ed or hardlinked

Nix-fruits decided to implement a `/files/` directory, where "traditional-like" files live, to be hardlinked into nixos. The most relevant being dotfiles.

This, as opposed to configuring everything via nixos (often home-manager) own framework.
I don't feel very strongly about this, and in my own config I mix-and-match based on what i find easier in the moment (eg. i had trouble theming alacritty via normal config and it just would not work. Nix-ified and it instantly worked). In general. if the config is very short (terminal-emu, just has font, theme and a couple preferences) I'll have it nix-ed, while longer files (window manager with all the hotkey and logic) i will keep bare.

##### pros of hardlinked:
- portable: Of course you would neeeeever want to switch away from Nixos but... what if?Maybe you get tired of nix shenanigan.  Maybe another declarative distro is better. Maybe your friend isn't converted but wants your dotfiles for an app. Maybe your grandma's PC has linux mint and you want your dotfiles on the user-account you have there... Whatever... if your configs are hardlinked, they're always there for you to copy-paste elsewhere anytime. Nixifying them is a bit like vendor lock-in. You can always translate them back, but it's extra work.
- documentation: if you're hardlinking files, then their behaviour and thus documentation is excactly as it is for any other distro. Whatever manual you're looking up, it's 1:1 instructions to what you're doing. You have one less abstraction to think about "ah so I want this option ~~and so in the nix language i have to do~~". Moreover for copying dotiles. You get to *just* copy them.

##### pros of nix-ed
- much more homogeneous configs; all the config languages are suddenly one
- tidier repo if you fully commit, you can just get rid of `files` entirely.
  - tidier modules, the config lives in the relevant nix module directly for you to see, you don't need to jump to a separate related file.
- syntax changes becomes an upstream issue (looking at you hyprland).



### Nix vs Manual steps
I think there's a plainly correct answer here, no pros and cons.

Firstly, if you're on Nix, work towards being able to configure declaratively. In particular, *hard limit*:
- **do not** touch configuration files manually outside of your repo.
- **do not** install stuff with the package manager like on other distros.

make your config files do all that stuff.

However, for GUI or "program inernal" options... cater to your wants and capabilities with nix; and in particular the trade-off of pain-to-benefit. eg:

- Configuring dotfiles? Do it with nix (either [[philosophy_choices#dotfiles: nix-ed or hardlinked]])
- Configuring browser extensions... you could do it with nix; but it's not so smooth and easy. And often browsers can sync that stuff on login... Still, it's nice to have a single source of truth on rebuild... So do it if it's not painful relative to your nix level.
- Setting up website accounts to be auto-logged in: is it possible to automate site logins declaratively with nix? Maybe, idk. But even if it is, it would be an insane effort; and what does it save you? Using a password manager? Not worth it, just leave it as a manual step.

