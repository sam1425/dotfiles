#!/bin/bash
MONTH=$(date +%m)
case $MONTH in
    03|04|05) echo "#8ec07c" ;; # Spring (Aqua/Green)
    06|07|08) echo "#fabd2f" ;; # Summer (Yellow)
    09|10|11) echo "#fe8019" ;; # Fall (Orange)
    *)        echo "#d3869b" ;; # Winter (Purple)
esac
