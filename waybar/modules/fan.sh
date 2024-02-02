#/bin/bash

#Requires LenovoLegionLinux Driver

fan1=$(cat /sys/class/hwmon/hwmon4/fan1_target)
fan2=$(cat /sys/class/hwmon/hwmon4/fan2_target)

echo "Fan 1: ${fan1} RPM Fan 2: ${fan2} RPM"
