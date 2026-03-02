#!/bin/bash

# NOTE: This script is currently MacOS specific

echo 'Running --down script'
echo "Setting DNS Servers back to defaults"
/usr/sbin/networksetup -setdnsservers Wi-Fi 216.106.1.12 216.106.1.11

