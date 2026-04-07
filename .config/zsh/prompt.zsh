##
## Prompt
##

eval "$(starship init zsh)"
#PROMPT2="                    ❯"
precmd() {
    local prompt_rendered="$(starship prompt)"
    local clean=$(print -P "$prompt_rendered" | sed 's/\x1b\[[0-9;]*m//g')
    PROMPT_INDENT_WIDTH=${#clean}
    PROMPT2=$(printf "%*s\e[1m❯\e[0m " $(($PROMPT_INDENT_WIDTH - 2)) "")
}
/home/c0mplex/.scripts/system/birthday 
/home/c0mplex/.scripts/loginart/optimizedlogincatwithhtext

# vim:ft=zsh
