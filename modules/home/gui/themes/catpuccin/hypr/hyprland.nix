# Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
#
# Theme Elements & Colors for Hyprland.
# Edited for Garuda Linux by yurihikari
# Edited by FloRide for its personal config
{...}: {
  wayland.windowManager.hyprland.settings = {
    config = {
      general = {
        border_size = 2;
        gaps_in = 5;
        gaps_out = 10;
        col = {
          active_border = {
            colors = [ "rgba(B4A1DBFF)" "rgba(D04E9DFF)" ];
            angle = 45;
          };
          inactive_border = {
            colors = [ "rgba(1E2030FF)" "rgba(1E2030FF)" ];
            angle = 45;
          };
        };
      };
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        dim_inactive = false;
        dim_strength = 0.5;
      };
      animations = {
        enabled = true;
      };
    };

    animation = [
      { leaf = "windowsIn"; enabled = true; speed = 5; bezier = "default"; style = "popin 0%"; }
      { leaf = "windowsOut"; enabled = true; speed = 5; bezier = "default"; style = "popin"; }
      { leaf = "windowsMove"; enabled = true; speed = 5; bezier = "default"; style = "slide"; }
      { leaf = "fadeIn"; enabled = true; speed = 8; bezier = "default"; }
      { leaf = "fadeOut"; enabled = true; speed = 8; bezier = "default"; }
      { leaf = "fadeSwitch"; enabled = true; speed = 8; bezier = "default"; }
      { leaf = "fadeShadow"; enabled = true; speed = 8; bezier = "default"; }
      { leaf = "fadeDim"; enabled = true; speed = 8; bezier = "default"; }
      { leaf = "border"; enabled = true; speed = 10; bezier = "default"; }
      { leaf = "workspaces"; enabled = true; speed = 5; bezier = "default"; style = "slide"; }
    ];
  };
}
