#!/bin/zsh

#lock command
lock='gtklock -d -m /usr/lib/gtklock/playerctl-module.so -m /usr/lib/gtklock/powerbar-module.so -m /usr/lib/gtklock/userinfo-module.so -b /home/mrduarte/Pictures/wallpapers/DSC_01.jpg && hyprctl dispatch dpms off'
#lock='swaylock --clock --indicator --indicator-idle-visible --grace-no-mouse --effect-blur 10x2 -i /home/mrduarte/Pictures/wallpapers/DSC_01.jpg -s fill'

#Verify if any app is playing music

#playerctl_suspend=$( if [[ $(playerctl -l -s) == "" ]] ; then; systemctl suspend; else hyprctl dispatch dpms off; fi )

#ADD TO HYPERLAND CONFIG: exec = $HOME/.config/hypr/set-displays-swayidle.sh
hyprctl -j monitors > $HOME/.config/hypr/grep_output.txt
EXT_MONITOR=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'HDMI-A-1')
POWER_ADAPTER=$(cat /sys/class/power_supply/ADP0/online | grep '1')

#Verify if swayidle and hyprpaper is running
swayidle_running="$(ps -fC 'grep' -N | grep 'swayidle' | wc -l)"
hyprpaper_running="$(ps -fC 'grep' -N | grep 'hyprpaper' | wc -l)"
if [[ $swayidle_running -gt 1 && $hyprpaper_running -gt 1 ]]; then
  pkill -f --older 1 'swayidle'
fi

#Set Refresh Rate & Time Values
if [ $POWER_ADAPTER ]; then; refresh_rate="165hz" && time_1=300 && time_2=310 && time_3=600 ; else refresh_rate="60hz" && time_1=300 && time_2=310 && time_3=450; fi

#Set Internal Display Variable
laptop=eDP-1
#hyprpaper -c $HOME/.config/hypr/hyprpaper.conf &

#Set Displays Resolutions
hyprctl keyword monitor $laptop,1920x1080@$refresh_rate,0x0,1 #,bitdepth,10 #bug in 10 bits
hyprctl keyword monitor HDMI-A-1,highrr,1920x0,1
#hyprctl keyword monitor HDMI-A-1,1920x1080,1920x0,1


#Set Swayidle For Suspend

## GTKLock command
swayidle -w \
  timeout $time_1 'hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on' \
  timeout $time_2 '${lock} && hyprctl dispatch dpms off' \
  timeout $time_3 '$HOME/.config/hypr/playerctl_suspend.sh' \
  before-sleep $lock &

## Swaylock command
#swayidle -w \
  #timeout $time_1 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
  #timeout $time_2 'swaylock -f --clock --indicator  -i $HOME/.config/hypr/screenlockbg.png -s fill' \
  #timeout $time_3 'systemctl suspend' \
  #before-sleep 'swaylock -f --clock  --grace 5 --indicator  -i $HOME/.config/hypr/screenlockbg.png -s fill' &
