_: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg = {
      enable = true;
      settings.no-symkey-cache = true;
    };
    gallery-dl = {
      enable = true;
      settings.extractor = {
        base-directory = "/Shared/media/archive/gallery-dl";
        user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 GLS/100.10.9939.100";
        skip = true;
        downloader = {
          rate = "10M";
          retries = 3;
          timeout = 5;
        };
        postprocessor = {
          content = {
            name = "content";
            event = "post";
            filename = "{post_id|tweet_id|id}.txt";
            mode = "custom";
            format = "{content|description}\n";
          };
          cbz = {
            "name" = "zip";
            "compression" = "store";
            "extension" = "cbz";
            "filter" = "extension not in ('zip', 'rar')";
            "whitelist" = [
              "mangadex"
              "exhentai"
              "nhentai"
              "hitomi"
            ];
          };
          ugoira-webm = {
            name = "ugoira";
            extension = "webm";
            ffmpeg-args = [
              "-c:v"
              "libvpx-vp9" # Changed to libvpx-vp9
              "-b:v"
              "0" # Set bitrate to 0 for lossless
              "-crf"
              "30" # Use CRF for quality control
              "-pix_fmt"
              "yuv420p"
            ];
            ffmpeg-twopass = true;
            ffmpeg-demuxer = "image2";
          };
          ugoira-mp4 = {
            name = "ugoira";
            extension = "mp4";
            ffmpeg-args = [
              "-hide_banner"
              "-loglevel"
              "error"
              "-c:v"
              "libx264"
              "-b:v"
              "4M"
              "-preset"
              "veryslow -c:a"
            ];
            ffmpeg-twopass = true;
            libx265-prevent-odd = true;
          };
          ugoira-gif = {
            name = "ugoira";
            extension = "gif";
            ffmpeg-args = [
              "-filter_complex"
              "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse"
            ];
          };
          ugoira-copy = {
            name = "ugoira";
            extension = "mkv";
            ffmpeg-args = [
              "-c"
              "copy"
            ];
            libx264-prevent-odd = false;
            repeat-last-frame = false;
          };
        };
        ytdl = {
          enabled = true;
          module = "yt-dlp";
        };
        danbooru = {
          "ugoira" = true;
          "postprocessors" = [ "ugoira" ];
        };
        gelbooru = {
          "ugoira" = true;
          "postprocessors" = [ "ugoira" ];
        };
        fanbox = {
          archive = "/Shared/media/archive/gallery-dl/archive-fanbox.sqlite3";
          cookies = {
            FANBOXSESSID = "74708428_VpDSgg0EHo2lTrCsFAeAxr6gmlyTaQki";
            p_ab_id = "7";
            p_ab_id_2 = "4";
            p_ab_d_id = "846934715";
            privacy_policy_agreement = "7";
            privacy_policy_notification = "0";
            cf_clearance = "bhWoqe3KDGfJJoIi805qvKUt3dpjylx7iwlnQulDJ_Y-1728327576-1.2.1.1-bKMI9rQxBtD8UPnW3KEr4lI3_TCRaKoO2knLfMOohauo7FOesY41.Vr..zdE7LiIPdECcOQ2qjbV9MfbHF3TrgBTqq8ZsCaqTL5MDfSDML4nXA49cKbwEHjJv07nj2O8rukdyYPth_DCIfKHj0WsAdhEBKFTB_k9mitjlFNp8VJ_UWxaQq86Xi0FrAxRfIYRzGt96UPExtkHHbmlrZxU8A3NgLEeIR3_L6UAAY1dg6WWfMt5FMO6rGCP8lvpWKClEyCWaCXdg0.x7BemjNH2fn2CTjTivUX4yRpbxoG5oYfgDmLjqvUuctDcXcXO.VD3K2Sle9Zh._ixXo2uW327nw";
            "__cf_bm" = "CX4TUMpeQx6HKhcahhOVTtDTzTpmgQYjeH9Fjz0iiaY-1728327573-1.0.1.1-FyUmmu_DOSLY9PSU.BOYV_HYiztXDTDo";
          };
          cookies-update = true;
          postprocessors = [ "content" ];
        };
        patreon = {
          archive = "/Shared/media/archive/gallery-dl/archive-patreon.sqlite3";
          cookies = {
            session_id = "vvVN8t9tQuoaT7UBokd8UV9NYUk7VEDtJVhf7GCPZQg";
          };
          postprocessors = [ "content" ];
        };
        nhentai = {
          postprocessors = [
            "content"
            "zip"
          ];
          archive = "/Shared/media/archive/gallery-dl/archive-nh.sqlite3";
          cookies = {
            cf_clearance = "sV9Ji3VDS2r_XbhqI4TQxH0qj_pDq_b1LaS2.p_NSsw-1717090247-1.0.1.1-DaUtEKoSG.HTU16fT3.FJJIwSl9YOloEDrwNRqHjtLpVBqSvgevEH_l2JTiK993LCDbWFnCKultgRQQEJ9gzvg";
            csrftoken = "2LeaLdn2r3SWc4F4uEBMg5l7O9qTC7kVRYcyGQoW5C1kkvUGds3mxg2Yvp7E2WhD";
            sessionid = "paaprqtqzfpn1jh2ig3hjqmhyu937lfr";
          };
        };
        archive = "/Shared/media/archive/gallery-dl/archive.sqlite3";
        archive-pragma = [
          "journal_mode=WAL"
          "synchronous=NORMAL"
        ];
        mangadex = {
          postprocessors = [
            "content"
            "cbz"
          ];
        };
        cache = {
          file = "/Shared/media/archive/gallery-dl/cache.sqlite3";
        };
      };
    };
  };
}
