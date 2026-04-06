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
# Clone the repo
git clone https://github.com/c0mplex/dotfiles.git && cd dotfiles
```

```
# install base dotfiles (recomended)
./install

# or install everything (base + system + .files)
./install all
```

---
*feel free to copy what you like!*

credits:
- zsh config based on [yoru's](https://github.com/raexera/yoru)
