{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # just in case for some users
      firefox
      thunderbird
      ;
  };
}
