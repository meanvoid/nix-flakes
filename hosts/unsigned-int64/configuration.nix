{
  config,
  pkgs,
  lib,
  agenix,
  path,
  hostname,
  users,
  vscode-server,
  ...
}: let
  importModule = moduleName: let
    dir = path + "/modules/${hostname}";
  in
    import (dir + "/${moduleName}");
  hostModules = moduleDirs: builtins.concatMap importModule moduleDirs;
in {
  imports =
    [
      ./hardware-configuration.nix
      ./config.nix
      (path + "/modules/unsigned-int64/environment/users.nix")
    ]
    ++ hostModules [
      "networking"
      "services"
      "virtualisation"
    ];

  environment = {
    systemPackages =
      (with pkgs; [
        # Networking
        dig
        finger_bsd
        nmap
        curl
        wget

        # Archives
        zip
        unzip
        rar
        unrar
        lz4

        # Utils
        distrobox
        neofetch
        hyfetch
        nvme-cli

        # Benchmarking
        fio
        lm_sensors

        # Media encoding/decoding
        ffmpeg_6-full
        imagemagick
        mpv
        mpd
      ])
      ++ (with pkgs.gst_all_1; [
        gstreamer
        gst-vaapi
        gstreamermm
        gst-devtools
        gst-rtsp-server
        gst-plugins-good
        gst-plugins-base
        gst-editing-services
      ]);
    shells = with pkgs; [zsh bash fish];
    pathsToLink = ["/share/zsh"];
    binsh = "${pkgs.dash}/bin/dash";
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
    rtkit.enable = true;
  };
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = true;
        PermitRootLogin = "prohibit-password";
      };
      listenAddresses = [
        {addr = "0.0.0.0"; port = "68333";}
        {addr = "192.168.254.1"; port = 22;}
        {addr = "192.168.10.1"; port = 22;}
        {addr = "172.168.10.1";port = 22;}
      ];
    };
    dnsmasq = {
      enable = true;
      settings = {
        server = [
          # adguard dns
          "94.140.14.14"
          "94.140.15.15"
          # dnsforge
          "176.9.93.198"
          "176.9.1.117"
          "2a01:4f8:151:34aa::198"
          "2a01:4f8:141:316d::117"
          "49.12.223.2"
          "49.12.43.208"
          "2a01:4f8:c17:4fbc::2"
          "2a01:4f8:c012:ed89::208"
          # blahdns
          "78.46.244.143"
          "2a01:4f8:c17:ec67::1"
          "95.216.212.177"
          "2a01:4f9:c010:43ce::1"
          # mullvad
          "194.242.2.3"
          "2a07:e340::3"
          # quad9
          "9.9.9.9"
          # cloudflare
          "1.1.1.1"
        ];
        interface = "wireguard0";
      };
    };
    vscode-server.enable = true;
    pcscd.enable = true;
  };
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      resizeAmount = 10;
      escapeTime = 250;
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    dconf.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.05";
}
