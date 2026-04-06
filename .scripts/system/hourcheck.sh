#!/bin/bash

export DISPLAY=:0
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

HOUR=$(date +%H)
if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 20 ]; then
    /usr/bin/brightnessctl s 100%
    XAUTHORITY=$(fd -d1 'xauth_' /tmp --full-path 2>/dev/null | head -1) /usr/bin/redshift -x
else
    /usr/bin/brightnessctl s 10%
    XAUTHORITY=$(fd -d1 'xauth_' /tmp --full-path 2>/dev/null | head -1) /usr/bin/redshift -P -O 3500
fi
