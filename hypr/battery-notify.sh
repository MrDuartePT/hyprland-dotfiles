#!/bin/zsh
# Low battery notifier

# Kill already running processes
already_running="$(ps -fC 'grep' -N | grep 'battery-notify-auto.sh' | wc -l)"
if [[ $already_running -gt 1 ]]; then
	pkill -f --older 1 'battery-notify-auto.sh'
fi

while [[ 0 -eq 0 ]]; do
	battery_status="$(cat /sys/class/power_supply/BAT0/status)"
	battery_charge="$(cat /sys/class/power_supply/BAT0/capacity)"
    battery_time="$(cat /sys/class/power_supply/BAT0/capacity)"

	if [[ $battery_status == 'Discharging' && $battery_charge -le 30 ]]; then
		if   [[ $battery_charge -le 8 ]]; then
			notify-send --urgency=critical "Battery critical ! -> Plug the Charger or will hibernate in 1m" "${battery_charge}%"
            sleep 60
			battery_status="$(cat /sys/class/power_supply/BAT0/status)" # see if charger is detected after 60s
			if [[ $battery_status == 'Discharging' ]]; then
				/bin/systemctl hibernate #prevents double hibernation
			else
				sleep 300
			fi
		elif   [[ $battery_charge -le 15 ]]; then
			notify-send --urgency=critical "Battery critical !" "${battery_charge}%"
			sleep 300
		elif [[ $battery_charge -le 25 ]]; then
			notify-send --urgency=critical "Battery low !" "${battery_charge}%"
			sleep 600
		else
			sleep 600
		fi
	else
		sleep 600
	fi
done


