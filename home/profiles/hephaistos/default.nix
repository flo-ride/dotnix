{ pkgs, lib, ... }: {
  imports = [  ];

  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1, 2256x1504,0x0,1";
  };
}
