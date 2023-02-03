#!/bin/zsh
DISP_LAPTOP_NVIDIA=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'eDP-1')
EXT_MONITOR=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'HDMI-A-1')

if [ $EXT_MONITOR ]; then
   #External Dispay + LID CLOSE + HYBRID MODE
   if [ $DISP_LAPTOP_NVIDIA ]; then
      hyprctl keyword monitor eDP-1,disable
   else
      hyprctl keyword monitor eDP-2,disable
   fi
   #Change swayidle built in screen is disable
   swayidle -w \
      timeout 300 'grim -s 0.1 -g "0,0 0x1080" $HOME/.config/sway/screenlockbg.png && swaylock -f --clock --indicator  -i $HOME/.config/sway/screenlockbg.png -s fill' \
      timeout 500 'systemctl suspend' \
      before-sleep 'grim -s 0.1 -g "0,0 0x1080" $HOME/.config/hypr/screenlockbg.png && swaylock -f --clock --indicator  -i $HOME/.config/hypr/screenlockbg.png -s fill'
else
    systemctl suspend
fi