{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
  ];

  home.sessionVariables = {
    # upscale steam
    GDK_SCALE = "1";
  };
}
