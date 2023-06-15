{
  lib,
  nixpkgs,
  nur,
  home-manager,
  spicetify-nix,
  flatpaks,
  users,
  path,
  ...
}: {
  homeManagerModulesLinux = hostName: [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit users path spicetify-nix;
        host = {
          inherit hostName;
        };
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

  homeManagerModulesDarwin = hostName: [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit users path;
        host = {
          inherit hostName;
        };
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
}
