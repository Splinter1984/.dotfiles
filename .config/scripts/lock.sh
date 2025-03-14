#!/bin/bash

# File: lock.sh
# Original Author: Abhishek Yadav
# Upstream: https://github.com/b4skyx/unix-scripts

# Pretty lockscreen implementation using i3lock-color
# Bind this script to a keybind or run using xautolock to execute it on idle/sleep.

# Note: Works only with the i3lock latest version. They changed some flags which broke backwards compatibility.

CLOCK_FONT="Sarasa UI HC"
FONT="Hack Nerd Font Mono"
pngfile="/tmp/sclock.png"
bmpfile="/tmp/sclock.bmp"
glitchedfile="/tmp/sclock_g.bmp"

#quote="$(shuf -n 1 ~/.quotes)"
status=$(playerctl status || true)
music_paused_on_lock=false
#prev-val of --ind-pos="w/2:h-24"

glitch() {
  ##### glitch bg ####

  scrot -z $pngfile

  # convert to bmp and pixelate
  convert -rotate -90 $pngfile $bmpfile

  for a in {1,2,4,5,15}
  do
      # Glitch it with sox FROM: https://maryknize.com/blog/glitch_art_with_sox_imagemagick_and_vim/
      sox -t ul -c 1 -r 48k $bmpfile -t ul $glitchedfile trim 0 100s : echo 1 1 $((a*2)) 0.1
      # Rotate it by 90 degrees
      convert -scale $((100/(a)))% -scale $((100*(a)))% -rotate 90 $glitchedfile $bmpfile
  done

  convert -modulate 80 -gravity center $bmpfile $pngfile
}

lock() {
        #i3lock -n -c 00000066 -e --fill \
        i3lock -n -i $pngfile --fill \
                --ind-pos="w/2:2*h/3+36" \
                --radius=7 --ring-width=8 \
                --ring-color=31363b00 --ringver-color=474f5400 --ringwrong-color=474f5400 \
                --inside-color=474f54 --insidever-color=d39bb600 --insidewrong-color=d39bb600\
                --keyhl-color=bfddb2 --bshl-color=d39bb6 \
                --line-uses-inside \
                --time-str="%H:%M:%S" --time-pos="w/2:h/2-70" \
                --time-color=d0d0d0 --timeoutline-color=868686  --time-font="$CLOCK_FONT:style=Italic" --time-size=64 \
                --date-str="%a, %d %b %Y" --date-pos="tx:ty+42"\
                --date-color=d0d0d0 --date-font="$FONT:style=Bold" --date-size=24 \
                --greeter-text="\"SEE YOU SPACE SAMURAI\"" \
                --greeter-pos="w/2:h/2+18"\
                --greeter-color=d39bb6 --greeter-font="$FONT" --greeter-size=14 \
                --keylayout 2 --layout-pos="18:h-18" --layout-color=999f93 --layout-align=1\
                --layout-font="Hack Nerd Font Mono" \
                --verif-text="Matching Passphrase.." --verif-pos="w/2:h-18" \
                --verif-color=999f93 --verif-font="$FONT" --verif-size=14 \
                --wrong-text="Invalid Passphrase!" --wrong-pos="w/2:h-18" \
                --wrong-color=d76e6e --wrong-font="$FONT" --wrong-size=14 \
                --noinput-text="No Input"
}

# Pause the current playing song
if [ "$status" == "Playing" ]; then
	playerctl pause &
	music_paused_on_lock=true
fi

# kill all rofi instances
if pgrep -x rofi; then
	killall rofi
fi

# lock the screen
glitch
lock
rm $pngfile $bmpfile $glitchedfile

# Resume playback on unlock
if [ "$music_paused_on_lock" = true ]; then
	playerctl play
fi

