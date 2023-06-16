#!/bin/bash
HYPRLAND_CHECK=$(env | grep XDG_CURRENT_DESKTOP=Hyprland)
SWAY_CHECK=$(env | grep XDG_CURRENT_DESKTOP=Sway)
KDE_CHECK=$(env | grep XDG_CURRENT_DESKTOP=KDE)
GNOME_CHECK=$(env | grep XDG_CURRENT_DESKTOP=GNOME)

if [ $KDE_CHECK ]; then

fi

if [ $GNOME_CHECK ]; then
    
fi