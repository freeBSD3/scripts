#!/bin/sh


random_tap()
{
  x1=$1 y1=$2 x2=$3 y2=$4

  min_x=$(( x1 < x2 ? x1 : x2 ))
  max_x=$(( x1 > x2 ? x1 : x2 ))
  min_y=$(( y1 < y2 ? y1 : y2 ))
  max_y=$(( y1 > y2 ? y1 : y2 ))

  range_x=$(( max_x - min_x + 1 ))
  range_y=$(( max_y - min_y + 1 ))

  random_x=$(( $(od -An -N2 -t u2 /dev/urandom) % range_x + min_x ))
  random_y=$(( $(od -An -N2 -t u2 /dev/urandom) % range_y + min_y ))
  # echo $random_x $random_y

  id=$(xdotool search --name SM-X510)
  xdotool mousemove $random_x $random_y click 1
}

random_swipe() {
  num_swipes=$1
  direction=$2
  min_x=287
  max_x=1080
  min_y=207
  max_y=630
  duration=200

  range_x=$(( max_x - min_x + 1 ))
  range_y=$(( max_y - min_y + 1 ))
  swipe_length=$(( range_x * 65 / 100 ))

  id=$(xdotool search --name SM-X510)

  i=0
  while [ $i -lt $num_swipes ]; do
    random_y=$(( $(od -An -N2 -t u2 /dev/urandom) % range_y + min_y ))
    random_x_start=0
    random_x_end=0

    if [ "$direction" = "rl" ]; then
      random_x_start=$(( $(od -An -N2 -t u2 /dev/urandom) % (range_x - swipe_length) + min_x + swipe_length ))
      random_x_end=$(( random_x_start - swipe_length ))
    elif [ "$direction" = "lr" ]; then
      random_x_start=$(( $(od -An -N2 -t u2 /dev/urandom) % (range_x - swipe_length) + min_x ))
      random_x_end=$(( random_x_start + swipe_length ))
    else
      echo "Invalid direction. Please specify 'rl' or 'lr'."
      return 1
    fi

    delta_x=$(( random_x_end - random_x_start ))
    delta_y=$(( $(od -An -N2 -t u2 /dev/urandom) % 40 - 20 ))
    pitch=$(echo "scale=2; a($delta_y / $delta_x) * 180 / 3.14159265359" | bc -l)
    while [ $(echo "$pitch > 20 || $pitch < -20" | bc -l) -eq 1 ]; do
      delta_y=$(( $(od -An -N2 -t u2 /dev/urandom) % 40 - 20 ))
      pitch=$(echo "scale=2; a($delta_y / $delta_x) * 180 / 3.14159265359" | bc -l)
    done
    random_y_end=$(( random_y + delta_y ))

    xdotool mousemove $random_x_start $random_y mousedown 1
    sleep 0.25
    steps=10
    dx=$(( (random_x_end - random_x_start) / steps ))
    dy=$(( (random_y_end - random_y) / steps ))
    j=0
    while [ $j -lt $steps ]; do
      xdotool mousemove $(( random_x_start + j * dx )) $(( random_y + j * dy ))
      sleep $(echo "scale=2; $duration / $steps / 1000" | bc -l)
      j=$((j + 1))
    done
    xdotool mouseup 1
    sleep $(echo "scale=2; $(od -An -N2 -t u2 /dev/urandom) % 47 / 100 + 0.41" | bc -l)
    i=$((i + 1))
  done
}

image_diff() {
  image1=/home/jbm/tablet/$1.png
  image2=/tmp/$1.png
  percent=$2
  diff=$(gm compare -metric RMSE \
    "$image1" "$image2" null: 2>&1)
  similarity=$(echo "$diff" | \
    awk '/Total:/ {print 100 - $2 * 100}' | bc)
  [ $(echo "$similarity >= $percent" | bc) -eq 1 ]
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
sleep 40
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
  adb logcat -c
  rm /tmp/*.png
  sleep 0.25
  scrot /tmp/fullscreen.png
  scrot -a 678,591,180,45 /tmp/replay.png
  scrot -a 1024,724,161,40 /tmp/fight.png
  scrot -a 1088,491,130,30 /tmp/auto.png
  scrot -a 218,106,207,21 /tmp/home.png
  scrot -a 116,635,160,64 /tmp/quests.png
  scrot -a 1007,719,208,57 /tmp/beginquest.png
  scrot -a 500,450,250,100 /tmp/reconnect.png
  sleep 1

  output1=$(./image_find /tmp/fullscreen.png \
    ~/tablet/special_quests.png)
  if [ $? -eq 0 ]; then
    set -- $output1
    IFS=, read x1 y1 <<EOF
    $1
EOF
    IFS=, read x2 y2 <<EOF
    $2
EOF
    random_tap $x1 $y1 $x2 $y2
    sleep 0.36
    random_tap $x1 $y1 $x2 $y2
  fi

  output2=$(./image_find /tmp/fullscreen.png \
    ~/tablet/rol.png)
  if [ $? -eq 0 ]; then
    set -- $output2
    IFS=, read x1 y1 <<EOF
    $1
EOF
    IFS=, read x2 y2 <<EOF
    $2
EOF
    random_tap $x1 $y1 $x2 $y2
  fi

  output3=$(./image_find /tmp/fullscreen.png \
    ~/tablet/rol2.png)
  if [ $? -eq 0 ]; then
    set -- $output3
    IFS=, read x1 y1 <<EOF
    $1
EOF
    IFS=, read x2 y2 <<EOF
    $2
EOF
    random_tap $x1 $y1 $x2 $y2
    sleep 0.41
    random_tap $x1 $y1 $x2 $y2
  fi

  output4=$(./image_find /tmp/fullscreen.png \
    ~/tablet/quests.png)
  if [ $? -eq 0 ]; then
    random_swipe 4 rl
  fi

  output5=$(./image_find /tmp/fullscreen.png \
    ~/tablet/gauntlet.png)
  if [ $? -eq 0 ]; then
    random_swipe 5 rl
  fi

  if image_diff reconnect 80; then
    random_tap 527 473 717 519
    sleep 0.31
    random_tap 527 473 717 519
    echo "Tapped on Reconnect"
  fi

  if image_diff beginquest 90; then
    random_tap 1007 719 1207 760
    sleep 0.55
    random_tap 1007 719 1207 760
  fi

  if image_diff home 95; then
    random_tap 329 125 425 190 
    sleep 0.39
    random_tap 329 125 425 190 
  fi

  if image_diff replay 95; then
    random_tap 678 591 858 636
    sleep 0.35
    random_tap 678 591 858 636
    sleep 10
  fi

  if image_diff fight 95; then
    random_tap 1024 724 1195 764
    sleep 0.57
    random_tap 1024 724 1195 764
    sleep 2
  fi

  if image_diff auto 95; then
    random_tap 1088 491 1212 521
    sleep 0.73
    random_tap 1088 491 1212 521
    sleep 2
  fi

  sleep 15
  adb logcat -c

done &

# Keep screen awake
while xdotool search --name SM-X510 > /dev/null; do
  adb shell input keyevent 224
  sleep 59
done &
