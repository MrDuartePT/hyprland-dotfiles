#!/bin/bash

bluetoothctl paired-devices | cut -f2 -d' ' | while read uuid; do bluetoothctl info $uuid | grep -B8 -e 'Connected: yes' | grep 'Device' | cut -f2 -d' '; done