{ pkgs, lib, ... }: {
  imports = [ ../../programs ../../services ../../terminals/alacritty.nix ];

  wayland.windowManager.hyprland.settings = {
    monitor = [ "eDP-1, 1920x1080,0x500,1" "HDMI-A-1, 3440x1440, 1920x0,1" "DP-1,  1920x1080, 5360x120, 1"] ;
  };
}
