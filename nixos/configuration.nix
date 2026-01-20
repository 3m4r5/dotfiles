# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
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

  environment = {
    systemPackages = with pkgs; [ # List packages installed in system profile. To search, run: $ nix search wget
      # desktop environment
      waybar networkmanagerapplet swaynotificationcenter udiskie polkit_gnome swayosd adwaita-icon-theme
      # menus
      rofi rofimoji
      # terminal & files
      kitty junction ripdrag ouch nerd-fonts.symbols-only
      # clipboard
      wl-clipboard wtype cliphist
      # screenshot
      slurp grim satty
      # connect
      openvpn remmina
      # development
      vscodium zed-editor git nixd devbox
      # web
      mitmproxy zola brave epiphany
      (python313.withPackages (ps: with ps; [
        requests
        beautifulsoup4
      ]))
    ];
    sessionVariables.NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    bash = { interactiveShellInit = (builtins.readFile ../.bashrc); };
    yazi = {
      enable = true;
      initLua = ../yazi/init.lua;
      settings = {
        yazi = (builtins.fromTOML (builtins.readFile ../yazi/yazi.toml));
        keymap = (builtins.fromTOML (builtins.readFile ../yazi/keymap.toml));
      };
      plugins = {
        wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
        vcs-files = pkgs.yaziPlugins.vcs-files;
        sudo = pkgs.yaziPlugins.sudo;
        relative-motions = pkgs.yaziPlugins.relative-motions;
        bypass = pkgs.yaziPlugins.bypass;
        ouch = pkgs.yaziPlugins.ouch;
      };
    };
  };

  services = { # List services that you want to enable
    printing.enable = true; # Enable CUPS to print documents.
    pulseaudio.enable = false;
    getty.autologinUser = "o";
    gnome.gnome-keyring.enable = true;
    udisks2.enable = true;
    # displayManager.autoLogin.enable = true;
    # displayManager.autoLogin.user = "o";
    flatpak = {
      enable = true;
      packages = [
        "app.zen_browser.zen" # "re.sonny.Junction"
      ];
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # jack.enable = true;
      # media-session.enable = true; # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1";
    useOSProber = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openvpn
      ];
    };
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # proxy = {
        # default = "http://user:password@proxy:port/";
        # noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  };

  time.timeZone = "Asia/Amman";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    mime = {
      enable = true;
      defaultApplications = {
        "text/html" = "re.sonny.Junction.desktop";
        "inode/directory" = "re.sonny.Junction.desktop";
        "x-scheme-handler/http" = "re.sonny.Junction.desktop";
        "x-scheme-handler/https" = "re.sonny.Junction.desktop";
        "x-scheme-handler/file" = "re.sonny.Junction.desktop";
        "x-scheme-handler/mailto" = "re.sonny.Junction.desktop";
      };
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  users.users.o = {
    isNormalUser = true;
    description = "o";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };

  # nixpkgs.config.allowUnfree = true; # Allow unfree packages

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      localConf = (builtins.readFile ../fontconfig/fonts.conf);
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
