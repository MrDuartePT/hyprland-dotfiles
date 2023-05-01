#!/bin/zsh

BAT=$(cat /sys/class/power_supply/BAT0/capacity)
BAT_POWER_NOW=$(cat /sys/class/power_supply/BAT0/power_now)
BAT_ENERGY_NOW=$(cat /sys/class/power_supply/BAT0/energy_now)

BAT_TIME_HOURS_DECIMAL=$(echo "$BAT_ENERGY_NOW / $BAT_POWER_NOW" | bc -l)

BAT_TIME_HOURS_INT=$(echo $(expr $BAT_ENERGY_NOW / $BAT_POWER_NOW))

if [[ BAT_TIME_HOURS_INT -eq 0 ]]; then

BAT_TIME_MINUTOS=$(echo "$BAT_TIME_HOURS_DECIMAL * 60" | bc -l)
BAT_TIME_MINUTOS_INT=$(printf "%.0f" $BAT_TIME_MINUTOS)

BAT_TIME=$(echo ${BAT_TIME_MINUTOS_INT}m)

notify-send "Battery Percentage = $BAT%" "Time Remaning: $BAT_TIME"
else
BAT_TIME_MINUTOS_DEC=$(echo "$BAT_TIME_HOURS_DECIMAL - $BAT_TIME_HOURS_INT" | bc -l)
BAT_TIME_MINUTOS=$(echo "$BAT_TIME_MINUTOS_DEC * 60" | bc -l)
BAT_TIME_MINUTOS_INT=$(printf "%.0f" $BAT_TIME_MINUTOS)

BAT_TIME=$(echo ${BAT_TIME_HOURS_INT}h:${BAT_TIME_MINUTOS_INT})

notify-send "Battery Percentage = $BAT%" "Time Remaning: $BAT_TIME"
fi


