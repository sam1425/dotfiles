#!/usr/bin/env bash

echo "Hello fello" $(whoami) "from" $(uname)
echo "This is your system info"
echo "your uptime is " $(cut --character=1-10 <(uptime))
echo "You have a processor with" $(nproc) "cores"
echo "You are using the:"${SHELL##*/} "shell"
echo "It is " $(date '+%B %d')
echo "You are using the" $TERM "terminal"
