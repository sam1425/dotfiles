# Package manifests

These lists cover the base shell, terminal, window-manager, and desktop tools
configured by this repository. They are starting points: hardware-specific
drivers, fonts, and every optional script dependency are deliberately not
installed automatically.

On Arch-based systems, review the list and install it with:

```bash
grep -vE '^\s*(#|$)' arch.txt | sudo pacman -S --needed -
```

On Debian/Ubuntu systems:

```bash
sudo apt-get update
grep -vE '^\s*(#|$)' debian.txt | xargs sudo apt-get install -y
```

Some configured tools are distribution-specific or may come from a third-party
repository (notably `sheldon`, `yazi`, `eza`, and Nerd Fonts). Install those
from a trusted source appropriate for your distribution.
