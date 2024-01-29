{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (inputs.nix-vscode-extensions.extensions.x86_64-linux) vscode-marketplace;

  vscode-overlay = pkgs.vscode.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [pkgs.makeWrapper];
    postInstall =
      oldAttrs.postInstall
      or ""
      + ''
        wrapProgram "$out/bin/code" --set GTK_USE_PORTAL=1
      '';
  });
in {
  home.packages = with pkgs; [
    python3Full
    ruby
    go
    jdk
    rustup
  ];
  programs.vscode = {
    enable = true;
    package = vscode-overlay;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
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
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "material-icon-theme";
      "telemetry.telemetryLevel" = "off";
    };
    extensions = with vscode-marketplace; [
      # lang and lsp support
      ms-python.python # python
      ms-dotnettools.csharp # csharp
      ms-vscode.cpptools # cpp
      rust-lang.rust-analyzer # rust
      golang.go # golang
      redhat.java # java
      scala-lang.scala # scala
      mathiasfrohlich.kotlin # kotlin
      fwcd.kotlin # kotlin debug
      shopify.ruby-lsp # ruby, previous was deprecated
      dart-code.flutter # flutter
      ms-azuretools.vscode-docker # docker
      ms-kubernetes-tools.vscode-kubernetes-tools # kuber
      yzhang.markdown-all-in-one # markdown
      redhat.vscode-yaml # yaml
      dotjoshjohnson.xml # xml
      graphql.vscode-graphql # graphql
      lizebang.bash-extension-pack # bash
      bbenoist.nix # nix lsp
      kamadorueda.alejandra # alejandra

      # Utils
      mkhl.direnv # direnv
      njpwerner.autodocstring # autodocstring
      ms-vscode.hexeditor # hexediting
      ms-vscode-remote.remote-ssh # vscode ssh
      ms-vsliveshare.vsliveshare # live share
      visualstudioexptteam.vscodeintellicode # intellisense
      visualstudioexptteam.intellicode-api-usage-examples
      christian-kohler.path-intellisense # file name intellisense
      tamasfe.even-better-toml # toml support
      editorconfig.editorconfig # editorconfig support
      github.vscode-pull-request-github #
      donjayamanne.githistory # git history
      eamodio.gitlens # gitlens
      mikestead.dotenv # dotenv
      humao.rest-client # restapi
      aaron-bond.better-comments

      # Java utils
      vscjava.vscode-gradle
      vscjava.vscode-java-pack

      # C Utils
      formulahendry.code-runner # C/CPP coderunner
      danielpinto8zz6.c-cpp-compile-run # compile and run
      ms-vscode.cmake-tools # cbuild
      ms-vscode.makefile-tools # cbuild
      llvm-vs-code-extensions.vscode-clangd # clang
      cschlosser.doxdocgen # doxygen

      # Dotnet Utils
      ms-dotnettools.vscode-dotnet-runtime

      # Python Utils
      batisteo.vscode-django # django
      kevinrose.vsc-python-indent # indetation
      wholroyd.jinja # jinja
      donjayamanne.python-environment-manager # venv

      # JS utils
      steoates.autoimport
      ecmel.vscode-html-css # html css
      formulahendry.auto-rename-tag # auto rename
      formulahendry.auto-close-tag # auto close
      ritwickdey.liveserver # liveserver
      firefox-devtools.vscode-firefox-debug # firefox debugger
      angular.ng-template # angular
      johnpapa.angular2 # angular snippets
      dbaeumer.vscode-eslint # eslint
      jasonnutter.search-node-modules # search trough node_modules
      christian-kohler.npm-intellisense # npm intellisense
      wallabyjs.quokka-vscode # quokkajs
      prisma.prisma # nodejs.prisma
      wix.vscode-import-cost
      vue.volar
      hollowtree.vue-snippets
      octref.vetur # vuejs
      dsznajder.es7-react-js-snippets # reactjs snippets
      msjsdiag.vscode-react-native # react-native
      bradlc.vscode-tailwindcss # tailwindcss intellisense

      # themes and icons
      jdinhlife.gruvbox
      catppuccin.catppuccin-vsc
      dracula-theme.theme-dracula
      pkief.material-icon-theme
      zhuangtongfa.material-theme

      # Languages
      ms-ceintl.vscode-language-pack-ja
      streetsidesoftware.code-spell-checker
      esbenp.prettier-vscode # prettier
    ];
  };
}
