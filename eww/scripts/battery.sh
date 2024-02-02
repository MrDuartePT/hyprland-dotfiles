#!/bin/bash
# This script is use to get Battery Information from my machine.
# Then that information is displayed eww widget


BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`

#Set icon on battery
function icon_battery() {
  case "$capacity" in
    100)
      icon="󰁹"
    ;;
    90[0-9])
      icon="󰂂"
    ;;
    80[0-9])
      icon="󰂁"
    ;;
    70[0-9])
      icon="󰂁"
    ;;
    60[0-9])
      icon="󰂀"
    ;;
    50[0-9])
      icon="󰁿"
    ;;
    40[0-9])
      icon="󰁾"    
      ;;
    30[0-9])
      icon="󰁽"    
      ;;
    20[0-9])
      icon="󰁼"    
      ;;
    10[0-9])
      icon="󰁻"
    ;;
    0[0-9])
      icon="󰁺"
    ;;
  esac
}

function icon_charger() {
  case "$capacity" in
    100)
      icon="󰂅"
    ;;
    90[0-9])
      icon="󰂋"
    ;;
    80[0-9])
      icon="󰂊"
    ;;
    70[0-9])
      icon="󰢞"
    ;;
    60[0-9])
      icon="󰂉"
    ;;
    50[0-9])
      icon="󰢝"
    ;;
    40[0-9])
      icon="󰂈"    
      ;;
    30[0-9])
      icon="󰂇"    
      ;;
    20[0-9])
      icon="󰂆"    
      ;;
    10[0-9])
      icon="󰢜"
    ;;
    0[0-9])
      icon="󰢟"
    ;;
  esac
}

#Get values
capacity=$(cat /sys/class/power_supply/${BAT}/capacity)
if [ $(cat /sys/class/power_supply/ADP0/online) = 1 ]; then
  icon_charger
  charge_time=$(upower -i /org/freedesktop/UPower/devices/battery_${BAT} | grep "time to full" | awk '{ print $4 }' FS=' ' | tr -d '[:space:]')
  time_string="Time to Charge:"
  message_eww=$(echo -e "${icon}  ${capacity}%")
else
  icon_battery
  charge_time=$(upower -i /org/freedesktop/UPower/devices/battery_${BAT} | grep "time to empty" | awk '{ print $4 }' FS=' ' | tr -d '[:space:]')
  time_string="Time to Left:"
  message_eww=$(echo -e "${icon}  ${capacity}%")
fi


function EwwWidget() {
  printf "%s" "$message_eww"
}

function EwwClick() {
if [ ${capacity} -eq 100 ]; then
   notify-send -i "battery" "Battery Full" -r 123
else
  #Calculate in hours and minutes
  if [ ${charge_time} -ge 60 ]; then
    charge_time_h=$(echo "$(echo "${charge_time}/60")" | bc)
    charge_time_m=$(echo "$(echo "${charge_time} - (${charge_time_h}*60)") | bc")
    charge_time_string="${charge_time_h}h ${charge_time_m}m"
  else
    charge_time_string="$(printf "%0.f" "$charge_time")"
  fi
  message_eww=$(echo -e "$time_string $charge_time_string")
  notify-send -i "battery" "$message_eww" -r 123
fi
}

if [ "$1" = "EwwClick" ]; then
	EwwClick
else
	EwwWidget 
fi
