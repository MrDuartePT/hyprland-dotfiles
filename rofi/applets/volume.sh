#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Volume

# Volume Info
mixer="$(amixer info Master | grep 'Mixer name' | cut -d':' -f2 | tr -d \',' ')"
speaker=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/Volume: //' | xargs -I {} zsh -c "echo '{} * 100 / 1' | bc")
mic=$(wpctl get-volume @DEFAULT_SOURCE@ | sed 's/Volume: //' | xargs -I {} zsh -c "echo '{} * 100 / 1' | bc")

active=""
urgent=""

# Speaker Info
amixer get Master | grep '\[on\]' &>/dev/null
if [[ "$?" == 0 ]]; then
	active="-a 1"
	stext='Mute'
	sicon=''
else
	urgent="-u 1"
	stext='Unmute'
	sicon=''
fi

# Microphone Info
amixer get Capture | grep '\[on\]' &>/dev/null
if [[ "$?" == 0 ]]; then
	[ -n "$active" ] && active+=",3" || active="-a 3"
	mtext='Mute'
	micon='󰍬'
else
	[ -n "$urgent" ] && urgent+=",3" || urgent="-u 3"
	mtext='Unmute'
	micon='󰍭'
fi

# Theme Elements
prompt="S:$stext, M:$mtext"
mesg="$mixer - Speaker: $speaker%, Mic: $mic%"

list_col='1'
list_row='5'
win_width='400px'

# Options
option_1="󰝝 Increase"
option_2="$sicon $stext"
option_3="󰝞 Decrese"
option_4="$micon $mtext"
option_5=" Settings"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-theme ../rofi/style-volume.rasi \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		${active} ${urgent} \
		-markup-rows
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
	elif [[ "$1" == '--opt2' ]]; then
		wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle
	elif [[ "$1" == '--opt3' ]]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 5%-
	elif [[ "$1" == '--opt4' ]]; then
		wpctl set-mute @DEFAULT_SOURCE@ toggle
	elif [[ "$1" == '--opt5' ]]; then
		pavucontrol
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
