# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
let # External let binding to fetch nix-flatpak without causing infinite recursion.
  pkgs = import <nixpkgs> {};
  nix-flatpak = pkgs.fetchFromGitHub {
    owner = "gmodena";
    repo = "nix-flatpak";
    rev = "v0.6.0";
    hash = "sha256-iAVVHi7X3kWORftY+LVbRiStRnQEob2TULWyjMS6dWg=";
  };
in

{ config, pkgs, lib, ... }:

{
  imports = [
    "${nix-flatpak}/modules/nixos.nix"
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Amman";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_JO.UTF-8";
    LC_IDENTIFICATION = "ar_JO.UTF-8";
    LC_MEASUREMENT = "ar_JO.UTF-8";
    LC_MONETARY = "ar_JO.UTF-8";
    LC_NAME = "ar_JO.UTF-8";
    LC_NUMERIC = "ar_JO.UTF-8";
    LC_PAPER = "ar_JO.UTF-8";
    LC_TELEPHONE = "ar_JO.UTF-8";
    LC_TIME = "ar_JO.UTF-8";
  };

  environment.etc = {
    "xdg/applications/unzip.desktop".text = ''
      [Desktop Entry]
      Encoding=UTF-8
      Type=Application
      NoDisplay=true
      Exec=unzip %f
      Name=unzip
    '';

    "xdg/mimeapps.list".text = ''
      [Default Applications]
      x-scheme-handler/file=re.sonny.Junction.desktop
      inode/directory=re.sonny.Junction.desktop
      x-scheme-handler/http=re.sonny.Junction.desktop
      x-scheme-handler/https=re.sonny.Junction.desktop
    '';
  };

  services.printing.enable = true; # Enable CUPS to print documents.

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # Enable sound with pipewire.
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  users.users.o = {
    isNormalUser = true;
    description = "o";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };

  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "o";
  services.getty.autologinUser = "o";

  # nixpkgs.config.allowUnfree = true; # Allow unfree packages

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    waybar hyprpolkitagent
    git zed-editor nixd hyprlang
    unzip
    junction
    kitty
    nerd-fonts.symbols-only
    yazi
    rofi-wayland rofimoji
    swaynotificationcenter
    wl-clipboard wtype cliphist
    slurp grim satty
    openvpn remmina
    networkmanagerapplet
    adwaita-icon-theme
    (python313.withPackages (ps: with ps; [
      requests
      beautifulsoup4
    ]))
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    bash = {
      interactiveShellInit = ''
        bind 'set show-all-if-ambiguous on'
        bind 'TAB:menu-complete'

        if [ -f ~/.config/.bash_aliases ]; then
          . ~/.config/.bash_aliases
        fi

        if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
          exec Hyprland
        fi
      '';
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      localConf = ''
        <fontconfig>
          <alias binding="same">
      		<family>emoji</family>
      		<prefer>
     			<family>Apple Color Emoji</family> <!-- Added -->
       			<!-- System fonts -->
       			<family>Noto Color Emoji</family> <!-- Google -->
       			<family>Apple Color Emoji</family> <!-- Apple -->
       			<family>Segoe UI Emoji</family> <!-- Microsoft -->
        		<family>Twitter Color Emoji</family> <!-- Twitter -->
       			<family>EmojiOne Mozilla</family> <!-- Mozilla -->
       			<!-- Third-Party fonts -->
       			<family>Emoji Two</family>
       			<family>Emoji One</family>
       			<!-- Non-color -->
       			<family>Noto Emoji</family> <!-- Google -->
       			<family>Android Emoji</family> <!-- Google -->
       		</prefer>
          </alias>
		  <alias>
		       <family>serif</family>
		       <prefer>
		           <family>Symbols Nerd Font</family>
		           <family>Apple Color Emoji</family>
		       </prefer>
		   </alias>
		   <alias>
		       <family>sans-serif</family>
		       <prefer>
		           <family>Symbols Nerd Font</family>
		           <family>Apple Color Emoji</family>
		       </prefer>
		   </alias>
		   <alias>
		       <family>monospace</family>
		       <prefer>
		           <family>Symbols Nerd Font Mono</family>
		           <family>Apple Color Emoji</family>
		       </prefer>
		   </alias>
		   <match target="pattern">
		       <test qual="any" name="family">
		           <string>Noto Color Emoji</string>
		       </test>
		       <edit name="family" mode="assign" binding="same">
		           <string>Apple Color Emoji</string>
		       </edit>
		   </match>
		   <match target="pattern">
		       <test qual="any" name="family">
		           <string>Noto Sans Mono</string>
		       </test>
		       <edit name="family" mode="assign" binding="same">
		           <string>Symbols Nerd Font Mono</string>
		       </edit>
		   </match>
		       <match target="pattern">
		       <test qual="any" name="family">
		           <string>Awesome</string>
		       </test>
		       <edit name="family" mode="assign" binding="same">
		           <string>Symbols Nerd Font</string>
		       </edit>
		   </match>
        </fontconfig>
      '';
    };
    packages = with pkgs; [
      nerd-fonts.symbols-only
      (stdenvNoCC.mkDerivation {
        pname = "AppleColorEmoji";
        version = "18.4";
        src = pkgs.fetchurl {
          url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v18.4/AppleColorEmoji.ttf";
          sha256 = "1ggahpw54rjpxirjbyarwd5gvvg1hi08zw4c1nab8dqls5xhgzd4";
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src $out/share/fonts/truetype/
        '';
      })
    ];
  };

  # environment.sessionVariables.NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland:
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.flatpak = {
    enable = true;
    packages = [
      "app.zen_browser.zen"
      # "re.sonny.Junction"
    ];
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}