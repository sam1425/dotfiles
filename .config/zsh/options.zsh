##
## ZSH Options
##

umask 022
zmodload zsh/zle
zmodload zsh/zpty
zmodload zsh/complist

#autoload -Uz colors
#colors
autoload -Uz add-zsh-hook

ZCOMPDUMP="$ZSH_RAM_CACHE/.zcompdump"
if [[ ! -f "$ZCOMPDUMP" && -f "$HOME/.zcompdump" ]]; then
  cp "$HOME/.zcompdump" "$ZCOMPDUMP"
fi

autoload -Uz compinit
if [[ -n "$ZCOMPDUMP"(#qN.mh+24) ]]; then
  (compinit -d "$ZCOMPDUMP" && zcompile "$ZCOMPDUMP") &!
  compinit -i -C -d "$ZCOMPDUMP"
else
  compinit -i -C -d "$ZCOMPDUMP"
fi

zle -N _sudo_command_line

# History
HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

# Autosuggestion
ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$color8,bold"

while read -r opt
do 
  setopt $opt
done <<-EOF
EXTENDED_GLOB
AUTOCD
AUTO_MENU
AUTO_PARAM_SLASH
RE_MATCH_PCRE
PROMPT_SUBST
COMPLETE_IN_WORD
NO_MENU_COMPLETE
HASH_LIST_ALL
ALWAYS_TO_END
NOTIFY
NOHUP
MAILWARN
INTERACTIVE_COMMENTS
APPEND_HISTORY
INC_APPEND_HISTORY
EXTENDED_HISTORY
HIST_IGNORE_ALL_DUPS
HIST_IGNORE_SPACE
HIST_NO_FUNCTIONS
HIST_EXPIRE_DUPS_FIRST
HIST_SAVE_NO_DUPS
HIST_REDUCE_BLANKS
EOF

while read -r opt
do 
  unsetopt $opt
done <<-EOF
FLOWCONTROL
SHARE_HISTORY
CORRECT
NOBEEP
NOMATCH
EQUALS
EOF

if [[ ! -f "$ZSH_RAM_CACHE/zoxide_init.zsh" ]]; then
  zoxide init zsh --cmd cd > "$ZSH_RAM_CACHE/zoxide_init.zsh"
fi
source "$ZSH_RAM_CACHE/zoxide_init.zsh"

# vim:filetype=zsh:nowrap
