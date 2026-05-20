##
## Prompt
##

/home/c0mplex/.scripts/loginart/optimizedlogincatwithhtext

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

# vim:ft=zsh
