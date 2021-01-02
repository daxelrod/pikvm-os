#!/bin/bash
set -ex
if [ "$1" != --do-the-thing ]; then
    exit 1
fi

if [ ! -f "/boot/pikvm.txt" ]; then
    exit 0
fi

rw

source /boot/pikvm.txt

if [ -n "$WIFI_ESSID" ]; then
    WIFI_IFACE="${WIFI_IFACE:-wlan0}"
    config="/etc/netctl/$WIFI_IFACE-${WIFI_ESSID/ /_}"

    cat <<end_wifi_config > "$config"
Description='Generated by Pi-KVM bootconfig service'
Interface='$WIFI_IFACE'
Connection=wireless
Security=wpa
ESSID='$WIFI_ESSID'
IP=dhcp
Key='$WIFI_PASSWD'
end_wifi_config

    systemctl enable "netctl-auto@${WIFI_IFACE}.service"
fi

rm /boot/pikvm.txt

ro
