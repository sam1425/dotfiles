##
## Prompt
##

TERM_W=$(tput cols)
TODAY=$(date +%Y-%m-%d)
PROMPT_CACHE="$ZSH_RAM_CACHE/full_prompt_${TERM_W}.txt"

if [[ -f "$PROMPT_CACHE" ]]; then
  cat "$PROMPT_CACHE"
else
  # First run: build the cache
  (
    # Starship init output is already sourced, we just want the art here
    /home/c0mplex/.scripts/system/birthday
    /home/c0mplex/.scripts/loginart/optimizedlogincatwithhtext
  ) | tee "$PROMPT_CACHE"
fi

# Refresh cache in background if needed (e.g., date changed)
# You can manually delete this cache file to force a refresh of the art
if [[ ! -f "$ZSH_RAM_CACHE/sentinel_${TODAY}" ]]; then
  (
    /home/c0mplex/.scripts/system/birthday
    /home/c0mplex/.scripts/loginart/optimizedlogincatwithhtext > "$PROMPT_CACHE"
    touch "$ZSH_RAM_CACHE/sentinel_${TODAY}"
  ) &!
fi

# Starship prompt setup (this part remains dynamic)
if [[ ! -f "$ZSH_RAM_CACHE/starship_init.zsh" ]]; then
  starship init zsh > "$ZSH_RAM_CACHE/starship_init.zsh"
fi
source "$ZSH_RAM_CACHE/starship_init.zsh"

autoload -Uz add-zsh-hook
continuation_line() {
      local prompt_rendered="$(starship prompt)"
      local clean=$(print -P "$prompt_rendered" | sed 's/\x1b\[[0-9;]*m//g')
      PROMPT_INDENT_WIDTH=${#clean}
      PROMPT2=$(printf "%*s%%{\e[1;38;2;251;241;199m%%}❯%%{\e[0m%%} " $(($PROMPT_INDENT_WIDTH - 2)) "")
}
add-zsh-hook precmd continuation_line

# Force cursor (|) at startup
printf '\e[5 q'

# vim:ft=zsh
