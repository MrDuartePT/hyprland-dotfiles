#!/usr/bin/env bash

## Author  : Gonçalo Duarte (MrDuartePT)
## Github  : @MrDuartePT

## Applets : Power Menu

#This applet need LLL - https://github.com/johnfanv2/LenovoLegionLinux

# Pre-Requisites, Elements and options
status_mux=$(legion_cli hybrid-mode-status | grep True)
status_superglfx=$(systemctl status supergfxd)
current_superglfx=$(supergfxctl --status)
get_distro_name=$(cat /etc/lsb-release | sed "s/DISTRIB_ID=//")

#Set your teminal and aur helper if you are on arch
term="alacritty -e"
aur_helper="paru"

back=' back'
next=' next'

yes=' Yes'
no=' No'
	
control_dgpu () {
	if [ $start_mux ]; then
		if [ $status_superglfx ]; then
			mesg="Mode: Hybrid Mode  Supergfxd:active"
			option_1="Supergfx - Integrated Mode"
			option_2="Supergfx - Hybrid Mode"
			option_3="Supergfx - VFIO Mode"
			option_4="LLL - Change to DGPU Mode"
		fi

		list_col='1'
		list_row='3'
		mesg="Mode: Hybrid Mode  Supergfxd:active"
		option_1="LLL - Change to DGPU Mode"
		option_2="Install superglfxctl for more option"

	else
		list_col='1'
		list_row='3'
		mesg="Mode: DGPU Mode"
		option_1="LLL - Change to Hybrid Mode"
		option_2="LLL - Install and enable superglfxctl and Change to Hybrid Mode"
	fi

	list_col='1'
	list_row='5'
}

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p $prompt \
		-mesg "$mesg" \
		-markup-rows
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

install_superglfx () {
	if [ $get_distro_name="Gentoo" ]; then
		$term su -c "emerge supergfxctl"
	elif [ $get_distro_name="Ubuntu" || $get_distro_name="POP-OS" || $get_distro_name="Debian" ]; then
		$term su -c "apt-get install supergfxctl"
	elif [ $get_distro_name="Fedora" ]; then
		$term su -c "dnf install supergfxctl"
	elif [ $get_distro_name="ArchLinux" ]; then
		$term su -c "$aur_helper -Sy supergfxctl"
	fi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
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
	if [ $start_mux ]; then
		if [ $status_superglfx ]; then
			if [[ "$1" == '--opt1' ]]; then
				confirm_run "supergfxctl -m integrated"
			elif [[ "$1" == '--opt2' ]]; then
				confirm_run "supergfxctl -m hybrid"
			elif [[ "$1" == '--opt3' ]]; then
				confirm_run "supergfxctl -m vfio"
			elif [[ "$1" == '--opt4' ]]; then
				confirm_run "pkexec legion_cli hybrid-mode-disable"
			fi
		fi
		
		if [[ "$1" == '--opt1' ]]; then
			confirm_run "pkexec legion_cli hybrid-mode-disable"
		elif [[ "$1" == '--opt2' ]]; then
			confirm_run "install_superglfx"
			confirm_run "pkexec legion_cli hybrid-mode-disable"
		fi

	else
		if [[ "$1" == '--opt1' ]]; then
		confirm_run "pkexec legion_cli hybrid-mode-enable"
		elif [[ "$1" == '--opt2' ]]; then
		confirm_run "install_superglfx"
		fi
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
esac