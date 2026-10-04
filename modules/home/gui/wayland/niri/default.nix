{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.gui.wayland.niri;

  dms-ipc = "${lib.getExe pkgs.dms-shell} ipc call";
  playerctl = "${lib.getExe pkgs.playerctl}";
  term = "${lib.getExe pkgs.alacritty}";
  screenshot = "${lib.getExe pkgs.dms-shell} screenshot";

  toNiri = str: lib.splitString " " str;
in {
  options.modules.gui.wayland.niri.enable = lib.mkEnableOption "Niri Wayland compositor";

  imports = [
    flake.inputs.niri.homeModules.niri
  ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xwayland-satellite # xwayland support
    ];
    programs.niri = {
      enable = true;
      package = flake.inputs.niri.packages.${pkgs.system}.niri-unstable;
      settings = {
        spawn-at-startup = [
          {command = ["${pkgs.systemd}/bin/systemctl" "--user" "restart" "steam-run-url-service"];}
          {command = toNiri "${dms-ipc} lock lock";}
        ];
        xwayland-satellite = {
          enable = true;
        };
        input = {
          focus-follows-mouse.enable = true;
          focus-follows-mouse.max-scroll-amount = "0%";
          warp-mouse-to-focus.enable = true;
          keyboard = {
            numlock = true;
            xkb = {
              layout = "gb";
              variant = "extd";
            };
          };
        };
        binds = {
          "Mod+Return".action.spawn = toNiri term;
          "Mod+D".action.spawn = toNiri "${dms-ipc} spotlight toggle";

          "Mod+X".action.spawn = toNiri "${dms-ipc} lock lock";
          "Mod+Shift+Q".action.close-window = {};
          "Mod+Shift+E".action.quit = {};
          "Mod+Shift+P".action.power-off-monitors = {};

          "Mod+Shift+C".action.spawn = toNiri "${dms-ipc} clipboard toggle";
          "PRINT".action.spawn = toNiri screenshot;

          # Focus controls
          "Mod+Up".action.focus-window-up = {};
          "Mod+Down".action.focus-window-down = {};
          "Mod+Left".action.focus-column-left = {};
          "Mod+Right".action.focus-column-right = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+J".action.focus-window-down = {};
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};

          # Move controls
          "Mod+Shift+Down".action.move-window-down = {};
          "Mod+Shift+Left".action.consume-or-expel-window-left = {};
          "Mod+Shift+Right".action.consume-or-expel-window-right = {};
          "Mod+Shift+Up".action.move-window-up = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Shift+H".action.consume-or-expel-window-left = {};
          "Mod+Shift+L".action.consume-or-expel-window-right = {};
          "Mod+Shift+K".action.move-window-up = {};

          # Mouse wheel controls
          "Mod+Shift+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = {};
          };
          "Mod+Shift+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = {};
          };
          "Mod+WheelScrollDown".action.focus-column-right = {};
          "Mod+WheelScrollUp".action.focus-column-left = {};

          # Column controls
          "Mod+Shift+V".action.switch-preset-column-width = {};
          "Mod+V".action.switch-preset-window-height = {};
          "Mod+F".action.maximize-column = {};

          # Audio Controls
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = toNiri "${dms-ipc} audio increment 1";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = toNiri "${dms-ipc} audio decrement 1";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = toNiri "${dms-ipc} audio mute";
          };
          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = toNiri "${playerctl} play-pause";
          };
          "XF86AudioPause" = {
            allow-when-locked = true;
            action.spawn = toNiri "${playerctl} play-pause";
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn = toNiri "${playerctl} next";
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn = toNiri "${playerctl} previous";
          };

          # Brightness Controls
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn = toNiri "${dms-ipc} brightness increment 5 \"\"";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn = toNiri "${dms-ipc} brightness decrement 5 \"\"";
          };
        };
        environment = {
          XDG_CURRENT_DESKTOP = "niri";
          QT_QPA_PLATFORM = "wayland";
          QT_QPA_PLATFORMTHEME = "gtk3";
          T_QPA_PLATFORMTHEME_QT6 = "gtk3";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          GTK_USE_PORTAL = "1";
        };

        window-rules = [
          {
            matches = [
              {app-id = "^org\\.keepassxc\\.KeePassXC$";}
              {app-id = "^org\\.gnome\\.World\\.Secrets$";}
              {app-id = "^bitwarden$";}
              {app-id = "^Bitwarden$";}
              {app-id = "^1Password$";}
              {title = "(?i).*bitwarden.*";}
              {title = "(?i).*banque.*";}
              {title = "(?i).*bank.*";}
              {title = "(?i).*vault.*";}
              {title = "(?i).*paypal.*";}
              {title = "(?i).*crypto.*";}
              {title = "(?i).*wallet.*";}
              {title = "(?i).*doctolib.*";}
              {title = "(?i).*ameli.*";}
              {title = "(?i).*mutuelle.*";}
              {title = "(?i).*impot.*";}
              {title = "(?i).*authenticator.*";}
              {title = "(?i).*password.*";}
            ];
            block-out-from = "screen-capture";
          }
        ];

        layout = {
          preset-window-heights = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0;}
          ];
          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0;}
          ];
        };
      };
    };
  };
}
