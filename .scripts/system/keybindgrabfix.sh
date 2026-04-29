#!/bin/sh

wm_class=$(xdotool getactivewindow getwindowclassname 2>/dev/null)

if [ "$wm_class" = "Emacs" ]; then
    xdotool key --clearmodifiers alt+x
else
    dmenu_run
fi
