#!/bin/bash
# This script is use to get Network Information from my machine.
# Then that information is displayed eww widget

if [ "$(nmcli connection show --active | grep -oh "ethernet")" == "ethernet" ]; then
  connection_name="$(nmcli connection show --active | grep 'ethernet' | awk '{ print $1, $2, $3 }' FS=' ')"
  connection_interface="$(nmcli connection show --active | grep 'ethernet' | awk '{ print $6 }' FS=' ')"
  icon="󰈀"
  message_eww="${icon} ${connection_interface} - ${connection_name}"
elif [ "$(nmcli connection show --active | grep -oh "wifi")" == "wifi" ] ; then
  connection_name="$(nmcli connection show --active | grep 'wifi' | awk '{ print $1 }' FS=' ')"
  connection_interface="$(nmcli connection show --active | grep 'wifi' | awk '{ print $6 }' FS=' ')"
  signal_strength_percentage=$(nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}' FS=' ')
  icon=""
  message_eww="${icon} ${connection_interface} - ${connection_name} (${signal_strength_percentage}%)"
else
  connection_name="Not connected"
  icon="󰲜"
  message_eww="${icon} ${connection_name}"
fi

function ShowInfo() {
  #get connection ip and dns
  connection_dns="$(nmcli connection show --active "${connection_name}" | grep 'IP4.DNS' | awk '{ print $2 }' FS='[:/]' | tr -d '[:space:]')"
  connection_wan="$(dig whoami.akamai.net. @ns1-1.akamaitech.net. +short)"
  connection_ip="$(nmcli connection show --active "${connection_name}" | grep 'IP4.ADDRESS' | awk '{ gsub (" ", "", $0); print $2 "/" $3 }' FS='[:/]' | tr -d '[:space:]')"
  notification_format="$(echo -e "${connection_interface}: ${connection_name} - ${connection_ip}\nDNS: ${connection_dns}\nWAN IP: ${connection_wan}")"
  notify-send -i "network-idle" "$notification_format" -r 123
}

function EwwWidget() {
  printf "%s" "$message_eww"
}


if [ "$1" = "ShowInfo" ]; then
	ShowInfo
else
	EwwWidget	
fi
