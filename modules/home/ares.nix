{ pkgs, ... }:
{
  enableSuspend = false;
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, 3440x1440@60, 1920x0, 1"
      "HDMI-A-1, 1920x1080, 0x120, 1"
    ];
  };
}
