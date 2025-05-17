#!/usr/bin/env bash

CONSERVATION_MODE_PATH="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

get_status() {
    if [[ $(cat "$CONSERVATION_MODE_PATH") -eq 1 ]]; then
        echo '{"alt": "on", "tooltip": "Safe Charging is ON"}'
    else
        echo '{"alt": "off", "tooltip": "Safe Charging is OFF"}'
    fi
}

toggle_mode() {
    if [[ $(cat "$CONSERVATION_MODE_PATH") -eq 1 ]]; then
        echo 0 | pkexec tee "$CONSERVATION_MODE_PATH" > /dev/null
        notify-send "Safe Charging" "Disabled"
        echo '{"alt": "off", "tooltip": "Safe Charging is OFF"}'
    else
        echo 1 | pkexec tee "$CONSERVATION_MODE_PATH" > /dev/null
        notify-send "Safe Charging" "Enabled"
        echo '{"alt": "on", "tooltip": "Safe Charging is ON"}'
    fi
}

case "$1" in
    -s|--status)
        get_status
        ;;
    -t|--toggle)
        toggle_mode
        ;;
    *)
        echo "Usage: $0 {-s|--status|-t|--toggle}"
        exit 1
        ;;
esac