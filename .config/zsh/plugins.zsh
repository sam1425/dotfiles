##
## Plugins
##

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

if [[ ! -f "$ZSH_RAM_CACHE/sheldon_source.zsh" || "$XDG_CONFIG_HOME/sheldon/plugins.toml" -nt "$ZSH_RAM_CACHE/sheldon_source.zsh" ]]; then
  sheldon source > "$ZSH_RAM_CACHE/sheldon_source.zsh"
fi
source "$ZSH_RAM_CACHE/sheldon_source.zsh"

# Initialize zoxide (placed after plugins to ensure completion works with fzf-tab)
if [[ ! -f "$ZSH_RAM_CACHE/zoxide_init.zsh" ]]; then
  zoxide init zsh --cmd cd > "$ZSH_RAM_CACHE/zoxide_init.zsh"
fi
source "$ZSH_RAM_CACHE/zoxide_init.zsh"

function man() {
  LESS_TERMCAP_mb=$'\e[1;31m' \
  LESS_TERMCAP_md=$'\e[1;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;33m\e[44m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[1;32m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  GROFF_NO_SGR=1 command man "$@"
}

# vim:ft=zsh
