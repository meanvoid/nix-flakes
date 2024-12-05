{ pkgs, ... }:
{
  home.packages = [
    pkgs.python3Full
    pkgs.go
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
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
