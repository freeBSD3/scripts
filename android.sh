#!/bin/sh


random_tap()
{
  local x1=$1 y1=$2 x2=$3 y2=$4

  local min_x=$(( x1 < x2 ? x1 : x2 ))
  local max_x=$(( x1 > x2 ? x1 : x2 ))
  local min_y=$(( y1 < y2 ? y1 : y2 ))
  local max_y=$(( y1 > y2 ? y1 : y2 ))

  local range_x=$(( max_x - min_x + 1 ))
  local range_y=$(( max_y - min_y + 1 ))

  local random_x=$(( $(od -An -N2 -t u2 /dev/urandom) % range_x + min_x ))
  local random_y=$(( $(od -An -N2 -t u2 /dev/urandom) % range_y + min_y ))
  # echo $random_x $random_y

  local id=$(xdotool search --name SM-X510)
  xdotool mousemove $random_x $random_y click 1
}

random_swipe() {
  local num_swipes=$1
  local direction=$2
  local min_x=287
  local max_x=1080
  local min_y=207
  local max_y=630
  local duration=200

  local range_x=$(( max_x - min_x + 1 ))
  local range_y=$(( max_y - min_y + 1 ))
  local swipe_length=$(( range_x * 65 / 100 ))

  local id=$(xdotool search --name SM-X510)

  i=0
  while [ $i -lt $num_swipes ]; do
    local random_y=$(( $(od -An -N2 -t u2 /dev/urandom) % range_y + min_y ))
    local random_x_start random_x_end

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

    local delta_x=$(( random_x_end - random_x_start ))
    local delta_y=$(( $(od -An -N2 -t u2 /dev/urandom) % 40 - 20 ))
    local pitch=$(echo "scale=2; a($delta_y / $delta_x) * 180 / 3.14159265359" | bc -l)
    while [ $(echo "$pitch > 20 || $pitch < -20" | bc -l) -eq 1 ]; do
      delta_y=$(( $(od -An -N2 -t u2 /dev/urandom) % 40 - 20 ))
      pitch=$(echo "scale=2; a($delta_y / $delta_x) * 180 / 3.14159265359" | bc -l)
    done
    local random_y_end=$(( random_y + delta_y ))

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
sleep 15
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
  scrot -a 678,591,180,45 /tmp/replay.png
  scrot -a 1024,724,161,40 /tmp/fight.png
  scrot -a 1088,491,130,30 /tmp/auto.png
  scrot -a 218,106,207,21 /tmp/home.png
  scrot -a 116,635,160,64 /tmp/quests.png
  scrot -a 694,568,230,100 /tmp/rol.png
  scrot -a 60,560,215,50 /tmp/special_quests.png
  scrot -a 1007,719,208,57 /tmp/beginquest.png
  sleep 1

  if image_diff beginquest 90; then
    random_tap 1007 719 1207 760
    sleep 0.55
    random_tap 1007 719 1207 760
  fi

  if image_diff home 95; then
    random_tap 329 125 425 190 
    sleep 0.39
    random_tap 329 125 425 190 
    sleep 5
    random_swipe 3 rl
    sleep 2
    random_tap 490 474 691 683
  fi

  if image_diff quests 90; then
    random_swipe 3 rl
    sleep 2
    random_tap 490 474 691 683
  fi

  if image_diff special_quests 90; then
    random_swipe 5 rl
    sleep 2
    random_tap 699 571 925 705
    sleep 2
    random_tap 832 610 940 712
    sleep 2
  fi

  if image_diff replay 95; then
    random_tap 678 591 858 636
    sleep 0.35
    random_tap 678 591 858 636
    awk -F: '
      BEGIN {
        increments[1]=9
        increments[2]=2
        increments[3]=1
      }
      {$2+=increments[NR]}1' OFS=: "$DOC_PATH" > temp.txt &&
      mv temp.txt "$DOC_PATH"
    cat $DOC_PATH
    sleep 10
  fi

  if image_diff rol 90; then
    random_tap 699 571 925 705
    sleep 2
    random_tap 832 610 940 712
    sleep 2
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
