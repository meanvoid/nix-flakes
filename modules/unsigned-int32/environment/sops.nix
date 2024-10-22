{ pkgs, path, ... }:
{
  sops = {
    gnupg.home = "/Users/marie/.gnupg";
    gnupg.sshKeyPaths = [ ];
    # TODO: Migrate from agenix to sops-nix
    # secrets = {
    #   "Users/root/password" = {
    #     neededForUsers = true;
    #     format = "yaml";
    #     sopsFile = path + /secrets/unsigned-int32.yaml;
    #   };
    #   "Users/ashuramaru/password" = {
    #     neededForUsers = true;
    #     format = "yaml";
    #     sopsFile = path + /secrets/unsigned-int32.yaml;
    #   };
    #   "Users/meanrin/password" = {
    #     neededForUsers = true;
    #     format = "yaml";
    #     sopsFile = path + /secrets/unsigned-int32.yaml;
    #   };
    # };
  };
  environment.systemPackages = builtins.attrValues { inherit (pkgs) sops; };
}
