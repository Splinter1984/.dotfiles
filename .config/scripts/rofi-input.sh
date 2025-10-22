#!/bin/bash

inputs() {
    INPUT=$(pactl list short sources | cut  -f 2 | grep input | rofi -dmenu -p "Input" -mesg "Select prefered input source" )
    pacmd set-default-source "$INPUT" >/dev/null 2>&1

    for recording in $(pacmd list-source-outputs | awk '$1 == "index:" {print $2}'); do
        pacmd move-source-output "$recording" "$INPUT" >/dev/null 2>&1
    done
}

volume_source_up() {
    MUTE=$(get_is_muted) 
    if [ "$MUTE" = "yes" ]; then
      pactl set-source-mute @DEFAULT_SOURCE@ toggle
    fi
    pactl set-source-volume @DEFAULT_SOURCE@ +2%
    dunstify " Volume: " \
          -u low \
          -h int:value:$(pactl get-source-volume @DEFAULT_SOURCE@ | grep Volume | awk '{volume = $5;} END {print $5}') \
          -h string:synchronous:volume \
          -i microphone-sensitivity-high
}

volume_source_down() {
    MUTE=$(get_is_muted) 
    if [ "$MUTE" = "yes" ]; then
      pactl set-source-mute @DEFAULT_SOURCE@ toggle
    fi
    pactl set-source-volume @DEFAULT_SOURCE@ -2%
    dunstify " Volume: " \
          -u low \
          -h int:value:$(pactl get-source-volume @DEFAULT_SOURCE@ | grep Volume | awk '{volume = $5;} END {print $5}') \
          -h string:synchronous:volume \
          -i microphone-sensitivity-high
}

function get_is_muted() {
  pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}'
}

mute_source() {
    MUTE=$(get_is_muted)
    if [ "$MUTE" = "yes" ]; then
        pactl set-source-mute @DEFAULT_SOURCE@ toggle 
        dunstify " Unmute" \
          -u low \
          -h string:synchronous:volume \
          -i microphone-sensitivity-high
    else
        pactl set-source-mute @DEFAULT_SOURCE@ toggle 
        dunstify " Mute" \
          -u low \
          -h string:synchronous:volume \
          -i microphone-sensitivity-muted
    fi 
}

get_default_source() {
  pactl get-default-source
}

input_volume() {
  pactl get-source-volume @DEFAULT_SOURCE@ | grep Volume | awk '{volume = $5; mute = "'"$(get_is_muted)"'"}
    END {print mute=="no"? " " volume: ""}'
}

output_volume_listener() {
    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "change"; then
            output_volume
        fi
    done
}

input_volume_listener() {
    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "change"; then
            input_volume
        fi
    done
}

case "$1" in
    --input)
        inputs
    ;;
    --mute_source)
        mute_source
    ;;
    --volume_source_up)
        volume_source_up
    ;;
    --volume_source_down)
        volume_source_down
    ;;
    --input_volume)
        input_volume
    ;;
    --input_volume_listener)
        input_volume
        input_volume_listener
    ;;
    *)
        echo "Wrong argument"
    ;;
esac
