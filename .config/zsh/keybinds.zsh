#  d8b                         d8b        d8,                d8b
#  ?88                         ?88       `8P                 88P
#   88b                         88b                         d88
#   888  d88' d8888b?88   d8P   888888b   88b  88bd88b  d888888   .d888b,
#   888bd8P' d8b_,dPd88   88    88P `?8b  88P  88P' ?8bd8P' ?88   ?8b,
#  d88888b   88b    ?8(  d88   d88,  d88 d88  d88   88P88b  ,88b    `?8b
# d88' `?88b,`?888P'`?88P'?8b d88'`?88P'd88' d88'   88b`?88P'`88b`?888P'
#                          )88
#                         ,d8P
#                      `?888P'

function smart-k-up() {
    if [[ -n "$POSTDISPLAY" && $CURSOR -eq $#BUFFER ]]; then
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


function zvm_escape_newline_indent() {
    if [[ $BUFFER != *$'\n'* ]]; then
        local p="${BUFFER%% -*}"
        [[ "$p" == "$BUFFER" ]] && p="${p%% *}"
        _zvm_pad="${(l:$((${#p} + 1)):: :)}"
    fi
    LBUFFER+=" \\"
    zle -U "$_zvm_pad"
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

    zvm_bindkey vicmd '^F' 

    zvm_bindkey viins '^W' vi-backward-kill-word

    zvm_bindkey viins '^H' vi-backward-kill-word

    #zvm_bindkey viins '^?' vi-backward-kill-word

    zvm_bindkey viins '^[[13;2u' zvm_escape_newline_indent

    zvm_bindkey viins '^[[13;5u' zvm_escape_newline_indent
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
