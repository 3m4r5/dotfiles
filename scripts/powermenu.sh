#!/usr/bin/env bash
# credits: https://github.com/adi1090x/rofi

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-3"
theme='style-2' # Available Styles: 1-5

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
# shutdown=''
# reboot=''
# lock=''
# suspend=''
# logout=''
# yes=''
# no=''
reload=''
bios=''
hibernate='󰋊'
shutdown='⏻'
reboot=''
lock=''
suspend='󰤄'
logout=''
yes=''
no='X'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/shared/confirm.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reload\n$hibernate\n$bios\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			hyprctl dispatch exit
		elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--bios' ]]; then
			systemctl reboot --firmware-setup
		elif [[ $1 == '--reload' ]]; then
			hyprctl reload
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		fi
        ;;
	$hibernate)
		run_cmd --hibernate
		;;
	$bios)
		run_cmd --bios
		;;
	$reload)
		run_cmd --reload
		;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
