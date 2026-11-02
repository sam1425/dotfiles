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

function _smart-k-up() {
    if [[ -n "$POSTDISPLAY" ]]; then
        BUFFER=$BUFFER$POSTDISPLAY
        CURSOR=$#BUFFER
        POSTDISPLAY=
    elif [[ -n "${widgets[history-substring-search-up]}" ]]; then
        zle history-substring-search-up
    else
        zle up-line-or-history
    fi
}


function _smart-j-down() {
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

function _fzf_find_file() {
    local file
    file=$(fd --type f --hidden --follow --exclude .git 2>/dev/null \
        | fzf --preview 'bat --color=always --line-range :500 {}' --preview-window=right:60%)
    if [[ -n "$file" ]]; then
        BUFFER="$EDITOR $file"
        zle accept-line
    else
        zle reset-prompt
    fi
}
zle -N _fzf_find_file

# --- Binds ---
function zvm_after_init() {

    zvm_define_widget _smart-k-up
    zvm_define_widget _smart-j-down

    zvm_bindkey viins '^K' _smart-k-up
    zvm_bindkey viins '^J' _smart-j-down
    zvm_bindkey vicmd '^K' _smart-k-up
    zvm_bindkey vicmd '^J' _smart-j-down
    zvm_bindkey vicmd 'k' _smart-k-up
    zvm_bindkey vicmd 'j' _smart-j-down

    zvm_bindkey viins '^B' _sudo_command_line
    zvm_bindkey vicmd '^B' _sudo_command_line

    zvm_bindkey viins '^Z' undo

    zvm_bindkey viins '^W' vi-backward-kill-word

    zvm_bindkey viins '^H' vi-backward-kill-word

    #zvm_bindkey viins '^?' vi-backward-kill-word

    zvm_bindkey vicmd '^F' _fzf_find_file

    zvm_bindkey viins '^[[13;2u' zvm_escape_newline_indent

    zvm_bindkey viins '^[[13;5u' zvm_escape_newline_indent
}

function zvm_after_lazy_keybindings() {
        zvm_quote_seeker() {
        # Inlined from zvm_keys() — avoids a subshell fork per keypress
        local keys=${ZVM_KEYS:-$KEYS}
        case "${ZVM_MODE}" in
            ($ZVM_MODE_VISUAL)      [[ "$keys" != v* ]] && keys="v${keys}" ;;
            ($ZVM_MODE_VISUAL_LINE) [[ "$keys" != V* ]] && keys="V${keys}" ;;
        esac
        keys=${keys//$'\n'/$ZVM_ESCAPE_NEWLINE}
        keys=${keys// /$ZVM_ESCAPE_SPACE}

        # Inlined from zvm_parse_surround_keys() — same reason
        local action= surround=
        case "${keys}" in
            (vS*) action=S;    surround=${keys:2} ;;
            (vsa*) action=a;   surround=${keys:3} ;;
            (vys*) action=y;   surround=${keys:3} ;;
            (s[dr]*) action=${keys:1:1}; surround=${keys:2} ;;
            ([acd]s*) action=${keys:0:1}; surround=${keys:2} ;;
            ([cdvy][ia]*) action=${keys:0:2}; surround=${keys:2} ;;
        esac
        local char=${surround// /$ZVM_ESCAPE_SPACE}
        local widget

        if [[ "${action:0:1}" == "v" ]]; then
            widget="zvm_select_surround"
            [[ "$ZVM_MODE" != "$ZVM_MODE_VISUAL" ]] && zvm_select_vi_mode $ZVM_MODE_VISUAL
        else
            widget="zvm_change_surround_text_object"
        fi

        if [[ "$BUFFER" == *"$char"* ]]; then
            local fwd=${BUFFER[(ib:CURSOR+2:)$char]}
            if (( fwd <= ${#BUFFER} )); then
                CURSOR=$((fwd - 1))
            else
                local bwd=${BUFFER[(Ib:CURSOR:)$char]}
                (( bwd > 0 )) && CURSOR=$((bwd - 1))
            fi
        fi

        $widget "$action" "$char"
    }
    zvm_define_widget zvm_quote_seeker

    local -a quotes=('"' "'" '`')
    local q
    for q in $quotes; do
        zvm_bindkey visual "i$q" zvm_quote_seeker
        zvm_bindkey visual "a$q" zvm_quote_seeker
        zvm_bindkey vicmd  "vi$q" zvm_quote_seeker
        zvm_bindkey vicmd  "va$q" zvm_quote_seeker
        zvm_bindkey vicmd  "ci$q" zvm_quote_seeker
        zvm_bindkey vicmd  "ca$q" zvm_quote_seeker
        zvm_bindkey vicmd  "di$q" zvm_quote_seeker
        zvm_bindkey vicmd  "da$q" zvm_quote_seeker
        zvm_bindkey vicmd  "yi$q" zvm_quote_seeker
        zvm_bindkey vicmd  "ya$q" zvm_quote_seeker
        zvm_bindkey viopp  "i$q" zvm_quote_seeker
        zvm_bindkey viopp  "a$q" zvm_quote_seeker
    done
}
# vim:ft=zsh:nowrap
