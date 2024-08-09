{ pkgs, lib, ... }: {
  imports = [ ../../programs ../../services ../../terminals/alacritty.nix ];

  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1, 2256x1504,0x0,1";
  };

  home.packages = with pkgs; [
    freecad
  ];
}
