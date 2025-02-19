# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:
let
  hostVars = import ../host-variables.nix;
in
{
  system.stateVersion = "24.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # == Imports ==
  imports =
    [
	../hardware-configuration.nix
	inputs.home-manager.nixosModules.default
    (./. + "/hardware/${hostVars.workstationName}-hardware-custom.nix")
	./nix_modules/unstable.nix
	./nix_modules/hyprpanel.nix
    ];


  # == Network ==
  networking.hostName = "${hostVars.workstationName}";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  services.xrdp.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # == Locale ==
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # == DE ==
  services.xserver = {
    enable = true;
    displayManager.autoLogin.enable = false;
    displayManager.autoLogin.user = "ded";
    windowManager.bspwm.enable = true;
  }
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;
  services.libinput.enable = true;

  fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
    fira-code-nerdfont
    jetbrains-mono
    iosevka
    font-awesome
    material-design-icons
   ];

  fontconfig = {
    defaultFonts = {
      monospace = [ "Jetbrains Mono Nerd Font" ];
      serif = [ "Jetbrains Mono Nerd Font" ];
      sansSerif = [ "Jetbrains Mono Nerd Font" ];
      };
    };
  };

  programs.bash = {
    shellAliases = {
      nt = "sudo nixos-rebuild test --flake /etc/nixos/custom#default --impure";
      ns = "sudo nixos-rebuild switch --flake /etc/nixos/custom#default --impure";
    };
  };


  # == Sound ==
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #media-session.enable = true;
  };


  # == User ==
  users.users.ded = {
    isNormalUser = true;
    description = "ded";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = "${pkgs.fish}/bin/fish";
    home = "/home/ded";
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "ded" = import (config.users.users.ded.home + "/.config/home-manager/home.nix"); };
  };
  security.sudo = {
    enable = true;
    extraConfig = ''
      ded ALL=(ALL) NOPASSWD:ALL
    '';
  };

  # == Pkgs ==
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # == App ==
    alacritty
    bat
    bluetuith
    brave
    brightnessctl
    cava
    chromium
    cmake
    cpio
    cliphist
    clipmenu
    clippy
    dunst
    flameshot
    firefox-beta
    fish
    fzf
    godot_4
    kitty
    lazygit
    meson
    neofetch
    neovide
    networkmanager_dmenu
    nwg-bar
    nwg-drawer
    picom
    p7zip
    protonvpn-gui
    rofi
    skim
    slock
    starship
    tidal-hifi
    tor
    tor-browser
    torsocks
    unzip
    vscodium
    waybar
    wezterm
    wofi
    xautolock
    zenity
    escrotum
    eza
    fd
    flatpak
    lsd
    nix-prefetch-git
    nix-search-cli
    tmux
    wget
    qpwgraph
    qjackctl
    xclip
    yabridge
    yabridgectl
    yazi
    # == Lib ==
    coreutils
    docker
    docker-compose
    glibc
    killall
    libglvnd
    ntfs3g
    procps
    psmisc
    pulsemixer
    ripgrep
    # == Dev ==
    #nodejs
    #nodejs_22
    gcc
    gh
    gh-dash
    git
    git-crypt
    glab
    gnumake
    go
    lua-language-server
    python3Full
    ruby_3_2
    sqlite
    stylua
    vimPlugins.vim-plug
    yarn
    wineWowPackages.stable
    wineWowPackages.fonts
    winetricks
    # == WM ==
    bspwm
    dmenu
    feh
    polybarFull
    sxhkd
    timeshift
    xorg.libxcb
    swww
  ];


  # == Programs ==
  # Enable Flatpak in the system and add the Flathub repository
  services.flatpak.enable = true;

  # Activation script to add Flathub and install Chrome and Brave
  system.activationScripts.installFlatpakApps = lib.mkAfter ''
    # Path to the Flatpak binary
    FLATPAK=${pkgs.flatpak}/bin/flatpak

    # Add the Flathub repository if it does not already exist
    if ! $FLATPAK remote-list | grep -q flathub; then
      $FLATPAK remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    # if ! $FLATPAK list | grep -q com.brave.Browser; then
    #   $FLATPAK install -y flathub com.brave.Browser
    # fi
  '';

  programs  = {
	hyprland.enable = true;
	fish.enable = true;
  };
  #fix suid slock
  security.wrappers.slock = {
    source = "${pkgs.slock}/bin/slock";
    owner = "root";
    group = "root";
    setuid = true;
  };

  # == Virtualization ==
  virtualisation = {
    waydroid.enable = true;
    docker = {
      enable = true;
      # enableNvidia = true;
    };
  };
}
