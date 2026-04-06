#!/bin/bash
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "fg:#fbf1c7" # Default cream if not in git
    exit
fi

STATUS=$(git status --porcelain 2>/dev/null)
if [[ -z "$STATUS" ]]; then
    echo "fg:#98971a" # Green (Clean)
elif [[ "$STATUS" == *"M"* ]]; then
    echo "fg:#b16286" # Purple (Modified)
elif [[ "$STATUS" == *"A"* ]] || [[ "$STATUS" == *"M "* ]]; then
    echo "fg:#d79921" # Yellow (Staged)
else
    echo "fg:#458588" # Blue (Untracked/Other)
fi
