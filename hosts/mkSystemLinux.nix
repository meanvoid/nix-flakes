{
  lib,
  inputs,
  self,
  nixpkgs,
  darwin,
  nur,
  agenix,
  home-manager,
  users,
  path,
  spicetify-nix,
  aagl,
  flatpaks,
  ...
}: {
  homeManagerModules = hostName: [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit users path spicetify-nix;
        host = {inherit hostName;};
      };
      home-manager.users = lib.mkMerge (lib.mapAttrsToList
        (user: userName: {
          "${userName}" = {
            imports = [(./. + "/${hostName}/home/${userName}/home.nix")];
          };
        })
        users);
    }
  ];

  mkSystemConfig = {
    hostName,
    system,
    useHomeManager ? false,
    useNur ? false,
    useAagl ? false,
    useFlatpak ? false,
    modules ? [],
    ...
  }: let
    defaults =
      [
        {
          config = {
            nixpkgs.config.allowUnfree = lib.mkDefault true;
            services.flatpak.enable = lib.mkDefault useFlatpak;
          };
        }
        agenix.nixosModules.default
      ]
      ++ modules;
    sharedModules = lib.concatLists [
      (lib.optional useNur nur.nixosModules.nur)
      (lib.optional useAagl aagl.nixosModules.default)
      (lib.optional useFlatpak flatpaks.nixosModules.default)
      (lib.optionals useHomeManager (homeManagerModules hostName))
      defaults
    ];
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit users path;
        host = {inherit hostName;};
      };
      modules = [(./. + "/${hostName}/configuration.nix")] ++ sharedModules;
    };
}
