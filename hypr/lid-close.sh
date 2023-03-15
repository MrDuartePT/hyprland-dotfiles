#!/bin/zsh
DISP_LAPTOP_NVIDIA=$(grep -rnw /home/mrduarte/.config/hypr/grep_output.txt -e 'eDP-1')
EXT_MONITOR=$(grep -rnw /home/mrduarte/.config/hypr/grep_output.txt -e 'HDMI-A-1')

if [ $EXT_MONITOR ]; then
   #External Dispay + LID CLOSE + HYBRID MODE
   if [ $DISP_LAPTOP_NVIDIA ]; then
      hyprctl keyword monitor eDP-1,disable
   else
      hyprctl keyword monitor eDP-2,disable
   fi
   #Change swayidle built in screen is disable
   swayidle -w \
      timeout 299 'grim -s 0.05 -g "0,0 1920x1080" $HOME/.config/hypr/screenlockbg.png' \
      timeout 300 'gtklock -d -m /usr/lib/gtklock/playerctl-module.so -m /usr/lib/gtklock/powerbar-module.so -m /usr/lib/gtklock/userinfo-module.so -b $HOME/.config/hypr/screenlockbg.png' \
      timeout 500 'systemctl suspend' \
      before-sleep 'gtklock -d -m /usr/lib/gtklock/playerctl-module.so -m /usr/lib/gtklock/powerbar-module.so -m /usr/lib/gtklock/userinfo-module.so -b $HOME/.config/hypr/screenlockbg.png'
else
    systemctl suspend
fi