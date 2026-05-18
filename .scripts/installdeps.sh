
#!/usr/bin/env bash

SCRIPTS="$(fd --search-path ~/.scripts/)"

echo "$SCRIPTS" | awk -F  '/' '{print $NF}' | dmenu 


check_deps() {
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || { notify-send "Missing: $cmd"; exit 1; }
    done
}

main(){
    check_deps maim slop
}

main "$@"
