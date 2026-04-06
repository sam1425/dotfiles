#!/bin/bash

CONFIG_FILE="$HOME/dotfiles/.config/picom/picom.conf"
PICOM_PID=$(pgrep -x picom)

if grep -q "blur-method = \"kawase\";" "$CONFIG_FILE"; then
    # Disable Kawase blur
    sed -i '/blur-method = "kawase";/s/^/#/' "$CONFIG_FILE"
    sed -i '/blur-strength = 7;/s/^/#/' "$CONFIG_FILE"
    sed -i '/blur-background = true;/s/^/#/' "$CONFIG_FILE"
else
    # Enable Kawase blur
    sed -i '/#blur-method = "kawase";/s/^#//' "$CONFIG_FILE"
    sed -i '/#blur-strength = 7;/s/^#//' "$CONFIG_FILE"
    sed -i '/#blur-background = true;/s/^#//' "$CONFIG_FILE"
fi

# Reload picom
if [ -n "$PICOM_PID" ]; then
    kill -SIGUSR1 "$PICOM_PID"
else
    picom --config "$CONFIG_FILE" &
fi