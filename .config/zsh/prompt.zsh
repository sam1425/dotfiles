##
## Prompt
##

# $HOME/.scripts/loginart/optimizedlogincatwithhtext

if [[ ! -f "$ZSH_RAM_CACHE/starship_init.zsh" ]]; then
  starship init zsh > "$ZSH_RAM_CACHE/starship_init.zsh"
fi
source "$ZSH_RAM_CACHE/starship_init.zsh"

# continuation_line() {
#       local prompt_rendered="$(starship prompt)"
#       local clean=$(print -P "$prompt_rendered" | sed 's/\x1b\[[0-9;]*m//g')
#       PROMPT_INDENT_WIDTH=${#clean}
#       PROMPT2=$(printf "%*s%%{\e[1;38;2;251;241;199m%%}❯%%{\e[0m%%} " $(($PROMPT_INDENT_WIDTH - 2)) "")
# }
# add-zsh-hook precmd continuation_line

# cursor (|) at startup
printf '\e[5 q'

# Syntax highlighting colors (set after F-Sy-H loads to avoid being wiped)
FAST_HIGHLIGHT_STYLES+=(
  'command'        'fg=#89B482'
  'alias'          'fg=#89B482'
  'builtin'        'fg=#89B482'
  'function'       'fg=#89B482'
  'keyword'        'fg=#D3869B'
  'string'         'fg=#D8A657'
  'single-quoted-argument' 'fg=#D8A657'
  'double-quoted-argument' 'fg=#D8A657'
  'path'           'fg=#7DAEA3'
  'comment'        'fg=#928374,italic'
  'precommand'     'fg=#D3869B'
)

# vim:ft=zsh
