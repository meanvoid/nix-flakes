{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages =
    (with pkgs; [
      curl
      wget
      nmap
      dig

      zip
      unzip
      rar
      unrar
      lz4

      # utils
      neofetch
      hyfetch

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
      gst-plugins-bad
      gst-plugins-ugly
      gst-plugins-good
      gst-plugins-base
      gst-editing-services
    ]);

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    htop = {
      enable = true;
      package = pkgs.htop-vim;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
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
            insteadOf = ["gh:" "github:"];
          };
        };
      };
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      resizeAmount = 10;
      escapeTime = 250;
    };
  };
}
