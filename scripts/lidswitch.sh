#!/usr/bin/env bash

SIGNAL=3
conffile="$HOME/.config/hypr/hyprland.conf"

line=$(grep -P "Lid Switch" -n "$conffile" | awk -F ":" '{print $1}')
status="$(awk "NR==$line {print \$0}" "$conffile" | head --bytes=1)"
if [ "$status" == "#" ]; then
  status="off"
elif [ "$status" == "b" ]; then
  status="on"
else
  printf "FATAL ERROR: Invalid byte %s" "$status"
  exit 1
fi

if [ "$1" == "status" ]; then
  if [ "$status" == "on" ]; then
    printf '{"text": "󰌢"}\n'
  elif [ "$status" == "off" ]; then
    printf '{"text": "󰛧"}\n'
  else
    printf "FATAL ERROR: Invalid status %s" "$status"
  fi

elif [ "$1" == "off" ]; then
  sed -i.bak "${line}s/^bind/#bind/" "$conffile"
  pkill -RTMIN+$SIGNAL waybar
  notify-send "Lidswitch" "Lidswitch OFF"

elif [ "$1" == "on" ]; then
  sed -i.bak "${line}s/#//" "$conffile"
  pkill -RTMIN+$SIGNAL waybar
  notify-send "Lidswitch" "Lidswitch ON"

elif [ "$1" == "toggle" ]; then
  "$0" off
  sleep 10
  "$0" on

else
    printf "FATAL ERROR: Invalid argument %s" "$1"
fi

