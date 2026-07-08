{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.gui.wayland.hyprland;
  hyprlandPkgs = flake.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [];

  options.modules.gui.wayland.hyprland.enable = lib.mkEnableOption "Hyprland Wayland compositor";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
    # add hyprland to display manager sessions
    services.displayManager.sessionPackages = [pkgs.hyprland];
    services.displayManager.defaultSession = "hyprland";
  };
}
