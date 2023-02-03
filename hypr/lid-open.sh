#!/bin/zsh
DISP_LAPTOP_NVIDIA=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'eDP-1')
EXT_MONITOR=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'HDMI-A-1')

if [ $EXT_MONITOR ]; then
   #External Dispay + LID OPEN + HYBRID MODE
   if [ $DISP_LAPTOP_NVIDIA ]; then
      hyprctl keyword monitor eDP-1,1920x1080,0x1080,1
   else
      hyprctl keyword monitor eDP-2,1920x1080,0x1080,1
   fi
fi