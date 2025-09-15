alias mv='mv -n'
alias lsa='ls -a'
alias debug-gtk='env GTK_DEBUG=interactive'
alias bios='systemctl reboot --firmware-setup'
alias head='sed 11q'

alias nxe='$EDITOR ~/.config/nixos/configuration.nix'
alias nxs='sudo nixos-rebuild switch'
alias nxu='sudo nix-channel --update && nxs --upgrade'

alias fpi='flatpak install'
alias fpu='flatpak update'

alias vpn='pkexec openvpn --config ~/.config/vpn/sslvpn-client-config.ovpn --auth-user-pass ~/.config/vpn/auth.txt'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
