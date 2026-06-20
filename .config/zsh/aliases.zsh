#  .d8b.  db      d888888b  .d8b.  .d8888. d88888b .d8888.
# d8' `8b 88        `88'   d8' `8b 88'  YP 88'     88'  YP
# 88ooo88 88         88    88ooo88 `8bo.   88ooooo `8bo.
# 88~~~88 88         88    88~~~88   `Y8b. 88~~~~~   `Y8b.
# 88   88 88booo.   .88.   88   88 db   8D 88.     db   8D
# YP   YP Y88888P Y888888P YP   YP `8888Y' Y88888P `8888Y'

#especific for monogame engine
alias mgcb_editor='dotnet mgcb-editor Content/Content.mgcb'
#platform specific:
bgr() { feh --bg-scale "$(command find ~/Pictures/wallpaper -type f | shuf -n1)"; }
alias icat='kitten icat'
alias lynx='command lynx -vikeys'
alias Prompt='PROMPT="%~ % "'

vim() {
  local buf
  buf=$(emacsclient -e "(buffer-name (window-buffer (frame-selected-window (selected-frame))))" 2>/dev/null)
  [[ $buf == "\"$1\"" ]] && { xdotool key alt+2; return }
   command vim "$@"
}
emacs() {
    # Jump to Tag 2 in dwm
    xdotool key alt+2
    # busy until the buffer is closed
    emacsclient -a '' "$@">/dev/null 2>&1
    # Once Emacs is closed, jump back to Tag 1
    xdotool key alt+1
}
alias emacsc="emacsclient -n"
alias vimacs="\emacs -nw"
alias starprompt="source ~/.scripts/prompt"

keyboard() {
    sudo systemd-hwdb update
    sudo udevadm trigger /dev/input/event*
}

brightnessup(){
    magick $1 -brightness -contrast 20x0 $1
}

make(){
  if [ -f justfile ] || [ -f Justfile ]; then
    just "$@"
  else
    command make "$@"
  fi
}

cz() {
  local dir
  dir=$(zoxide query -l | fzf --reverse --height 40% --preview 'eza --tree --level 2 --icons {}' --preview-window right:50%) && cd "$dir"
}

#Useful:
alias exe="chmod +x"
alias c="printf '\033[2J\033[3J\033[1;1H'"
alias q="exit"
alias open='xdg-open'
alias find='fd'
alias grep='grep --color=auto'
alias cleanram="sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'"
alias mktar='tar zcvf' # mktar <archive_compress>
alias untar='tar zxvf' # untar <archive_decompress> <file_list>
alias zp='zip -r' # z <archive_compress> <file_list>
alias ..="\cd .."
alias ...='\cd ../../'
alias ....='\cd ../../..'
alias .....='\cd ../../../../'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias md="mkdir -p"
alias fm='yazi'
alias orphans='pacman -Qtdq | sudo pacman -Rns -'
alias update='mirrors && sudo pacman -Syu'
alias pacin="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
alias paruin="paru -Slq | strings | fzf -m --preview 'paru -Si {1}; echo -e \"\nFILES:\"; paru -Fl {1} | awk \"{print \$2}\" | head -n 100' | xargs -ro paru -S"
alias pacrem="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias paccache='sudo paccache -rk3'
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
alias trimssd="sudo fstrim -va"
alias cpugetavail='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors'
alias cpushowcurrent='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias cpusethigh='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias frecency='zoxide add ~/Documents/Programming >/dev/null 2>&1'
whoown(){
    pacman -Qo $@
}

#Networking
alias ports='netstat -tulanp'
alias myip="curl -s ifconfig.me"

globalip(){
    diff <(myip) <(dig +short iduai.duckdns.org)
}

#Miscelaneous:
alias compresspdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=compressed.pdf"
alias updatediscord='sudo pacman -Sy discord && sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'
unison(){
    command unison $@ -auto
}
alias fonts="fc-list : family | cut -d, -f1 | sort -u | fzf"

#git specific:
source "$HOME/.config/zsh/gitaliases.zsh"
alias gitalias='source "$HOME/.config/zsh/unsourced/gitaliases.zsh"'

# vim:ft=zsh
