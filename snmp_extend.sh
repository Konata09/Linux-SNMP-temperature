#!/bin/zsh
declare -A SENSOR_MAP
SENSOR_MAP[A0]="0"
SENSOR_MAP[CPU]="1"
SENSOR_MAP[GPU]="2"
SENSOR_MAP[PLL]="3"
SENSOR_MAP[PMIC]="4"
SENSOR_MAP[Thermal]="5"

function PrintUsage() {
  echo "Usage: snmp_extend.sh sensor -g OID"
}

if [[ "$2" = "-g" ]]; then
  ZONE=${SENSOR_MAP[$1]}
  if [[ $ZONE ]]; then
    SENSOR_NAME=$(cat /sys/class/thermal/thermal_zone$ZONE/type)
    SENSOR_TEMP=$(cat /sys/class/thermal/thermal_zone$ZONE/temp)
    echo $3
    echo integer
    echo $SENSOR_TEMP
  fi
elif  [[ "$2" = "-n" ]]; then
  exit 0
else
  PrintUsage
fi