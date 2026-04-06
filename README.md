# Dotfiles

Simple and fast. My personal dotfiles in my Linux machine.

## 🛠 Tools
These dotfiles modify and enhance the following:

- **Shell**: [Zsh](.config/zsh) (w/ [Starship](.config/starship) & [Sheldon](.config/sheldon))
- **WM**: [i3](.config/i3) & [DWM](.files/suckless/dwm)
- **Terminal**: [Kitty](.config/kitty) & [ST](.files/suckless/stwithpatches)
- **Editor**: [Vim](.vim) & [Emacs](.files/.emacs.d)
- **File Manager**: [Yazi](.config/yazi)
- **Monitor**: [btop](.config/btop)
- **Notifs**: [Dunst](.config/dunst)
- **Compositor**: [Picom](.config/picom)

## ✨ Highlights
- **Fast**: Zsh loads in ~0.35s on old hardware.
- **Custom**: Based on , tweaked for my flow.
- **Scripts**: A collection of useful [tools](.files/.scripts) for daily tasks.
- **Aliases**: Powerful shortcuts for package management, system maintenance, and more.

<img width="659" height="57" alt="image" src="https://github.com/user-attachments/assets/cf6b9a07-8e27-4aa9-932a-53f2d85d41d9" />

## Setup
This repo uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks.

```bash
# Clone the repo
git clone https://github.com/c0mplex/dotfiles.git && cd dotfiles

# Install base dotfiles
./install

# Install everything (base + system + .files)
./install all
```

---
*Feel free to copy what you like!*

Credits:
- zsh config based on [yoru's](https://github.com/raexera/yoru)
