{ config, pkgs, ... }:
{
  config.environment.systemPackages = with pkgs.nodePackages; [
    yarn # node package manager
    typescript # tsc 
    ts-node # repl for typescript
    tsun # testing
    javascript-typescript-langserver
    nodemon # uptimer for js and not only apps
    lodash # generic library mostly deprecated but let it be
    jsdoc # jsdocuments generator 
    sass # sass compiler 
  ];
}
