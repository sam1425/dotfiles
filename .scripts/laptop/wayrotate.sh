#!/bin/bash
DISPLAYNAME="eDP-1" # Check 'wlr-randr' to confirm your display name

monitor-sensor | while read -r line; do
    case "$line" in
        *normal*)
            wlr-randr --output $DISPLAYNAME --transform normal
            ;;
        *bottom-up*)
            wlr-randr --output $DISPLAYNAME --transform 180
            ;;
        *left-up*)
            wlr-randr --output $DISPLAYNAME --transform 90
            ;;
        *right-up*)
            wlr-randr --output $DISPLAYNAME --transform 270
            ;;
    esac
done
