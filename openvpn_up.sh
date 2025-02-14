#!/bin/bash

echo 'Running --up script'
idxs=("1" "2" "3" "4")
dns=''
for idx in ${idxs[@]}; do
  option_name=foreign_option_$idx
  args=(${!option_name})

  if [[ "${args[@]}" = '' ]]; then
    continue
  fi

  echo "processing foreign option: ${args[@]}"
  if [[ ${args[0]} = 'dhcp-option' && ${args[1]} = 'DNS' ]]; then
    dns="${args[2]}"
  fi
  if [[ ${args[0]} = 'dns' && ${args[1]} = 'server' && ${args[3]} = 'address' ]]; then
    dns="${args[4]}"
  fi
  if [[ "${dns}" != '' ]]; then
    echo "Setting DNS Server to ${dns}..."
    /usr/sbin/networksetup -setdnsservers Wi-Fi ${dns} 216.106.1.12 216.106.1.11
  fi
  dns=''
done
echo "Resetting Wifi"
/usr/sbin/networksetup -setnetworkserviceenabled Wi-Fi off && \
  sleep 5 && \
  /usr/sbin/networksetup -setnetworkserviceenabled Wi-Fi on
echo 'Done running --up script'
