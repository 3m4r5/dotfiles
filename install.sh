#!/usr/bin/env bash

timedatectl set-timezone Asia/Amman # fix timezone
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm # rpm fusion (for ffmpegthumbnailer)
dnf -y copr enable solopasha/hyprland

# list installed packages: dnf repoquery --userinstalled
#                 for vscode  V                 for junction and Zen V            for yazi V             V for btop
dnf install -y hyprland git micro btop polkit-gnome rofimoji flatpak flameshot ffmpegthumbnailer rocm-smi waybar kitty network-manager-applet blueman rofi-wayland hyprland-autoname-workspaces libglvnd-gles pavucontrol unzip python3 python3-requests mpv firewall-applet imv nwg-clipman

mkdir .config/
mkdir .local/
mkdir .local/bin/

# yazi:
curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip yazi-x86_64-unknown-linux-gnu.zip
rm -f yazi-x86_64-unknown-linux-gnu.zip yazi-x86_64-unknown-linux-gnu/README.md yazi-x86_64-unknown-linux-gnu/LICENSE
mv yazi-x86_64-unknown-linux-gnu/* .local/bin/
rm -rf yazi-x86_64-unknown-linux-gnu

# config:
git clone https://github.com/3m4r5/dotfiles.git
cp -r dotfiles/* .config/
cp dotfiles/.bash_aliases dotfiles/.gitignore .config/
rm -rf dotfiles
chmod +x .config/scripts/*

# flathub:
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub io.github.zen_browser.zen
flatpak -y install flathub re.sonny.Junction
xdg-settings set default-web-browser re.sonny.Junction.desktop
xdg-mime default re.sonny.Junction.desktop x-scheme-handler/file
xdg-mime default re.sonny.Junction.desktop inode/directory

# nerd fonts: (WIP)
mkdir .local/share/fonts/
cd .local/share/fonts/
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip NerdFontsSymbolsOnly.zip
rm -f NerdFontsSymbolsOnly.zip LICENSE README.md
cd -

# Apple Color Emoji: https://gist.github.com/win0err/9d8c7f0feabdfe8a4c9787b02c79ac51
curl -LO https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf
sed -i -e 's/Noto Color/Apple Color Emoji<\/family><family>Noto Color/g' /etc/fonts/conf.d/60-generic.conf # TODO 45

rm -rf .cache/fontconfig
fc-cache -f

echo "
if [ -f ~/.config/.bash_aliases ]; then
. ~/.config/.bash_aliases
fi
export GTK_THEME=Adwaita-dark" >> .bashrc

: ' TODO
yazi:
- cli
- sudo mode
- icons
- md/html rendering
- relative line numbers
- gif/apng/heic preview and scroll
- remote file manegment (google drive / waydroid)
- external drives (flash)
hyprland:
- color picker/zoom/workspaces plugin
- keybinds script
waybr: sensors module
bar: display window icons in workspace module
other:
- hyprland, bar, bash, zsh, yazi, zellij, kitty, rofimoji config
- notifications
- media controls
- fix linear brightness
- external monitor brightness & volume
- keycast: wlkeys/showmethekeys
- on-screen keyboard
- safe charging/prayer times/layout translator script(espanso?)
- add features from ubuntu sway
- pywall theme switcher
- dynamic wallpaper per workspace
- manage with gnu stow / dotter'
