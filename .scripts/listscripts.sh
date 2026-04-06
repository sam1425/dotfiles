#!/usr/bin/env bash

SCRIPTS="$(fd --search-path ~/.scripts/)"

echo "$SCRIPTS" | awk -F  '/' '{print $NF}' | dmenu 

