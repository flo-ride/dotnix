{
  pkgs,
  flake,
  ...
}: let
  hyprlandPkgs = flake.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
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
}
