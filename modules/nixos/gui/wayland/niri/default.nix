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
    # Make sure niri is available in the display manager (SDDM)
    services.displayManager.sessionPackages = [ flake.inputs.niri.packages.${pkgs.system}.niri-unstable ];

    programs.niri = {
      enable = true;
      package = flake.inputs.niri.packages.${pkgs.system}.niri-unstable;
    };
  };
}
