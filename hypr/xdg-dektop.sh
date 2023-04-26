#!/bin/bash
sleep 1
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/libexec/xdg-desktop-portal-hyprland &
/usr/libexec/flatpak-portal &
sleep 5
/usr/libexec/xdg-desktop-portal &
