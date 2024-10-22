{ lib, config, ... }:
{
  options.i18n.inputMethod.fcitx5 = {
    addEnvironmentVariables = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        ## Adds env variables that fix some issues with some specific apps 
        ### for example java based opengl apps or kitty
        ```sh
        SDL_IM_MODULE=fcitx
        GLFW_IM_MODULE=ibus
        ```
      '';
    };
  };
  config =
    lib.mkIf
      (
        config.i18n.inputMethod.enabled == "fcitx5"
        && config.i18n.inputMethod.fcitx5.waylandFrontend == true
        && config.i18n.inputMethod.fcitx5.addEnvironmentVariables
      )
      {
        environment.sessionVariables = {
          SDL_IM_MODULE = "fcitx";
          GLFW_IM_MODULE = "ibus";
        };
      };
}
