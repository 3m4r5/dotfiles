timedatectl set-timezone Asia/Amman # fix timezone
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm # rpm fusion (for ffmpegthumbnailer)
dnf -y copr enable solopasha/hyprland
dnf install -y\
hyprland\
git\
micro\
btop\
hyprpolkitagent\
rofimoji\
flatpak\
flameshot\
ffmpegthumbnailer\
rocm-smi\
waybar\
kitty\
network-manager-applet\
blueman\
rofi-wayland\
hyprland-autoname-workspaces\
libglvnd-gles\
pavucontrol\
unzip\
python3\
python3-requests\
mpv\
imv\
nwg-clipman\
zathura\
SwayNotificationCenter\
power-profiles-daemon\
PackageKit-command-not-found\
lm_sensors\
adwaita-gtk2-theme\
hyprland-devel

# flathub:
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub io.github.zen_browser.zen flathub re.sonny.Junction
sed -i -e 's/Noto Color/Apple Color Emoji<\/family><family>Noto Color/g' /etc/fonts/conf.d/60-generic.conf # TODO 45

hyprpm update
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo