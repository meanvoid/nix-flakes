{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    highlight = {
      MatchParen = {
        bold = true;
      };
    };

    opts = {
      autoindent = true;
      backup = false;
      cc = "80";
      compatible = false;
      cursorline = true;
      cursorlineopt = "both";
      history = 1000;
      ignorecase = true;
      number = true;
      relativenumber = true;
      scrolloff = 2;
      shiftwidth = 4;
      showcmd = true;
      showmatch = true;
      showmode = false;
      smartcase = true;
      smartindent = true;
      swapfile = false;
      tabstop = 4;
      termguicolors = true;
      timeoutlen = 0;
      wildmenu = true;
      wrap = false;
    };

    plugins = {
      web-devicons.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "path"; }
            { name = "buffer"; }
            { name = "nvim_lsp"; }
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      lastplace = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
        };
      };
      gitsigns = {
        enable = true;
      };
      gitgutter = {
        enable = true;
      };
      indent-blankline = {
        enable = true;
        settings = {
          exclude = {
            buftypes = [
              "terminal"
              "quickfix"
            ];
            filetypes = [
              ""
              "checkhealth"
              "help"
              "lspinfo"
              "packer"
              "TelescopePrompt"
              "TelescopeResults"
              "yaml"
            ];
          };
          indent = {
            char = "│";
          };
        };
      };
      lualine = {
        enable = true;
        settings = {
          options = {
            disabled_filetypes = {
              __unkeyed-1 = "NvimTree";
            };
            theme = "base16";
          };
        };
      };
      nix.enable = true;
      nvim-autopairs = {
        enable = true;
        settings = {
          disable_filetype = [ "TelescopePrompt" ];
        };
      };
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
        disableNetrw = true;
        extraOptions = {
          view.width = 30;
        };
        hijackCursor = true;
        openOnSetup = false;
      };
      telescope = {
        enable = true;
        extensions = {
          file-browser.enable = true;
          frecency.enable = true;
          fzf-native.enable = true;
          live-grep-args.enable = true;
        };
      };
      which-key = {
        enable = true;
        settings = {
          preset = "classic";
          win = {
            border = "single";
          };
          spec = [
            {
              __unkeyed-1 = "<F6>";
              __unkeyed-2 = "<cmd>NvimTreeToggle<CR>";
              desc = "Toggle Filetree";
              mode = "n";
            }
            {
              __unkeyed-1 = "<leader>/";
              __unkeyed-2 = "<cmd>Telescope live_grep<CR>";
              desc = "live_grep";
              mode = "n";
            }
            {
              __unkeyed-1 = "<leader>b";
              __unkeyed-2 = "<cmd>Telescope buffers<CR>";
              desc = "buffers";
              mode = "n";
            }
            {
              __unkeyed-1 = "<leader>f";
              __unkeyed-2 = "<cmd>Telescope find_files<CR>";
              desc = "find files";
              mode = "n";
            }
            {
              __unkeyed-1 = "<leader>p";
              __unkeyed-2 = "\"+p";
              desc = "paste from clipboard";
              mode = "n";
            }
            {
              __unkeyed-1 = "<leader>y";
              __unkeyed-2 = "\"+y";
              desc = "yank to clipboard";
              mode = "v";
            }
          ];
        };
      };
    };

    extraPackages = with pkgs.vimPlugins; [
      vim-sensible
    ];

    globals = {
      mapleader = " ";
    };

    colorschemes.base16 = {
      enable = true;
      colorscheme = "catppuccin-mocha";
      settings = {
        telescope = true;
        telescope_borders = true;
      };
    };
  };
}
