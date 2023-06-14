#!/bin/zsh
EXT_MONITOR=$(grep -rnw /home/mrduarte/.config/hypr/grep_output.txt -e 'HDMI-A-1')

if [ $EXT_MONITOR ]; then
   hyprctl keyword monitor eDP-1,1920x1080,0x1080,1
fi