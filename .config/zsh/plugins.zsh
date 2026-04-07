##
## Plugins
##

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

eval "$(sheldon source)"

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
