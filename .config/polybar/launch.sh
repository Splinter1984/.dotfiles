#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Get network Interface
wifi=$(echo /sys/class/net/*/wireless | awk -F'/' '{ print $5 }')
eth=$(ls /sys/class/net | grep ^e)
WIRELESS_INTERFACE=$wifi ETHERNET_INTERFACE=$eth polybar -c ~/.config/polybar/config.ini top &
WIRELESS_INTERFACE=$wifi ETHERNET_INTERFACE=$eth polybar -c ~/.config/polybar/config.ini bottom &

# Setup
echo 43245 | tee /sys/class/backlight/intel_backlight/brightness
pactl set-source-volume @DEFAULT_SOURCE@ 25%
pactl set-source-mute @DEFAULT_SOURCE@ 1
pactl set-sink-volume @DEFAULT_SINK@ 5%
