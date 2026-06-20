#  @@@@@@  @@@@@@@  @@@@@@@
# @@!  @@@ @@!  @@@   @@!
# @!@  !@! @!@@!@!    @!!
# !!:  !!! !!:        !!:
#  : :. :   :          :

setopt EXTENDED_GLOB
umask 022
zmodload zsh/zle
zmodload zsh/zpty
zmodload zsh/complist

autoload -Uz add-zsh-hook

ZCOMPDUMP="$ZSH_RAM_CACHE/.zcompdump"

# Completion settings
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_RAM_CACHE/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
if [[ -n ${ZCOMPDUMP}(#qN.mh+24) ]]; then
  compinit -i -d "$ZCOMPDUMP"
  # Compile dump file in background for next time
  { zcompile "$ZCOMPDUMP" } &!
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
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
# ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$color8,bold"
#could break:
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

while read -r opt
do 
  setopt $opt
done <<-EOF
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

# vim:filetype=zsh:nowrap
