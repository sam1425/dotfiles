#!/bin/bash

# Usage: transition.sh [day|night]
MODE=$1
STEPS=60        # number of steps
INTERVAL=60     # seconds between steps (60 steps * 60s = 1 hour transition)

if [ "$MODE" = "day" ]; then
    START_BRIGHT=10
    END_BRIGHT=100
    START_TEMP=3500
    END_TEMP=6500
else
    START_BRIGHT=100
    END_BRIGHT=10
    START_TEMP=6500
    END_TEMP=3500
fi

for i in $(seq 1 $STEPS); do
    # Linear interpolation
    BRIGHT=$(( START_BRIGHT + (END_BRIGHT - START_BRIGHT) * i / STEPS ))
    TEMP=$(( START_TEMP + (END_TEMP - START_TEMP) * i / STEPS ))

    /usr/bin/brightnessctl s ${BRIGHT}%
    /usr/bin/redshift -P -O $TEMP

    sleep $INTERVAL
done
