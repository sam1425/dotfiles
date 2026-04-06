## Aliases

#especific for c development
alias makec='clang -o exe'
#especific for monogame engine
alias mgcb_editor='dotnet mgcb-editor Content/Content.mgcb'
#platform specific:
alias bgr='feh --bg-scale "$(find ~/Pictures/wallpaper -type f | shuf -n1)"'
alias icat='kitten icat'
alias lynx='lynx -vikeys'
alias Prompt='PROMPT="%~ % "'
alias emacst='emacsclient -a ''"'
emacs() {
    # Jump to Tag 2 in dwm
    xdotool key alt+2
    # busy until the buffer is closed
    emacsclient -a '' "$@">/dev/null 2>&1
    # Once Emacs is closed, jump back to Tag 1
    xdotool key alt+1
}
alias vimacs="\emacs -nw"

#Useful:
alias c="printf '\033[2J\033[3J\033[1;1H'"
alias q="exit"
alias open='xdg-open'
alias find='fd'
alias grep='grep --color=auto'
alias cleanram="sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'"
alias mktar='tar zcvf' # mktar <archive_compress>
alias untar='tar zxvf' # untar <archive_decompress> <file_list>
alias zp='zip -r' # z <archive_compress> <file_list>
alias sr='source ~/.config/zsh/env.zsh'
alias ..="\cd .."
alias ...='\cd ../../../'
alias ....='\cd ../../../../'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias md="mkdir -p"
alias fm='yazi'
alias pacin="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
alias paruin="paru -Slq | strings | fzf -m --preview 'paru -Si {1}; echo -e \"\nFILES:\"; paru -Fl {1} | awk \"{print \$2}\" | head -n 100' | xargs -ro paru -S"
alias pacrem="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias mirrors="sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
alias pac="pacman -Q | fzf"
alias parucom="paru -Gc"
alias parupd="paru -Qua"
alias pacupd="pacman -Qu"
alias pacpac="pacman -Qent"
alias parucheck="paru -Gp"
alias cleanpac='sudo pacman -Rns $(pacman -Qtdq); paru -c'
alias installed="grep -i installed /var/log/pacman.log"
alias ls="eza --icons --group-directories-first"
alias l="ls -l"
alias l.="ls -A | grep -E '^\.'"
alias listdir="ls -d */ > list"
alias la="ls -a"
alias ld="eza --icons --only-dirs"
alias ll="\ls -alFh"
alias lla="ls -la"
alias llh="ls -lh"
alias lt="ls --tree"
alias cat="bat --color=always --plain"
alias bat="bat --color=always"
alias mv='mv -iv'
alias cp='cp -ivr'
alias copy="xclip -selection clipboard -i"
alias rmvr='rm -vr'
alias xprop='xprop -id $(slop -f "%i" -b 2 -p -2 -c 0.2,0.51,0.45,1 2>/dev/null)'
#Not so useful:
#alias mkgrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
#alias run='pnpm run'
#alias trim_all="sudo fstrim -va"

#Networking
alias ports='netstat -tulanp'

#git specific:
alias gitaliases='source "~/.config/zsh/specific/gitaliases.zsh"'
#Miscelaneous:
alias compresspdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=compressed.pdf"
alias updatediscord='sudo pacman -Syy && sudo pacman -Sy discord && sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'

# vim:ft=zsh
