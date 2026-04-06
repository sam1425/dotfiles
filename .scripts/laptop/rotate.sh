#!/bin/bash

DEVICE="ELAN Touchscreen"
DISPLAYNAME="eDP1"
 
monitor-sensor | while read -r line; do
    case "$line" in
        *normal*)
            xrandr --output $DISPLAYNAME --rotate normal
            xinput set-prop "$DEVICE" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
            ;;
        #*left-up*)
            #xrandr --output $DISPLAYNAME --rotate left
            #xinput set-prop "$DEVICE" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
            #;;
        #*right-up*)
            #xrandr --output $DISPLAYNAME --rotate right
            #xinput set-prop "$DEVICE" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
            #;;
        *bottom-up*)
            xrandr --output $DISPLAYNAME --rotate inverted
            xinput set-prop "$DEVICE" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
            ;;
    esac
done
