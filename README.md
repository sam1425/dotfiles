# Dotfiles

Simple and fast. My personal dotfiles in my Linux machine.

## 🛠 Tools
These dotfiles modify and enhance the following:

- **Shell**: [Zsh](.config/zsh) (w/ [Starship](.config/starship) & [Sheldon](.config/sheldon))
- **WM**: [DWM](.files/suckless/dwm) & [i3](.config/i3)
- **Terminal**: [ST](.files/suckless/stwithpatches) & [Kitty](.config/kitty)
- **Editor**: [Emacs](.files/.emacs.d) & [Vim](.vim)
- **File Manager**: [Yazi](.config/yazi)
- **Monitor**: [btop](.config/btop)
- **Notifs**: [Dunst](.config/dunst)
- **Compositor**: [Picom](.config/picom)

## Specs
- **Fast**: Zsh loads in ~0.35s on old hardware.
- **Custom**: tweaked for my workflow so don't expect an easy-to-use env.
- **Scripts**: A collection of useful [tools](.files/.scripts) for daily tasks.
- **Aliases**: Shortcuts that i find useful for system maintenance, and terminal-focused workflow.

## Setup
This repo uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks.

```bash
# Clone the repo with submodules
git clone --recurse-submodules --depth=1 https://github.com/sam1425/dot_files.git dotfiles
cd dotfiles
```

### Update Submodules
To pull the latest changes for all submodules:
```bash
git submodule update --remote --recursive
```

```bash
# install base dotfiles (recomended)
./install

# or install everything (base + system + .files)
./install all
```

The installer is safe by default: it stops on conflicts instead of changing
either your existing files or the repository. Review the conflict and move it
aside, or explicitly opt into adoption only after backing it up:

```bash
./install --adopt
```

`install` and `remove` can be run from any directory. Use `./install --help`
or `./remove --help` for the available modes.

### Dependencies

The baseline package manifests live in [packages](packages). Install the
manifest for your distribution before running the installer, then add the
optional packages that match the applications you use. They are intentionally
reviewable lists rather than an installer that changes your system.

---
*feel free to copy what you like!*

credits:
- zsh config based on [yoru's](https://github.com/raexera/yoru)
