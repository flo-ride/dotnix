{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.gui.wayland.hyprland;
in {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
  ];

  options.modules.gui.wayland.hyprland.enable = lib.mkEnableOption "Hyprland Wayland compositor";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      # upscale steam
      GDK_SCALE = "1";
    };
  };
}
