#!/usr/bin/env bash

curl -O "https://raw.githubusercontent.com/3m4r5/dotfiles/main/install.sh" && sudo sh install.sh

mkdir -p ~/.config/ ~/.local/bin/ ~/.local/share/fonts/ ~/.local/share/applications/
touch ~/.local/share/applications/micro.desktop ~/.local/share/applications/unzip.desktop
echo "[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay=true
Exec=kitty micro %f
Name=kitty micro" >> ~/.local/share/applications/micro.desktop
echo "[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay=true
Exec=unzip %f
Name=unzip" >> ~/.local/share/applications/unzip.desktop

# yazi:
curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip yazi-x86_64-unknown-linux-gnu.zip
rm -f yazi-x86_64-unknown-linux-gnu.zip yazi-x86_64-unknown-linux-gnu/README.md yazi-x86_64-unknown-linux-gnu/LICENSE
mv yazi-x86_64-unknown-linux-gnu/* ~/.local/bin/
rm -rf yazi-x86_64-unknown-linux-gnu

# config:
git clone https://github.com/3m4r5/dotfiles.git
cp -r dotfiles/* ~/.config/
cp dotfiles/.bash_aliases dotfiles/.gitignore ~/.config/
rm -rf dotfiles
chmod +x ~/.config/scripts/*

# junction
xdg-settings set default-web-browser re.sonny.Junction.desktop
xdg-mime default re.sonny.Junction.desktop x-scheme-handler/file
xdg-mime default re.sonny.Junction.desktop inode/directory

# nerd fonts: (WIP)
cd ~/.local/share/fonts/
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip NerdFontsSymbolsOnly.zip
rm -f NerdFontsSymbolsOnly.zip LICENSE README.md
# Apple Color Emoji: https://gist.github.com/win0err/9d8c7f0feabdfe8a4c9787b02c79ac51
curl -LO https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf
rm -rf ~/.cache/fontconfig
fc-cache -f
cd -

echo "
if [ -f ~/.config/.bash_aliases ]; then
. ~/.config/.bash_aliases
fi
export GTK_THEME=Adwaita-dark" >> ~/.bashrc
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
- pywall theme switcher
- dynamic wallpaper per workspace
- manage with gnu stow / dotter'
