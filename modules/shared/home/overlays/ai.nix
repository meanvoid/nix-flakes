{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.nixified-ai.overlays.python-torchCuda ];
  home.packages = [
    inputs.nixified-ai.packages.${pkgs.system}.invokeai-nvidia
    inputs.nixified-ai.packages.${pkgs.system}.textgen-nvidia
  ];
}
