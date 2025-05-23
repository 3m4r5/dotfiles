#!/usr/bin/env bash
sudo sh <(curl -s "https://raw.githubusercontent.com/3m4r5/dotfiles/main/install.sh")

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

# kanata:
curl -L https://github.com/jtroo/kanata/releases/latest/download/kanata -o ~/.local/bin/kanata
chmod +x ~/.local/bin/kanata

# config:
git clone https://github.com/3m4r5/dotfiles.git
cp -r dotfiles/* ~/.config/
cp dotfiles/.bash_aliases dotfiles/.gitignore dotfiles/kanata.kbd ~/.config/
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
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

if [ -f ~/.config/.bash_aliases ]; then
. ~/.config/.bash_aliases
fi" >> ~/.bashrc

pip install requests beautifulsoup4