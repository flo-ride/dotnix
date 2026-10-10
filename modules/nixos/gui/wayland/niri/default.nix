{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.gui.wayland.niri;
in {
  options.modules.gui.wayland.niri.enable = lib.mkEnableOption "Niri Wayland compositor";

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    # Make sure niri is available in the display manager (SDDM)
    services.displayManager.sessionPackages = [flake.inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable];

    programs.niri = {
      enable = true;
      package = flake.inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config.niri = {
        default = lib.mkForce ["gtk" "gnome"];
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = lib.mkForce ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = lib.mkForce ["gnome"];
        "org.freedesktop.impl.portal.Secret" = lib.mkForce ["gnome"];
      };
    };
  };
}
