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
# menu select removed: conflicts with fzf-tab's 'menu no' below
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
HISTFILE="$XDG_CACHE_HOME/.zhistory"
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
BEEP
NOMATCH
EQUALS
EOF

# --- fzf-tab completions styling & previews ---
zstyle ':completion:*' menu no
# Disable use-fzf-default-opts: FZF_DEFAULT_OPTS contains --height=90%, --border, and
# --layout=reverse which conflict with fzf-tab's own internal height math (capped at
# LINES/3*2) and its hardcoded --layout=reverse. The collision collapsed the list to 1 line.
zstyle ':fzf-tab:*' use-fzf-default-opts no
# Port colors, prompt & pointer from FZF_DEFAULT_OPTS into fzf-tab-specific flags.
# fzf-tab appends $fzf_flags last so these safely override its defaults.
zstyle ':fzf-tab:*' fzf-flags \
  '--color=fg:#ebdbb2,fg+:#689d6a,bg+:#282828,hl:#b16286,hl+:#d3869b,info:#cba6f7,prompt:#458588,spinner:#cc241d,pointer:#fe8019,marker:#8ec07c,border:#1e1e2e,header:#fabd2f' \
  '--prompt=<3Ξ' '--pointer=|>' \
  '--bind=tab:down,btab:up'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Previews
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || eza -1 --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:(cd|__zoxide_z):*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -p $word -o cmd= 2>/dev/null'
zstyle ':fzf-tab:complete:kill:*' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'case "$group" in
     "modified file") git diff $word | delta ;;
     "recent commit object name") git show --color=always $word ;;
     *) git log --color=always $word ;;
   esac'
zstyle ':fzf-tab:complete:git-diff:*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'

# vim:filetype=zsh:nowrap

