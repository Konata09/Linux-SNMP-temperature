#!/bin/zsh
declare -A SENSOR_MAP
SENSOR_MAP[A0]="0"
SENSOR_MAP[CPU]="1"
SENSOR_MAP[GPU]="2"
SENSOR_MAP[PLL]="3"
SENSOR_MAP[PMIC]="4"
SENSOR_MAP[Thermal]="5"

PPPOE_DEV="pppoe-wan"

function PrintUsage() {
  echo "Usage: snmp_extend.sh SENSOR -g OID"
}

if [[ "$2" = "-g" ]]; then
  if [[ "$1" = "IP" ]]; then
    IP=$(ip a show dev $PPPOE_DEV | grep inet | xargs | cut -d ' ' -f2)
    echo "$3"
    echo string
    echo "$IP"
  elif [[ "$1" = "IPV6" ]]; then
    IPV6=$(ip a show dev $PPPOE_DEV | grep inet6 | xargs | cut -d ' ' -f2 | grep -o -E '^[^\/]*')
    echo "$3"
    echo string
    echo "$IPV6"
  else
    ZONE=${SENSOR_MAP[$1]}
    if [[ $ZONE ]]; then
      SENSOR_NAME=$(cat /sys/class/thermal/thermal_zone$ZONE/type)
      SENSOR_TEMP=$(cat /sys/class/thermal/thermal_zone$ZONE/temp)
      echo "$3"
      echo integer
      echo "$SENSOR_TEMP"
    fi
  fi
elif [[ "$2" = "-n" ]]; then
  exit 0
else
  PrintUsage
fi
