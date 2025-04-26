#!/bin/bash

REBOOT=$(sysctl kern.boottime | awk '{print $5}' | tr -d ,)
bootTimeFormatted=$(date -jf %s $REBOOT +%F )
echo "<result>$bootTimeFormatted</result>"