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
    fi
    if [[ -n "${widgets[history-substring-search-up]}" ]]; then
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
        # Inlined from zvm_keys() [jeffreytse/zsh-vi-mode]
        local keys=${ZVM_KEYS:-$KEYS}
        case "${ZVM_MODE}" in
            ($ZVM_MODE_VISUAL)      [[ "$keys" != v* ]] && keys="v${keys}" ;;
            ($ZVM_MODE_VISUAL_LINE) [[ "$keys" != V* ]] && keys="V${keys}" ;;
        esac
        keys=${keys//$'\n'/$ZVM_ESCAPE_NEWLINE}
        keys=${keys// /$ZVM_ESCAPE_SPACE}

        # Inlined from zvm_parse_surround_keys() [jeffreytse/zsh-vi-mode]
        local action= surround=
        case "${keys}" in
            (vS*) action=S;    surround=${keys:2} ;;
            (vsa*) action=a;   surround=${keys:3} ;;
            (vys*) action=y;   surround=${keys:3} ;;
            (s[dr]*) action=${keys:1:1}; surround=${keys:2} ;;
            ([acd]s*) action=${keys:0:1}; surround=${keys:2} ;;
            ([cdvy][ia]*) action=${keys:0:2}; surround=${keys:2} ;;
            ([ia]*) action=${keys:0:1}; surround=${keys:1} ;;
        esac
        local char=${surround// /$ZVM_ESCAPE_SPACE}
        local widget

        if [[ "${action:0:1}" == "v" || "${action:0:1}" == "i" || "${action:0:1}" == "a" ]]; then
            widget="zvm_select_surround"
            [[ "$ZVM_MODE" != "$ZVM_MODE_VISUAL" ]] && zvm_select_vi_mode $ZVM_MODE_VISUAL
        else
            widget="zvm_change_surround_text_object"
        fi

        # Inlined from zvm_match_surround() [jeffreytse/zsh-vi-mode]
        # Resolves open/close pair for brackets; quotes stay symmetric.
        local bchar=$char echar=$char
        case $char in
            ('(') echar=')' ;;
            ('[') echar=']' ;;
            ('{') echar='}' ;;
            ('<') echar='>' ;;
            (')') bchar='(' ;;
            (']') bchar='[' ;;
            ('}') bchar='{' ;;
            ('>') bchar='<' ;;
        esac

        # Plain bounded scan — forward first, backward fallback.
        if [[ "$BUFFER" == *"$bchar"* || "$BUFFER" == *"$echar"* ]]; then
            local len=${#BUFFER} i fwd=0 bwd=0
            for (( i = CURSOR + 1; i <= len; i++ )); do
                [[ ${BUFFER[i]} == "$bchar" || ${BUFFER[i]} == "$echar" ]] && { fwd=$i; break }
            done
            if (( fwd > 0 )); then
                CURSOR=$((fwd - 1))
            else
                for (( i = CURSOR + 1; i >= 1; i-- )); do
                    [[ ${BUFFER[i]} == "$bchar" || ${BUFFER[i]} == "$echar" ]] && { bwd=$i; break }
                done
                (( bwd > 0 )) && CURSOR=$((bwd - 1))
            fi
        fi

        # The real zvm_search_surround/zvm_change_surround_text_object
        # take it from here — they still fork their own subshells
        # internally, but only once per actual action, not per scan.
        $widget "$action" "$char"
    }
    zvm_define_widget zvm_quote_seeker

    local -a surround_chars=('"' "'" '`' '(' ')' '[' ']' '{' '}' '<' '>')
    local c
    for c in $surround_chars; do
        zvm_bindkey visual "i$c" zvm_quote_seeker
        zvm_bindkey visual "a$c" zvm_quote_seeker
        zvm_bindkey vicmd  "vi$c" zvm_quote_seeker
        zvm_bindkey vicmd  "va$c" zvm_quote_seeker
        zvm_bindkey vicmd  "ci$c" zvm_quote_seeker
        zvm_bindkey vicmd  "ca$c" zvm_quote_seeker
        zvm_bindkey vicmd  "di$c" zvm_quote_seeker
        zvm_bindkey vicmd  "da$c" zvm_quote_seeker
        zvm_bindkey vicmd  "yi$c" zvm_quote_seeker
        zvm_bindkey vicmd  "ya$c" zvm_quote_seeker
        zvm_bindkey viopp  "i$c" zvm_quote_seeker
        zvm_bindkey viopp  "a$c" zvm_quote_seeker
    done
    zvm_change_surround() {
    local ret=($(zvm_parse_surround_keys)) 
    local action=${1:-${ret[1]}} 
    local surround=${2:-${ret[2]//$ZVM_ESCAPE_SPACE/ }} 
    local bpos=${3} epos=${4} 
    local is_appending=false 
    case $action in
        (S | y | a) is_appending=true  ;;
    esac
    if $is_appending
    then
        if [[ -z $bpos && -z $epos ]]
        then
            ret=($(zvm_selection)) 
            bpos=${ret[1]} epos=${ret[2]} 
        fi
    else
        # Scan and move cursor to nearest surround char if outside
        local bchar=$surround echar=$surround
        case $surround in
            ('(') echar=')' ;;
            ('[') echar=']' ;;
            ('{') echar='}' ;;
            ('<') echar='>' ;;
        esac
        if [[ "$BUFFER" == *"$bchar"* || "$BUFFER" == *"$echar"* ]]; then
            local len=${#BUFFER} i fwd=0 bwd=0
            for (( i = CURSOR + 1; i <= len; i++ )); do
                [[ ${BUFFER[i]} == "$bchar" || ${BUFFER[i]} == "$echar" ]] && { fwd=$i; break }
            done
            if (( fwd > 0 )); then
                CURSOR=$((fwd - 1))
            else
                for (( i = CURSOR + 1; i >= 1; i-- )); do
                    [[ ${BUFFER[i]} == "$bchar" || ${BUFFER[i]} == "$echar" ]] && { bwd=$i; break }
                done
                (( bwd > 0 )) && CURSOR=$((bwd - 1))
            fi
        fi

        ret=($(zvm_search_surround "$surround")) 
        (( ${#ret[@]} )) || return
        bpos=${ret[1]} epos=${ret[2]} 
        zvm_highlight custom $bpos $(($bpos+1))
        zvm_highlight custom $epos $(($epos+1))
    fi
    local key= 
    case $action in
        (c | r) zvm_enter_oppend_mode
            read -k 1 key
            zvm_exit_oppend_mode ;;
        (S | y | a) if [[ -z $surround ]]
            then
                zvm_enter_oppend_mode
                read -k 1 key
                zvm_exit_oppend_mode
            else
                key=$surround 
            fi
            if [[ $ZVM_MODE == $ZVM_MODE_VISUAL ]]
            then
                zle visual-mode
            fi ;;
    esac
    case "$key" in
        ($'\e' | "${ZVM_VI_ESCAPE_BINDKEY//\^\[/$'\e'}") zvm_highlight clear
            return ;;
    esac
    ret=($(zvm_match_surround "$key")) 
    local bchar=${${ret[1]//$ZVM_ESCAPE_SPACE/ }:-$key} 
    local echar=${${ret[2]//$ZVM_ESCAPE_SPACE/ }:-$key} 
    local value=$($is_appending && echo 0 || echo 1 ) 
    local head=${BUFFER:0:$bpos} 
    local body=${BUFFER:$((bpos+value)):$((epos-(bpos+value)))} 
    local foot=${BUFFER:$((epos+value))} 
    BUFFER="${head}${bchar}${body}${echar}${foot}" 
    zvm_highlight clear
    case $action in
        (S | y | a) zvm_select_vi_mode $ZVM_MODE_NORMAL ;;
    esac
}

    zvm_change_surround_text_object() {
        local ret=($(zvm_parse_surround_keys))
        local action=${1:-${ret[1]}}
        local surround=${2:-${ret[2]//$ZVM_ESCAPE_SPACE/ }}
        local char=$surround

        local bchar=$char echar=$char
        case $char in
            ('(') echar=')' ;;
            ('[') echar=']' ;;
            ('{') echar='}' ;;
            ('<') echar='>' ;;
            (')') bchar='(' ;;
            (']') bchar='[' ;;
            ('}') bchar='{' ;;
            ('>') bchar='<' ;;
        esac

        if [[ "$BUFFER" == *"$bchar"* || "$BUFFER" == *"$echar"* ]]; then
            local len=${#BUFFER} i fwd=0 bwd=0
            for (( i = CURSOR + 1; i <= len; i++ )); do
                [[ ${BUFFER[i]} == "$bchar" || ${BUFFER[i]} == "$echar" ]] && { fwd=$i; break }
            done
            if (( fwd > 0 )); then
                CURSOR=$((fwd - 1))
            else
                for (( i = CURSOR + 1; i >= 1; i-- )); do
                    [[ ${BUFFER[i]} == "$bchar" || ${BUFFER[i]} == "$echar" ]] && { bwd=$i; break }
                done
                (( bwd > 0 )) && CURSOR=$((bwd - 1))
            fi
        fi

        ret=($(zvm_search_surround "${surround}"))
        if [[ ${#ret[@]} == 0 ]]
        then
            zvm_select_vi_mode $ZVM_MODE_NORMAL
            return
        fi
        local bpos=${ret[1]}
        local epos=${ret[2]}
        if [[ ${action:1:1} == 'i' ]]
        then
            ((bpos++))
        else
            ((epos++))
        fi
        CUTBUFFER=${BUFFER:$bpos:$(($epos-$bpos))}
        case ${action:0:1} in
            (c) BUFFER="${BUFFER:0:$bpos}${BUFFER:$epos}"
                    CURSOR=$bpos
                    zvm_select_vi_mode $ZVM_MODE_INSERT ;;
            (d) BUFFER="${BUFFER:0:$bpos}${BUFFER:$epos}"
                    CURSOR=$bpos  ;;
        esac
    }
}

# vim:ft=zsh:nowrap
