#!/usr/bin/env bash
INTERVAL=360
export SWWW_TRANSITION_FPS=144

cd $HOME/.config/wallpapers
swww init

while : ; do
	find -not -name '.*' \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
                angle=$((RANDOM % 360))
                swww img "$img" --transition-type wipe --transition-step 144 --transition-angle $angle
			sleep $INTERVAL
		done
done
