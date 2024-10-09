{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=18";
    hwRender = true;
    fonts = [
      {
        name = "MesloLGL Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "Meslo" ]; };
      }
    ];
  };
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  hardware.pulseaudio.enable = false;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    gvfs.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # essential
      zip
      unzip
      rar
      lz4
      p7zip
      lm_sensors

      # utils
      binutils
      findutils
      util-linux
      fio # disk benchmark

      ffmpeg_6-full
      imagemagick
      mpv
      mpd

      # Networking
      finger_bsd
      curl
      wget
      nmap
      dig

      pciutils
      usbutils
      nvme-cli

      # nvim clipboard
      xclip
      wl-clipboard
      wl-clipboard-x11

      # misc
      neofetch
      hyfetch
      ;
    inherit (pkgs.gst_all_1)
      gstreamer
      gst-vaapi
      gstreamermm
      gst-devtools
      gst-rtsp-server
      gst-plugins-bad
      gst-plugins-ugly
      gst-plugins-good
      gst-plugins-base
      gst-editing-services
      ;
  };
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      withPython3 = true;
      withNodeJs = true;
      withRuby = true;
    };
    htop = {
      enable = true;
      package = pkgs.htop-vim;
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
      config = {
        init = {
          defaultBranch = "main";
        };
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
  #TODO make false if theres no xserver
  security.rtkit.enable = true;
  programs.dconf.enable = true;
}
