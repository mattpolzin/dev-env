#!/bin/bash

echo 'Running --up script'
args=($foreign_option_1)
if [[ ${args[0]} = 'dhcp-option' && ${args[1]} = 'DNS' ]]; then
  echo "Setting DNS Server to ${args[2]}..."
  /usr/sbin/networksetup -setdnsservers Wi-Fi ${args[2]} 216.106.1.12 216.106.1.11
fi
