#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x

## Modify
## Author  : Gonçalo Duarte (MrDuartePT)
## Github  : @MrDuartePT

## Applets : Power Menu

#Command to lock the device
lock='gtklock -d -m /usr/lib/gtklock/playerctl-module.so -m /usr/lib/gtklock/powerbar-module.so -m /usr/lib/gtklock/userinfo-module.so -b /home/mrduarte/Pictures/wallpapers/DSC_01.jpg'
#lock='swaylock --clock --indicator --indicator-idle-visible --grace-no-mouse --effect-blur 10x2 -i /home/mrduarte/Pictures/wallpapers/DSC_01.jpg -s fill'

# Applet Elements
prompt:"Power Menu"
mesg="Uptime : `uptime -p | sed -e 's/up //g'`"
list_col='1'
list_row='6'

# Options
option_1="󱅞 Lock"
option_2="⏾ Suspend"
option_3=" Hibernate"
option_4=" Reboot"
option_5=" Shutdown"
option_6=" Logout"
yes=' Yes'
no=' No'

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-theme ../rofi/style-powermenu.rasi
		-p $prompt \
		-mesg "$mesg" \
		-markup-rows
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-theme ../rofi/style.rasi \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?'
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run () {	
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
        ${1} && ${2} && ${3}
    else
        exit
    fi	
}

run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		$lock
	elif [[ "$1" == '--opt2' ]]; then
		systemctl suspend
	elif [[ "$1" == '--opt3' ]]; then
		confirm_run "systemctl hibernate"
	elif [[ "$1" == '--opt4' ]]; then
		confirm_run 'systemctl reboot'
	elif [[ "$1" == '--opt5' ]]; then
		confirm_run 'systemctl poweroff'
	elif [[ "$1" == '--opt6' ]]; then
		confirm_run 'killall Hyprland'
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
    $option_6)
		run_cmd --opt6
        ;;
esac

