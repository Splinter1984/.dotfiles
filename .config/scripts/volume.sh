#!/usr/bin/env bash

case "$1" in
-inc)
  pamixer -u && pamixer -i 1
  dunstify " Volume: "\
    -u low \
    -h int:value:$(pamixer --get-volume) \
    -h string:synchronous:volume \
    # -i audio-volume-high
  ;;
-dec)
  pamixer -u && pamixer -d 1
  dunstify " Volume: " \
    -u low \
    -h int:value:$(pamixer --get-volume) \
    -h string:synchronous:volume \
    # -i audio-volume-medium
  ;;
-mute)
  if [ $(pamixer --get-mute) == true ]; then
    pamixer -u
    dunstify " Unmute" \
      -u low \
      -h string:synchronous:volume \
      # -i audio-volume-high
  else
    pamixer -m
    dunstify "󰸈 Mute" \
      -u low \
      -h string:synchronous:volume \
      # -i audio-off
  fi
  ;;
*)
  exit 1
  ;;
esac
