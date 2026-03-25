## =============== ##
##   Keybindings   ##
## =============== ##

function smart-k-up() {
    if [[ -n "$_zsh_autosuggest_suggestion" ]]; then
        zle autosuggest-accept
    elif [[ -n "${widgets[history-substring-search-up]}" ]]; then
        zle history-substring-search-up
    else
        zle up-line-or-history
    fi
}

function smart-j-down() {
    if [[ -n "${widgets[history-substring-search-down]}" ]]; then
        zle history-substring-search-down
    else
        zle down-line-or-history
    fi
}


# --- Binds ---
# Vim plugin keybinds:
function zvm_after_init() {

    #export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
    #export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
    export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
    export ZVM_CURSOR_STYLE_ENABLED=true
    export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    export ZVM_VI_SURROUND_BINDKEY=classic
    export KEYTIMEOUT=20

    zvm_define_widget smart-k-up
    zvm_define_widget smart-j-down

    zvm_bindkey viins '^K' smart-k-up
    zvm_bindkey viins '^J' smart-j-down
    zvm_bindkey vicmd '^K' smart-k-up
    zvm_bindkey vicmd '^J' smart-j-down
    zvm_bindkey vicmd 'k' smart-k-up
    zvm_bindkey vicmd 'j' smart-j-down
    zvm_bindkey viins '^y' zvm_yank_to_clipboard

    zvm_bindkey viins '^B' _sudo_command_line
    zvm_bindkey vicmd '^B' _sudo_command_line
}

# Add text object extension -- eg ci" da(:
#autoload -U select-quoted
#zle -N select-quoted
#for m in visual viopp; do
    #for c in {a,i}{\',\",\`}; do
        #bindkey -M $m $c select-quoted
    #done
#done
# vim:ft=zsh:nowrap
