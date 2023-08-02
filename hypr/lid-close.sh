#!/bin/zsh
EXT_MONITOR=$(grep -rnw /home/mrduarte/.config/hypr/grep_output.txt -e 'HDMI-A-1')

#lock command
lock='gtklock -d -m /usr/local/lib/gtklock/playerctl-module.so -m /usr/local/lib/gtklock/powerbar-module.so -m /usr/local/lib/gtklock/userinfo-module.so -b /home/mrduarte/Pictures/wallpapers/DSC_01.jpg'
#lock='swaylock --clock --indicator --indicator-idle-visible --grace-no-mouse --effect-blur 10x2 -i /home/mrduarte/Pictures/wallpapers/DSC_01.jpg -s fill'

if [ $EXT_MONITOR ]; then
   hyprctl keyword monitor eDP-1,disable

   time_1=300 && time_2=310 && time_3=600

swayidle -w \
    timeout $time_1 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on' \
    timeout $time_2 ${lock} \
    timeout $time_3 'systemctl suspend' \
    before-sleep $lock &
else
    systemctl suspend
fi