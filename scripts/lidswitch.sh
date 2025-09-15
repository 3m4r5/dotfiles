#!/usr/bin/env bash

LID_STATE=$(< /proc/acpi/button/lid/LID/state)

if echo "$LID_STATE" | grep -q "open"; then
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
else
    hyprctl keyword monitor "eDP-1,disable"
fi