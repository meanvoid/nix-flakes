{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [rustup zlib openssl.dev pkg-config]);
    # enableUpdateCheck = true;
    # enableExtensionUpdateCheck = true;
    mutableExtensionsDir = true;
    userSettings = {
      "typescript.suggest.paths" = false;
      "javascript.suggest.paths" = false;
      "files.autoSave" = "afterDelay";
      "editor.fontSize" = 19;
      "editor.fontFamily" = "'MesloLGL Nerd Font'";
      "editor.tabSize" = 2;
      "editor.renderWhitespace" = "selection";
      "editor.cursorStyle" = "line";
      "editor.cursorBlinking" = "blink";
      "editor.bracketPairColorization.enabled" = true;
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
      "editor.formatOnSave" = true;
      "diffEditor.maxFileSize" = 0;
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;
      "editor.quickSuggestions" = {
        "other" = "on";
        "comments" = "on";
        "strings" = "off";
      };
      "terminal.integrated.minimumContrastRatio" = 1;
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.iconTheme" = "material-icon-theme";
      "telemetry.telemetryLevel" = "off";
    };
    extensions = with pkgs.vscode-extensions; [
      # lang and lsp support
      ms-python.python # python
      njpwerner.autodocstring
      ms-dotnettools.csharp # csharp
      ms-vscode.cpptools # cpp
      formulahendry.code-runner # C/CPP coderunner
      ms-vscode.hexeditor # hexediting
      ms-vscode.cmake-tools # cbuild
      ms-vscode.makefile-tools # cbuild
      llvm-vs-code-extensions.vscode-clangd # clang
      ms-vscode-remote.remote-ssh # vscode ssh
      golang.go # golang
      bbenoist.nix # nixfmt tool
      prisma.prisma # nodejs.prisma
      vscodevim.vim # vim
      # wholroyd.jinja # jinja
      yzhang.markdown-all-in-one # markdown

      # Utils
      christian-kohler.path-intellisense # file name intellisense
      bradlc.vscode-tailwindcss # tailwindcss intellisense

      # themes and icons
      jdinhlife.gruvbox
      catppuccin.catppuccin-vsc
      dracula-theme.theme-dracula
      pkief.material-icon-theme

      # Languages
      ms-ceintl.vscode-language-pack-ja
      streetsidesoftware.code-spell-checker
      esbenp.prettier-vscode # prettier
    ];
  };
}
