#!/bin/sh

output=$(./image_find fullscreen.png ~/tablet/special_quests.png)
if [ $? -eq 0 ]; then
    set -- $output
    IFS=, read x1 y1 <<EOF
$1
EOF
    IFS=, read x2 y2 <<EOF
$2
EOF
    echo "Template found at ($x1,$y1) ($x2,$y2)"
    echo "x1: $x1"
    echo "y1: $y1"
    echo "x2: $x2"
    echo "y2: $y2"
else
    echo "Template not found"
fi
