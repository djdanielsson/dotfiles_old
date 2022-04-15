#!/usr/bin/env bash
#filename="~/Pictures/$(date +'%Y.%m.%d-%H:%m:%S').png"
#echo "Taking screenshot $filename"

#touch $filename
#grim $filename
grim -t jpeg ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).jpg
