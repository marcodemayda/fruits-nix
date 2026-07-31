# TODO

You need to do this stuff for the system to rebuild.

- [ ] Follow any TODO comments present in the nix files. Use any program's global search to find them.
  - [ ] TODO's tend to come with a warning or assertion which blocks the rebuild. Remove each as you do the related TODO.
- [ ] check out `interpolants.json` and fill relevant values.
  - [ ] match `hosts/<host1>` with `host1.hostname`
  - [ ] match `files/homes/user` with `general.user`.
    - [ ] if you have exiting dotfiles you want to port, go ahead an paste them in `dotconfig`.
