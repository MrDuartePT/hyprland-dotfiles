#!/bin/zsh
EXT_MONITOR=$(grep -rnw /home/mrduarte/.config/hypr/grep_output.txt -e 'HDMI-A-1')

if [ $EXT_MONITOR ]; then
   hyprctl keyword monitor eDP-1,disable

   #Change swayidle built in screen is disable
   swayidle -w \
      timeout 299 'grim -s 0.05 -g "0,0 1920x1080" $HOME/.config/hypr/screenlockbg.png' \
      timeout 300 'gtklock -d -m /usr/local/lib/gtklock/playerctl-module.so -m /usr/local/lib/gtklock/powerbar-module.so -m /usr/local/lib/gtklock/userinfo-module.so -b $HOME/.config/hypr/screenlockbg.png' \
      timeout 500 'systemctl suspend' \
      before-sleep 'gtklock -d -m /usr/local/lib/gtklock/playerctl-module.so -m /usr/local/lib/gtklock/powerbar-module.so -m /usr/local/lib/gtklock/userinfo-module.so -b $HOME/.config/hypr/screenlockbg.png'
else
    systemctl suspend
fi