{ pkgs, ... }:
{
  imports = [
    ./nodejs.nix # rename to coding.nix
  ];
  environment.systemPackages = with pkgs; [
    # Desktop apps
    thunderbird # mail client
    firefox
    lollypop # music player

    # Utils (add busybox later)
    alacritty # terminal emulator
    tmux # terminal multiplexer
    monkeysphere # gpg
    sshfs # ssh filesystem
    pciutils # list pci devices
    usbutils # list usb devices
    nmap # scan ports
    htop # system monitor
    nvtop-amd # system monitor but for gpu
    vulkan-tools # vkcube and other """very usefull tools"""
    libva-utils # vaapi info
    glxinfo # opengl info
    clinfo # opencl info
    neofetch # just needed
    lm_sensors # hardware sensors
    fzf # tui choser
    nixpkgs-fmt # tool to format .nix files
    wget
    killall

    coreutils

    # media
    ffmpeg_6-full
    gst_all_1.gstreamer
    gst_all_1.gst-vaapi

    # Containers
    docker-compose
    podman-compose

    # archives
    unzip
    unrar
    p7zip

    # wine
    wineWowPackages.staging
    winetricks
    dosbox-staging

    # virtualization
    libguestfs
    looking-glass-client
    virt-viewer
    spice-gtk
    virt-manager
    virt-top

    # Javascript
    nodejs
    deno
    bun

    # C# dotnet
    dotnet-sdk
    dotnetPackages.Nuget
    powershell

    # DE apps
    ++ (with pkgs.gnome; [
    gnome-tweaks
    adwaita-icon-theme
    dconf-editor
    gnome-shell-extensions
  ])
    ++ (with pkgs.gnomeExtensions; [
    appindicator
    git
    gtile
    sensory-perception
    snow
    snowy
  ])
    ++ (with pkgs.libsForQt5; [
    breeze-icons
    breeze-gtk
  ]);
    }
