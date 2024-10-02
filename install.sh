timedatectl set-timezone Asia/Amman # fix timezone
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm # rpm fusion (for ffmpegthumbnailer)
dnf -y copr enable solopasha/hyprland

# list installed packages: dnf repoquery --userinstalled
#                 for vscode  V                 for junction and Zen V            for yazi V             V for btop
dnf install -y hyprland git micro btop polkit-gnome rofimoji flatpak flameshot ffmpegthumbnailer rocm-smi waybar kitty network-manager-applet blueman rofi-wayland hyprland-autoname-workspaces libglvnd-gles pavucontrol unzip python3 python3-requests mpv firewall-applet imv nwg-clipman
# flathub:
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub io.github.zen_browser.zen flathub re.sonny.Junction
sed -i -e 's/Noto Color/Apple Color Emoji<\/family><family>Noto Color/g' /etc/fonts/conf.d/60-generic.conf # TODO 45
mkdir -p /usr/share/themes/Adwaita-dark/gtk-3.0
touch /usr/share/themes/Adwaita-dark/gtk-3.0/gtk.css
echo '@import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");' >> /usr/share/themes/Adwaita-dark/gtk-3.0/gtk.css
rm -f install.sh