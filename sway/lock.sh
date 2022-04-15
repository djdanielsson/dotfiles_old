#!/bin/bash
trap cleanup 0 1 2 3 6

image="/tmp/lock_sway_image-$$.png"
text="/tmp/lock_sway_text-$$.png"
width=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .current_mode.width')

function cleanup {
  rm ${image}
  rm ${text}
}


# Generate screenshot of currently focused monitor
grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') ${image}

# and then blur
convert ${image} -scale 85% -blur 0x4 -scale 100% -fill black -colorize 55% ${image}

[[ -f $1 ]] && convert ${image} $1 \
                 -gravity center   \
                 -composite        \
                 -matte ${image}

[ -f $text ] || {
    convert -size ${width}x60 xc:gray \
            -font Fira Code \
            -pointsize 56 \
            -fill white \
            -alpha activate \
            -gravity center \
            -kerning 50 \
            -annotate +0+0 "LOCKED" ${text};
}

convert ${image} ${text} -gravity center -geometry +0+200 -composite ${image}

swaylock -s fill -i ${image}
