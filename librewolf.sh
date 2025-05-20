#!/bin/sh


/usr/local/bin/librewolf \
  https://www.meta.ai >/dev/null 2>&1 &
sleep 1.5

id=$(echo $(xdotool search \
  --name "LibreWolf") | cut -d' ' -f5)

xdotool windowmove $id 0 0
xdotool windowsize $id 100% 100% +0 +0

sleep 9

xdotool mousemove 770 531 click 1
xdotool type 'hey'
xdotool mousemove 1255 527 click 1
sleep 1
xdotool mousemove 1173 686 click 1
sleep 0.5
xdotool mousemove 1000 500
sleep 0.5
xdotool click --repeat 12 5
xdotool click 1
sleep 0.5
xdotool mousemove 985 747
xdotool click 1
