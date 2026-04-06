#!/bin/bash 
query="$( echo "" | dmenu -p "Search: " <&- )" 
[ -n "${query}" ] && firefox https://www.duckduckgo.com/search?q="${query}" >/dev/null 2>&1 &
