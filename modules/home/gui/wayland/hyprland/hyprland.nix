{
  lib,
  config,
  pkgs,
  ...
}: let
  mainMod = "SUPER";

  # Packages
  dms-ipc = "dms ipc call";
  term = "${pkgs.alacritty}/bin/alacritty";
  screenshot = "dms screenshot";
  playerctl = "${lib.getExe pkgs.playerctl}";
  hypridle = "${lib.getExe pkgs.hypridle}";
in {
  wayland.windowManager.hyprland = {
    configType = "hyprlang";
    settings = {
      "$mainMod" = mainMod;

      input = {
        kb_layout = "gb";
        kb_variant = "extd";
        follow_mouse = 1; # Cursor movement will always change focus to the window under the cursor.
      };

      general = {
        layout = "dwindle";
      };

      decoration = {
        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          ignore_opacity = false;
        };
      };

      # Exec configuration
      exec-once = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.systemd}/bin/systemctl --user start graphical-session.target"
        "${pkgs.systemd}/bin/systemctl --user restart steam-run-url-service"
        "${hypridle}"
        "${lib.getExe pkgs.hyprlock} --immediate"
      ];

      bind =
        [
          # General
          "$mainMod SHIFT, Q, killactive"
          "$mainMod, F, fullscreen"
          "$mainMod, Space, togglefloating"

          # Application Launchers
          "$mainMod, Return, exec, ${term}"
          "$mainMod, D, exec, ${dms-ipc} spotlight toggle"
          "$mainMod, N, exec, ${dms-ipc} notifications toggle"
          "$mainMod, TAB, exec, ${dms-ipc} hypr toggleOverview"

          # Security
          "$mainMod, X, exec, ${dms-ipc} lock lock"

          # Clipboard
          "$mainMod SHIFT, V, exec, ${dms-ipc} clipboard toggle"

          # Screenshot
          " , PRINT, exec, ${screenshot}"
          "$mainMod SHIFT, S, exec, ${screenshot}"

          # Resize submap
          "$mainMod, R, submap, resize"

          # Move focus
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          # Workspaces
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ]
        ++ lib.flatten (
          map (
            n: let
              ws = let
                c = n / 10;
              in
                builtins.toString (n - (c * 10));
            in [
              "$mainMod, ${ws}, workspace, ${toString n}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString n}"
            ]
          ) (builtins.genList (x: x + 1) 10)
        );

      binde = [
        # Brightness Controls
        " , XF86MonBrightnessDown, exec, ${dms-ipc} brightness decrement 5 \"\""
        " , XF86MonBrightnessUp, exec, ${dms-ipc} brightness increment 5 \"\""

        # Audio Controls
        " , XF86AudioRaiseVolume, exec, ${dms-ipc} audio increment 1"
        " , XF86AudioLowerVolume, exec, ${dms-ipc} audio decrement 1"

        # Move window
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # When floating
        "$mainMod SHIFT, left, moveactive, -30 0"
        "$mainMod SHIFT, right, moveactive, 30 0"
        "$mainMod SHIFT, up, moveactive, 0 -30"
        "$mainMod SHIFT, down, moveactive, 0 30"
      ];

      bindl = [
        " , XF86AudioMute, exec, ${dms-ipc} audio mute"
        " , XF86AudioPlay, exec, ${playerctl} play-pause"
        " , XF86AudioPause, exec, ${playerctl} play-pause"
        " , XF86AudioNext, exec, ${playerctl} next"
        " , XF86AudioPrev, exec, ${playerctl} previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };

    submaps.resize.settings = {
      binde = [
        ", right, resizeactive, 10 0"
        ", left, resizeactive, -10 0"
        ", up, resizeactive, 0 -10"
        ", down, resizeactive, 0 10"
      ];

      bind = [
        ", escape, submap, reset"
      ];
    };
  };
}
