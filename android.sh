#!/bin/sh


random_tap() {
  local x1=$1 y1=$2 x2=$3 y2=$4

  local min_x=$(( x1 < x2 ? x1 : x2 ))
  local max_x=$(( x1 > x2 ? x1 : x2 ))
  local min_y=$(( y1 < y2 ? y1 : y2 ))
  local max_y=$(( y1 > y2 ? y1 : y2 ))

  local range_x=$(( max_x - min_x + 1 ))
  local range_y=$(( max_y - min_y + 1 ))

  local random_x=$(( $(od -An -N2 -t u2 /dev/urandom) % range_x + min_x ))
  local random_y=$(( $(od -An -N2 -t u2 /dev/urandom) % range_y + min_y ))
  echo $random_x $random_y

  xdotool mousemove $random_x $random_y click 1
}


if $(doas usbconfig | grep -iq samsung); then
  doas /usr/local/bin/adb kill-server
  sleep 0.5
  doas /usr/local/bin/adb start-server
  
  else
    echo "tablet not found"
fi


sleep 2
scrcpy -m 1250 --max-fps 5 -b 5M --no-audio \
  >/dev/null 2>&1 &
adb logcat -c
sleep 10
adb shell settings put system screen_brightness 2
id=$(xdotool search --name SM-X510)
sleep 0.25
xdotool windowmove $id 0 0
adb shell input keyevent KEYCODE_HOME
adb shell settings put system user_rotation 1
adb logcat -c
sleep 2
random_tap 690 541 726 575

# Replay and auto
while xdotool search --name SM-X510 > /dev/null; do
  rm /tmp/rply.png
  scrot -a 678,591,180,45 /tmp/rply.png
  sleep 1
  diff=$(gm compare -metric RMSE \
    /home/jbm/tablet/replay.png \
    /tmp/rply.png null: 2>&1)
  total=$(echo "$diff" | grep "Total:" | awk '{print $2}')
  similarity=$(echo "scale=2; 100 - ($total * 100)" | bc)
  if [ $(echo "$similarity >= 95" | bc) -eq 1 ]; then
    random_tap 678 591 858 636
    sleep 0.35
    random_tap 678 591 858 636
    sleep 10
  fi

  rm /tmp/fight.png
  scrot -a 1024,724,161,40 /tmp/fight.png
  diff=$(gm compare -metric RMSE /tmp/fight.png \
    /home/jbm/tablet/fight.png null: 2>&1)
  total=$(echo "$diff" | grep "Total:" | awk '{print $2}')
  similarity=$(echo "scale=2; 100 - ($total * 100)" | bc)
  if [ $(echo "$similarity >= 95" | bc) -eq 1 ]; then
    random_tap 1024 724 1195 764
    sleep 0.57
    random_tap 1024 724 1195 764
    sleep 2
    wait
  fi

  rm /tmp/auto.png
  scrot -a 1088,491,130,30 /tmp/auto.png
  diff=$(gm compare -metric RMSE /tmp/auto.png \
    /home/jbm/tablet/auto.png null: 2>&1)
  total=$(echo "$diff" | grep "Total:" | awk '{print $2}')
  similarity=$(echo "scale=2; 100 - ($total * 100)" | bc)
  if [ $(echo "$similarity >= 95" | bc) -eq 1 ]; then
    random_tap 1088 491 1212 521
    sleep 0.73
    random_tap 1088 491 1212 521
    sleep 2
  fi
  sleep 60
done &

# Keep screen awake
while xdotool search --name SM-X510 > /dev/null; do
  adb shell input keyevent 224
  sleep 59
done &
