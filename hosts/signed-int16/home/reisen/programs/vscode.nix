{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    python3Full
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    userSettings = {
      "files.autoSave" = "afterDelay";
      "editor.cursorStyle" = "block";
      "editor.smoothScrolling" = true;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.list.smoothScrolling" = true;
      "window.menuBarVisibility" = "toggle";
      "terminal.integrated.smoothScrolling" = true;
    };
  };
}
