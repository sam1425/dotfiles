## =============== ##
##   Keybindings   ##
## =============== ##

function smart-k-up() {
    if [[ $CURSOR -gt ${#BUFFER%%$'\n'*} && $BUFFER == *$'\n'* ]]; then
        zle up-line
    elif [[ -n "$_zsh_autosuggest_suggestion" || -n "$POSTDISPLAY" ]]; then
        zle autosuggest-accept
    elif [[ -n "${widgets[history-substring-search-up]}" ]]; then
        zle history-substring-search-up
    else
        zle up-line-or-history
    fi
}

function smart-j-down() {
    if [[ $BUFFER == *$'\n'* ]]; then
        zle down-line
    elif [[ -n "${widgets[history-substring-search-down]}" ]]; then
        zle history-substring-search-down
    else
        zle down-line-or-history
    fi
}


function zvm_escape_newline_indent() {
    LBUFFER+=" \\"
    zle accept-line
}
zle -N zvm_escape_newline_indent

# --- Binds ---
function zvm_after_init() {

    zvm_define_widget smart-k-up
    zvm_define_widget smart-j-down

    zvm_bindkey viins '^K' smart-k-up
    zvm_bindkey viins '^J' smart-j-down
    zvm_bindkey vicmd '^K' smart-k-up
    zvm_bindkey vicmd '^J' smart-j-down
    zvm_bindkey vicmd 'k' smart-k-up
    zvm_bindkey vicmd 'j' smart-j-down

    zvm_bindkey viins '^B' _sudo_command_line
    zvm_bindkey vicmd '^B' _sudo_command_line

    zvm_bindkey viins '^W' vi-backward-kill-word

    zvm_bindkey viins '^H' vi-backward-kill-word

    #zvm_bindkey viins '^?' vi-backward-kill-word

    zvm_bindkey viins '^[[13;2u' zvm_escape_newline_indent
}

function zvm_after_lazy_keybindings() {
    # Checks if there is a detected soround keys ahead
    zvm_quote_seeker() {
        local ret=($(zvm_parse_surround_keys))
        local action=${ret[1]}
        local char=${ret[2]}
        local widget

        # Determine the ZVM internal widget and ensure mode
        if [[ "${action:0:1}" == "v" ]]; then
            widget="zvm_select_surround"
            # Ensure we are in visual mode if calling vi" from cmd mode
            if [[ "$ZVM_MODE" != "$ZVM_MODE_VISUAL" ]]; then
                zvm_select_vi_mode $ZVM_MODE_VISUAL
            fi
        else
            widget="zvm_change_surround_text_object"
        fi

        # Check if surround exists here
        local found=($(zvm_search_surround "$char"))

        if [[ ${#found[@]} == 0 ]]; then
            # No quote here, seek forward
            local next=$(zvm_substr_pos "$BUFFER" "$char" $((CURSOR + 1)) true)
            if [[ $next != -1 ]]; then
                CURSOR=$((next + 1))
            fi
        fi

        # Trigger ZVM action
        $widget "$action" "$char"
    }
zvm_define_widget zvm_quote_seeker

# 2. Explicit Safe Bindings

# --- Double Quotes ---
zvm_bindkey visual 'i"' zvm_quote_seeker
zvm_bindkey visual 'a"' zvm_quote_seeker
zvm_bindkey vicmd  'vi"' zvm_quote_seeker
zvm_bindkey vicmd  'va"' zvm_quote_seeker
zvm_bindkey vicmd  'ci"' zvm_quote_seeker
zvm_bindkey vicmd  'ca"' zvm_quote_seeker
zvm_bindkey vicmd  'di"' zvm_quote_seeker
zvm_bindkey vicmd  'da"' zvm_quote_seeker
zvm_bindkey vicmd  'yi"' zvm_quote_seeker
zvm_bindkey vicmd  'ya"' zvm_quote_seeker
zvm_bindkey viopp  'i"' zvm_quote_seeker
zvm_bindkey viopp  'a"' zvm_quote_seeker

# --- Single Quotes ---
zvm_bindkey visual "i'" zvm_quote_seeker
zvm_bindkey visual "a'" zvm_quote_seeker
zvm_bindkey vicmd  "vi'" zvm_quote_seeker
zvm_bindkey vicmd  "va'" zvm_quote_seeker
zvm_bindkey vicmd  "ci'" zvm_quote_seeker
zvm_bindkey vicmd  "ca'" zvm_quote_seeker
zvm_bindkey vicmd  "di'" zvm_quote_seeker
zvm_bindkey vicmd  "da'" zvm_quote_seeker
zvm_bindkey vicmd  "yi'" zvm_quote_seeker
zvm_bindkey vicmd  "ya'" zvm_quote_seeker
zvm_bindkey viopp  "i'" zvm_quote_seeker
zvm_bindkey viopp  "a'" zvm_quote_seeker

# --- Backticks ---
zvm_bindkey visual 'i`' zvm_quote_seeker
zvm_bindkey visual 'a`' zvm_quote_seeker
zvm_bindkey vicmd  'vi`' zvm_quote_seeker
zvm_bindkey vicmd  'va`' zvm_quote_seeker
zvm_bindkey vicmd  'ci`' zvm_quote_seeker
zvm_bindkey vicmd  'ca`' zvm_quote_seeker
zvm_bindkey vicmd  'di`' zvm_quote_seeker
zvm_bindkey vicmd  'da`' zvm_quote_seeker
zvm_bindkey vicmd  'yi`' zvm_quote_seeker
zvm_bindkey vicmd  'ya`' zvm_quote_seeker
zvm_bindkey viopp  'i`' zvm_quote_seeker
zvm_bindkey viopp  'a`' zvm_quote_seeker
}
# vim:ft=zsh:nowrap
