#!/bin/bash
FILE_OUTPUT=$(swaymsg --t get_outputs > grep_output.txt)
EXT_MONITOR=$(grep -rnw grep_output.txt -e 'HDMI-A-1')

if [[ $EXT_MONITOR ]]; then
    #notify-send "External Monitor - Disabling Lock on Lid Close"
     exec swayidle -w \
          timeout 300 'grim -s 0.1 -g "0,0 1920x1080" /home/mrduarte/.config/sway/screenlockbg.png && swaylock -f -i /home/mrduarte/.config/sway/screenlockbg.png -s fill' \
          timeout 320 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
          timeout 600 'systemctl hybrid-sleep'
else
    #notify-send "No External Monitor - Activating Lock on Lid Close"
     exec swayidle -w \
          timeout 300 'grim -s 0.1 -g "0,0 1920x1080" /home/mrduarte/.config/sway/screenlockbg.png && swaylock -f -i /home/mrduarte/.config/sway/screenlockbg.png -s fill' \
          timeout 310 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
          timeout 320 'systemctl suspend'
fi

#--clock --grace 5 --grace-no-mouse --indicator 
