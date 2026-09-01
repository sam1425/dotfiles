#!/usr/bin/env bash
set -euo pipefail

check_deps() {
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || { notify-send "Missing: $cmd"; return 1; }
    done
}

check_deps fd dmenu maim slop

fd --search-path "$HOME/.scripts" | awk -F/ '{print $NF}' | dmenu
