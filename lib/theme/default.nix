{ colorlib, lib }: rec {
  colors = import ./colors.nix;

  # #RRGGBB
  xcolors = lib.mapAttrs (_: colorlib.x) colors;

  # rgba(,,,) colors (css)
  rgbaColors = lib.mapAttrs (_: colorlib.rgba) colors;

  wallpaper = import ../../misc/wallpaper/jet_set_radio_alien.jpg;
}
