#!/bin/zsh

#ADD TO HYPERLAND CONFIG: exec = $HOME/.config/hypr/set-displays-swayidle.sh
hyprctl -j monitors > $HOME/.config/hypr/grep_output.txt
DISP_LAPTOP_NVIDIA=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'eDP-1')
EXT_MONITOR=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'HDMI-A-1')
POWER_ADAPTER=$(cat /sys/class/power_supply/ADP0/online | grep '1')

#Verify if swayidle and hyprpaper is running
swayidle_running="$(ps -fC 'grep' -N | grep 'swayidle' | wc -l)"
hyprpaper_running="$(ps -fC 'grep' -N | grep 'hyprpaper' | wc -l)"
if [[ $swayidle_running -gt 1 && $hyprpaper_running -gt 1 ]]; then
  pkill -f --older 1 'swayidle'
fi

#Set Refresh Rate & Time Values
if [ $POWER_ADAPTER ]; then; refresh_rate="165hz" && time_1=300 && time_2=305 && time_3=600 ; else refresh_rate="60hz" && time_1=300 && time_2=310 && time_3=450; fi

#Set Internal Display Variable
if [ $DISP_LAPTOP_NVIDIA ]; then
  #Nvidia Optimus Enable
  INTERNAL_DISPLAY=eDP-1
  hyprpaper -c $HOME/.config/hypr/hyprpaper.conf &
else
  #Nvidia Optimus Disable
  INTERNAL_DISPLAY=eDP-2
  hyprpaper -c $HOME/.config/hypr/hyprpaper-nvidia.conf &
fi

#Set Displays Resolutions

#old position
# if [ $EXT_MONITOR ]; then; hyprctl keyword monitor HDMI-A-1,1920x1080,0x0,1 && laptop_display_pos="0x1080"; else laptop_display_pos="0x0"; fi
# hyprctl keyword monitor $laptop,1920x1080@$refresh_rate,$laptop_display_pos,1

hyprctl keyword monitor $laptop,1920x1080@$refresh_rate,0x0,1
hyprctl keyword monitor HDMI-A-1,1920x1080,1920x0,1

#Set Swayidle For Suspend

## GTKLock command
swayidle -w \
  timeout $time_1 'grim -s 0.1 -g "0,0 1920x1080" $HOME/.config/hypr/screenlockbg.png && hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
  timeout $time_2 'gtklock -d -m /usr/lib/gtklock/playerctl-module.so -m /usr/lib/gtklock/powerba -b $HOME/.config/hypr/screenlockbg.png' \
  timeout $time_3 'systemctl suspend' \
  before-sleep 'gtklock -d -m /usr/lib/gtklock/playerctl-module.so -m /usr/lib/gtklock/powerbar-module.so -m /usr/lib/gtklock/userinfo-module.so -b $HOME/.config/hypr/screenlockbg.png' &

## Swaylock command
#swayidle -w \
  #timeout $time_1 'grim -s 0.1 -g "0,0 1920x1080" $HOME/.config/hypr/screenlockbg.png && hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
  #timeout $time_2 'swaylock -f --clock --indicator  -i $HOME/.config/hypr/screenlockbg.png -s fill' \
  #timeout $time_3 'systemctl suspend' \
  #before-sleep 'swaylock -f --clock  --grace 5 --indicator  -i $HOME/.config/hypr/screenlockbg.png -s fill' &