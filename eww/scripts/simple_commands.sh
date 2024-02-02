# !/bin/bash
# Get the brightness and sound values and icons

set -ex

[ "$(wpctl get-volume @DEFAULT_SINK@ | grep -oh "MUTED" )" == "MUTED" ] && sound_speaker=0 || sound_speaker=$(wpctl get-volume @DEFAULT_SINK@ | awk '{ print $2 }')

if [ "$(wpctl get-volume @DEFAULT_SOURCE@ | grep -oh "MUTED" )" == "MUTED" ]; then
  sound_mic=0
  mic_icon="󰍭"
else
  sound_mic=$(wpctl get-volume @DEFAULT_SOURCE@ | awk '{ print $2 }')
  mic_icon="󰍬"
fi

sound_mic=$(wpctl get-volume @DEFAULT_SOURCE@ | awk '{ print $2 }')
brightness_value=$(brightnessctl | grep "Current" | awk '{ print $4 }' | tr -d '()%')

case "$brightness_value" in
  80[0-9]|90[0-9]|100)
    icon_brightness="󰃠"
  ;;
  50[0-9]|60[0-9]|70[0-9])
    icon_brightness="󰃟"
  ;;
  20[0-9]|30[0-9]|40[0-9])
    icon_brightness="󰃝"    
  ;;
  0[0-9]|10[0-9])
    icon_brightness="󰃞"    
  ;;
esac

case "$sound_speaker" in
  70[0-9]|80[0-9]|90[0-9]|100)
    icon_speaker="󰕾"
  ;;
  30[6-9]|40[0-9]|50[0-9]|60[0-9])
    icon_speaker="󰖀"    
  ;;
  0[1-9]|10[0-9]|20[0-9]|30[0-5])
    icon_speaker="󰕿"    
  ;;
  0)
    icon_speaker="󰝟"
esac

case "$1" in
  brightness_value)
    printf "%.0f" "$brightness_value"
  ;;
  brightness_percentage)
    printf "%.0f%%" "$brightness_value"
  ;;
  brightness_icons)
    printf "%s" "$icon_brightness"
  ;;
  volume_speaker)
    printf "%.0f" "$(echo "${sound_speaker} * 100" | bc -l)"
  ;;
  volume_speaker_percentage)
    printf "%.0f%%" "$(echo "${sound_speaker} * 100" | bc -l)"
  ;;
  volume_speaker_icons)
    printf "%s" "$icon_speaker"
  ;;
  volume_mic)
    printf "%.0f%%" "$(echo "${sound_mic} * 100" | bc -l)"
  ;;
  volume_mic_percentage)
    printf "%.0f" "$(echo "${sound_mic} * 100" | bc -l)"
  ;;
  volume_speaker_icons)
    printf "%s" "$icon_mic"
  ;;

esac
