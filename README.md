## Monitor Linux Devices Temperature by SNMP

### Usage

1. Make sure you can get temperature from command like `cat /sys/class/thermal/thermal_zone0/temp`
2. Install snmpd and snmp `apt install snmp snmpd`
3. Edit first few lines of `snmp_extend.sh`, to map your sensor name to `thermal_zone`.  
   If you have one temperature sensor, it will be `/sys/class/thermal/thermal_zone0/`, then `/sys/class/thermal/thermal_zone1/`, etc.  
   To name a sensor, maybe you could cat `/sys/class/thermal/thermal_zone0/type` for reference.
4. Choose an OID to be our custom temperature subtree. This OID must begin with `1.3.6.1.4.1`, like `1.3.6.1.4.1.1989.10`.
5. Edit `/etc/snmp/snmpd.conf`, add OID which we choose from previous step as pass-through OID to our script.  
   Don't forget to add sensor name as script parameter.
   ```conf
    pass .1.3.6.1.4.1.1989.10.1 /opt/snmp_extend.sh A0
    pass .1.3.6.1.4.1.1989.10.2 /opt/snmp_extend.sh CPU
    pass .1.3.6.1.4.1.1989.10.3 /opt/snmp_extend.sh GPU
    pass .1.3.6.1.4.1.1989.10.4 /opt/snmp_extend.sh PLL
    pass .1.3.6.1.4.1.1989.10.5 /opt/snmp_extend.sh PMIC
    pass .1.3.6.1.4.1.1989.10.6 /opt/snmp_extend.sh Thermal
   ```
6. Edit `/etc/snmp/snmpd.conf`, add our custom OID to view. 
   ```conf
   view   systemonly  included   .1.3.6.1.4.1.1989
   ```
7. Restart snmpd and test if it works.
   ```shell
   $ systemctl restart snmpd
   $ snmpget -v2c -c public 127.0.0.1 .1.3.6.1.4.1.1989.10.1
   iso.3.6.1.4.1.1989.10.1 = INTEGER: 39500
   ```
   