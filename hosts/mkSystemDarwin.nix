{
  lib,
  inputs,
  self,
  nixpkgs,
  darwin,
  nur,
  home-manager,
  users,
  path,
  ...
}: {
  hostName,
  system,
  useHomeManager ? false,
  modules ? [],
  ...
}: let
  defaults =
    [
      {
        config = {
          nixpkgs.config.allowUnfree = lib.mkDefault true;
        };
      }
    ]
    ++ modules;

  sharedModules = lib.concatLists [
    (lib.optional useHomeManager (homeManagerModules hostName))
    defaults
  ];
in
  darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {inherit users inputs;};
    modules = [(./. + "/${hostName}/configuration.nix")] ++ sharedModules;
  }
