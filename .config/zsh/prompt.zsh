##
## Prompt
##

eval "$(starship init zsh)"
autoload -Uz add-zsh-hook
continuation_line() {
      local prompt_rendered="$(starship prompt)"
      local clean=$(print -P "$prompt_rendered" | sed 's/\x1b\[[0-9;]*m//g')
      PROMPT_INDENT_WIDTH=${#clean}
      PROMPT2=$(printf "%*s%%{\e[1;38;2;251;241;199m%%}❯%%{\e[0m%%} " $(($PROMPT_INDENT_WIDTH - 2)) "")
}
add-zsh-hook precmd continuation_line
continuation_line

/home/c0mplex/.scripts/system/birthday
/home/c0mplex/.scripts/loginart/optimizedlogincatwithhtext

# vim:ft=zsh
