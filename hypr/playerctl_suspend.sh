#!/bin/zsh

if [[ $(playerctl -l -s) == "" || $(playerctl status) == "Paused" ]] ; then
    systemctl suspend 
else 
    hyprctl dispatch dpms off 
fi