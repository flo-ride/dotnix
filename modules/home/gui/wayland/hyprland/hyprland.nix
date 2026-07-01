{
  lib,
  pkgs,
  ...
}: let
  mainMod = "SUPER";

  # Packages
  dms-ipc = "${lib.getExe pkgs.dms-shell} ipc call";
  term = "${lib.getExe pkgs.alacritty}";
  screenshot = "${lib.getExe pkgs.dms} screenshot";
  playerctl = "${lib.getExe pkgs.playerctl}";
  hypridle = "${lib.getExe pkgs.hypridle}";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";

  mkInline = lib.generators.mkLuaInline;
in {
  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;

    configType = "lua";

    settings = {
      config = {
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
      };

      on = [
        {
          _args = [
            "hyprland.start"
            (mkInline ''
              function()
                hl.exec_cmd("${pkgs.systemd}/bin/systemctl --user restart steam-run-url-service")
                hl.exec_cmd("${hypridle}")
                hl.exec_cmd("${lib.getExe pkgs.hyprlock} --immediate")
              end
            '')
          ];
        }
      ];

      bind =
        [
          # General
          {_args = ["${mainMod} + SHIFT + Q" (mkInline "hl.dsp.window.close()")];}
          {_args = ["${mainMod} + F" (mkInline "hl.dsp.window.fullscreen()")];}
          {_args = ["${mainMod} + Space" (mkInline "hl.dsp.window.float({ action = \"toggle\" })")];}

          # Application Launchers
          {_args = ["${mainMod} + Return" (mkInline "hl.dsp.exec_cmd(\"${term}\")")];}
          {_args = ["${mainMod} + D" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} spotlight toggle\")")];}
          {_args = ["${mainMod} + N" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} notifications toggle\")")];}
          {_args = ["${mainMod} + TAB" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} hypr toggleOverview\")")];}

          # Security
          {_args = ["${mainMod} + X" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} lock lock\")")];}

          # Clipboard
          {_args = ["${mainMod} + SHIFT + V" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} clipboard toggle\")")];}

          # Screenshot
          {_args = ["PRINT" (mkInline "hl.dsp.exec_cmd(\"${screenshot}\")")];}
          {_args = ["${mainMod} + SHIFT + S" (mkInline "hl.dsp.exec_cmd(\"${screenshot}\")")];}

          # Move focus
          {_args = ["${mainMod} + left" (mkInline "hl.dsp.focus({ direction = \"l\" })")];}
          {_args = ["${mainMod} + right" (mkInline "hl.dsp.focus({ direction = \"r\" })")];}
          {_args = ["${mainMod} + up" (mkInline "hl.dsp.focus({ direction = \"u\" })")];}
          {_args = ["${mainMod} + down" (mkInline "hl.dsp.focus({ direction = \"d\" })")];}
          {_args = ["${mainMod} + h" (mkInline "hl.dsp.focus({ direction = \"l\" })")];}
          {_args = ["${mainMod} + l" (mkInline "hl.dsp.focus({ direction = \"r\" })")];}
          {_args = ["${mainMod} + k" (mkInline "hl.dsp.focus({ direction = \"u\" })")];}
          {_args = ["${mainMod} + j" (mkInline "hl.dsp.focus({ direction = \"d\" })")];}

          # Workspaces
          {_args = ["${mainMod} + mouse_down" (mkInline "hl.dsp.focus({ workspace = \"e+1\" })")];}
          {_args = ["${mainMod} + mouse_up" (mkInline "hl.dsp.focus({ workspace = \"e-1\" })")];}
        ]
        ++ lib.flatten (
          map (
            n: let
              ws = let c = n / 10; in toString (n - (c * 10));
            in [
              {_args = ["${mainMod} + ${ws}" (mkInline "hl.dsp.focus({ workspace = \"${toString n}\" })")];}
              {_args = ["${mainMod} + SHIFT + ${ws}" (mkInline "hl.dsp.window.move({ workspace = \"${toString n}\" })")];}
            ]
          ) (builtins.genList (x: x + 1) 10)
        )
        ++ [
          # Brightness Controls
          {_args = ["XF86MonBrightnessDown" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} brightness decrement 5 \\\"\\\"\")") {repeating = true;}];}
          {_args = ["XF86MonBrightnessUp" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} brightness increment 5 \\\"\\\"\")") {repeating = true;}];}

          # Audio Controls
          {_args = ["XF86AudioRaiseVolume" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} audio increment 1\")") {repeating = true;}];}
          {_args = ["XF86AudioLowerVolume" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} audio decrement 1\")") {repeating = true;}];}

          # Move window
          {_args = ["${mainMod} + SHIFT + left" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow l\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + right" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow r\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + up" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow u\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + down" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow d\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + h" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow l\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + l" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow r\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + k" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow u\")") {repeating = true;}];}
          {_args = ["${mainMod} + SHIFT + j" (mkInline "hl.dsp.exec_cmd(\"${hyprctl} dispatch movewindow d\")") {repeating = true;}];}

          {_args = ["XF86AudioMute" (mkInline "hl.dsp.exec_cmd(\"${dms-ipc} audio mute\")") {locked = true;}];}
          {_args = ["XF86AudioPlay" (mkInline "hl.dsp.exec_cmd(\"${playerctl} play-pause\")") {locked = true;}];}
          {_args = ["XF86AudioPause" (mkInline "hl.dsp.exec_cmd(\"${playerctl} play-pause\")") {locked = true;}];}
          {_args = ["XF86AudioNext" (mkInline "hl.dsp.exec_cmd(\"${playerctl} next\")") {locked = true;}];}
          {_args = ["XF86AudioPrev" (mkInline "hl.dsp.exec_cmd(\"${playerctl} previous\")") {locked = true;}];}

          {_args = ["${mainMod} + mouse:272" (mkInline "hl.dsp.window.drag()") {mouse = true;}];}
          {_args = ["${mainMod} + mouse:273" (mkInline "hl.dsp.window.resize()") {mouse = true;}];}
        ];
    };
  };
}
