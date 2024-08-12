{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
    plugins = builtins.attrValues {
      inherit (pkgs.vimPlugins)
        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace # Opens document where you left it
        auto-pairs # Print double quotes/brackets/etc.
        vim-gitgutter # See uncommitted changes of file :GitGutterEnable

        # File Tree
        nerdtree # File Manager - set in extraConfig to F6

        # Customization
        wombat256-vim # Color scheme for lightline
        srcery-vim # Color scheme for text

        lightline-vim # Info bar at bottom
        indent-blankline-nvim # Indentation lines

        # Preview support
        vimtex
        vimpreviewpandoc
        image-nvim
        ;
      tree-sitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
    };
    extraConfig = ''
      syntax enable                             " Syntax highlighting
      colorscheme srcery                        " Color scheme text
      let g:lightline = {
      		\ 'colorscheme': 'wombat',
      	\ }                                     " Color scheme lightline
      highlight Comment cterm=italic gui=italic " Comments become italic
      hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

      set number                                " Set numbers
      set relativenumber                        " Set relative number
      nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
    '';
  };
}
