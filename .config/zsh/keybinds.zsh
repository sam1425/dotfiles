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
    export ZVM_CURSOR_STYLE_ENABLED=true
    export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    export ZVM_VI_SURROUND_BINDKEY=classic
    export KEYTIMEOUT=20

    zvm_define_widget zvm_surround_quote

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

function zvm_after_lazy_keybindings() {
    # 1. Ensure Surround is active in Classic Mode
    zvm_bindkey vicmd 'S' zvm_surround_add
    zvm_bindkey visual 'S' zvm_surround_add
    zvm_bindkey vicmd 'cs' zvm_surround_edit
    zvm_bindkey vicmd 'ds' zvm_surround_delete

    # 2. Manually map text objects for ALL relevant ZVM maps
    # Use a list to avoid the "select-quoted" escaping nightmare
    local -a zvm_maps
    zvm_maps=($ZVM_VICMD_KEYMAP $ZVM_VISUAL_KEYMAP $ZVM_OPPEND_KEYMAP)

    for map in $zvm_maps; do
        # Quoted objects
        zvm_bindkey $map 'i"' zvm_select_quoted
        zvm_bindkey $map 'a"' zvm_select_quoted
        zvm_bindkey $map "i'" zvm_select_quoted
        zvm_bindkey $map "a'" zvm_select_quoted
        zvm_bindkey $map 'i`' zvm_select_quoted
        zvm_bindkey $map 'a`' zvm_select_quoted
        
        # Bracket objects (common for C development)
        zvm_bindkey $map 'i(' zvm_select_brackets
        zvm_bindkey $map 'a(' zvm_select_brackets
        zvm_bindkey $map 'i{' zvm_select_brackets
        zvm_bindkey $map 'a{' zvm_select_brackets
    done
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
