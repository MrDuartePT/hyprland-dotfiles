#!/usr/bin/env bash

## Author  :
## Github  :
#
## Applets : Display Menu

# Display Info

hyprctl -j monitors >$HOME/.config/hypr/grep_output.txt
EXT_MONITOR=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'HDMI-A-1')
LAPTOP_MONITOR=$(grep -rnw $HOME/.config/hypr/grep_output.txt -e 'eDP-1')
POWER_ADAPTER=$(cat /sys/class/power_supply/ADP0/online | grep '1')

# Prompt Elements
prompt="Change Display Order"
if [[ $LAPTOP_MONITOR ]] && [[ $EXT_MONITOR ]]; then
	mesg="Displays Connected:  eDP-1 󰍹 HDMI-A-1"
elif [[ $LAPTOP_MONITOR ]]; then
	mesg="Displays Connected:  eDP-1"
else
	mesg="Displays Connected: 󰍹 HDMI-A-1"
fi

list_col='1'
list_row='4'
win_width='400px'

# Options
option_1=" Laptop Screen"
option_2="󰍹 Monitor Screen"
option_3="󰍺 Extended Screen"
option_4="󱞟 Mirror Screen"

# Orientacion
option_up=" External Screen up"
option_left=" External Screen right"
option_right=" External Screen left"
option_down=" External Screen down"

# Rofi CMD Display Optiopm
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-theme ../rofi/style.rasi \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		${active} ${urgent} \
		-markup-rows
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Pass variables to rofi dmenu
ort_exit() {
	echo -e "$option_up\n$option_left\n$option_right\n$option_down" | rofi_cmd
}

# Execute Command
#For X support use xrandr commands
ort_run() {
	selected_ort="$(ort_exit)"
	if [[ "$selected_ort" == "$option_up" ]]; then
		laptop_ori=0x768
		external_display_ori=0x0
		${1}
	elif [[ "$selected_ort" == "$option_left" ]]; then
		laptop_ori=0x0
		external_display_ori=1360x0
		${1}
	elif [[ "$selected_ort" == "$option_right" ]]; then
		laptop_ori=1360x0
		external_display_ori=0x0
		${1}
	elif [[ "$selected_ort" == "$option_down" ]]; then
		laptop_ori=0x0
		external_display_ori=0x768
		${1}
	fi
}

# Execute Command
#For X support use xrandr commands
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		$HOME/mrduarte-github/dotfiles/hypr/set-displays-swayidle
		hyprctl keyword monitor HDMI-A-1,disable
	elif [[ "$1" == '--opt2' ]]; then
		hyprctl keyword monitor HDMI-A-1,1920x1080,0x0,1
		hyprctl keyword monitor eDP-1,disable
	elif [[ "$1" == '--opt3' ]]; then
		ort_run
		$HOME/mrduarte-github/dotfiles/hypr/set-displays-swayidle
	elif [[ "$1" == '--opt4' ]]; then
		hyprctl keyword monitor eDP-1,1920x1080@$refresh_rate,0x0,1,bitdepth,10 #bug in 10 bits
		hyprctl keyword monitor HDMI-A-1,1920x1080,1920x0,1,mirror,eDP-1
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
	run_cmd --opt1
	;;
$option_2)
	run_cmd --opt2
	;;
$option_3)
	run_cmd --opt3
	;;
$option_4)
	run_cmd --opt4
	;;
$option_5)
	run_cmd --opt5
	;;
esac
