#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

case "$1" in
    on)
        echo "Entering Gamemode..."
        # Set CPU Governor to Performance
        cpupower frequency-set -g performance

        # Disable non-essential services
        systemctl stop sshd
        systemctl stop bluetooth
        systemctl stop cups  # Printing service
        systemctl stop syncthing
        systemctl stop mpd
        systemctl stop mpd-mpris
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
        pkill dwmblocks
        pkill deskflow
        pkill Discord
        pkill zsh
        pkill st
        pkill firefox
        pkill nchat
        wineserver -k 

        echo "Optimization complete."
        ;;
    off)
        echo "Leaving Gamemode..."
        # Set CPU Governor back to Schedutil or Powersave
        cpupower frequency-set -g schedutil

        # Re-enable services
        systemctl start sshd
        systemctl start bluetooth
        systemctl start cups
        systemctl start syncthing

        echo "System restored to default."
        ;;
    *)
        echo "Usage: $0 {on|off}"
        exit 1
        ;;
esac
