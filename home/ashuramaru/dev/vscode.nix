{ inputs, pkgs, ... }:
let
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # c/c++
      cmakeCurses
      clang-tools
      gnumake
      # Python
      python3Full
      # Ruby
      ruby
      # Rust
      rustc
      # Golang
      go
      # Java
      jdk

      # Nix
      nil
      nixfmt-rfc-style
      arduino-language-server
      ;
    inherit (pkgs.llvmPackages) libcxxClang;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = true;
    mutableExtensionsDir = true;
    userSettings = {
      "search.followSymlinks" = false;
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
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;
      "editor.quickSuggestions" = {
        "other" = "on";
        "comments" = "on";
        "strings" = "off";
      };
      "diffEditor.maxFileSize" = 0;
      "terminal.integrated.minimumContrastRatio" = 1;
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.sideBar.location" = "right";
      "telemetry.telemetryLevel" = "off";
      "editor.unicodeHighlight.allowedLocales" = {
        "ja" = true;
        "　" = true;
      };
      # nix
      "nix" = {
        "enableLanguageServer" = true;
        "serverPath" = "nil";
        "serverSettings.nil" = {
          "formatting" = {
            "command" = [ "nixfmt -v $(${pkgs.findutils}/bin/find * -type d | ${pkgs.gnugrep}/bin/grep -v \".direnv\")" ];
          };
          "nix" = {
            "binary" = "nix";
            "maxMemoryMB" = 8124;
            "flake.autoArchive" = true;
            "flake.autoEvalInputs" = true;
          };
        };
        "formatterPath" = "nixfmt";
      };
      # python
      "[python]" = {
        "formatting.provider" = "none";
        "editor.defaultFormatter" = "omnilib.ufmt";
        "editor.formatOnSave" = true;
      };
    };
    extensions = builtins.attrValues {
      ## -- Vscode specific -- ##
      remote-development = vscode-marketplace.ms-vscode-remote.vscode-remote-extensionpack;
      vscode-hexeditor = vscode-marketplace.ms-vscode.hexeditor;
      vscode-remote-extensionpack = vscode-marketplace.ms-vscode-remote.vscode-remote-extensionpack;
      vscode-liveshare = vscode-marketplace.ms-vsliveshare.vsliveshare;
      vscode-intellisense = vscode-marketplace.visualstudioexptteam.vscodeintellicode;
      vscode-intellicode-api-usage-examples = vscode-marketplace.visualstudioexptteam.intellicode-api-usage-examples;
      vscode-intellisense-path = vscode-marketplace.christian-kohler.path-intellisense;
      vscode-pull-request = vscode-marketplace.github.vscode-pull-request-github;
      vscode-git-history = vscode-marketplace.donjayamanne.githistory;
      vscode-gitlens = vscode-marketplace.eamodio.gitlens;
      vscode-better-comment = vscode-marketplace.aaron-bond.better-comments;
      vscode-code-spell-checker = vscode-marketplace.streetsidesoftware.code-spell-checker;
      ## -- Vscode specific -- ##

      ## -- Programming languages/lsp support -- ##
      cmake = vscode-marketplace.josetr.cmake-language-support-vscode;
      python = vscode-marketplace.ms-python.python;
      dotnet = vscode-marketplace.ms-dotnettools.csharp;
      cpptools-extension-pack = vscode-marketplace.ms-vscode.cpptools-extension-pack;
      rust-lang = vscode-marketplace.rust-lang.rust-analyzer;
      golang = vscode-marketplace.golang.go;
      scala = vscode-marketplace.scala-lang.scala;
      kotlin = vscode-marketplace.mathiasfrohlich.kotlin;
      kotlin-debugger = vscode-marketplace.fwcd.kotlin;
      ruby = vscode-marketplace.shopify.ruby-lsp;
      flutter = vscode-marketplace.dart-code.flutter;
      docker = vscode-marketplace.ms-azuretools.vscode-docker;
      kubernetes = vscode-marketplace.ms-kubernetes-tools.vscode-kubernetes-tools;
      markdown = vscode-marketplace.yzhang.markdown-all-in-one;
      yaml = vscode-marketplace.redhat.vscode-yaml;
      xml = vscode-marketplace.dotjoshjohnson.xml;
      toml = vscode-marketplace.tamasfe.even-better-toml;
      editorconfig = vscode-marketplace.editorconfig.editorconfig;
      graphql = vscode-marketplace.graphql.vscode-graphql;
      graphql-linter = vscode-marketplace.graphql.vscode-graphql-syntax;
      nix-lsp = vscode-marketplace.bbenoist.nix;
      github-actions = vscode-marketplace.github.vscode-github-actions;
      bash-extensions-pack = vscode-marketplace.lizebang.bash-extension-pack;
      ## -- Programming languages/lsp support -- ##

      ## -- Misc Utils -- ##
      prettier = vscode-marketplace.esbenp.prettier-vscode;
      markdown-linter = vscode-marketplace.davidanson.vscode-markdownlint;
      autodocstring = vscode-marketplace.njpwerner.autodocstring;
      dotenv = vscode-marketplace.mikestead.dotenv;
      restapi-client = vscode-marketplace.humao.rest-client;
      ## -- Misc Utils -- ##

      ## -- Nix Utils -- ##
      nix-ide = vscode-marketplace.jnoortheen.nix-ide;
      direnv = vscode-marketplace.mkhl.direnv;
      direnv-runtime = vscode-marketplace.rubymaniac.vscode-direnv;
      nixfmt = vscode-marketplace.brettm12345.nixfmt-vscode;
      ## -- Nix Utils -- ##

      ## -- Java Utils -- ##
      java = vscode-marketplace.redhat.java;
      gradle = vscode-marketplace.vscjava.vscode-gradle;
      java-debugger = vscode-marketplace.vscjava.vscode-java-debug;
      java-extension-pack = vscode-marketplace.vscjava.vscode-java-pack;
      ## -- Java Utils -- ##

      ## -- C/C++ Utils -- ##
      c-cpp-extension-pack = vscode-marketplace.ms-vscode.cpptools-extension-pack;
      code-runner = vscode-marketplace.formulahendry.code-runner;
      compile-and-run = vscode-marketplace.danielpinto8zz6.c-cpp-compile-run;
      makefile-tools = vscode-marketplace.ms-vscode.makefile-tools;
      doxygen = vscode-marketplace.cschlosser.doxdocgen;
      ## -- C/C++ Utils -- ##

      ## -- Dotnet Utils -- ##
      dotnet-tools-extension-pack = vscode-marketplace.ms-dotnettools.vscode-dotnet-pack;
      ## -- Dotnet Utils -- ##

      ## -- Python Utils -- ##
      ufmt = vscode-marketplace.omnilib.ufmt;
      black = vscode-marketplace.ms-python.black-formatter;
      python-linter = vscode-marketplace.ms-python.pylint;
      python-debugger = vscode-marketplace.ms-python.debugpy;
      django = vscode-marketplace.batisteo.vscode-django;
      python-indent = vscode-marketplace.kevinrose.vsc-python-indent;
      jinja = vscode-marketplace.wholroyd.jinja;
      python-env = vscode-marketplace.donjayamanne.python-environment-manager;
      ## -- Python Utils -- ##

      ## -- JavaScript/Typescript Utils -- ##
      autoimport = vscode-marketplace.steoates.autoimport;
      html-css = vscode-marketplace.ecmel.vscode-html-css;
      tailwind-css = vscode-marketplace.bradlc.vscode-tailwindcss;
      rename-tag = vscode-marketplace.formulahendry.auto-rename-tag;
      close-tag = vscode-marketplace.formulahendry.auto-close-tag;
      liveserver = vscode-marketplace.ritwickdey.liveserver;
      firefox-devtools = vscode-marketplace.firefox-devtools.vscode-firefox-debug;
      angular = vscode-marketplace.angular.ng-template;
      angular-examples = vscode-marketplace.johnpapa.angular2;
      eslint = vscode-marketplace.dbaeumer.vscode-eslint;
      search-node-modules = vscode-marketplace.jasonnutter.search-node-modules;
      npm-intellisense = vscode-marketplace.christian-kohler.npm-intellisense;
      prisma = vscode-marketplace.prisma.prisma;
      vscode-import = vscode-marketplace.wix.vscode-import-cost;
      vuejs = vscode-marketplace.octref.vetur;
      vuejs-volar = vscode-marketplace.vue.volar;
      vuejs-examples = vscode-marketplace.hollowtree.vue-snippets;
      react-native = vscode-marketplace.msjsdiag.vscode-react-native;
      reactjs-examples = vscode-marketplace.dsznajder.es7-react-js-snippets;
      ## -- JavaScript/Typescript Utils -- ##

      ## -- VSCode Themes/Icons -- ##
      vscode-theme-gruvbox = vscode-marketplace.jdinhlife.gruvbox;
      vscode-theme-catppuccin = vscode-marketplace.catppuccin.catppuccin-vsc;
      vscode-theme-dracula = vscode-marketplace.dracula-theme.theme-dracula;
      vscode-theme-material = vscode-marketplace.zhuangtongfa.material-theme;
      vscode-icon-material = vscode-marketplace.pkief.material-icon-theme;
      ## -- VSCode Themes/Icons -- ##

      ## -- Dictionary/Languages support -- ##
      japanese = vscode-marketplace.ms-ceintl.vscode-language-pack-ja;
      ## -- Dictionary/Languages support -- ##
    };
  };
  home.sessionVariables = {
    GO_PATH = "$XDG_DATA_HOME/go";
  };
}
