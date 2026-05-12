##
## Prompt
##

#TERM_W=$(tput cols)
#TODAY=$(date +%Y-%m-%d)
#PROMPT_CACHE="$ZSH_RAM_CACHE/birthday_${TERM_W}.txt"

#if [[ -f "$PROMPT_CACHE" ]]; then
  #cat "$PROMPT_CACHE"
#else
  #(export COLUMNS=$TERM_W; /home/c0mplex/.scripts/system/birthday) | tee "$PROMPT_CACHE"
#fi
#
#if [[ ! -f "$ZSH_RAM_CACHE/sentinel_${TODAY}" ]]; then
  #(export COLUMNS=$TERM_W; /home/c0mplex/.scripts/system/birthday) > "$PROMPT_CACHE" &!
  #touch "$ZSH_RAM_CACHE/sentinel_${TODAY}"
#fi

#/home/c0mplex/.scripts/loginart/optimizedlogincatwithhtext

if [[ ! -f "$ZSH_RAM_CACHE/starship_init.zsh" ]]; then
  starship init zsh > "$ZSH_RAM_CACHE/starship_init.zsh"
fi
source "$ZSH_RAM_CACHE/starship_init.zsh"

continuation_line() {
      local prompt_rendered="$(starship prompt)"
      local clean=$(print -P "$prompt_rendered" | sed 's/\x1b\[[0-9;]*m//g')
      PROMPT_INDENT_WIDTH=${#clean}
      PROMPT2=$(printf "%*s%%{\e[1;38;2;251;241;199m%%}❯%%{\e[0m%%} " $(($PROMPT_INDENT_WIDTH - 2)) "")
}
add-zsh-hook precmd continuation_line

# cursor (|) at startup
printf '\e[5 q'

# vim:ft=zsh
