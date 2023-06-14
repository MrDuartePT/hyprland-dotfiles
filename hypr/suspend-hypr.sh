#!/bin/bash
case "$1" in
    suspend)
        killall -STOP Hyprland
        ;;
    resume)
        killall -CONT Hyprland
        ;;
esac
