alias mv='mv -n'
alias lsa='ls -a'
alias debug-gtk='env GTK_DEBUG=interactive'
alias bios='systemctl reboot --firmware-setup'
alias head='sed 11q'

alias nxe='$EDITOR ~/.config/nixos/configuration.nix'
alias nxs='sudo nixos-rebuild switch'

alias vpn='pkexec openvpn --config ~/.config/vpn/sslvpn-client-config.ovpn --auth-user-pass ~/.config/vpn/auth.txt'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

[ "$(tty)" = "/dev/tty1" ] && exec niri-session
