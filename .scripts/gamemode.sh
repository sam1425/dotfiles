#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

set_governor() {
    echo "$1" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
}

case "$1" in
    on)
        echo "Entering Gamemode..."
        set_governor performance
        for svc in sshd bluetooth cups syncthing mpd mpd-mpris; do
            systemctl stop "$svc"
        done
        for proc in dwmblocks deskflow Discord emacs firefox nchat fastcompmgr picom \
                    obsidian unclutter dunst clipmenud \
                    polkit-gnome-authentication-agent-1 feh nchat; do
            pkill -x "$proc" 2>/dev/null
        done
        wineserver -k
        echo "Optimization complete."
        ;;
    off)
        echo "Leaving Gamemode..."
        set_governor schedutil
        for svc in sshd bluetooth cups syncthing mpd mpd-mpris; do
            systemctl start "$svc"
        done
        # Restart userspace processes as the desktop user
        DESKTOP_USER=$(logname)
        sudo -u "$DESKTOP_USER" dwmblocks &
        sudo -u "$DESKTOP_USER" picom -b
        sudo -u "$DESKTOP_USER" dunst &
        sudo -u "$DESKTOP_USER" clipmenud &
        sudo -u "$DESKTOP_USER" unclutter &
        sudo -u "$DESKTOP_USER" feh --bg-fill "$(cat ~/.fehbg_path)" &
        echo "System restored to default."
        ;;
    *)
        echo "Usage: $0 {on|off}"
        exit 1
        ;;
esac
