#!/bin/bash

set -ex

player_suspend() {
  if [[ $(playerctl -l -s) == "" ]] ; then
    'systemctl suspend'
  else
    'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on
  fi
}

player_suspend