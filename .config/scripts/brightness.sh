#!/bin/bash

# File: brightness
# Author: Abhishek Yadav
# Upstream: https://github.com/b4skyx/unix-scripts

# Script to increase or decrease your screen brightness.
# Displays a pretty progress bar for brightness levels.
# You can bind this to a keyboard shortcut. Make sure it is in your path.


# Usage:
# brightness -inc <percent>
# brightness -dec <percent>

# Example: Used in sxhkd
#
# XF86MonBrightnessDown
# 	brightness -dec 5
# XF86MonBrightnessUp
# 	brightness -inc 5
#

MAX_BRI=$(cat /sys/class/backlight/intel_backlight/max_brightness)
CUR_BRI=$(cat /sys/class/backlight/intel_backlight/brightness)

((MIN_BRI = MAX_BRI / 10))
((STEP = MAX_BRI * $2 / 100))

((CUR_PER = CUR_BRI * 100 / MAX_BRI))


case $1 in
-inc)
	((NEW_BRI = CUR_BRI + STEP))
	((NEW_PER = NEW_BRI * 100 / MAX_BRI))
	if ((NEW_BRI < MAX_BRI)); then
		echo $NEW_BRI | tee /sys/class/backlight/intel_backlight/brightness
		dunstify " Brightness: " \
      -u  low \
			-h int:value:$NEW_PER \
			-h string:synchronous:brightness \
      -i brightness-systray

	else
		dunstify " Brightness: " \
      -u  low \
			-h int:value:100 \
			-h string:synchronous:brightness \
      -i brightness-systray
  fi
	;;
-dec)
	((NEW_BRI = CUR_BRI - STEP))
	((NEW_PER = NEW_BRI * 100 / MAX_BRI))

	if ((NEW_BRI > MIN_BRI)); then
		echo $NEW_BRI | tee /sys/class/backlight/intel_backlight/brightness
		dunstify " Brightness: "\
      -u  low \
			-h int:value:$NEW_PER \
      -h string:synchronous:brightness \
      -i brightness-systray
	else
		echo $NEW_BRI | tee /sys/class/backlight/intel_backlight/brightness
		dunstify " Brightness: "\
      -u  low \
			-h int:value:$CUR_PER \
      -h string:synchronous:brightness \
      -i brightness-systray
  fi
	;;
-get)
	echo $CUR_PER
	;;
*)
	echo "Invalid arguments."
	;;
esac
