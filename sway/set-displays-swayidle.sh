#!/bin/zsh
FILE_OUTPUT=$(swaymsg --t get_outputs > grep_output.txt)
DISP_LAPTOP_NVIDIA=$(grep -rnw grep_output.txt -e 'eDP-1')
DISP_LAPTOP=$(grep -rnw grep_output.txt -e 'eDP-2')
EXT_MONITOR=$(grep -rnw grep_output.txt -e 'HDMI-A-1')


if [[ $DISP_LAPTOP_NVIDIA ] && [ $EXT_MONITOR ]]; then
  #Nvidia Optimus Disable
  swaymsg output eDP-1 mode 1920x1080@165.00hz pos 0 1080 adaptive_sync on render_bit_depth 10
  swaymsg output HDMI-A-1 mode 1920x1080@60.0Hz pos 0 0 adaptive_sync off
  #notify-send "External Monitor - Disabling Lock on Lid Close"

elif [[ $DISP_LAPTOP_NVIDIA ]]; then
  #Nvidia Optimus Disable
  swaymsg output eDP-1 mode 1920x1080@165.00hz pos 0 0 adaptive_sync on render_bit_depth 10
  #notify-send "No External Monitor - Activating Lock on Lid Close"   

elif [[ $DISP_LAPTOP ] && [ $EXT_MONITOR ]]; then
  #Nvidia Optimus Disable
  swaymsg output eDP-2 mode 1920x1080@165.00hz pos 0 1080 adaptive_sync on render_bit_depth 10
  swaymsg output HDMI-A-1 mode 1920x1080@60.0Hz pos 0 0 adaptive_sync off
  #notify-send "External Monitor - Disabling Lock on Lid Close"

elif [[ $DISP_LAPTOP ]]; then
  #Nvidia Optimus Enable
  swaymsg output eDP-2 mode 1920x1080@165.00hz pos 0 0 adaptive_sync on render_bit_depth 10
  #notify-send "No External Monitor - Activating Lock on Lid Close"

else
  echo "Default Sway config for outputs & swayidle"
fi


#--clock --grace 5 --grace-no-mouse --indicator 
