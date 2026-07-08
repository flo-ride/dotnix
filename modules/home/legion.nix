{...}: {
  modules.gui.wayland.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "1920x1080";
        position = "5360x500";
        scale = 1;
      }
      {
        output = "HDMI-A-1";
        mode = "3440x1440";
        position = "1920x0";
        scale = 1;
      }
      {
        output = "DP-1";
        mode = "1920x1080";
        position = "0x120";
        scale = 1;
      }
    ];
  };
}
